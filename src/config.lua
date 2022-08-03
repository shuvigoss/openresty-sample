local yaml = require "tinyyaml"

local _M = {}

local ngx_config_prefix = ngx.config.prefix
local config_data


local function load_config()
    local file_path = ngx_config_prefix() .. "conf/application.yaml"
    local file, err = io.open(file_path, "r")
    if err or file == nil then
        error("read config file error :" .. file_path .. " error is :" .. err, 2)
    end

    local content = file:read("*a")
    file:close()

    local config = yaml.parse(content or "")
    if not config then
        ngx.log(ngx.ERR, "config file is empty or wrong format")
    end

    config_data = config

end

function _M.init()
    load_config()
end

function _M.query(key)
    if not config_data then
        load_config()
    end

    if not config_data[key] then
        return nil, key .. " is not set in the configuration file"
    end

    return config_data[key], nil
end

return _M
