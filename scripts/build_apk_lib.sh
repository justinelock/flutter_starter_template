#!/bin/bash
# APK 打包公共逻辑：路径解析、版本维护、Release 构建与产物后处理。
# 由 build_apk.sh / build_apk_next.sh source，请勿直接执行。

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "请使用 scripts/build_apk.sh 或 scripts/build_apk_next.sh" >&2
  exit 1
fi

# 脚本目录与 Flutter 项目根（无论从何路径调用，均以 lib 文件位置为准）
BUILD_APK_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$BUILD_APK_LIB_DIR/.." && pwd)"
VERSION_FILE="$PROJECT_ROOT/build/version.next"
PUBSPEC="$PROJECT_ROOT/pubspec.yaml"

# 构建成功后写入的 APK 绝对路径（供 build_apk_next 校验）
APK_OUTPUT_PATH=""

# 版本名逢十进一：1.0.9 → 1.1.0 → … → 1.9.9 → 2.0.0（每位 0–9）
bump_version_name() {
  python3 - "$1" <<'PY'
import sys
parts = [int(x) for x in sys.argv[1].strip().split(".")]
while len(parts) < 3:
    parts.append(0)
parts[2] += 1
if parts[2] >= 10:
    parts[2] = 0
    parts[1] += 1
    if parts[1] >= 10:
        parts[1] = 0
        parts[0] += 1
print(".".join(str(p) for p in parts))
PY
}

# 从 build/version.next 读取下次打包版本；缺失时尝试 pubspec.yaml 并写回 version.next
read_version_next() {
  if [[ ! -f "$VERSION_FILE" ]]; then
    if [[ -f "$PUBSPEC" ]] && grep -q '^version:' "$PUBSPEC"; then
      local ver_line
      ver_line="$(grep '^version:' "$PUBSPEC" | head -1 | awk '{print $2}')"
      VERSION_NAME="${ver_line%%+*}"
      VERSION_CODE="${ver_line##*+}"
      echo "未找到 ${VERSION_FILE}，已从 pubspec.yaml 读取: ${VERSION_NAME} (${VERSION_CODE})"
      write_version_next "$VERSION_NAME" "$VERSION_CODE"
      return
    fi
    echo "未找到 ${VERSION_FILE}，请执行: ./scripts/build_apk_next.sh init 1.0.0 1"
    exit 1
  fi
  # shellcheck disable=SC1090
  source "$VERSION_FILE"
  if [[ -z "${VERSION_NAME:-}" || -z "${VERSION_CODE:-}" ]]; then
    echo "version.next 格式错误，需包含 VERSION_NAME 与 VERSION_CODE"
    exit 1
  fi
}

write_version_next() {
  local name="$1"
  local code="$2"
  mkdir -p "$(dirname "$VERSION_FILE")"
  cat >"$VERSION_FILE" <<EOF
# 下次打包将使用的版本（由 build_apk_next.sh 自动维护）
VERSION_NAME=$name
VERSION_CODE=$code

EOF
}

sync_pubspec_version() {
  local name="$1"
  local code="$2"
  if [[ ! -f "$PUBSPEC" ]]; then
    return
  fi
  if sed --version 2>/dev/null | grep -q GNU; then
    sed -i "s/^version: .*/version: ${name}+${code}/" "$PUBSPEC"
  else
    sed -i '' "s/^version: .*/version: ${name}+${code}/" "$PUBSPEC"
  fi
}

