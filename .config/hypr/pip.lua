-- void: floating video card (browser picture-in-picture).
-- Omarchy already floats + pins PiP windows (default/hypr/apps/pip.lua), so the
-- card follows you to every desktop. This adds the void look, keeps hover from
-- stealing focus, and clicking the card jumps back to the video's desktop.

o.window({ tag = "pip" }, {
  border_size = 2,
  border_color = "rgba(8b7cf6ee) rgba(2a2440ee) 45deg",
  rounding = 12,
  no_follow_mouse = true,
  no_initial_focus = true,
})

local function is_pip(window)
  for _, tag in ipairs(window.tags or {}) do
    if tag:gsub("%*$", "") == "pip" then
      return true
    end
  end
  return false
end

local function xy(value)
  if type(value) ~= "table" then
    return nil
  end
  return value.x or value[1], value.y or value[2]
end

-- Only a real click counts: Hyprland may also hand focus to the pinned card
-- when you land on an empty desktop, and that must not yank you back.
local function cursor_over(window)
  local cursor = hl.get_cursor_pos()
  local x, y = xy(window.at)
  local w, h = xy(window.size)
  if not (cursor and x and w) then
    return false
  end
  return cursor.x >= x and cursor.x <= x + w and cursor.y >= y and cursor.y <= y + h
end

-- The browser window that owns the card: same process, preferring a YouTube tab.
local function source_window(pip)
  local fallback
  for _, window in ipairs(hl.get_windows()) do
    if window.pid == pip.pid and not is_pip(window) and window.workspace then
      if (window.title or ""):find("YouTube", 1, true) then
        return window
      end
      fallback = fallback or window
    end
  end
  return fallback
end

local function jump_to_source(pip)
  local source = source_window(pip)
  if not source then
    return
  end
  local current = hl.get_active_workspace and hl.get_active_workspace()
  if current and current.id == source.workspace.id then
    return
  end
  hl.dispatch(hl.dsp.focus({ workspace = tostring(source.workspace.id) }))
end

local function find_window(address)
  for _, window in ipairs(hl.get_windows()) do
    if window.address == address then
      return window
    end
  end
end

local function moved(ax, ay, bx, by, slack)
  return math.abs(ax - bx) > slack or math.abs(ay - by) > slack
end

-- Last focused non-card window, so a drag can hand focus back and the next
-- click on the card registers as a fresh activation.
local last_window

local function settle_after_drag(address, px, py)
  hl.timer(function()
    local pip = find_window(address)
    if not pip then
      return
    end
    local x, y = xy(pip.at)
    if moved(x, y, px, py, 0) then
      settle_after_drag(address, x, y)
      return
    end
    local back = last_window and find_window(last_window)
    local current = hl.get_active_workspace()
    if back and back.workspace and current and back.workspace.id == current.id then
      hl.dispatch(hl.dsp.focus({ window = "address:" .. back.address }))
    end
  end, { timeout = 150, type = "oneshot" })
end

-- A click is a press that leaves the card and cursor where they were. If
-- either moves within the window, it's a drag: stay put and let it be moved.
local CLICK_MS, TICK_MS = 300, 50

local function watch_click(address, wx, wy, cx, cy, elapsed)
  hl.timer(function()
    local pip = find_window(address)
    local cursor = hl.get_cursor_pos()
    if not (pip and cursor) then
      return
    end
    local x, y = xy(pip.at)
    if moved(x, y, wx, wy, 3) or moved(cursor.x, cursor.y, cx, cy, 6) then
      settle_after_drag(address, x, y)
    elseif elapsed + TICK_MS >= CLICK_MS then
      jump_to_source(pip)
    else
      watch_click(address, wx, wy, cx, cy, elapsed + TICK_MS)
    end
  end, { timeout = TICK_MS, type = "oneshot" })
end

hl.on("window.active", function(window)
  window = window or hl.get_active_window()
  if not window then
    return
  end
  if not is_pip(window) then
    last_window = window.address
    return
  end
  if cursor_over(window) then
    local wx, wy = xy(window.at)
    local cursor = hl.get_cursor_pos()
    watch_click(window.address, wx, wy, cursor.x, cursor.y, 0)
  end
end)

o.bind("SUPER + ALT + P", "Play/pause video", "omarchy-shell media playPause")
o.bind("SUPER + ALT + Y", "Jump to floating video's desktop", function()
  for _, window in ipairs(hl.get_windows()) do
    if is_pip(window) then
      jump_to_source(window)
      return
    end
  end
end)
