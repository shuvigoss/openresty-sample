local config = require "config"
local cjson = require "cjson.safe"

local _M = {}
local plugins_cache = {}
local plugins_upstreams
local last_version

function _M.init_plugins()
    local plugins = config.query("plugins")
    for index, value in ipairs(plugins) do
        local p = { name = value.name, phase = value.phase, runner = require("plugins." .. value.runner) }
        plugins_cache[index] = p
    end
end

function _M.run_plugins(phase)
    local upstream = ngx.ctx.metadata

    if upstream == '' or not upstream then
        return
    end


    local ps
    for index, value in ipairs(plugins_upstreams) do
        if upstream == value.upstream then
            ps = value.plugins
            break
        end
    end

    if not ps then
        return
    end

    local runners = {}
    for index, value in ipairs(plugins_cache) do
        if phase == value.phase then
            for i, v in ipairs(ps) do
                if value.name == v then
                    table.insert(runners, value.runner)
                end
            end
        end
    end

    for _, runner in ipairs(runners) do
        runner.do_work()
    end
end

-- "plugins": [
--         {
--             "upstream": "dsmp_upstream",
--             "plugins": [
--                 "basic_auth",
--                 "mask_body"
--             ]
--         }
--     ]
local function load_plugins(premature)
    if premature then
        return
    end

    ngx.timer.at(1, load_plugins)
    local apps = ngx.shared.apps:get("apps")
    local version = ngx.shared.apps:get("version")
    if not apps or not version then
        return
    end
    if last_version == version then
        return
    end

    local rs = cjson.decode(apps)
    plugins_upstreams = rs.plugins
    last_version = version
end

function _M.init_worker()
    ngx.timer.at(0, load_plugins)
end

return _M
