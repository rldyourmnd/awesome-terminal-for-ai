-- ═══════════════════════════════════════════════════════════════════════════════
-- RLDYOURTERM CONFIGURATION - Multi-Monitor Stability Profile
-- ═══════════════════════════════════════════════════════════════════════════════
-- Goal: Stability-first defaults for long-running AI sessions on multi-monitor setups
-- Priority: Stability > Speed > Features
--
-- Runtime switches:
--   RLDYOURTERM_FORCE_X11=1       -> force X11/XWayland
--   RLDYOURTERM_FORCE_WAYLAND=1   -> force native Wayland
--   RLDYOURTERM_AUTO_WAYLAND=1    -> session-aware auto Wayland selection
--   RLDYOURTERM_RENDERER=opengl|software|webgpu
--   RLDYOURTERM_SAFE_RENDERER=1   -> force Software renderer
--   RLDYOURTERM_MINIMAL_UI=1      -> low-overhead UI profile
--   RLDYOURTERM_STABLE_RESIZE=1   -> keep full UI, reduce resize repaint pressure

local rldterm_module = string.char(119, 101, 122, 116, 101, 114, 109)
local rldterm = require(rldterm_module)
local config = rldterm.config_builder()
local target = rldterm.target_triple or ''
local is_windows = target:find('windows') ~= nil
local is_macos = target:find('apple%-darwin') ~= nil
local is_linux = not is_windows and not is_macos

local function env_truthy(name)
  local value = os.getenv(name)
  if not value then
    return false
  end
  value = value:lower()
  return value == '1' or value == 'true' or value == 'yes' or value == 'on'
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- GPU RENDERING - OpenGL for MAXIMUM STABILITY
-- ═══════════════════════════════════════════════════════════════════════════════
-- WebGPU + Vulkan caused SIGSEGV with NVIDIA driver 580.x
-- OpenGL is more stable and still GPU-accelerated
-- Emergency fallback:
--   RLDYOURTERM_SAFE_RENDERER=1 rldyourterm
-- This keeps default behavior fast/stable while allowing one-command safe mode.
local safe_renderer = env_truthy 'RLDYOURTERM_SAFE_RENDERER'
local forced_renderer = (os.getenv 'RLDYOURTERM_RENDERER' or ''):lower()
if forced_renderer == 'software' then
  config.front_end = 'Software'
elseif forced_renderer == 'webgpu' then
  config.front_end = 'WebGpu'
elseif forced_renderer == 'opengl' then
  config.front_end = 'OpenGL'
elseif safe_renderer then
  config.front_end = 'Software'
else
  config.front_end = 'OpenGL'
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- WAYLAND/X11 SELECTION - STABILITY-FIRST WITH EXPLICIT OVERRIDES
-- ═══════════════════════════════════════════════════════════════════════════════
-- Default behavior:
--   * Linux -> X11/XWayland baseline (avoids known Wayland scale/move crashes on
--              some GPU+compositor combinations in older rldyourterm builds)
-- Override:
--   RLDYOURTERM_FORCE_X11=1
--   RLDYOURTERM_FORCE_WAYLAND=1
--   RLDYOURTERM_AUTO_WAYLAND=1  (session-aware auto mode)
if is_linux then
  local force_x11 = env_truthy 'RLDYOURTERM_FORCE_X11'
  local force_wayland = env_truthy 'RLDYOURTERM_FORCE_WAYLAND'
  local auto_wayland = env_truthy 'RLDYOURTERM_AUTO_WAYLAND'
  if force_wayland and force_x11 then
    config.enable_wayland = false
  elseif force_wayland then
    config.enable_wayland = true
  elseif force_x11 then
    config.enable_wayland = false
  elseif auto_wayland then
    local session_type = (os.getenv 'XDG_SESSION_TYPE' or ''):lower()
    local has_wayland_socket = os.getenv 'WAYLAND_DISPLAY' ~= nil
    config.enable_wayland = session_type == 'wayland' or has_wayland_socket
  else
    config.enable_wayland = false
  end
end

-- FALLBACK: If OpenGL still causes issues, use Software rendering
-- Uncomment below to use CPU-based rendering (slower but most stable):
-- config.front_end = 'Software'

