local wezterm = require("wezterm")
local config = wezterm.config_builder()

local themes = require("miter.themes")
local ui = require("miter.ui")
local fonts = require("miter.fonts")
local keys = require("miter.keys")
local target = wezterm.target_triple
local is_windows = target:find("windows") ~= nil
local is_linux = target:find("linux") ~= nil

config.mux_enable_ssh_agent = false

if is_windows then
    -- config.default_prog = { 'pwsh.exe' }
    config.default_domain = 'WSL:Ubuntu-26.04'
    -- default_cwd 仅作兜底：当无法从当前 pane 推断 cwd 时回退到此目录（而非 Windows 主目录 /mnt/c/Users/miter）。
    -- 新 pane/tab 已通过 pane:get_current_working_dir() 显式继承触发 pane 的 cwd。
    config.wsl_domains = {
        {
            name = 'WSL:Ubuntu-26.04',
            distribution = 'Ubuntu-26.04',
            default_cwd = '/home/miter',
        },
    }
else
    local localset = require("local")
    localset.load(config)
end

themes.load(config)
ui.load(config)
fonts.load(config)
keys.load(config)

return config
