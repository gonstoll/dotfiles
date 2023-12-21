return {
  'stevearc/conform.nvim',
  event = 'LspAttach',
  opts = {
    quiet = true,
    formatters_by_ft = {
      typescript = {'prettier'},
      typescriptreact = {'prettier'},
      javascript = {'prettier'},
      javascriptreact = {'prettier'},
      json = {'prettier'},
      html = {'prettier'},
      css = {'prettier'},
      scss = {'prettier'},
      markdown = {'prettier'},
      yaml = {'prettier'},
      sh = {'beautysh'},
      zsh = {'beautysh'},
    },
    format_on_save = function(bufnr)
      -- Disable autoformat for files in a certain path
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname:match('/node_modules/') then
        return
      end

      return {timeout_ms = 500, lsp_fallback = true, async = true}
    end,
    format_after_save = {lsp_fallback = true},
  },
  config = function(_, opts)
    local conform = require('conform')
    conform.setup(opts)

    -- Customize prettier args
    require('conform.formatters.prettier').args = function(ctx)
      local prettier_roots = {'.prettierrc', '.prettierrc.json', 'prettier.config.js'}
      local args = {'--stdin-filepath', '$FILENAME'}

      local localPrettierConfig = vim.fs.find(prettier_roots, {
        upward = true,
        path = ctx.dirname,
        type = 'file'
      })[1]
      local globalPrettierConfig = vim.fs.find(prettier_roots, {
        path = vim.fn.stdpath('config'),
        type = 'file'
      })[1]

      -- Project config takes precedence over global config
      if localPrettierConfig then
        vim.list_extend(args, {'--config', localPrettierConfig})
      elseif globalPrettierConfig then
        vim.list_extend(args, {'--config', globalPrettierConfig})
      end

      local hasTailwindPrettierPlugin = vim.fs.find('node_modules/prettier-plugin-tailwindcss', {
        upward = true,
        path = ctx.dirname,
        type = 'directory'
      })[1]

      if hasTailwindPrettierPlugin then
        vim.list_extend(args, {'--plugin', 'prettier-plugin-tailwindcss'})
      end

      return args
    end

    conform.formatters.beautysh = {
      prepend_args = function()
        return {'--indent-size', '2', '--force-function-style', 'fnpar'}
      end
    }
  end,
}