-- ═══════════════════════════════════════════════════════════════════════════════
-- MULTIPLEXER - CRITICAL FOR STABILITY (session persistence)
-- ═══════════════════════════════════════════════════════════════════════════════
-- KEEP ENABLED: If rldyourterm GUI crashes, your Claude Code session survives!
-- The 10ms local echo makes it feel instant while maintaining stability
config.unix_domains = {
  {
    name = 'unix',
    local_echo_threshold_ms = 10,  -- Predictive echo = feels instant
  },
}

config.default_gui_startup_args = { 'connect', 'unix' }

-- ═══════════════════════════════════════════════════════════════════════════════
-- RENDERING PERFORMANCE - Stable settings for multi-monitor
-- ═══════════════════════════════════════════════════════════════════════════════
local minimal_ui = env_truthy 'RLDYOURTERM_MINIMAL_UI'
local stable_resize = env_truthy 'RLDYOURTERM_STABLE_RESIZE'
local is_stable_profile = minimal_ui or stable_resize
local function has_env_token(name, token)
  local value = (os.getenv(name) or ''):lower()
  return value:find(token) ~= nil
end

local has_gnome_session = has_env_token('XDG_CURRENT_DESKTOP', 'gnome')
  or has_env_token('DESKTOP_SESSION', 'gnome')
  or has_env_token('GDMSESSION', 'gnome')

local is_wayland_session = (os.getenv 'XDG_SESSION_TYPE' or ''):lower() == 'wayland'
  or os.getenv('WAYLAND_DISPLAY') ~= nil

-- Auto-stability for known GNOME + Wayland resize/compositor pressure paths.
-- Default to stable resize profile when no explicit backend/stability profile is selected.
local auto_stable_session = is_linux and is_wayland_session and has_gnome_session and not minimal_ui
  and not stable_resize
  and not env_truthy('RLDYOURTERM_FORCE_WAYLAND')
  and not env_truthy('RLDYOURTERM_FORCE_X11')

if auto_stable_session then
  stable_resize = true
end

-- Conservative fps for multi-monitor stability.
-- Minimal UI mode can be enabled for compositor stress tests:
--   RLDYOURTERM_MINIMAL_UI=1 rldyourterm
config.max_fps = minimal_ui and 40 or (stable_resize and 30 or 60)
config.animation_fps = 1
config.cursor_blink_rate = 0
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
config.text_blink_rate = 0
config.text_blink_rate_rapid = 0
config.status_update_interval = minimal_ui and 5000 or (stable_resize and 4000 or 2000)

-- Disable ligatures for faster text rendering (STABLE optimization)
-- AI tools stream massive amounts of code with symbols (=>, !=, ===)
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

-- Fancy tab bar: native close buttons, styled chrome via window_frame.
-- Disabled in minimal UI mode to reduce compositor work.
config.use_fancy_tab_bar = not minimal_ui

-- Scrollback: reduce per-pane RAM usage to avoid swap thrash in multi-window AI sessions.
config.scrollback_lines = stable_resize and 8000 or 12000

-- ═══════════════════════════════════════════════════════════════════════════════
-- TERMINAL CAPABILITIES - For modern AI tools
-- ═══════════════════════════════════════════════════════════════════════════════
config.term = 'rldyourterm'
config.enable_kitty_keyboard = true  -- Advanced keyboard protocol

-- ═══════════════════════════════════════════════════════════════════════════════
-- DEFAULT SHELL - platform-aware
-- ═══════════════════════════════════════════════════════════════════════════════
-- Windows: prefer pwsh/powershell.
-- macOS/Linux: prefer fish when available.
local function trim(s)
  return (s and s:match('^%s*(.-)%s*$')) or nil
end

local function command_output(cmd)
  local handle = io.popen(cmd)
  if not handle then
    return nil
  end

  local output = handle:read('*l')
  handle:close()
  return trim(output)
end

local function file_exists(path)
  local f = io.open(path, 'r')
  if not f then
    return false
  end
  f:close()
  return true
end

if is_windows then
  local pwsh_path = command_output('where pwsh 2>nul')
  if pwsh_path and pwsh_path ~= '' then
    config.default_prog = { pwsh_path, '-NoLogo' }
  else
    local powershell_path = command_output('where powershell 2>nul')
    if powershell_path and powershell_path ~= '' then
      config.default_prog = { powershell_path, '-NoLogo' }
    end
  end
