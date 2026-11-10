require("./actions")
local navigator = require("./navigator")

-- Panes
rex.bind("ctrl+h", navigator.navigate("left"))
rex.bind("ctrl+l", navigator.navigate("right"))
rex.bind("ctrl+k", navigator.navigate("up"))
rex.bind("ctrl+j", navigator.navigate("down"))
-- rex.bind("ctrl+alt+h", "pane.focus.left")
-- rex.bind("ctrl+alt+l", "pane.focus.right")
-- rex.bind("ctrl+alt+k", "pane.focus.up")
-- rex.bind("ctrl+alt+j", "pane.focus.down")

-- Sessions
rex.bind("ctrl+shift+l", "leave_session", { action = "session.next" })
rex.bind("ctrl+shift+h", "leave_session", { action = "session.previous" })
rex.bind("ctrl+shift+p", "last_session")
rex.bind("ctrl+shift+c", "session.close")

-- Custom actions
rex.bind("cmd+s", "sessionizer")
rex.bind("cmd+shift+b", "open_project", { dir = "~/.dotfiles" })
rex.bind("cmd+shift+n", "open_project", { dir = "~/notes/obsidian/gonzalo_notes" })

rex.bind("ctrl+shift+o", "open_window", { label = "obsidian", command = { "obsidian" } })
