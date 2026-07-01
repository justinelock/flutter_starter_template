#!/bin/bash
# 自动读取 build/version.next → 打包 → 成功后版本名逢十进一、版本号 +1 并写回
#
# 用法：
#   ./scripts/build_apk_next.sh                    # 按 version.next 打包并递增
#   ./scripts/build_apk_next.sh -d '修复bug'       # 写库 description（默认 new version）
#   API_BASE_URL=... WS_BASE_URL=... ./scripts/build_apk_next.sh -d '测试服'
#   ./scripts/build_apk_next.sh init 1.0.0 1       # 重置下次打包版本（不执行打包）
#
# 版本名规则（三段 MAJOR.MINOR.PATCH，每位 0–9，到 10 向高位进 1）：
#   1.0.9 → 1.1.0 → … → 1.9.9 → 2.0.0

set -euo pipefail

# shellcheck source=build_apk_lib.sh
source "$(cd "$(dirname "$0")" && pwd)/build_apk_lib.sh"

usage() {
  echo "用法:"
  echo "  ./scripts/build_apk_next.sh [-d '发布说明']"
  echo "  ./scripts/build_apk_next.sh init <版本名> <版本号>"
  echo ""
  echo "示例:"
  echo "  ./scripts/build_apk_next.sh -d '修复听单定位'"
  echo "  ./scripts/build_apk_next.sh init 1.0.0 1"
}

cmd_init() {
  local name="${1:-}"
  local code="${2:-}"
  if [[ -z "$name" || -z "$code" ]]; then
    echo "用法: ./scripts/build_apk_next.sh init <版本名> <版本号>"
    echo "示例: ./scripts/build_apk_next.sh init 1.0.0 1"
    exit 1
  fi
  write_version_next "$name" "$code"
  sync_pubspec_version "$name" "$code"
  echo "已设置下次打包版本: $name ($code)"
  echo "执行打包: ./scripts/build_apk_next.sh"
}

if [[ "${1:-}" == "init" ]]; then
  cmd_init "${2:-}" "${3:-}"
  exit 0
fi

RELEASE_DESCRIPTION=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    -d|--description)
      shift
      if [[ -z "${1:-}" ]]; then
        echo "错误: -d 需要描述文案"
        usage
        exit 1
      fi
      RELEASE_DESCRIPTION="$1"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "未知参数: $1"
      usage
      exit 1
      ;;
  esac
done

read_version_next
CURRENT_NAME="$VERSION_NAME"
CURRENT_CODE="$VERSION_CODE"

echo "=========================================="
echo "本次打包: $CURRENT_NAME  (build-number=$CURRENT_CODE)"
if [[ -n "$RELEASE_DESCRIPTION" ]]; then
  echo "发布说明: $RELEASE_DESCRIPTION"
else
  echo "发布说明: new version（默认，可用 -d 指定）"
fi
echo "=========================================="

if [[ -n "$RELEASE_DESCRIPTION" ]]; then
  export DESCRIPTION="$RELEASE_DESCRIPTION"
fi

run_apk_release_build "$CURRENT_NAME" "$CURRENT_CODE"

if [[ ! -f "$APK_OUTPUT_PATH" ]]; then
  echo "打包失败，未递增版本（请检查上方构建输出）"
  exit 1
fi

NEXT_NAME="$(bump_version_name "$CURRENT_NAME")"
NEXT_CODE=$((CURRENT_CODE + 1))

write_version_next "$NEXT_NAME" "$NEXT_CODE"
sync_pubspec_version "$NEXT_NAME" "$NEXT_CODE"

RELEASE_APK_DIR="${RELEASE_APK_DIR:-dist/release}"
echo ""
echo "------------------------------------------"
echo "版本已记录，下次打包将使用:"
echo "  版本名: $NEXT_NAME"
echo "  版本号: $NEXT_CODE"
echo "  版本文件: build/version.next"
echo "  APK:      ${RELEASE_APK_DIR}/app-release-v${CURRENT_NAME}.apk"
echo "  命令:     ./scripts/build_apk_next.sh"
echo "  等价:     ./scripts/build_apk.sh $CURRENT_NAME $CURRENT_CODE"
echo "------------------------------------------"
