-- WezTerm Configuration
-- Matches Ghostty/Kitty configuration for consistency

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Load bar.wezterm plugin
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")

-- ==============================================================================
-- Font Configuration
-- ==============================================================================
config.font = wezterm.font('FiraCode Nerd Font Mono')
config.font_size = 16.0
config.harfbuzz_features = { 'zero', 'onum' }

-- ==============================================================================
-- Theme & Colors (Gruvbox Dark)
-- ==============================================================================
config.color_scheme = 'Gruvbox dark, hard (base16)'

-- Override with exact Gruvbox colors to match Ghostty
config.colors = {
  foreground = '#ebdbb2',
  background = '#282828',
  cursor_bg = '#928374',
  cursor_fg = '#282828',
  cursor_border = '#928374',
  selection_fg = '#928374',
  selection_bg = '#3c3836',

  -- Normal colors (0-7)
  ansi = {
    '#282828', -- black
    '#cc241d', -- red
    '#98971a', -- green
    '#d79921', -- yellow
    '#458588', -- blue
    '#b16286', -- magenta
    '#689d6a', -- cyan
    '#a89984', -- white
  },

  -- Bright colors (8-15)
  brights = {
    '#928374', -- bright black
    '#fb4934', -- bright red
    '#b8bb26', -- bright green
    '#fabd2d', -- bright yellow
    '#83a598', -- bright blue
    '#d3869b', -- bright magenta
    '#8ec07c', -- bright cyan
    '#928374', -- bright white
  },
}

-- ==============================================================================
-- Window Appearance & Behavior
-- ==============================================================================
config.window_decorations = 'RESIZE'
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}

-- Transparency and blur
config.window_background_opacity = 0.90
config.macos_window_background_blur = 32

-- Tab bar (configured via bar.wezterm plugin below)
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false

-- ==============================================================================
-- Cursor
-- ==============================================================================
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 0  -- No blinking
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

-- ==============================================================================
-- Shell
-- ==============================================================================
config.default_prog = { '/opt/homebrew/bin/fish' }

-- ==============================================================================
-- macOS Specific
-- ==============================================================================
config.send_composed_key_when_left_alt_is_pressed = true   -- macOS special chars (˙, ´, ˜, ˆ)
config.send_composed_key_when_right_alt_is_pressed = false  -- Terminal Meta key (Fish bindings)
config.quit_when_all_windows_are_closed = true

-- Display color space
config.color_scheme_dirs = {}
config.front_end = 'WebGpu'

-- ==============================================================================
-- Keybindings
-- ==============================================================================
local act = wezterm.action

config.keys = {
  -- Font size adjustments (cmd+ctrl like kitty_mod)
  { key = '=', mods = 'CMD|CTRL', action = act.IncreaseFontSize },
  { key = '-', mods = 'CMD|CTRL', action = act.DecreaseFontSize },
  { key = 'Backspace', mods = 'CMD|CTRL', action = act.ResetFontSize },

  -- Split management
  { key = 'd', mods = 'CMD', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'CMD|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'w', mods = 'CMD', action = act.CloseCurrentPane { confirm = false } },

  -- Split navigation (CMD+ALT+arrows)
  { key = 'LeftArrow', mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow', mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow', mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Down' },

  -- Pane resizing (CTRL+CMD+arrows)
  { key = 'LeftArrow', mods = 'CTRL|CMD', action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'RightArrow', mods = 'CTRL|CMD', action = act.AdjustPaneSize { 'Right', 5 } },
  { key = 'UpArrow', mods = 'CTRL|CMD', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'DownArrow', mods = 'CTRL|CMD', action = act.AdjustPaneSize { 'Down', 5 } },

  -- Tab management
  { key = 't', mods = 'CMD', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CMD|SHIFT', action = act.CloseCurrentTab { confirm = false } },
  { key = '[', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = ']', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(1) },

  -- Tab selection (cmd+1-9)
  { key = '1', mods = 'CMD', action = act.ActivateTab(0) },
  { key = '2', mods = 'CMD', action = act.ActivateTab(1) },
  { key = '3', mods = 'CMD', action = act.ActivateTab(2) },
  { key = '4', mods = 'CMD', action = act.ActivateTab(3) },
  { key = '5', mods = 'CMD', action = act.ActivateTab(4) },
  { key = '6', mods = 'CMD', action = act.ActivateTab(5) },
  { key = '7', mods = 'CMD', action = act.ActivateTab(6) },
  { key = '8', mods = 'CMD', action = act.ActivateTab(7) },
  { key = '9', mods = 'CMD', action = act.ActivateTab(8) },

  -- Word navigation (alt+left/right)
  { key = 'LeftArrow', mods = 'ALT', action = act.SendKey { key = 'b', mods = 'ALT' } },
  { key = 'RightArrow', mods = 'ALT', action = act.SendKey { key = 'f', mods = 'ALT' } },

  -- Atuin history search (Cmd+R sends Ctrl+R)
  { key = 'r', mods = 'CMD', action = act.SendKey { key = 'r', mods = 'CTRL' } },

  -- Clear scrollback
  { key = 'k', mods = 'CMD', action = act.ClearScrollback 'ScrollbackAndViewport' },

  -- Config reload
  { key = ',', mods = 'CMD|SHIFT', action = act.ReloadConfiguration },

  -- Shift+Enter sends escape+return
  { key = 'Enter', mods = 'SHIFT', action = act.SendString '\x1b\r' },
}

-- ==============================================================================
-- Mouse
-- ==============================================================================
config.mouse_bindings = {
  -- Disable click to open URLs (can be customized)
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelection 'ClipboardAndPrimarySelection',
  },
}

config.hide_mouse_cursor_when_typing = true

-- ==============================================================================
-- Miscellaneous
-- ==============================================================================
config.automatically_reload_config = true
config.scrollback_lines = 50000
config.enable_scroll_bar = false
config.window_close_confirmation = 'NeverPrompt'

-- ==============================================================================
-- Bar Plugin Configuration
-- ==============================================================================
bar.apply_to_config(
  config,
  {
    position = "bottom",
    max_width = 32,
    separator = {
      space = 1,
      left_icon = "",
      right_icon = "",
      field_icon = " ",
    },
    modules = {
      tabs = {
        enabled = true,
        active_tab_fg = 4,  -- blue
        inactive_tab_fg = 6, -- cyan (muted)
      },
      workspace = {
        enabled = false,
      },
      leader = {
        enabled = false,
      },
      pane = {
        enabled = false,
      },
      username = {
        enabled = false,
      },
      hostname = {
        enabled = false,
      },
      clock = {
        enabled = true,
        format = "%H:%M",
      },
      cwd = {
        enabled = true,
      },
    },
  }
)

return config
