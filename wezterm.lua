local wezterm = require("wezterm")
local config = wezterm.config_builder()
local mux = wezterm.mux

local themes = require("miter.themes")
local ui = require("miter.ui")
local fonts = require("miter.fonts")
local keys = require("miter.keys")
local domains = require("miter.domains")

local target = wezterm.target_triple
local is_windows = target:find("windows") ~= nil
local gen_spawn_command_func
if is_windows then
  config.default_prog = { 'wsl', '-d', 'Ubuntu-26.04', '--cd', '/home/miter' }
  gen_spawn_command_func = function(cwd)
    return  { domain = "CurrentPaneDomain", args = {'wsl', '-d', 'Ubuntu-26.04', '--cd', cwd } }
  end
else
  config.default_prog = { 'bash', '-l' }
  gen_spawn_command_func = function(cwd)
    return { domain = "CurrentPaneDomain", args = { 'bash', '-l' }, cwd = cwd }
  end
end

config.mux_enable_ssh_agent = false

domains.load(config)
themes.load(config)
ui.load(config)
fonts.load(config)
keys.load(config, gen_spawn_command_func)

return config
