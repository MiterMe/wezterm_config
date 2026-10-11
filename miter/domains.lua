local wezterm = require("wezterm")
local M = {}

function M.load(config, gen_domain_name)
  if gen_domain_name() == "windows" then
    config.default_gui_startup_args = { 'connect', gen_domain_name(), '--', table.unpack(config.default_prog) }
  else
    config.default_gui_startup_args = { 'connect', gen_domain_name() }
  end

  -- wezterm.on('mux-startup', function()
  --   local tab, pane, window = wezterm.mux.spawn_window { domain = { DomainName = gen_domain_name() } }
  -- end)
  config.unix_domains = {
    {
      name = gen_domain_name(),
      no_serve_automatically = true,
    }
  }
end

return M