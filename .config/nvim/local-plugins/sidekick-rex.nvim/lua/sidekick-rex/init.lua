-- Bridges sidekick.nvim's CLI multiplexer support to Rex. Inside Rex, set
-- `cli.mux.backend = "rex"` in sidekick's options and call setup() before
-- `require("sidekick").setup()`. Outside Rex, setup() does nothing.
local M = {}

M.did_setup = false

function M.setup()
    if M.did_setup or not vim.env.REX_SESSION then
        return
    end
    M.did_setup = true
    require("sidekick.cli.session").register("rex", require("sidekick-rex.backend"))
    require("sidekick-rex.patch").apply()
end

return M
