# Fork 后必改清单

Fork 本仓库并开始新产品开发前，请按顺序完成以下步骤。完成后可在 README 或团队 Wiki 中勾选留档。

---

## 1. 项目标识（必做）

| 项 | 位置 | 说明 |
|----|------|------|
| 应用显示名 | `lib/app/environment/env_config.dart` → `appName` | Debug / Prod 名称 |
| 包名 / Bundle ID | `android/app/build.gradle.kts`、`ios/Runner.xcodeproj`、`macos/Runner/Configs/AppInfo.xcconfig` 等 | 全平台统一替换 |
| `pubspec.yaml` | `name`、`description` | Dart 包名与描述 |
| 应用图标 | `assets/icons/`、各平台 `mipmap` / `AppIcon` | 替换启动图标与商店素材 |
| 启动图 | `assets/images/splash.png` | 品牌 Splash；远端配置见下文 Branding |

---

## 2. 环境与 API（必做）

| 项 | 位置 | 说明 |
|----|------|------|
| API 主机 | `lib/app/environment/env_config.dart` → `baseUrl` | 仅域名或 `IP:端口`，如 `https://api.example.com`、`http://192.168.1.10:8091` |
| API 前缀 | 同上 → `apiPrefix` | 如 `/api/v1`；Dio 实际根地址为 `apiBaseUrl`（自动拼接） |
| Mock 开关 | 同上 → `enableMock` | **Debug 默认 `true`（本地 Mock）**；**Prod 必须为 `false`** |
| 版本检查路径 | `versionCheckUrl` | 默认 `/app/versions/latest` |
| Dart Define | 构建命令 `--dart-define=APP_ENV=prod` | CI 与商店包务必使用 `prod` |

```sh
# 本地开发（Mock 服务，无需后端）
flutter run --dart-define=APP_ENV=debug

# 对接真实后端
# 1. 将 enableMock 设为 false（或仅在 prod 为 false）
# 2. 配置 baseUrl（主机）与 apiPrefix（如 /api/v1）
flutter run --dart-define=APP_ENV=debug
```

---

## 3. 认证对接（必做）

模版默认契约：

- **登录**：`email` + `password`
- **注册**：`email` + `password`（+ 可选 `displayName`）
- **存储**：Token → Secure Storage；用户邮箱 → SharedPreferences（`AppStorageKeys`）

### 3.1 通用 REST（默认实现）

文件：`lib/features/auth/data/services/remote_auth_service.dart`

- 登录：`POST /auth/login` → `{ email, password }`
- 注册：`POST /auth/register` → `{ email, password, displayName? }`
- 响应：扁平 JSON 或 `{ code: 0, data: { token/accessToken, user } }`

按你的后端调整路径、字段名与 `_parseAuthResult`。

### 3.2 非通用后端（手机号 / 证件号等）

参考示例（**默认未接线**）：

`lib/features/auth/data/services/example_backend_auth_service.dart`

在 `authServiceProvider`（`auth_repository_impl.dart`）中替换：

```dart
// return RemoteAuthService(ref.watch(apiClientProvider));
return ExampleBackendAuthService(ref.watch(apiClientProvider));
```

并视需要改登录/注册页面字段（仍须走 `LocaleKeys` / `context.l10n`）。

### 3.3 Token 与拦截器（建议）

| 项 | 位置 |
|----|------|
| 请求头注入 Token | `lib/core/network/api_interceptor.dart`（当前仅日志） |
| 401 刷新 / 登出 | 同上或独立 `AuthInterceptor` |
| 登出调远端 | `AuthRepositoryImpl.logout()` |

---

## 4. 版本更新（建议）

| 项 | 位置 | 说明 |
|----|------|------|
| 远程实现 | `lib/features/version/data/services/remote_version_service.dart` | 对齐后端版本接口 |
| Mock | `enableMock: true` 时使用 `MockVersionService`，默认**不弹更新** |
| 强制更新联调 | `FeatureFlags.enableForceUpdateMock` | 仅本地验证强更流程 |

