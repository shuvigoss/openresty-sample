local _M = {}

function _M.do_work()
    local user = nil
    if ngx.var.http_authorization then
        local auth = ngx.decode_base64(string.sub(ngx.var.http_authorization, 7))

        local _, _, login, pwd = string.find(auth, "(%w+):(%w+)")
        ngx.log(ngx.INFO, login, " ", pwd)
        if (login == 'bjca') and (pwd == 'bjca') then
            user = login
        end
    end

    if user == nil then
        ngx.header["WWW-Authenticate"] = 'Basic realm="Restricted"'
        ngx.exit(ngx.HTTP_UNAUTHORIZED)
    end
end

return _M
