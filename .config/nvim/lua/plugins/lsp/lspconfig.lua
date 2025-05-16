return {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    config = function()
        local setup_servers = require("lsp").setup_servers
        setup_servers({
            stylelint_lsp = {},
            basedpyright = {},
            tailwindcss = {},
            jsonls = require("plugins.lsp.servers.jsonls"),
            yamlls = require("plugins.lsp.servers.yamlls"),
            bashls = require("plugins.lsp.servers.bashls"),
            cssls = require("plugins.lsp.servers.cssls"),
            eslint = require("plugins.lsp.servers.eslint"),
            lua_ls = require("plugins.lsp.servers.lua_ls"),
            vtsls = require("plugins.lsp.servers.vtsls"),
            gopls = require("plugins.lsp.servers.gopls"),
        })
    end,
}
