local _M = {}

function _M.do_work()
    local chunk, eof = ngx.arg[1], ngx.arg[2]
    local buffered = ngx.ctx.buffered
    if not buffered then
        buffered = {} -- XXX we can use table.new here
        ngx.ctx.buffered = buffered
    end
    if chunk ~= "" then
        buffered[#buffered + 1] = chunk
        ngx.arg[1] = nil
    end
    if eof then
        local whole = table.concat(buffered)
        ngx.ctx.buffered = nil
        whole = string.gsub(whole, "%d", "*")
        ngx.arg[1] = whole
    end
end

return _M
