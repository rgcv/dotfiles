-- input
hl.config({ input = { sensitivity = -0.3 } })

-- monitors
hl.monitor({ output = "DP-1", mode = "preferred", position = "1080x480", scale = 1 })
hl.monitor({ output = "DP-2", mode = "highrr", position = "0x0", scale = 1, transform = true })

-- workspaces
hl.workspace_rule({ workspace = "4", monitor = "DP-2"})

-- exec
hl.on("hyprland.start", function ()
    hl.exec_cmd("discord", { workspace = "4 silent" })
    hl.exec_cmd("fluxer", { workspace = "4 silent" })
    hl.exec_cmd("signal-desktop", { workspace = "4 silent" })
    hl.exec_cmd("whatsdesk", { workspace = "4 silent" })
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("udiskie --smart-tray --appindicator")
end)
