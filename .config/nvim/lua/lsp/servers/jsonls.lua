return {
    settings = {
        json = {
            maxItemsComputed = 5000,
            colorDecorators = {enable = true},
            format = {enable = true},
            keepLines = {enable = true},
            schemaDownload = {enable = true},
            trace = {server = "off"},
            -- schemas = require('schemastore').json.schemas(),
            validate = {enable = true},
        },
    },
    -- Lazy-load schemas.
    on_new_config = function(config)
        config.settings.json.schemas = config.settings.json.schemas or {}
        vim.list_extend(config.settings.json.schemas, require("schemastore").json.schemas())
    end,
}
