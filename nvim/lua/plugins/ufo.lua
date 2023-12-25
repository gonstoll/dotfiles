return {
  'kevinhwang91/nvim-ufo',
  dependencies = {'kevinhwang91/promise-async'},
  opts = {
    provider_selector = function(bufnr, filetype, buftype)
      return {'treesitter', 'indent'}
    end
  },
  config = function(_, opts)
    local ufo = require('ufo')

    ufo.setup(opts)

    vim.keymap.set('n', 'zR', ufo.openAllFolds)
    vim.keymap.set('n', 'zM', ufo.closeAllFolds)
    vim.keymap.set('n', 'K', function()
      local winid = ufo.peekFoldedLinesUnderCursor(true)
      if not winid then
        vim.lsp.buf.hover()
      end
    end, {desc = 'LSP: Show hover documentation and folded code'})
  end
}
