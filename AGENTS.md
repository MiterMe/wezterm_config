# Wezterm 配置结构

## 模块划分

| 模块 | 文件 | 职责 |
|------|------|------|
| **主入口** | `wezterm.lua` | 加载所有子模块，处理平台差异（Windows/Linux） |
| **主题** | `miter/themes.lua` | 色彩方案（color_scheme） |
| **UI** | `miter/ui.lua` | GPU/渲染、显示帧率、标签栏、滚动缓冲、终端设置、铃声、性能微调 |
| **字体** | `miter/fonts.lua` | 字体族、字号、fallback、harfbuzz 特性、字形渲染参数、斜体/粗体规则 |
| **快捷键** | `miter/keys.lua` | 自定义按键绑定，禁用默认快捷键 |

此外，`wezterm.lua` 中内联处理了平台逻辑：
- **Windows**: 默认启动 powershell.exe
- **Linux**: 加载 `local.lua`（已 gitignore，用于存放机器级私有配置）

## 添加新配置的位置

- **主题相关** → `miter/themes.lua` 的 `M.load(config)` 内
- **UI/外观/性能** → `miter/ui.lua` 的 `M.load(config)` 内
- **字体相关** → `miter/fonts.lua` 的 `M.load(config)` 内
- **快捷键** → `miter/keys.lua` 的 `config.keys` 表内
- **平台特定逻辑**（如 Windows 特有 or Linux 特有）→ `wezterm.lua` 的对应平台分支
- **机器级/私有配置**（不提交 git）→ 新建 `local.lua`，格式参考 `local/expose` 方式
