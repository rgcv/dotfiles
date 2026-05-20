-- https://wiki.hypr.land/Configuring/Variables/#general
local colors = require("themes.mocha")

hl.config({
    general = {
        layout = "dwindle",

        border_size = 2,
        gaps_in = 7,
        gaps_out = 15,
        -- https://wiki.hypr.land/Configuring/Basics/Variables/#variable-types for info about colors
        ["col.active_border"] = "rgba(" .. colors.lavenderAlpha .. "ee)",
        ["col.inactive_border"] = "rgba(" .. colors.surface1Alpha .. "ee)"
    },

    -- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
    decoration = {
        rounding = 10,
        shadow = {
            color = "rgba(" .. colors.baseAlpha .. "ee)"
        }
    },

    -- https://wiki.hypr.land/Configuring/Basics/Variables/#misc
    misc = {
        force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = false -- If true disables the random hyprland logo / anime girl background. :(
    }
})