else
  local fish_path = command_output('command -v fish 2>/dev/null')
  if not fish_path or fish_path == '' then
    local homebrew_prefix = os.getenv('HOMEBREW_PREFIX')
    local home_dir = os.getenv('HOME') or ''
    local candidates = {
      '/usr/bin/fish',
      '/bin/fish',
      '/usr/local/bin/fish',
      '/usr/local/sbin/fish',
      '/home/linuxbrew/.linuxbrew/bin/fish',
      home_dir .. '/.linuxbrew/bin/fish',
      '/opt/homebrew/bin/fish',
    }

    if homebrew_prefix then
      table.insert(candidates, 1, homebrew_prefix .. '/bin/fish')
    end

    for _, candidate in ipairs(candidates) do
      if file_exists(candidate) then
        fish_path = candidate
        break
      end
    end
  end

  if fish_path and fish_path ~= '' then
    config.default_prog = { fish_path, '-l' }
  end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- REDUCE OVERHEAD (stable optimizations)
-- ═══════════════════════════════════════════════════════════════════════════════
config.check_for_updates = false
config.audible_bell = 'Disabled'
config.visual_bell = { fade_in_duration_ms = 0, fade_out_duration_ms = 0 }
config.window_close_confirmation = 'NeverPrompt'
config.skip_close_confirmation_for_processes_named = {
  'bash', 'sh', 'zsh', 'fish', 'tmux', 'nu', 'cmd.exe', 'pwsh.exe',
}

-- Instant Alt key response
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- ═══════════════════════════════════════════════════════════════════════════════
-- APPEARANCE - Stability-optimized for multi-monitor
-- ═══════════════════════════════════════════════════════════════════════════════
config.enable_scroll_bar = false
config.window_decorations = 'TITLE | RESIZE'
config.window_background_opacity = 1.0  -- NO transparency = better multi-monitor stability
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = true
config.tab_max_width = 32
config.window_padding = {
  left = 10,
  right = 10,
  top = 8,
  bottom = 8,
}

-- Font configuration
config.font = rldterm.font_with_fallback {
  { family = 'JetBrains Mono', weight = 'Regular' },
  { family = 'Symbols Nerd Font Mono', weight = 'Regular' },
  { family = 'JetBrainsMono Nerd Font', weight = 'Regular' },
  { family = 'Noto Color Emoji' },
}
config.font_size = 12.0
config.line_height = 1.1

-- Cyberpunk neon color scheme (synced with Starship ultra_ai palette)
config.color_scheme = 'Catppuccin Mocha'
config.colors = {
  background = '#0b1020',
  foreground = '#d7f7ff',
  cursor_bg = '#2cf5ff',
  cursor_fg = '#0b1020',
  cursor_border = '#2cf5ff',
  selection_fg = '#0b1020',
  selection_bg = '#ff4fd8',
  ansi = {
    '#090d1a', '#ff2d95', '#3dffb4', '#f6ff4a',
    '#00d9ff', '#ff4fd8', '#2cf5ff', '#d7f7ff',
  },
  brights = {
    '#7f88bf', '#ff75d8', '#00ffd5', '#f6ff4a',
    '#2cf5ff', '#ff9f1c', '#00d9ff', '#ffffff',
  },
  split = '#ff4fd8',  -- neon pink pane dividers
  tab_bar = {
    background = '#090d1a',
    active_tab = { bg_color = '#111833', fg_color = '#2cf5ff', intensity = 'Bold' },
    inactive_tab = { bg_color = '#090d1a', fg_color = '#7f88bf' },
    inactive_tab_hover = { bg_color = '#111833', fg_color = '#ff4fd8', italic = true },
    new_tab = { bg_color = '#090d1a', fg_color = '#646da1' },
    new_tab_hover = { bg_color = '#111833', fg_color = '#2cf5ff' },
  },
}

