#!/bin/bash
# Release APK 打包（默认不 flutter clean，避免与本地 debug 运行冲突）
#
# 用法：./scripts/build_apk.sh 1.2.0 20
# 可选：CLEAN=1 ./scripts/build_apk.sh ...          # 打包前执行 flutter clean
# 可选：RELEASE_APK_DIR=dist/release ./scripts/build_apk.sh ...
# 可选：DESCRIPTION='修复bug' ./scripts/build_apk.sh 1.2.0 20   # app_release_versions.description
#
# API / WebSocket 基地址（可选）：
#   1) 不设置 → lib/common/values/constants.dart 发布默认
#   2) API_BASE_URL=... WS_BASE_URL=... → --dart-define 覆盖
#
# 自动递增版本请用：./scripts/build_apk_next.sh

set -euo pipefail

# shellcheck source=build_apk_lib.sh
source "$(cd "$(dirname "$0")" && pwd)/build_apk_lib.sh"

VERSION_NAME="${1:-}"
VERSION_CODE="${2:-1}"

if [[ -z "$VERSION_NAME" ]]; then
  echo "用法: ./scripts/build_apk.sh <版本名> [版本号]"
  echo "示例: ./scripts/build_apk.sh 1.1.9 20"
  echo "自动版本: ./scripts/build_apk_next.sh [-d '发布说明']"
  exit 1
fi

if [[ -z "${2:-}" ]]; then
  VERSION_CODE=1
fi

run_apk_release_build "$VERSION_NAME" "$VERSION_CODE"
