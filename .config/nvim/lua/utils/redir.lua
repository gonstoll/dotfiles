-- Display command output in neovim split window
-- Taken from: https://gist.github.com/Leenuus/7a2ea47b88bfe16430b42e4e48122718
local M = {}

local function redir_open_win(buf, vertical, stderr_p)
  local wn = stderr_p and 'redir_sterr_win' or 'redir_win'
  if vim.g[wn] == nil then
    local win = vim.api.nvim_open_win(buf, true, {
      vertical = vertical,
    })
    vim.api.nvim_create_autocmd('WinClosed', {
      pattern = {string.format('%d', win)},
      callback = function()
        vim.g[wn] = nil
      end,
    })
    vim.g[wn] = win
  else
    vim.api.nvim_win_set_buf(vim.g[wn], buf)
  end
end

local function redir_vim_command(cmd, vertical)
  vim.cmd('redir => output')
  vim.cmd('silent ' .. cmd)
  vim.cmd('redir END')
  local output = vim.fn.split(vim.g.output, '\n')
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, 0, false, output)

  redir_open_win(buf, vertical)
end

local function redir_shell_command(cmd, lines, vertical, stderr_p)
  local shell_cmd = {
    'sh',
    '-c',
    cmd,
  }

  local stdin = nil
  if #lines ~= 0 then
    stdin = lines
  end

  local stdout_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value('ft', 'redir_stdout', {buf = stdout_buf})
  redir_open_win(stdout_buf, vertical)

  local stderr = nil
  if stderr_p then
    local stderr_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value('ft', 'redir_sterr', {buf = stderr_buf})
    redir_open_win(stderr_buf, vertical, true)
    stderr = function(_, data)
      vim.schedule_wrap(function()
        if data ~= nil then
          local output = vim.fn.split(data, '\n')
          vim.api.nvim_buf_set_lines(stderr_buf, -1, -1, false, output)
        end
      end)()
    end
  end

  vim.system(shell_cmd, {
    text = true,
    stdout = function(_, stdout)
      vim.schedule_wrap(function()
        if stdout ~= nil then
          local output = vim.fn.split(stdout, '\n')
          vim.api.nvim_buf_set_lines(stdout_buf, -1, -1, false, output)
        end
      end)()
    end,
    stderr = stderr,
    stdin = stdin,
  }, function(completed)
    -- NOTE:
    -- placeholder to make call async
  end)
end

function M.redir(args)
  local cmd = args.args
  local vertical = args.smods.vertical
  local stderr_p = args.bang

  if cmd:sub(1, 1) == '!' then
    local range = args.range
    local lines
    if range == 0 then
      lines = {}
    else
      local line1 = args.line1 - 1
      local line2 = args.line2
      line2 = line1 == line2 and line1 + 1 or line2
      lines = vim.api.nvim_buf_get_lines(0, line1, line2, false)
    end

    cmd = cmd:sub(2)
    redir_shell_command(cmd, lines, vertical, stderr_p)
  else
    redir_vim_command(cmd, vertical)
  end
end

function M.evaler(range)
  return function(bang)
    local line = vim.fn.getline(1)
    local it = string.match(line, '^#!(.*)')

    local cmd = string.format('%sRedir%s !', range, bang and '!' or '')

    if it and it ~= '' then
      vim.cmd(cmd .. it)
    else
      vim.fn.feedkeys(':' .. cmd, 'tn')
    end
  end
end

return M
