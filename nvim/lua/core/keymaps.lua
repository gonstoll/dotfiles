-- Select all
vim.keymap.set('n', '<C-b>', 'gg<S-v>G', {desc = 'Select all'})

-- New tab
vim.keymap.set('n', 'tn', ':tabnew %<CR>', {desc = 'New tab'})
vim.keymap.set('n', 'tc', ':tabclose<CR>', {desc = 'Close tab'})
-- Split window
vim.keymap.set('n', 'ss', ':split<Return><C-w>w', {desc = 'Split window horizontally'}) -- Horizontal
vim.keymap.set('n', 'sv', ':vsplit<Return><C-w>w', {desc = 'Split window vertically'})  -- Vertical
-- Move window
vim.keymap.set('', '<C-h>', '<C-w>h', {desc = 'Move window (left)'})                    -- Left
vim.keymap.set('', '<C-k>', '<C-w>k', {desc = 'Move window (up)'})                      -- Up
vim.keymap.set('', '<C-j>', '<C-w>j', {desc = 'Move window (down)'})                    -- Down
vim.keymap.set('', '<C-l>', '<C-w>l', {desc = 'Move window (right)'})                   -- Right

vim.keymap.set('n', '<C-p>', '<cmd>cprev<CR>zz', {desc = 'Previous quickfix item'})
vim.keymap.set('n', '<C-n>', '<cmd>cnext<CR>zz', {desc = 'Next quickfix item'})

-- Resize window
vim.keymap.set('n', '<C-w><left>', '<C-w><', {desc = 'Resize window (left)'})
vim.keymap.set('n', '<C-w><right>', '<C-w>>', {desc = 'Resize window (right)'})
vim.keymap.set('n', '<C-w><up>', '<C-w>+', {desc = 'Resize window (up)'})
vim.keymap.set('n', '<C-w><down>', '<C-w>-', {desc = 'Resize window (down)'})

-- Move lines
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", {desc = 'Move line down'})
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", {desc = 'Move line up'})

vim.keymap.set('n', 'J', 'mzJ`z')

-- Jumping pages keeps cursor in the middle
vim.keymap.set('n', '<C-d>', '<C-d>zz', {desc = 'Jump page down'})
vim.keymap.set('n', '<C-u>', '<C-u>zz', {desc = 'Jump page up'})

-- Keep search terms in the middle of the screen
vim.keymap.set('n', 'n', 'nzzzv', {desc = 'Jump to next search term'})
vim.keymap.set('n', 'N', 'Nzzzv', {desc = 'Jump to previous search term'})

-- Pastes copied buffer and keeps it in the register
vim.keymap.set('x', '<leader>p', '\"_dP')

-- Sources current buffer
vim.keymap.set('n', '<leader><leader>', function() vim.cmd('so') end)

-- Opens fugitive
vim.keymap.set('n', '<leader>gs', ':top Git<CR>', {desc = 'Fugitive: Open git console'})

-- Toggle highlighting search
vim.keymap.set('n', '<leader>;h', ':set hlsearch!<CR>', {desc = 'Toggle highlighting search'})

-- Save without formatting
vim.keymap.set('n', ';wf', ':noautocmd w<CR>', {desc = 'Save without formatting'})

-- Cursor navigating on insert mode
vim.keymap.set('i', '<M-h>', '<left>', {desc = 'Move cursor left'})
vim.keymap.set('i', '<M-l>', '<right>', {desc = 'Move cursor left'})
vim.keymap.set('i', '<M-j>', '<down>', {desc = 'Move cursor left'})
vim.keymap.set('i', '<M-k>', '<up>', {desc = 'Move cursor left'})
