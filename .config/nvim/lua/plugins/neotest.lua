return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-treesitter/nvim-treesitter",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        -- Adapters
        "nvim-neotest/neotest-jest",
        "marilari88/neotest-vitest",
        "thenbe/neotest-playwright",
        "fredrikaverpil/neotest-golang",
    },
    commit = "52fca671",
    keys = function()
        local desc = Utils.plugin_keymap_desc("neotest")
        return {
            {"<leader>T", "", desc = "+test"},
            {"<leader>Tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = desc("Run File")},
            {"<leader>TT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = desc("Run All Test Files")},
            {"<leader>Tr", function() require("neotest").run.run() end, desc = desc("Run Nearest")},
            {"<leader>TW", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = desc("Toggle watch mode (not working with jest)")},
            {"<leader>Tl", function() require("neotest").run.run_last() end, desc = desc("Run Last")},
            {"<leader>Ts", function() require("neotest").summary.toggle() end, desc = desc("Toggle Summary")},
            {"<leader>TO", function() require("neotest").output.open({enter = true, auto_close = true}) end, desc = desc("Show Output")},
            {"<leader>To", function() require("neotest").output_panel.toggle() end, desc = desc("Toggle Output Panel")},
            {"<leader>TS", function() require("neotest").run.stop() end, desc = desc("Stop")},
            {
                "<leader>Tw",
                function() require("neotest").run.run({vim.fn.expand("%"), jestCommand = "node_modules/.bin/jest --watch"}) end,
                desc = desc("Run test on watch mode"),
            },
        }
    end,
    opts = {
        floating = {border = "single"},
        status = {virtual_text = true},
        output = {open_on_run = true},
        summary = {mappings = {jumpto = "<CR>"}},
        output_panel = {
            open = "botright vsplit | vertical resize 80",
        },
        adapters = {
            ["neotest-jest"] = {
                jestCommand = "npm test --",
                jestConfigFile = function(file)
                    if string.find(file, "/apps/") or string.find(file, "/packages/") then
                        return string.match(file, "(.-/[^/]+/)src") .. "jest.config.{j,t}s"
                    end

                    return vim.fn.getcwd() .. "/jest.config.{j,t}s"
                end,
                cwd = function(file)
                    if string.find(file, "/apps/") or string.find(file, "/packages/") then
                        return string.match(file, "(.-/[^/]+/)src")
                    end
                    return vim.fn.getcwd()
                end,
                ---@async
                ---@param file_path string?
                ---@return boolean
                isTestFile = function(file_path)
                    if not file_path then
                        return false
                    end

                    -- return vim.fn.fnamemodify(file_path, ":e:e") == "spec.js"
                    return require("neotest-jest.jest-util").defaultIsTestFile(file_path) or
                        string.match(file_path, "**/spec.[tj]sx?$")
                end,
            },
            ["neotest-vitest"] = {
                filter_dir = function(name, rel_path, root)
                    return name ~= "node_modules"
                end,
            },
            ["neotest-golang"] = {
                dap_go_enabled = true,
            },
            ["neotest-playwright"] = {
                adapter = {
                    options = {
                        enable_dynamic_test_discovery = true,
                        get_playwright_binary = function()
                            local install_path = "node_modules/.bin/playwright"
                            return vim.fs.find(install_path, {upward = true, path = vim.fn.getcwd(), type = "file"})[1]
                        end,
                        get_playwright_config = function()
                            local root_paths = {"/apps/e2e", "/apps/e2e-tests"}
                            local path = nil
                            for _, root_path in ipairs(root_paths) do
                                local app_path = vim.fn.getcwd() .. root_path
                                if vim.fn.isdirectory(app_path) then
                                    path = app_path .. "/playwright.config.ts"
                                end
                            end
                            return path or vim.loop.cwd() .. "/playwright.config.ts"
                        end,
                        ---@param name string
                        ---@param rel_path string
                        filter_dir = function(name, rel_path, root)
                            return rel_path:match("node_modules")
                        end,
                        ---@param file_path string
                        is_test_file = function(file_path)
                            return file_path:find("{e2e,e2e-tests}/.*%.{test,spec}%.[tj]sx?$") ~= nil
                        end,
                    },
                },
            },
        },
    },
    config = function(_, opts)
        local neotest_ns = vim.api.nvim_create_namespace("neotest")
        vim.diagnostic.config({
            virtual_text = {
                format = function(diagnostic)
                    -- Replace newline and tab characters with space for more compact diagnostics
                    local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
                    return message
                end,
            },
        }, neotest_ns)

        if opts.adapters then
            local adapters = {}
            for name, config in pairs(opts.adapters or {}) do
                if type(name) == "number" then
                    if type(config) == "string" then
                        config = require(config)
                    end
                    adapters[#adapters + 1] = config
                elseif config ~= false then
                    local adapter = require(name)
                    if type(config) == "table" and not vim.tbl_isempty(config) then
                        local meta = getmetatable(adapter)
                        if adapter.setup then
                            adapter.setup(config)
                        elseif adapter.adapter then
                            adapter.adapter(config)
                            adapter = adapter.adapter
                        elseif meta and meta.__call then
                            adapter = adapter(config)
                        else
                            error("Adapter " .. name .. " does not support setup")
                        end
                    end
                    adapters[#adapters + 1] = adapter
                end
            end
            opts.adapters = adapters
        end

        require("neotest").setup(opts)
    end,
}
