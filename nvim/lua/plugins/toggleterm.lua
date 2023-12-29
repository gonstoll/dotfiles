local open_mapping = '<F5>'

return {
  'akinsho/toggleterm.nvim',
  version = '*',
  keys = open_mapping,
  enabled = false,
  opts = {
    direction = 'vertical',
    size = 80,
    open_mapping = open_mapping,
  },
  config = function(_, opts)
    local toggleterm = require('toggleterm')

    toggleterm.setup(opts)

    function _G.set_terminal_keymaps()
      local options = {buffer = 0}
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], options)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], options)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], options)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], options)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], options)
      vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], options)
    end

    -- if you only want these mappings for toggle term use term://*toggleterm#* instead
    -- vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')

    -- vim.cmd([[
    --   autocmd TermEnter term://*toggleterm#*
    --   \ tnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
    --
    --   " By applying the mappings this way you can pass a count to your
    --   " mapping to open a specific window.
    --   " For example: 2<C-t> will open terminal 2
    --   nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
    --   inoremap <silent><c-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>
    -- ]])
  end
}

-- return {
--   'voldikss/vim-floaterm',
--   init = function()
--     vim.g.floaterm_wintype = 'vsplit'
--     vim.g.floaterm_width = 0.5
--     vim.g.floaterm_opener = 'edit'
--   end,
--   keys = {
--     {
--       '<F5>',
--       ':FloatermNew<CR>',
--       mode = 'n',
--       noremap = true,
--       silent = true,
--       desc = 'New terminal (FloatTerm)',
--     },
--     {
--       '<F5>',
--       '<C-\\><C-n>:FloatermNew<CR>',
--       mode = 't',
--       noremap = true,
--       silent = true,
--       desc = 'New terminal (FloatTerm)',
--     },
--     {
--       '<F6>',
--       ':FloatermPrev<CR>',
--       mode = 'n',
--       noremap = true,
--       silent = true,
--       desc = 'Previous terminal (FloatTerm)',
--     },
--     {
--       '<F6>',
--       '<C-\\><C-n>:FloatermPrev<CR>',
--       mode = 't',
--       noremap = true,
--       silent = true,
--       desc = 'Previous terminal (FloatTerm)',
--     },
--     {
--       '<F7>',
--       ':FloatermNext<CR>',
--       mode = 'n',
--       noremap = true,
--       silent = true,
--       desc = 'Next terminal (FloatTerm)',
--     },
--     {
--       '<F7>',
--       '<C-\\><C-n>:FloatermNext<CR>',
--       mode = 't',
--       noremap = true,
--       silent = true,
--       desc = 'Next terminal (FloatTerm)',
--     },
--     {
--       '<F8>',
--       ':FloatermToggle<CR>',
--       mode = 'n',
--       noremap = true,
--       silent = true,
--       desc = 'Toggle terminal (FloatTerm)',
--     },
--     {
--       '<F8>',
--       '<C-\\><C-n>:FloatermToggle<CR>',
--       mode = 't',
--       noremap = true,
--       silent = true,
--       desc = 'Toggle terminal (FloatTerm)',
--     },
--     {
--       '<F9>',
--       ':FloatermKill<CR>',
--       mode = 'n',
--       noremap = true,
--       silent = true,
--       desc = 'Kill terminal (FloatTerm)',
--     },
--     {
--       '<F9>',
--       '<C-\\><C-n>:FloatermKill<CR>',
--       mode = 't',
--       noremap = true,
--       silent = true,
--       desc = 'Kill terminal (FloatTerm)',
--     },
--   },
-- }
