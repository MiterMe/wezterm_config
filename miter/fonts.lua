local wezterm = require("wezterm")
local M = {}

-- 简化的 harfbuzz 特性，只保留必要的连字
local hb_features = {
	"calt=1",
	"ss01=1",
	"ss02=1",
	"ss03=1",
	"ss07=1",
	"ss08=1",
	"ss09=1",
	"liga=1",
}

local function normal_font(config)
	config.font = wezterm.font_with_fallback({
		{ family = "Monaspace Argon", weight = "Medium", harfbuzz_features = hb_features },
		{ family = "MiSans", weight = "Medium" },
	})
end

local function normal_italic_font(rules)
	table.insert(rules, {
		intensity = "Normal",
		italic = true,
		font = wezterm.font_with_fallback({
			{ family = "Monaspace Xenon", weight = "Medium", harfbuzz_features = hb_features },
			{ family = "LXGW Neo ZhiSong", weight = "Medium" },
		}),
	})
end

local function bold_font(rules)
	table.insert(rules, {
		intensity = "Bold",
		italic = false,
		font = wezterm.font_with_fallback({
			{ family = "Monaspace Argon", weight = "Bold", harfbuzz_features = hb_features },
			{ family = "MiSans", weight = "Bold" },
		}),
	})
end

local function bold_italic_font(rules)
	table.insert(rules, {
		intensity = "Bold",
		italic = true,
		font = wezterm.font_with_fallback({
			{ family = "Monaspace Xenon", weight = "Bold", harfbuzz_features = hb_features },
			{ family = "LXGW Neo ZhiSong", weight = "Bold" },
		}),
	})
end

function M.load(config)
	config.font_size = 10
	config.font_shaper = "Harfbuzz"
	config.font_rules = {}
	config.front_end = "WebGpu"
	normal_font(config)
	normal_italic_font(config.font_rules)
	bold_font(config.font_rules)
	bold_italic_font(config.font_rules)
	-- config.cell_width = 1.1
	-- config.freetype_load_flags = 'DEFAULT'
	config.freetype_load_flags = 'NO_HINTING'
	-- config.freetype_load_flags = 'NO_BITMAP'
	-- config.freetype_load_flags = 'FORCE_AUTOHINT'
	-- config.freetype_load_flags = 'MONOCHROME'
  -- config.freetype_load_flags = 'NO_AUTOHINT'
	config.freetype_load_target = "Normal"
	-- config.freetype_load_target = 'Light'
	-- config.freetype_load_target = "Mono"
	-- config.freetype_load_target = "HorizontalLcd"
	-- config.freetype_render_target = 'HorizontalLcd'
end

return M
