rex.action({
    name  = "sessionizer",
    title = "Sessionizer",
    args  = { dir = "string?" },
    run   = function(ctx, args)
        local command = { os.getenv("HOME") .. "/.config/bin/rex-sessionizer" }
        if args.dir ~= nil then
            table.insert(command, args.dir)
        end

        local window, err = rex.session.new_window({
            window_label = "sessionizer",
            layout = rex.layout.block({
                flavor  = "com.superlogical.terminal.shell",
                options = { command = command },
            }),
        })
        if err ~= nil then error(err, 0) end

        -- The server makes the new window active, but the app keeps showing its current tab.
        rex.client.queue("session.select", {
            session_id = ctx.session_id,
            window_id  = window.window_id,
        })
    end,
})

rex.bind("cmd+s", "sessionizer")
rex.bind("cmd+shift+b", "sessionizer", { dir = "~/.dotfiles" })
rex.bind("cmd+shift+n", "sessionizer", { dir = "~/notes/obsidian/gonzalo_notes" })
rex.bind("cmd+shift+h", "sessionizer", { dir = "~/" })

rex.action({
    name  = "open_window",
    title = "Open or Focus Window",
    args  = { label = "string", command = "array?" },
    run   = function(ctx, args)
        local view, err = rex.call("session.view", { session_id = ctx.session_id })
        if err ~= nil then error(err, 0) end
        for _, window in ipairs(view.windows or {}) do
            if window.label == args.label then
                local _, focus_err = rex.session.focus_window({ window_id = window.window_id })
                if focus_err ~= nil then error(focus_err, 0) end
                return
            end
        end
        local _, new_err = rex.session.new_window({
            window_label = args.label,
            layout = rex.layout.block({
                flavor  = "com.superlogical.terminal.shell",
                options = { command = args.command },
            }),
        })
        if new_err ~= nil then error(new_err, 0) end
    end,
})
rex.bind("cmd+shift+o", "open_window", { label = "obsidian", command = { "obsidian" } })
