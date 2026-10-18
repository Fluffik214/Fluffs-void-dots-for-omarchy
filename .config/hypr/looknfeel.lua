-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
-- hl.config({
--   general = {
--     -- No gaps between windows or borders.
--     gaps_in = 0,
--     gaps_out = 0,
--     border_size = 0,
--
--     -- Change to niri-like side-scrolling layout.
--     layout = "scrolling",
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
-- hl.config({
--   decoration = {
--     -- Use round window corners.
--     rounding = 8,
--
--     -- Dim unfocused windows (0.0 = no dim, 1.0 = fully dimmed).
--     dim_inactive = true,
--     dim_strength = 0.15,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
-- hl.config({
--   animations = {
--     -- Disable all animations.
--     enabled = false,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- hl.config({
--   layout = {
--     -- Avoid overly wide single-window layouts on wide screens.
--     single_window_aspect_ratio = { 1, 1 },
--   },
-- })

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
--     column_width = 0.97,
--   },
-- })

-- void: floaty animations — things drift in and settle, like moving through space.
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("drift", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })
hl.curve("float", { type = "bezier", points = { { 0.22, 1.12 }, { 0.36, 1 } } })
hl.curve("sink", { type = "bezier", points = { { 0.4, 0 }, { 0.6, 0.4 } } })

hl.animation({ leaf = "windowsIn", enabled = true, speed = 6, bezier = "float", style = "popin 82%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "sink", style = "popin 90%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5.5, bezier = "drift" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 4, bezier = "drift" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 3, bezier = "sink" })
hl.animation({ leaf = "border", enabled = true, speed = 8, bezier = "drift" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 5, bezier = "drift", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 3, bezier = "sink", style = "fade" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "drift", style = "slidefade 12%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "drift", style = "slidefadevert 20%" })

-- Slowly rotating violet border gradient (keeps the GPU redrawing; set enabled = false to save battery).
hl.animation({ leaf = "borderangle", enabled = true, speed = 100, bezier = "linear", style = "loop" })

-- void: window look — soft corners, violet glow on focus, dim the rest, frosted shell surfaces.
hl.config({
  general = {
    gaps_in = 4,
    gaps_out = 8,
  },

  decoration = {
    rounding = 10,
    rounding_power = 2.5,

    dim_inactive = true,
    dim_strength = 0.12,

    shadow = {
      enabled = true,
      range = 22,
      render_power = 3,
      color = "rgba(8b7cf640)",
      color_inactive = "rgba(00000000)",
    },

    blur = {
      enabled = true,
      size = 7,
      passes = 3,
      noise = 0.015,
      vibrancy = 0.2,
      brightness = 0.8,
    },
  },
})

hl.layer_rule({ match = { namespace = "^omarchy-(bar|menu|notifications|osd|clipboard|emojis|reminders|polkit)$" }, blur = true, ignore_alpha = 0.2 })
