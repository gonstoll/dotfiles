-- Bridges sidekick.nvim's CLI multiplexer support to Rex. Inside Rex, set
-- `cli.mux.backend = "rex"` in sidekick's options and call setup() before
-- `require("sidekick").setup()`. Outside Rex, setup() does nothing.
local M = {}

---@class sidekick-rex.Config
---@field create "window"|"split" where new agents open: a new Rex tab, or a split beside Neovim
---@field split {side: "right"|"left"|"above"|"below", ratio: integer} ratio is the agent's share, 1-99 percent
M.config = {
    create = "window",
    split = {
        side = "right",
        ratio = 40,
    },
}

M.did_setup = false

function M.in_rex()
    return vim.env.REX_SESSION ~= nil and vim.env.REX_BLOCK ~= nil
end

---@param opts? sidekick-rex.Config|{}
function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})
    if M.did_setup or not M.in_rex() then
        return
    end
    M.did_setup = true
    require("sidekick.cli.session").register("rex", require("sidekick-rex.backend"))
    require("sidekick-rex.patch").apply()
end

return M
