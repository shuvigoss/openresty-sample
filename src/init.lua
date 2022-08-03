local config       = require "config"
local upstream_ori = require "resty.upstream"
local upstream     = require "upstream"
local loader       = require "loader"
local route        = require "route"
local plugins      = require "plugins"
local balancer     = require "resty.upstream.balancer"
local ngx_balancer = require "ngx.balancer"
local _M           = { version = 1.0 }


function _M.init()
    config.init()

    upstream_ori.init({
        cache = "upstream",
        cache_size = 1000
    })

    plugins.init_plugins()
end

function _M.http_balancer_phase()
    local up = ngx.ctx.metadata
    local peer = balancer.get_round_robin_peer(up)
    if not peer then
        ngx.exit(502)
        return
    end

    ngx.log(ngx.INFO, "use host ", peer.host, " port:", peer.port, " to balancer ", up)

    local ok, err = ngx_balancer.set_current_peer(peer.host, peer.port)
    if not ok then
        ngx.log(ngx.ERR, "balancer error ", ok, "   ", err)
    end
end

function _M.http_access_phase()
    route.pre_request()
    plugins.run_plugins("access")
end

function _M.http_body_filter_phase()
    plugins.run_plugins("body_filter")
end

function _M.init_worker()
    upstream.init_worker()
    route.init_worker()
    loader.init_worker()
    plugins.init_worker()
end

return _M
