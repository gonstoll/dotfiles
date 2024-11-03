return {
  'neovim/nvim-lspconfig',
  config = function()
    vim.diagnostic.config({
      virtual_text = true,
      severity_sort = true,
      underline = true,
      float = {
        border = 'single',
        source = true,
        max_width = 100,
      },
    })

    vim.lsp.handlers['textDocument/hover'] = function(_, result, ctx, config)
      config = require('utils').merge_table(config or {}, {border = 'single', max_width = 100})
      config.focus_id = ctx.method
      if not (result and result.contents) then
        return
      end
      local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
      markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
      if vim.tbl_isempty(markdown_lines) then
        return
      end
      return vim.lsp.util.open_floating_preview(markdown_lines, 'markdown', config)
    end

    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
      vim.lsp.handlers.signature_help,
      {title = 'Signature', border = 'single', max_width = 100}
    )

    local icons = require('utils.icons')
    for type, icon in pairs(icons.diagnostics) do
      local hl = 'DiagnosticSign' .. type
      vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
    end

    local lspconfig = require('lspconfig')
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.foldingRange = {dynamicRegistration = false, lineFoldingOnly = true}

    local lsp_servers = {
      jsonls = {capabilities = capabilities},
      emmet_language_server = {capabilities = capabilities},
      bashls = {capabilities = capabilities},
      tailwindcss = {capabilities = capabilities, root_dir = lspconfig.util.root_pattern('tailwind.config.js', 'tailwind.config.ts')},
      cssls = require('plugins.lsp.servers.cssls').setup(capabilities),
      eslint = require('plugins.lsp.servers.eslint').setup(capabilities),
      lua_ls = require('plugins.lsp.servers.lua_ls').setup(capabilities),
      vtsls = require('plugins.lsp.servers.vtsls').setup(capabilities),
      -- ts_ls = require('plugins.lsp.servers.ts_ls').setup(capabilities),
    }

    for server_name, server_config in pairs(lsp_servers) do
      lspconfig[server_name].setup(server_config)
    end

    for _, server_config in pairs(lsp_servers) do
      if server_config.keys then
        for _, key in ipairs(server_config.keys) do
          vim.keymap.set('n', key[1], key[2], {desc = key.desc})
        end
      end
    end
  end,
}
