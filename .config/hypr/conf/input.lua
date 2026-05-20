-- https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
    input = {
            kb_layout = "us,us(intl)",
            kb_variant = nil,
            kb_model = nil,
            kb_options = "caps:escape",
            kb_rules = nil,

            repeat_rate = 30,
            repeat_delay = 350,

            touchpad = {
                natural_scroll = true,
            },
        },
})

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

