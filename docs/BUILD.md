# 打包与常用命令

App（iOS / Android / Web）本地开发、Release 打包与环境变量速查。

---

## 1. 环境准备

```bash
# 检查 Flutter 环境
flutter doctor -v

# 拉依赖
flutter pub get
```

**iOS 额外要求**：

- macOS + Xcode（从 App Store 安装）
- Xcode Command Line Tools：`xcode-select --install`
- Apple Developer 账号（真机调试 / 上架）
- 首次在 Xcode 打开 `ios/Runner.xcworkspace`，配置 **Signing & Capabilities**（Team、Bundle ID）

**Android 额外要求**：

- Android SDK（Android Studio 或 command-line tools）
- 接受 licenses：`flutter doctor --android-licenses`

---

## 2. 本地运行（Debug）

```bash
# 列出设备
flutter devices

# iOS 模拟器
flutter run -d ios

# Android 模拟器 / 真机
flutter run -d android

# 指定局域网 API（单域，禁用主备 failover）
flutter run --dart-define=API_BASE_URL=http://192.168.254.127:8091

# 模拟主备域名（至少 2 个 host）
flutter run --dart-define=API_BACKUP_HOSTS=http://192.168.254.127:8091,http://192.168.254.127:8092

# 全量 HTTP 日志（排查接口）
flutter run --dart-define=VERBOSE_HTTP=true

# Chrome Web
flutter run -d chrome
```

---

## 3. iOS 打包

### 3.1 最常用：生成 IPA（不上传 App Store）

**仅构建、本地/Xcode 后续签名**（CI 或手动导出常用）：

```bash
flutter build ipa --release --no-codesign
```

产物目录：

```
build/ios/ipa/
  fubang.ipa          # 或 *.ipa
build/ios/archive/    # Xcode archive
```

**指定 API 域名**：

```bash
flutter build ipa --release --no-codesign --dart-define=API_BACKUP_HOSTS=https://app.example.com,https://example.com
```

**主域 + 备用域名（App 主备 failover）**：

```bash
flutter build ipa --release --no-codesign \
  --build-name=1.3.3 \
  --build-number=34 \
  --dart-define=API_BACKUP_HOSTS=https://app.example.com,https://example.com
```

### 3.2 带版本号

版本也可写在 `pubspec.yaml`（当前 `version: 1.3.3+34`），或命令行覆盖：

```bash
flutter build ipa --release --no-codesign \
  --build-name=1.3.4 \
  --build-number=35
```

### 3.3 完整签名并上传 App Store Connect

需已在 Xcode / Apple Developer 配置好证书与 Provisioning Profile：

```bash
# 自动签名 + 导出（需 ios/ 工程 Signing 正确）
flutter build ipa --release
```

成功后可用 **Transporter** 或 `xcrun altool` 上传 `build/ios/ipa/*.ipa` 到 App Store Connect。

### 3.4 仅构建 iOS App（不打包 IPA）

```bash
flutter build ios --release --no-codesign
```
```bash
flutter build ipa --release --no-codesign --dart-define=API_BASE_URL=https://fb.ev8l8.com 
```
```bash
flutter build ipa --release --no-codesign --dart-define=API_BASE_URL=https://fb.ev8l8.com 
flutter build ipa --release --no-codesign \
  --dart-define=API_BACKUP_HOSTS=https://app.fubonplus.com,https://app.fubang.vip
```

再用 Xcode：`Product → Archive` 手动归档。

### 3.5 清理后重打

```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..   # 若 CocoaPods 报错时再执行
flutter build ipa --release --no-codesign
```

### 3.6 iOS 常见问题

| 现象 | 处理 |
| --- | --- |
| Signing 失败 | Xcode 打开 `ios/Runner.xcworkspace`，选 Team，勾选 Automatically manage signing |
| Pod 相关错误 | `cd ios && pod install --repo-update` |
| 架构 / 模拟器 | Release 包打真机/arm64；模拟器用 `flutter run -d ios` |
| 更新检测 | iOS 走 App Store / 接口下发的 `iosUrl`，见 [`Constants.iosAppStoreUrl`](../lib/common/values/constants.dart) |

---

## 4. Android 打包

### 4.1 单次打包

