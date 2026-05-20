-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name = "suppress-maximize-events",
    match = {
        class = ".*",
    },
    suppress_event = "maximize",
})

hl.window_rule {
    -- Fix some dragging issues with XWayland
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },

    no_focus = true
}

hl.window_rule({
    match = {
        class = "steam",
        title = "Friends List",
    },
    float = true,
})

hl.window_rule({
    match = {
        class = "firefox",
        title = "Picture-in-Picture",
    },
    float = true,
    pin = true,
})
hl.window_rule({ match = { class = "firefox" }, workspace = 3 })
hl.window_rule({ match = { class = "discord" }, workspace = 4 })
hl.window_rule({ match = { class = "fluxer_app" }, workspace = 4 })
hl.window_rule({ match = { class = "vesktop" }, workspace = 4 })
hl.window_rule({ match = { class = "whatsdesk" }, workspace = 4 })
hl.window_rule({ match = { class = "signal" }, workspace = 4 })
