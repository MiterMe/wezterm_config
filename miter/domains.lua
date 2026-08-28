local wezterm = require("wezterm")
local M = {}

function M.load(config)
  config.unix_domains = {
  {
    name = 'unix',
    no_serve_automatically = true,
  }
}
end

return M