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
  config = function(plugin, opts)
    require('conform').setup(opts)

    require('conform.formatters.prettier').args = function(ctx)
      local args = {'--stdin-filepath', '$FILENAME'}
      local found = vim.fs.find('.prettierrc.json', {upward = true, path = ctx.dirname, type = 'file'})[1]
      if found then
        vim.list_extend(args, {'--config', found})
      end
      return args
    end
  end,
}
