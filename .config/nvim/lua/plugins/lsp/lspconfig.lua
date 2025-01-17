return {
  'neovim/nvim-lspconfig',
  config = function()
    local server_setup = require('lsp').server_setup
    server_setup('emmet_language_server')
    server_setup('stylelint_lsp')
    server_setup('jsonls', require('plugins.lsp.servers.jsonls'))
    server_setup('yamlls', require('plugins.lsp.servers.yamlls'))
    server_setup('bashls', require('plugins.lsp.servers.bashls'))
    server_setup('tailwindcss', require('plugins.lsp.servers.tailwindcss'))
    server_setup('cssls', require('plugins.lsp.servers.cssls'))
    server_setup('eslint', require('plugins.lsp.servers.eslint'))
    server_setup('lua_ls', require('plugins.lsp.servers.lua_ls'))
    server_setup('vtsls', require('plugins.lsp.servers.vtsls'))
    server_setup('gopls', require('plugins.lsp.servers.gopls'))
  end,
}
