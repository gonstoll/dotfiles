local M = {}

function M.setup()
    local s = ""
    for i = 1, vim.fn.tabpagenr("$") do
        local winnr = vim.fn.tabpagewinnr(i)
        local buflist = vim.fn.tabpagebuflist(i)
        local bufnr = buflist[winnr]
        local bufname = vim.fn.bufname(bufnr)
        local filename = vim.fn.fnamemodify(bufname, ":t") -- only file name

        if i == vim.fn.tabpagenr() then
            s = s .. "%#TabLineSel#"
        else
            s = s .. "%#TabLine#"
        end

        s = s .. " " .. i .. ":" .. (filename ~= "" and filename or "[No Name]") .. " "
    end
    s = s .. "%#TabLineFill#"
    return s
end

return M