```bash
./scripts/build_apk.sh 1.3.4 35
```

产物：`dist/release/app-release-v1.3.4.apk`

**可选环境变量**：

```bash
# 打包前 clean
CLEAN=1 ./scripts/build_apk.sh 1.3.4 35

# 指定 API 主域（单域模式）
API_BASE_URL=https://app.example.com ./scripts/build_apk.sh 1.3.4 35

# 注入备用 API 域名
API_BACKUP_HOSTS='https://app.example.com,https://example.com' \
  ./scripts/build_apk.sh 1.3.4 35

# 发布说明（写入管理后台）
DESCRIPTION='修复行情颜色' ./scripts/build_apk.sh 1.3.4 35

# 只打包，不自动应用 release SQL（仍会生成 SQL 文件）
SKIP_RELEASE_DB=1 ./scripts/build_apk.sh 1.3.4 35
```

### 4.2 自动递增版本（推荐日常发版）

[`build/version.next`](../build/version.next) 记录下次版本，`build_apk_next.sh` 打完后自动 bump：

```bash
# 按 version.next 打包并递增
./scripts/build_apk_next.sh

# 带发布说明 + 覆盖 API/WS
API_BASE_URL=https://app.example.com WS_BASE_URL=wss://app.example.com \
  ./scripts/build_apk_next.sh -d "bug fix"

# 重置下次版本
./scripts/build_apk_next.sh init 1.3.0 30
```

### 4.3 手动 flutter 命令

```bash
flutter build apk --release \
  --build-name=1.3.4 \
  --build-number=35 \
  --obfuscate \
  --split-debug-info=dist/release/debug-info \
  --dart-define=API_BACKUP_HOSTS=https://app.example.com,https://example.com
```

---

## 5. Web 打包

```bash
# 标准 Release（图标 tree-shake）
flutter build web --release --tree-shake-icons

# 或使用项目脚本（支持环境变量）
./build_web.sh
```

**Web 常用环境变量**（见 [`build_web.sh`](../build_web.sh)）：

```bash
API_BASE_URL=http://192.168.x.x:8091 ./build_web.sh
MEDIA_CDN_URL=https://cdn.example.com ./build_web.sh
BASE_HREF=/app/ ./build_web.sh          # 非根路径部署
CLEAN=1 ./build_web.sh
```

产物：`build/web/`，脚本会打成 `dist/release/fubang-web.zip`。

> Web Release 使用浏览器当前域名作为 API，**不参与** App 主备 failover。

---

## 6. 编译期参数（dart-define）汇总

| 变量 | 用途 | 典型场景 |
| --- | --- | --- |
| `API_BASE_URL` | 强制唯一 API 根地址 | 本地调试、单域部署；**禁用 failover** |
| `API_BACKUP_HOSTS` | 备用 API，逗号分隔 | Release App 主备切换 |
| `MEDIA_CDN_URL` | 媒体 CDN 根地址 | 视频/HLS 与 API 不同域 |
| `CHAT_HTML_BASE_URL` | 客服 H5 根地址 | chat.html 独立域名 |
| `VERBOSE_HTTP` | 打印完整 HTTP 日志 | Debug 排查 |
| `BINANCE_REST_BASE_URL` | 秒合约 K 线 REST 代理 | 币安反代 |
| `QUOTE_MARKET_WS_URL` | 秒合约 Binance WS | Web 451 等场景 |

示例（iOS Release + 主备）：

```bash
flutter build ipa --release --no-codesign \
  --build-name=1.3.4 --build-number=35 \
  --dart-define=API_BACKUP_HOSTS=https://app.example.com,https://example.com
```

---

## 7. 版本号管理

| 来源 | 说明 |
| --- | --- |
| `pubspec.yaml` | `version: 1.3.3+34`（名称 + 构建号） |
| `build/version.next` | `build_apk_next.sh` 维护的下次 Android 版本 |
| `--build-name` / `--build-number` | 命令行覆盖，iOS/Android 通用 |

Android 发版后更新管理后台：`scripts/release_version_sql.sh`（`build_apk.sh` 末尾会自动调用，除非 `SKIP_RELEASE_DB=1`）。

---

## 8. 测试

```bash
# 单元测试
flutter test

# 分析
flutter analyze
```

---