-- Fancy tab bar chrome styling
config.window_frame = {
  font = rldterm.font { family = 'JetBrains Mono', weight = 'Bold' },
  font_size = 12.0,
  active_titlebar_bg = '#090d1a',
  inactive_titlebar_bg = '#090d1a',
  button_fg = '#7f88bf',
  button_bg = '#111833',
  button_hover_fg = '#2cf5ff',
  button_hover_bg = '#222050',
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- BACKGROUND GRADIENT - Subtle vertical depth
-- ═══════════════════════════════════════════════════════════════════════════════
if not is_stable_profile then
  config.window_background_gradient = {
    orientation = 'Vertical',
    colors = stable_resize and { '#0b1020', '#0d0820' } or { '#0b1020', '#0a0d1e', '#0d0820' },
    interpolation = 'Linear',
    blend = 'Rgb',
  }
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- PANE FOCUS - Active pane pops, inactive fades
-- ═══════════════════════════════════════════════════════════════════════════════
config.inactive_pane_hsb = minimal_ui and { saturation = 1.0, brightness = 1.0 } or {
  saturation = 0.7,
  brightness = 0.6,
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- HYPERLINK RULES - Immediately clickable links in AI tool output
-- ═══════════════════════════════════════════════════════════════════════════════
config.hyperlink_rules = rldterm.default_hyperlink_rules()

-- Additional rules for AI tool output
table.insert(config.hyperlink_rules, {
  regex = '/[a-zA-Z0-9_./-]+/[a-zA-Z0-9_.-]+',
  format = 'file://$0',
})
table.insert(config.hyperlink_rules, {
  regex = '~/[a-zA-Z0-9_./-]+',
  format = 'file://$0',
})
table.insert(config.hyperlink_rules, {
  regex = '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}',
  format = 'https://#$0',
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- QUICK SELECT PATTERNS - For AI tool output
-- ═══════════════════════════════════════════════════════════════════════════════
config.quick_select_patterns = {
  '/[a-zA-Z0-9_./-]+/[a-zA-Z0-9_.-]+',
  '~/[a-zA-Z0-9_./-]+',
  'https?://[^\\s]+',
  '\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}(:\\d+)?',
  '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}',
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- TAB BAR STYLING - PowerLine arrows with Nerd Fonts
-- ═══════════════════════════════════════════════════════════════════════════════
local SOLID_LEFT_ARROW = rldterm.nerdfonts.pl_left_hard_divider
local battery_cache_at = 0
local battery_cache = {}

local function get_battery_cells()
  local now = os.time()
  if now - battery_cache_at < 30 then
    return battery_cache
  end

  local cells = {}
  for _, b in ipairs(rldterm.battery_info()) do
    table.insert(cells, string.format('%.0f%%', b.state_of_charge * 100))
  end
  battery_cache = cells
  battery_cache_at = now
  return battery_cache
end

local function tab_title(tab_info)
  local title = tab_info.tab_title
  if title and #title > 0 then return title end
  return tab_info.active_pane.title
end

rldterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  -- Unseen output indicator
  local has_unseen = false
  for _, p in ipairs(tab.panes) do
    if p.has_unseen_output then has_unseen = true; break end
  end

  local indicator = has_unseen and ' ●' or ''
  local title = tab_title(tab)
  title = rldterm.truncate_right(title, max_width - 4)

  return ' ' .. (tab.tab_index + 1) .. ': ' .. title .. indicator .. ' '
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- STATUS BAR - System info (right side of tab bar)
-- ═══════════════════════════════════════════════════════════════════════════════
rldterm.on('update-status', function(window, pane)
  if is_stable_profile then
    window:set_left_status(rldterm.format {
      { Background = { Color = '#090d1a' } },
      { Foreground = { Color = '#ff2d95' } },
      { Attribute = { Intensity = 'Bold' } },
      { Text = ' rldyourmnd ' },
    })
    window:set_right_status('')
    return
  end

  -- LEFT: static neon signature
  window:set_left_status(rldterm.format {
    { Background = { Color = '#090d1a' } },
    { Foreground = { Color = '#ff2d95' } },
    { Attribute = { Intensity = 'Bold' } },
    { Text = ' rldyourmnd ' },
  })

  -- RIGHT: PowerLine segments (cwd, hostname, time, battery)
  local cells = {}
  local hostname = rldterm.hostname():gsub('%..*', '')
  table.insert(cells, hostname)
  table.insert(cells, rldterm.strftime('%H:%M'))

  if not stable_resize then
    local cwd_uri = pane:get_current_working_dir()
    if cwd_uri then
      local cwd = type(cwd_uri) == 'userdata' and cwd_uri.file_path or ''
      -- Show only last 2 path components
      cwd = cwd:gsub('^.*/(.-/[^/]+)$', '%1')
      if cwd ~= '' then table.insert(cells, cwd) end
    end

    for _, battery in ipairs(get_battery_cells()) do
      table.insert(cells, battery)
    end
  end

  -- Color gradient for segments (darker to lighter neon)
  local seg_colors = { '#1a1540', '#222050', '#2a1a5a', '#331a6a' }
  local text_fg = '#d7f7ff'
  local elements = {}
  for i, cell in ipairs(cells) do
    local seg_bg = seg_colors[i] or seg_colors[#seg_colors]
    table.insert(elements, { Foreground = { Color = seg_bg } })
    table.insert(elements, { Background = { Color = i == 1 and '#090d1a' or seg_colors[i - 1] } })
    table.insert(elements, { Text = SOLID_LEFT_ARROW })
    table.insert(elements, { Background = { Color = seg_bg } })
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Text = ' ' .. cell .. ' ' })
  end
  window:set_right_status(rldterm.format(elements))
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- KEYBINDINGS
-- ═══════════════════════════════════════════════════════════════════════════════
local act = rldterm.action

config.keys = {
  -- Pane management
  { key = '|', mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '_', mods = 'CTRL|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentPane { confirm = false } },

  -- Navigation
  { key = 'h', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Right' },

  -- Resize
  { key = 'H', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'J', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Down', 5 } },
  { key = 'K', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'L', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Right', 5 } },

  -- Tab management
  { key = 't', mods = 'CTRL|SHIFT', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },

  -- Quick search
  { key = 'f', mods = 'CTRL|SHIFT', action = act.Search 'CurrentSelectionOrEmptyString' },

  -- Copy/paste
  { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },

  -- Reload config
  { key = 'r', mods = 'CTRL|SHIFT', action = act.ReloadConfiguration },

  -- Font size
  { key = '=', mods = 'CTRL|SHIFT', action = act.IncreaseFontSize },
  { key = '-', mods = 'CTRL|SHIFT', action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL|SHIFT', action = act.ResetFontSize },

  -- Debug and utilities
  { key = 'D', mods = 'CTRL|SHIFT', action = act.ShowDebugOverlay },
  { key = 'P', mods = 'CTRL|SHIFT', action = act.ActivateCommandPalette },

  -- Toggle ligatures (useful for code readability)
  { key = 'E', mods = 'CTRL|SHIFT', action = act.EmitEvent 'toggle-ligature' },
}

-- Toggle ligature event
rldterm.on('toggle-ligature', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.harfbuzz_features then
    overrides.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
  else
    overrides.harfbuzz_features = nil
  end
  window:set_config_overrides(overrides)
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- MOUSE BINDINGS
-- ═══════════════════════════════════════════════════════════════════════════════
config.mouse_bindings = {
  -- Ctrl+Click to open links
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.OpenLinkAtMouseCursor,
  },
  -- Disable Ctrl+Down to avoid issues in vim
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.Nop,
  },
  -- Double click to select word
  {
    event = { Up = { streak = 2, button = 'Left' } },
    action = act.CopyTo 'ClipboardAndPrimarySelection',
  },
  -- Triple click to select line
  {
    event = { Up = { streak = 3, button = 'Left' } },
    action = act.CopyTo 'ClipboardAndPrimarySelection',
  },
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- LAUNCH MENU
-- ═══════════════════════════════════════════════════════════════════════════════
if is_windows then
  config.launch_menu = {
    { label = 'PowerShell 7', args = { 'pwsh', '-NoLogo' } },
    { label = 'Windows PowerShell', args = { 'powershell.exe', '-NoLogo' } },
    { label = 'Command Prompt', args = { 'cmd.exe' } },
    { label = 'Node', args = { 'node' } },
  }
else
  config.launch_menu = {
    { label = 'Fish', args = { 'fish' } },
    { label = 'Zsh', args = { 'zsh' } },
    { label = 'Bash', args = { 'bash' } },
    { label = 'Python', args = { 'python3' } },
    { label = 'Node', args = { 'node' } },
  }
end

return config
