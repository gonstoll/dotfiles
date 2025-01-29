return {
    'garymjr/nvim-snippets',
    enabled = vim.g.cmp_enable,
    opts = {search_paths = {vim.fn.stdpath('config') .. '/snippets/nvim'}},
    keys = {
        {
            '<Tab>',
            function()
                if vim.snippet.active({direction = 1}) then
                    vim.schedule(function()
                        vim.snippet.jump(1)
                    end)
                    return
                end
                return '<Tab>'
            end,
            expr = true,
            silent = true,
            mode = 'i',
        },
        {
            '<Tab>',
            function()
                vim.schedule(function()
                    vim.snippet.jump(1)
                end)
            end,
            expr = true,
            silent = true,
            mode = 's',
        },
        {
            '<S-Tab>',
            function()
                if vim.snippet.active({direction = -1}) then
                    vim.schedule(function()
                        vim.snippet.jump(-1)
                    end)
                    return
                end
                return '<S-Tab>'
            end,
            expr = true,
            silent = true,
            mode = {'i', 's'},
        },
    },
}
