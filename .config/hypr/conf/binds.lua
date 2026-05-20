-- See https://wiki.hypr.land/Configuring/Basics/Binds/ for more
local mod = "SUPER"
local left = "H"
local down = "J"
local up = "K"
local right = "L"

hl.bind(mod .. " + Return", hl.dsp.exec_cmd(_G.bin .. "/terminal"))
hl.bind(mod .. " + Q", hl.dsp.window.kill())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + Space", hl.dsp.exec_cmd(_G.scripts .. "/menu"))
--bind = $mod, V, togglesplit, # dwindle
hl.bind(mod .. "+ X", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mod .. " + SHIFT + Space", hl.dsp.window.float())
hl.bind(mod .. " + S", hl.dsp.window.pin())
hl.bind(mod .. " + T", hl.dsp.group.toggle())
hl.bind("CTRL + Space", hl.dsp.exec_cmd("hyprctl switchxkblayout all next"))
hl.bind(mod .. " + Tab", function ()
    -- TODO(rgcv): doesn't work
    return function ()
        local w = hl.get_active_window()
        if not w then return end
        if w.floating then
            hl.dispatch(hl.dsp.window.cycle_next({ tiled = true }))
        else
            hl.dispatch(hl.dsp.window.cycle_next({ floating = true }))
        end
    end
end)

-- Move focus with mod + hjkl/cursors
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "d" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + " .. left, hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + " .. down, hl.dsp.focus({ direction = "d" }))
hl.bind(mod .. " + " .. up, hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + " .. right, hl.dsp.focus({ direction = "r" }))

-- Move window with mod + SHIFT + hjkl/cursors
hl.bind(mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l", group_aware = true }))
hl.bind(mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d", group_aware = true }))
hl.bind(mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u", group_aware = true }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r", group_aware = true }))
hl.bind(mod .. " + SHIFT + " .. left, hl.dsp.window.move({ direction = "l", group_aware = true }))
hl.bind(mod .. " + SHIFT + " .. down, hl.dsp.window.move({ direction = "d", group_aware = true }))
hl.bind(mod .. " + SHIFT + " .. up, hl.dsp.window.move({ direction = "u", group_aware = true }))
hl.bind(mod .. " + SHIFT + " .. right, hl.dsp.window.move({ direction = "r", group_aware = true }))

-- Resize active window with mode + yuio
local function resize_pct(x, y)
    return function ()
        local w = hl.get_active_window()
        if not w then return end
        hl.dispatch(hl.dsp.window.resize({
            x = math.floor(w.size.x * x / 100),
            y = math.floor(w.size.y * y / 100),
            relative = true,
        }))
    end
end
hl.bind(mod .. " + Y", resize_pct(-10,   0), { repeating = true })
hl.bind(mod .. " + U", resize_pct(  0, -10), { repeating = true })
hl.bind(mod .. " + I", resize_pct(  0,  10), { repeating = true })
hl.bind(mod .. " + O", resize_pct( 10,   0), { repeating = true })
hl.bind(mod .. " + SHIFT + U", resize_pct(-10, -10), { repeating = true })
hl.bind(mod .. " + SHIFT + I", resize_pct( 10,  10), { repeating = true })

-- Switch workspaces with mod + [0-9]
for i = 1, 10, 1 do
    hl.bind(mod .. " + " .. (i % 10), hl.dsp.focus({ workspace = i }))
end

-- Move active window to a workspace with mod + SHIFT + [0-9]
for i = 1, 10, 1 do
    hl.bind(mod .. " + SHIFT + " .. (i % 10), hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Move current workspace to output elsewhere
hl.bind(mod .. " + CTRL + left", hl.dsp.workspace.move({ monitor = "l" }))
hl.bind(mod .. " + CTRL + down", hl.dsp.workspace.move({ monitor = "d" }))
hl.bind(mod .. " + CTRL + up", hl.dsp.workspace.move({ monitor = "u" }))
hl.bind(mod .. " + CTRL + right", hl.dsp.workspace.move({ monitor = "r" }))
hl.bind(mod .. " + CTRL + " .. left, hl.dsp.workspace.move({ monitor = "l" }))
hl.bind(mod .. " + CTRL + " .. down, hl.dsp.workspace.move({ monitor = "d" }))
hl.bind(mod .. " + CTRL + " .. up, hl.dsp.workspace.move({ monitor = "u" }))
hl.bind(mod .. " + CTRL + " .. right, hl.dsp.workspace.move({ monitor = "r" }))

-- Scroll through existing workspaces with mod + scrol
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mod + LMB/RMB and dragging
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize())
hl.bind(mod .. " + SHIFT + mouse:273", hl.dsp.window.resize())

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("SHIFT + XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SOURCE@ 5%+"), { locked = true, repeating = true })
hl.bind("SHIFT + XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SOURCE@ 5%-"), { locked = true, repeating = true })
hl.bind("SHIFT + XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Screenshotting
-- windows-like
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd(_G.scripts .. "/grimblast --notify --freeze -- copysave area"))
hl.bind("Print", hl.dsp.exec_cmd(_G.scripts .. "/grimblast --notify -- copy screen"))
hl.bind("ALT + Print", hl.dsp.exec_cmd(_G.scripts .. "/grimblast --notify -- copy active"))
hl.bind(mod .. " + Print", hl.dsp.exec_cmd(_G.scripts .. "/grimblast --notify -- copysave screen"))
-- alternative
hl.bind(mod .. " +                P", hl.dsp.exec_cmd(_G.scripts .. "/grimblast --notify copy screen"))
hl.bind(mod .. " +         ALT  + P", hl.dsp.exec_cmd(_G.scripts .. "/grimblast --notify copy output"))
hl.bind(mod .. " +         CTRL + P", hl.dsp.exec_cmd(_G.scripts .. "/grimblast --notify --freeze copy area"))
hl.bind(mod .. " + SHIFT +        P", hl.dsp.exec_cmd(_G.scripts .. "/grimblast --notify save screen"))
hl.bind(mod .. " + SHIFT + ALT  + P", hl.dsp.exec_cmd(_G.scripts .. "/grimblast --notify save output"))
hl.bind(mod .. " + SHIFT + CTRL + P", hl.dsp.exec_cmd(_G.scripts .. "/grimblast --notify --freeze save area"))

-- Submap
-- system
hl.bind(mod .. " + SHIFT + X", hl.dsp.submap("system"))
hl.define_submap("system", function ()
    hl.bind("U", hl.dsp.exec_cmd("systemctl poweroff"))
    hl.bind("S", hl.dsp.exec_cmd("systemctl suspend"))
    hl.bind("L", hl.dsp.exec_cmd("systemctl terminate-user $USER"))
    hl.bind("R", hl.dsp.exec_cmd("systemctl reboot"))
    hl.bind("escape", hl.dsp.submap("reset"))
end)