# 执行 Release APK 构建、重命名、可选写库与 web/download 同步
# 参数：$1 版本名  $2 版本号（build-number）
run_apk_release_build() {
  local version_name="$1"
  local version_code="$2"
  local release_apk_dir="${RELEASE_APK_DIR:-dist/release}"
  local debug_info_dir="${DEBUG_INFO_DIR:-dist/release/debug-info}"
  local start_time end_time duration
  local apk_path new_name new_path web_dir copied f

  cd "$PROJECT_ROOT"

  start_time=$(date +%s)

  if [[ "${CLEAN:-0}" == "1" ]]; then
    echo "CLEAN=1 → flutter clean"
    flutter clean
  fi

  flutter pub get

  mkdir -p "$PROJECT_ROOT/$release_apk_dir" "$PROJECT_ROOT/$debug_info_dir"

  # 仅当显式设置环境变量时才注入 --dart-define；未设置则走 Constants 发布默认
  local dart_define_args=()
  [[ -n "${API_BASE_URL:-}" ]] && dart_define_args+=(--dart-define=API_BASE_URL="${API_BASE_URL}")
  [[ -n "${WS_BASE_URL:-}" ]] && dart_define_args+=(--dart-define=WS_BASE_URL="${WS_BASE_URL}")

  if [[ -n "${API_BASE_URL:-}" || -n "${WS_BASE_URL:-}" ]]; then
    echo "API/WS: 使用环境变量 dart-define 覆盖"
    [[ -n "${API_BASE_URL:-}" ]] && echo "  API_BASE_URL=${API_BASE_URL}"
    [[ -n "${WS_BASE_URL:-}" ]] && echo "  WS_BASE_URL=${WS_BASE_URL}"
  else
    echo "API/WS: 未设置 API_BASE_URL/WS_BASE_URL，使用 constants.dart 发布默认（见 _prodApiBaseUrl）"
  fi

  flutter build apk --release \
    --build-name="$version_name" \
    --build-number="$version_code" \
    --obfuscate \
    --split-debug-info="$debug_info_dir" \
    ${dart_define_args[@]+"${dart_define_args[@]}"}

  apk_path="build/app/outputs/flutter-apk/app-release.apk"
  new_name="app-release-v${version_name}.apk"
  new_path="${release_apk_dir}/${new_name}"

  end_time=$(date +%s)
  duration=$((end_time - start_time))

  if [[ ! -f "$apk_path" ]]; then
    echo "打包失败，未找到 $apk_path"
    exit 1
  fi

  mv "$apk_path" "$new_path"
  APK_OUTPUT_PATH="$PROJECT_ROOT/$new_path"
  echo "打包完成：${APK_OUTPUT_PATH}"

  echo "开始时间：$(date -r "$start_time" '+%Y-%m-%d %H:%M:%S')"
  echo "结束时间：$(date -r "$end_time" '+%Y-%m-%d %H:%M:%S')"
  echo "耗时：${duration} 秒"
  echo "产物目录: ${release_apk_dir}/（APK + SQL + debug-info）"
  echo "本地静态: web/download/（HTML + 已同步的 APK/SQL）"
  echo "生产 APK: GET {apiBaseUrl}/app/${new_name}"

  local update_link_script="$BUILD_APK_LIB_DIR/update_passenger_order_apk_link.sh"
  if [[ -x "$update_link_script" ]]; then
    "$update_link_script" "$version_name"
  else
    echo "跳过: 未找到 update_passenger_order_apk_link.sh"
  fi

  local release_sql_script="$BUILD_APK_LIB_DIR/release_version_sql.sh"
  if [[ -x "$release_sql_script" ]]; then
    if [[ "${SKIP_RELEASE_DB:-0}" != "1" ]]; then
      APPLY_RELEASE_DB=1 "$release_sql_script" "$version_name"
    else
      "$release_sql_script" "$version_name"
    fi
  else
    echo "跳过: 未找到 release_version_sql.sh"
  fi

  web_dir="$PROJECT_ROOT/web/download"
  mkdir -p "$web_dir"
  shopt -s nullglob
  copied=0
  for f in "$PROJECT_ROOT/$release_apk_dir"/*.apk "$PROJECT_ROOT/$release_apk_dir"/*.sql; do
    if [[ -f "$f" ]]; then
      cp -f "$f" "$web_dir/"
      copied=$((copied + 1))
    fi
  done
  shopt -u nullglob
  if [[ "$copied" -gt 0 ]]; then
    echo "已同步 ${release_apk_dir}/ → web/download/（${copied} 个文件，不含 debug-info）"
  else
    echo "警告: ${release_apk_dir}/ 下未找到可同步到 web/download/ 的 APK/SQL" >&2
  fi
}
