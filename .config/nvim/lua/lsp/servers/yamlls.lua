return {
    settings = {
        yaml = {
            schemaStore = {
                enable = false, -- Disable built-in schemaStore support, and use SchemaStore.nvim instead.
                url = "",       -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
            },
            -- schemas = require('schemastore').yaml.schemas(),
        },
    },
    -- Lazy-load schemas.
    on_new_config = function(config)
        config.settings.yaml.schemas = config.settings.yaml.schemas or {}
        vim.list_extend(config.settings.yaml.schemas, require("schemastore").yaml.schemas())
    end,
}
