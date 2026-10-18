-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Windows-style Czech AltGr: Ctrl+Alt+key types the same symbol as Right Alt+key.
-- Sends a real AltGr (MOD5) chord with explicit mods so the held Ctrl+Alt don't
-- leak into it (wtype did, which browsers rejected). Same down/up split as
-- Omarchy's universal clipboard bindings.
-- V @  Q \  W |  E €  X #  C &  F [  G ]  B {  N }  , <  . >
for _, key in ipairs({ "V", "Q", "W", "E", "X", "C", "F", "G", "B", "N", "comma", "period" }) do
  o.bind("CTRL + ALT + " .. key, nil, function()
    hl.dispatch(hl.dsp.send_key_state({ mods = "MOD5", key = key, state = "down" }))
    hl.timer(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = "MOD5", key = key, state = "up" }))
    end, { timeout = 50, type = "oneshot" })
  end)
end
