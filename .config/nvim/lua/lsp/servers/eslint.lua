local desc = Utils.plugin_keymap_desc("eslint")

return {
    settings = {
        format = false,
        -- run = "onSave",
        -- workingDirectory = {mode = "location"},
        experimental = {
            useFlatConfig = true,
        },
    },
    flags = os.getenv("DEBOUNCE_ESLINT") and {
        allow_incremental_sync = false,
        debounce_text_changes = 1000,
    } or nil,
    keys = {
        {
            "<leader>ef",
            ":LspEslintFixAll<CR>",
            desc = desc("Fix all"),
        },
    },
}
