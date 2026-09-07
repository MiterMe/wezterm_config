local wezterm = require("wezterm")
local M = {}

function M.load(config, gen_domain_name)
  config.ssh_backend = 'Ssh2'

  wezterm.on('mux-startup', function()
    local tab, pane, window = wezterm.mux.spawn_window { }
  end)
  config.unix_domains = {
    {
      name = gen_domain_name(),
      no_serve_automatically = true,
    }
  }
  config.default_gui_startup_args = { 'connect', gen_domain_name() }

end

return M