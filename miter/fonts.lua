local wezterm = require("wezterm")
local M = {}

local function normal_font(config)
	config.font = wezterm.font_with_fallback({
		{
			family = "Monaspace Argon",
			weight = "Regular",
			italic = false,
			harfbuzz_features = {
				"calt=1",
				"ss01=1",
				"ss02=1",
				"ss03=1",
				"ss04=1",
				"ss05=1",
				"ss06=1",
				"ss07=1",
				"ss08=1",
				"ss09=1",
				"ss10=1",
				"liga=1",
			},
		},
		{ family = "MiSans", weight = "Regular", italic = false },
	})
end

local function normal_italic_font(rules)
	table.insert(rules, {
		intensity = "Normal",
		italic = true,
		font = wezterm.font_with_fallback({
			{
				family = "Monaspace Xenon",
				weight = "Regular",
				italic = false,
				harfbuzz_features = {
					"calt=1",
					"ss01=1",
					"ss02=1",
					"ss03=1",
					"ss04=1",
					"ss05=1",
					"ss06=1",
					"ss07=1",
					"ss08=1",
					"ss09=1",
					"ss10=1",
					"liga=1",
				},
			},
			{ family = "LXGW WenKai Screen", weight = "Regular", italic = false },
		}),
	})
end

local function bold_font(rules)
	table.insert(rules, {
		intensity = "Bold",
		italic = false,
		font = wezterm.font_with_fallback({
			{
				family = "Monaspace Argon",
				weight = "Bold",
				italic = false,
				harfbuzz_features = {
					"calt=1",
					"ss01=1",
					"ss02=1",
					"ss03=1",
					"ss04=1",
					"ss05=1",
					"ss06=1",
					"ss07=1",
					"ss08=1",
					"ss09=1",
					"ss10=1",
					"liga=1",
				},
			},
			{ family = "MiSans", weight = "Bold", italic = false },
		}),
	})
end

local function bold_italic_font(rules)
	table.insert(rules, {
		intensity = "Bold",
		italic = true,
		font = wezterm.font_with_fallback({
			{
				family = "Monaspace Xenon",
				weight = "Bold",
				italic = false,
				harfbuzz_features = {
					"calt=1",
					"ss01=1",
					"ss02=1",
					"ss03=1",
					"ss04=1",
					"ss05=1",
					"ss06=1",
					"ss07=1",
					"ss08=1",
					"ss09=1",
					"ss10=1",
					"liga=1",
				},
			},
			{ family = "LXGW WenKai Screen", weight = "Bold", italic = false },
		}),
	})
end

function M.load(config)
	config.font_size = 10
	config.font_shaper = "Harfbuzz"
	config.font_rules = {}
	normal_font(config)
	normal_italic_font(config.font_rules)
	bold_font(config.font_rules)
	bold_italic_font(config.font_rules)
end

return M
