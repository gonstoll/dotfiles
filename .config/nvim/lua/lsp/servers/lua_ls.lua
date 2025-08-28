return {
    settings = {
        Lua = {
            hint = {enable = true},
            workspace = {checkThirdParty = false},
            telemetry = {enable = false},
            completion = {callSnippet = "Replace"},
            diagnostics = {globals = {"vim"}},
            format = {
                enable = true,
                -- https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/docs/format_config_EN.md
                defaultConfig = {
                    indent_size = 4,
                    tab_width = 4,
                    quote_style = "double",
                    call_arg_parentheses = "keep",
                    trailing_table_separator = "smart",
                    space_around_table_field_list = "false",
                    space_before_attribute = false,
                    space_inside_square_brackets = false,
                    align_call_args = false,
                    align_function_params = false,
                    align_continuous_assign_statement = false,
                    align_continuous_rect_table_field = false,
                    align_if_branch = false,
                    align_array_table = false,
                },
            },
        },
    },
}
