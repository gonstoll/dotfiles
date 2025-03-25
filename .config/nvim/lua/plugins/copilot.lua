return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        opts = {
            suggestion = {
                enabled = true,
                auto_trigger = true,
                keymap = {
                    accept = "<C-a>",
                    next = "<M-]>",
                    prev = "<M-[>",
                    dismiss = "<C-R>",
                },
            },
        },
    },

    {
        "CopilotC-Nvim/CopilotChat.nvim",
        cmd = {
            "CopilotChat",
            "CopilotChatFix",
            "CopilotChatDocs",
            "CopilotChatLoad",
            "CopilotChatOpen",
            "CopilotChatSave",
            "CopilotChatClose",
            "CopilotChatToggle",
            "CopilotChatStop",
            "CopilotChatModel",
            "CopilotChatModels",
            "CopilotChatReset",
            "CopilotChatCommit",
            "CopilotChatTests",
            "CopilotChatReview",
            "CopilotChatExplain",
            "CopilotChatDebugInfo",
            "CopilotChatCommitStaged",
            "CopilotChatFixDiagnostic",
        },
        dependencies = {"github/copilot.vim", "nvim-lua/plenary.nvim"},
        opts = {
            debug = false,
        },
    },
}
