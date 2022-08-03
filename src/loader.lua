local config = require "config"
local str = require "resty.string"
local resty_sha1 = require "resty.sha1"

local last_version
local _M = {}

local function load(premature)
    if premature then
        return
    end

    if ngx.worker.id() ~= 0 then
        return
    end

    local ok, err = ngx.timer.at(2, load)
    if not ok then
        ngx.log(ngx.ERR, "failed to create the timer: ", err)
        return
    end

    local rsPath = config.query("configResource")

    if not rsPath then
        ngx.log(ngx.ERR, "no configResource found!")
        return
    end

    local file, err = io.open(rsPath, "r")
    if err or file == nil then
        ngx.log(ngx.ERR, "read rsPath error :", err)
        return
    end

    local content = file:read("*a")
    file:close()


    local sha1 = resty_sha1:new()
    sha1:update(content)
    local digest = sha1:final()
    local lv = str.to_hex(digest)

    -- ngx.log(ngx.INFO, "start load resource" , lv)

    if lv ~= last_version then
        last_version = lv
        local apps = ngx.shared.apps
        apps:set("apps", content)
        apps:set("version", lv)
    end
end

function _M.init_worker()
    ngx.timer.at(0, load)
end

return _M
