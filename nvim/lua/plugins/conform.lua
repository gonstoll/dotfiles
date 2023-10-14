return {
  'stevearc/conform.nvim',
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
    local util = require('conform.util')

    conform.setup(opts)

    -- Customize prettier args
    require('conform.formatters.prettier').args = function(ctx)
      local args = {'--stdin-filepath', '$FILENAME'}
      local found = vim.fs.find('.prettierrc.json', {
        upward = true,
        path = ctx.dirname,
        type = 'file'
      })[1]
      local found2 = vim.fs.find('.prettierrc.json', {
        path = vim.fn.expand('~/.config/nvim'),
        type = 'file'
      })[1]

      -- Project config takes precedence over global config
      if found then
        vim.list_extend(args, {'--config', found})
      elseif found2 then
        vim.list_extend(args, {'--config', found2})
      end

      local isUsingTailwind = vim.fs.find('tailwind.config.js', {
        upward = true,
        path = ctx.dirname,
        type = 'file'
      })[1]
      local local_prettier_tailwind_plugin = vim.fs.find('node_modules/prettier-plugin-tailwindcss/dist/index.mjs', {
        upward = true,
        path = ctx.dirname,
        type = 'file'
      })[1]

      if local_prettier_tailwind_plugin then
        vim.list_extend(args, {'--plugin', local_prettier_tailwind_plugin})
      else
        if isUsingTailwind then
          vim.notify('Please run npm i -D prettier-plugin-tailwindcss', vim.log.levels.WARN)
        end
      end

      return args
    end

    local beautysh = require('conform.formatters.beautysh')
    conform.formatters.beautysh = vim.tbl_deep_extend('force', beautysh, {
      args = util.extend_args(beautysh.args, {'--indent-size', '2', '--force-function-style', 'fnpar'})
    })
  end,
}
