local sidekick_desc = Utils.plugin_keymap_desc("Sidekick")
local default_ai_tool = vim.env.DEFAULT_AI_CLI or "opencode"

-- sidekick's picker formatter, but with the path column lined up. sidekick pads
-- the `[backend:location]` part to a fixed width, so a long Rex tab title pushes
-- that row's path out of line. Pad it to the widest location instead.
local function aligned_format(states)
    local Select = require("sidekick.cli.ui.select")
    -- The location is the part highlighted as "Special", and the padding follows it
    local function location(parts)
        for i, part in ipairs(parts) do
            if part[2] == "Special" then
                return i
            end
        end
    end
    local width = 0
    for _, state in ipairs(states) do
        local parts = Select.format(state)
        local i = location(parts)
        if i then
            width = math.max(width, vim.api.nvim_strwidth(parts[i][1]))
        end
    end
    return function(state, picker)
        local parts = Select.format(state, picker)
        local i = location(parts)
        if i and parts[i + 1] then
            parts[i + 1] = {string.rep(" ", width - vim.api.nvim_strwidth(parts[i][1]) + 2)}
        end
        return parts
    end
end

-- Sends `msg` to a running agent of any tool, picked from all of them. The pick
-- sticks until the agent is detached with <leader>aD. With no agent running,
-- starts the default tool instead.
local function send_to_running(msg)
    return function()
        local Cli = require("sidekick.cli")
        local State = require("sidekick.cli.state")
        -- Render before the picker opens, since it ends visual mode and the selection with it
        local rendered, text = Cli.render({msg = msg})
        if rendered == "" or not text then
            return
        end
        if #State.get({attached = true}) > 0 then
            return Cli.send({text = text})
        end
        -- Finding running agents is slow, so look once and attach the pick
        -- directly. sidekick's own picker and send() would each look again.
        local running = State.get({started = true})
        if #running == 0 then
            return Cli.send({text = text, name = default_ai_tool})
        end
        local format = aligned_format(running)
        vim.ui.select(running, {
            prompt = "Send to:",
            kind = "sidekick_cli",
            format_item = function(state)
                return table.concat(vim.tbl_map(function(part) return part[1] end, format(state)))
            end,
            snacks = {format = format},
        }, function(state)
            if state then
                State.attach(state)
                Cli.send({text = text})
            end
        end)
    end
end

return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        opts = {
            filetypes = {
                markdown = true,
                sh = function()
                    if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
                        -- disable for .env files
                        return false
                    end
                    return true
                end,
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                keymap = {
                    accept = "<C-j>",
                    next = "<M-]>",
                    prev = "<M-[>",
                    dismiss = "<C-R>",
                },
            },
        },
    },

    {
        "folke/sidekick.nvim",
        event = "VeryLazy",
        dependencies = {
            "gonstoll/sidekick-rex.nvim",
        },
        ---@type sidekick.Config
        opts = {
            nes = {
                enabled = false,
            },
            cli = {
                mux = {
                    enabled = true,
                    backend = vim.env.REX_SESSION and "rex" or "tmux",
                    -- Only tmux reads this: Rex always starts agents in their own tab
                    create = "terminal",
                },
            },
        },
        config = function(_, opts)
            -- Must come first: it lets sidekick accept "rex" as a backend
            require("sidekick-rex").setup()
            require("sidekick").setup(opts)
        end,
        keys = {
            {
                "<tab>",
                function()
                    -- if there is a next edit, jump to it, otherwise apply it if any
                    if not require("sidekick").nes_jump_or_apply() then
                        return "<Tab>" -- fallback to normal tab
                    end
                end,
                expr = true,
                desc = sidekick_desc("Goto/Apply next edit suggestion"),
            },
            {
                "<leader>aa",
                function() require("sidekick.cli").toggle() end,
                desc = sidekick_desc("Toggle CLI"),
            },
            {
                "<leader>as",
                function() require("sidekick.cli").select({name = default_ai_tool}) end,
                -- Or to select only installed tools:
                -- require("sidekick.cli").select({ filter = { installed = true } })
                desc = sidekick_desc("Select CLI"),
            },
            {
                "<leader>aD",
                function() require("sidekick.cli").close() end,
                desc = sidekick_desc("Detach a CLI session"),
            },
            {
                "<leader>at",
                send_to_running("{this}"),
                mode = {"x", "n"},
                desc = sidekick_desc("Send this"),
            },
            {
                "<leader>af",
                send_to_running("{file}"),
                desc = sidekick_desc("Send file"),
            },
            {
                "<leader>av",
                send_to_running("{selection}"),
                mode = {"x"},
                desc = sidekick_desc("Send visual selection content"),
            },
            {
                "<leader>ad",
                send_to_running("{diagnostics}"),
                mode = {"x"},
                desc = sidekick_desc("Send selected diagnostics"),
            },
            {
                "<leader>ap",
                function() require("sidekick.cli").prompt({name = default_ai_tool}) end,
                mode = {"n", "x"},
                desc = sidekick_desc("Select prompt"),
            },
            -- Opencode keybinds
            {
                "<leader>ao",
                function() require("sidekick.cli").toggle({name = "opencode", focus = true}) end,
                desc = sidekick_desc("Toggle opencode"),
            },
        },
    },
}
