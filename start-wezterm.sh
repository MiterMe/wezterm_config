#!/bin/bash

# 定义默认 workspace 名称
DEFAULT_WORKSPACE="default"

# 判断是否传入了参数
if [ $# -ge 1 ]; then
  # 如果有参数，使用第一个参数作为 workspace 名称
  WORKSPACE="$1"
else
  # 无参数则使用默认值
  WORKSPACE="$DEFAULT_WORKSPACE"
fi

# 启动 wezterm 并连接指定 workspace
wezterm connect unix --workspace "$WORKSPACE"
