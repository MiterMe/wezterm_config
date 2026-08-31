local wezterm = require("wezterm")
local M = {}

function M.load(config)
  config.ssh_backend = 'Ssh2'

  wezterm.on('mux-startup', function()
    local tab, pane, window = wezterm.mux.spawn_window { }
  end)
  config.unix_domains = {
    {
      name = 'localhost',
      no_serve_automatically = true,
    }
  }
  config.default_gui_startup_args = { 'connect', 'localhost' }

end

return M