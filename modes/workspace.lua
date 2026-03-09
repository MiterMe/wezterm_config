local wezterm = require("wezterm")
local act = wezterm.action

return {
	{
		key = "n",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				if line and #line > 0 then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
	{
		key = "s",
		action = wezterm.action_callback(function(window, pane)
			local workspaces = {}
			for i, v in ipairs(wezterm.mux.get_workspace_names()) do
				workspaces[i] = { id = v, label = v }
			end
			window:perform_action(
				act.InputSelector({
					action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
						if id and #id > 0 and label and #label > 0 then
							inner_window:perform_action(
								act.SwitchToWorkspace({
									name = label,
								}),
								inner_pane
							)
						end
					end),
					title = "Choose Workspace",
					choices = workspaces,
					fuzzy = true,
					fuzzy_description = "Fuzzy find a workspace ",
				}),
				pane
			)
		end),
	},
}
