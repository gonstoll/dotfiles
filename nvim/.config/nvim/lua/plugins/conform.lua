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
      graphql = {'prettier'},
      vue = {'prettier'},
      angular = {'prettier'},
      less = {'prettier'},
      flow = {'prettier'},
      sh = {'beautysh'},
      bash = {'beautysh'},
      zsh = {'beautysh'},
    },
    format_on_save = function(bufnr)
      -- Disable autoformat for files in a certain path
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname:match('/node_modules/') then
        return
      end

      return {timeout_ms = 1000, lsp_fallback = true}
    end,
    format_after_save = {lsp_fallback = true},
  },
  config = function(_, opts)
    local conform = require('conform')
    conform.setup(opts)

    -- Customize prettier args
    require('conform.formatters.prettier').args = function(_, ctx)
      local prettier_roots = {'.prettierrc', '.prettierrc.json', 'prettier.config.js'}
      local args = {'--stdin-filepath', '$FILENAME'}
      local config_path = vim.fn.stdpath('config')

      local localPrettierConfig = vim.fs.find(prettier_roots, {
        upward = true,
        path = ctx.dirname,
        type = 'file'
      })[1]
      local globalPrettierConfig = vim.fs.find(prettier_roots, {
        path = type(config_path) == 'string' and config_path or config_path[1],
        type = 'file'
      })[1]
      local disableGlobalPrettierConfig = os.getenv('DISABLE_GLOBAL_PRETTIER_CONFIG')

      -- Project config takes precedence over global config
      if localPrettierConfig then
        vim.list_extend(args, {'--config', localPrettierConfig})
      elseif globalPrettierConfig and not disableGlobalPrettierConfig then
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
