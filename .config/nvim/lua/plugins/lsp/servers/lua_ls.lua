return {
    settings = {
        Lua = {
            hint = { enable = true },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            completion = { callSnippet = "Replace" },
            diagnostics = { globals = { "vim" } },
            format = { enable = false },
        },
    },
}
