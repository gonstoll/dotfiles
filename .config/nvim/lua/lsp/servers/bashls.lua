return {
    settings = {
        bashIde = {
            globPattern = "*@(.sh|.inc|.bash|.command|.zsh)",
            shellcheckArguments = {
                "-e",
                "SC2086", -- Double quote to prevent globbing and word splitting
                -- '-e', 'SC2155', -- Declare and assign separately to avoid masking return values
            },
        },
    },
}