---

## 5. 国际化（必做）

| 项 | 位置 |
|----|------|
| 文案资源 | `lib/l10n/app_en.arb`、`app_zh.arb` |
| 生成 | `flutter gen-l10n` |
| 页面访问 | `context.l10n.xxx`（禁止硬编码用户可见中文/英文） |

新增语言：在 `l10n.yaml` / ARB 中增加 locale，并更新 `supportedLocales`。

---

## 6. 主题与品牌（建议）

| 项 | 位置 |
|----|------|
| 色板 | `lib/app/theme/app_color_schemes.dart`、`app_color_tokens.dart` |
| 玻璃参数 | `lib/app/theme/app_glass_tokens.dart` |
| 排版 | `lib/app/theme/app_typography_tokens.dart`（参见 `docs/ios_font.md`） |
| 设计规格 | `docs/iphone_17_pro_ui_theme.md` |

---

## 7. 可观测性与网络（建议）

| 项 | 位置 | 状态 |
|----|------|------|
| 崩溃上报 | `lib/core/crash/crash_reporter.dart` | 占位，需接 Firebase / Sentry |
| 分析 | `lib/core/analytics/analytics_service.dart` | 占位 |
| 网络监听 | `networkMonitorProvider` | 已定义，业务未接线 |
| 启动 Branding | `lib/features/splash/data/services/branding_service.dart` | 失败不阻塞；Splash 仍用本地图 |

在 `bootstrap.dart` 或 `env_config` 中按环境启用 `enableCrashReport` / `enableAnalytics`。

---

## 8. 首页与功能模块（必做）

| 项 | 说明 |
|----|------|
| 替换首页 | `lib/features/home/presentation/pages/home_page.dart` 当前为**占位欢迎页** |
| 删除演示依赖 | 未使用的 SVG（`assets/svgs/` 约 180+）、`enableDebugPanel` 设置项等 |
| 新 Feature | 在 `lib/features/<name>/` 按 `presentation` / `data` / `domain` 扩展 |

---

## 9. 安全与密钥（必做）

- **不要**提交：`.env`、证书、keystore、API Key、内网 IP
- CI 密钥：GitHub Secrets（见 `.github/workflows/flutter_ci.yml`）
- Web Secure Storage：配合 CSP、短效 Token、刷新轮换（见 README）

---

## 10. 测试与 CI（建议）

```sh
dart format lib test
flutter analyze
flutter test
```

| 测试 | 路径 |
|------|------|
| 主流程（Splash → 登录 → 首页） | `test/integration/app_flow_test.dart` |
| Auth / 主题 / 排版 | `test/features/`、`test/app/` |
| Widget | `test/widget/` |

发布前建议补充：Repository 单测、路由 redirect 边界、移动平台 `flutter build apk/ios`。

---

## 11. 快速验收

完成必改项后，确认：

- [ ] `APP_ENV=debug` 下无需后端即可登录（Mock）
- [ ] `APP_ENV=prod` + `enableMock: false` 可连真实 API
- [ ] 登录 → 首页 → 设置 → 登出 → 回登录页
- [ ] 中英切换正常
- [ ] 亮/暗色主题正常
- [ ] `flutter analyze` 与 `flutter test` 通过
- [ ] 首页已替换为产品内容，无演示密码预填

---

## 相关文档

- [README](../README.md) — 架构与开发命令
- [新手指引](./GETTING_STARTED.md) — 跑通项目、第一个改动
- [项目框架介绍](./ARCHITECTURE.md) — 分层、路由、设计系统详解
- [docs/ios_font.md](./ios_font.md) — 排版规格
- [docs/iphone_17_pro_ui_theme.md](./iphone_17_pro_ui_theme.md) — 主题色与玻璃规格
- [docs/riverpod3_flutter.md](./riverpod3_flutter.md) — Riverpod 3 参考
