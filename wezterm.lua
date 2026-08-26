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
    -- WSL 域默认起始目录设为 WSL 用户主目录（而非 Windows 主目录 /mnt/c/Users/miter）。
    -- 这是 20260823 nightly 里 SpawnTab 无法直接带 cwd 时的可靠落点：
    -- 初始 pane、新 tab、分屏（未显式指定 cwd 时）均回退到此目录。
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
