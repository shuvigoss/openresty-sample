local cjson         = require "cjson.safe"
local radix         = require "resty.radixtree"


local _M = {}
local rx
local last_version

function _M.pre_request()
    local uri = ngx.var.request_uri

    local metadata = rx:match(uri)
    if not metadata then
        ngx.exit(404)
    end

    ngx.ctx.metadata = metadata
end

-- {
--     "location": "/api",
--     "upstream": "api_upstream"
-- }
local function load_routes(premature)
    if premature then
        return
    end

    ngx.timer.at(1, load_routes)
    local apps = ngx.shared.apps:get("apps")
    local version = ngx.shared.apps:get("version")
    if not apps or not version then
        return
    end
    if last_version == version then
        return
    end

    local rs = cjson.decode(apps)

    local routes = rs.routes
    if not routes then
        return
    end

    local r = {}
    for index, value in ipairs(routes) do
        r[index] = {
            paths = { value.location },
            metadata = value.upstream,
        }
    end

    rx = radix.new(r)
    ngx.log(ngx.INFO, " update route  path ", " size is ", #routes)
    last_version = version
end

function _M.init_worker()
    ngx.timer.at(0, load_routes)
end

return _M
