local keyset = vim.keymap.set

keyset('c', '<C-g>', '<C-f>', {desc = 'Edit command in cmdline mode'})
keyset('n', '<C-s>', 'gg<S-v>G', {desc = 'Select all'})

-- New tab
keyset('n', 'tn', ':tabnew %<CR>', {desc = 'New tab'})
keyset('n', 'tc', ':tabclose<CR>', {desc = 'Close tab'})
-- Split window
keyset('n', '<leader>ss', ':split<Return><C-w>w', {desc = 'Split window horizontally'}) -- Horizontal
keyset('n', '<leader>sv', ':vsplit<Return><C-w>w', {desc = 'Split window vertically'})  -- Vertical

-- Move between qf items
keyset('n', '<C-p>', '<cmd>cprev<CR>zz', {desc = 'Previous quickfix item'})
keyset('n', '<C-n>', '<cmd>cnext<CR>zz', {desc = 'Next quickfix item'})

-- Resize splits
keyset('n', '<M-Left>', '<C-w>5>', {desc = 'Resize window (left)'})
keyset('n', '<M-Right>', '<C-w>5<', {desc = 'Resize window (right)'})
keyset('n', '<M-Down>', '<C-w>5-', {desc = 'Resize window (down)'})
keyset('n', '<M-Up>', '<C-w>5+', {desc = 'Resize window (up)'})

-- Move lines
keyset('v', 'J', ":m '>+1<CR>gv=gv", {desc = 'Move line down'})
keyset('v', 'K', ":m '<-2<CR>gv=gv", {desc = 'Move line up'})
keyset('n', 'J', 'mzJ`z')

-- Jumping pages keeps cursor in the middle
keyset('n', '<C-d>', '<C-d>zz', {desc = 'Jump page down'})
keyset('n', '<C-u>', '<C-u>zz', {desc = 'Jump page up'})

-- Keep search terms in the middle of the screen
keyset('n', 'n', 'nzzzv', {desc = 'Jump to next search term'})
keyset('n', 'N', 'Nzzzv', {desc = 'Jump to previous search term'})

-- Pastes copied buffer and keeps it in the register
keyset('x', '<leader>p', '\"_dP')

-- Sources current buffer
keyset('n', '<leader><leader>', function() vim.cmd('so') end)

-- Opens fugitive
keyset('n', '<leader>gf', ':top Git<CR>', {desc = 'Fugitive: Open git console'})

-- Toggle highlighting search
keyset('n', '<leader>;h', ':set hlsearch!<CR>', {desc = 'Toggle highlighting search'})

-- Save without formatting
keyset('n', '<leader>wf', ':noautocmd w<CR>', {desc = 'Save without formatting'})

-- Open terminal below
keyset('n', ',st', function()
  vim.cmd.new()
  vim.cmd.wincmd('J')
  vim.api.nvim_win_set_height(0, 12)
  vim.wo.winfixheight = true
  vim.cmd.term()
end, {desc = 'Open terminal below'})

keyset('n', '<leader>bg', function()
  local active_bg = vim.o.background
  if active_bg == 'dark' then
    vim.cmd('set background=light')
  else
    vim.cmd('set background=dark')
  end
end, {desc = 'Toggle background'})