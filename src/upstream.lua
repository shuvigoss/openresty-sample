local upstream = require "resty.upstream"
local cjson    = require "cjson.safe"
local _M       = {}

local last_version

local function load_upstreams(premature)
    if premature then
        return
    end

    ngx.timer.at(1, load_upstreams)
    local apps = ngx.shared.apps:get("apps")
    local version = ngx.shared.apps:get("version")
    if not apps or not version then
        return
    end
    if last_version == version then
        return
    end

    local rs = cjson.decode(apps)

    local upstreams = rs.upstreams
    if not upstreams then
        return
    end

    for index, value in ipairs(upstreams) do

        local hosts = {}
        for i, v in ipairs(value["hosts"]) do
            hosts[i] = v
        end
        ngx.log(ngx.INFO, " update upstream  name ", value.name, " size is ", #hosts)
        upstream.update_upstream(value["name"], {
            version = 1,
            hosts = hosts
        })
    end

    last_version = version
end

function _M.init_worker()
    ngx.timer.at(0, load_upstreams)
end

return _M
