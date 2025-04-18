return {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    config = function()
        local setup_server = require("lsp").setup_server
        setup_server("stylelint_lsp")
        setup_server("basedpyright")
        setup_server("jsonls", require("plugins.lsp.servers.jsonls"))
        setup_server("yamlls", require("plugins.lsp.servers.yamlls"))
        setup_server("bashls", require("plugins.lsp.servers.bashls"))
        setup_server("tailwindcss", require("plugins.lsp.servers.tailwindcss"))
        setup_server("cssls", require("plugins.lsp.servers.cssls"))
        setup_server("eslint", require("plugins.lsp.servers.eslint"))
        setup_server("lua_ls", require("plugins.lsp.servers.lua_ls"))
        setup_server("vtsls", require("plugins.lsp.servers.vtsls"))
        setup_server("gopls", require("plugins.lsp.servers.gopls"))
    end,
}
