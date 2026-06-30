你是一名资深 Flutter 架构师、Dart 专家、Riverpod 3 专家、跨平台 UI 架构顾问和生产级移动端工程负责人。

请帮我从零设计并生成一套生产级 Flutter Starter Template。

这个模板不是 Demo，而是一个可以直接用于真实项目的基础框架。它需要覆盖 Android、iOS、Web、Windows、macOS、Linux，并且使用最新稳定版 Flutter、Dart、Riverpod 3、go_router、dio、Material 3，以及 liquid_glass_widgets: ^0.19.5。

请严格按生产级标准设计：架构清晰、分层明确、可测试、可维护、可扩展、跨平台适配良好、支持 debug/prod 环境、支持国际化、主题切换、版本更新、登录注册、日志脱敏、安全存储、全局错误处理、统一 UI 状态组件、Feature Flags、App 生命周期管理、Crash Report 预留、Analytics 预留、README 和 CI/CD 预留。

请不要一次性输出所有代码。请先输出架构方案、目录结构、依赖规划、UI 规格方案、分阶段生成计划和需要我确认的问题。等我确认后，再逐步生成代码。

==================================================
一、项目目标
==================================================

基于 Flutter 最新 stable、Dart 最新 stable、Riverpod 3 最新稳定版本，搭建一个可直接运行、可持续扩展、可用于真实生产项目的跨平台应用模板。

目标平台：

- Android
- iOS
- Web
- Windows
- macOS
- Linux

模板最小功能单元必须包括：

- 启动页 Splash
- 登录
- 注册
- 首页
- 设置页
- 版本更新检查
- 强制更新弹窗
- 普通更新弹窗
- 国际化 zh / en
- 主题切换：亮色 / 暗色 / 跟随系统
- debug / prod 环境隔离
- 日志系统，debug 更多日志，prod 最小日志并脱敏
- 全局错误处理
- 全局 SnackBar / Toast
- 统一 Loading / Empty / Error 组件
- Feature Flags
- AppLifecycle 管理
- ResponsiveLayout
- Crash Report 预留
- Analytics 预留
- 网络状态监听预留
- CI/CD 模板预留
- README.md
- liquid_glass_widgets 风格融合
- Riverpod 3 现代 API
- go_router 路由鉴权
- dio 网络层
- 本地存储和安全存储
- 基础测试
- 详细注释, 步骤级别的注释
- 日志变更

==================================================
二、UI 规格要求：以 iPhone 17 Pro 为设计基准
==================================================

UI 设计必须以 iPhone 17 Pro 为核心视觉基准。

iPhone 17 Pro = compact 端 1x 设计基准
其他手机 = 轻微比例缩放
平板 = medium 布局
桌面/Web = expanded 布局

请以 iPhone 17 Pro 的 6.3 英寸 Super Retina XDR OLED 屏幕作为移动端主设计基准。iPhone 17 / iPhone 17 Pro 系列屏幕像素密度约为 460 ppi，iPhone 17 的 6.3 英寸机型分辨率为 2622 x 1206 像素；iPhone 17 Pro 也是 6.3 英寸级别设备。实际开发中请使用 Flutter logical pixels，而不是物理像素。移动端基准设计画布可按约 402 x 874 logical pixels 处理，其他设备按比例自适应缩放。

重要要求：

1. 移动端 UI 以 iPhone 17 Pro 为视觉模板。
2. 字体大小、控件高度、圆角、间距、图标尺寸、按钮尺寸、输入框尺寸，都以 iPhone 17 Pro 的视觉密度作为 1x 基准。
3. 其他设备根据屏幕宽度和平台进行比例缩放，而不是简单固定尺寸。
4. Android 手机需要接近 iPhone 17 Pro 的视觉比例，但保留 Material 3 交互体验。
5. iPad / 平板需要使用 medium 布局。
6. Web / Desktop 使用 expanded 布局，不能简单把手机界面拉宽。
7. 所有页面必须适配 SafeArea。
8. 所有表单页面需要支持键盘弹起后的滚动。
9. 桌面端需要限制内容最大宽度，避免 UI 过宽。
10. Web 端需要支持浏览器刷新后恢复状态。
11. 所有 UI token 需要集中管理，包括：
    - AppSpacing
    - AppRadius
    - AppTypography
    - AppSizing
    - AppBreakpoints
    - AppDurations
    - AppShadows
    - AppGlassTokens
12. 请封装统一的响应式工具，而不是在每个页面里散落 MediaQuery 判断。
13. 请实现一个 ResponsiveLayout 组件，至少支持：
    - compact：手机，默认参考 iPhone 17 Pro
    - medium：平板、小窗口、折叠屏
    - expanded：桌面、Web 大屏
14. 字体风格应尽量接近 iOS 现代系统视觉，但使用 Flutter 跨平台安全方案，不要强行依赖不可用字体。
15. Typography 需要基于 Material 3 TextTheme，并结合 iPhone 17 Pro 视觉比例做适配。
16. 控件默认高度建议：
    - 主按钮高度：52 logical pixels 左右
    - 输入框高度：52-56 logical pixels
    - 大圆角卡片：24-32
    - 普通卡片圆角：20-24
    - 小控件圆角：12-16
    - 页面水平边距：20-24
17. 页面内容在 iPhone 17 Pro 宽度下需要视觉舒适，不得拥挤。
18. UI 需要支持暗色模式下的 liquid glass 效果。
19. UI 动效需要克制、现代、顺滑，避免过度炫技。
20. 如果不同平台不适合完全同一视觉，需要保留统一品牌风格，同时做平台级自适应。

请建立一套统一设计系统，例如：

lib/app/design/
  app_breakpoints.dart
  app_spacing.dart
  app_radius.dart
  app_sizing.dart
  app_typography.dart
  app_durations.dart
  app_shadows.dart
  app_glass_tokens.dart
  responsive_layout.dart
  adaptive_scale.dart

其中 adaptive_scale 需要以 iPhone 17 Pro logical width 约 402 为 1x 基准，对不同屏幕进行合理缩放，并设置最小和最大缩放限制，避免桌面端过大。

请不要在页面中直接硬编码大量尺寸。尺寸应优先来自 design tokens。

==================================================
三、技术栈要求
==================================================

1. Flutter / Dart

- 使用 Flutter 最新 stable。
- 使用 Dart 最新 stable。
- 开启 sound null safety。
- 使用 Material 3。
- 支持 Android、iOS、Web、Windows、macOS、Linux。
- 项目代码必须可以直接运行。
- 避免使用废弃 API。

2. 状态管理

- 使用 Riverpod 3 作为唯一主状态管理方案。
- 使用 flutter_riverpod。
- 优先使用现代 Riverpod API：
  - Provider
  - FutureProvider
  - StreamProvider
  - Notifier
  - AsyncNotifier
  - StreamNotifier
- 可以使用代码生成：
  - riverpod_annotation
  - riverpod_generator
  - build_runner
- 不要使用 legacy API：
  - StateProvider
  - StateNotifierProvider
  - ChangeNotifierProvider
- 不要使用 Provider、GetX、Bloc 作为主状态管理框架。
- 所有业务状态需要可测试。
- Provider 按功能模块拆分，不允许堆在单个大文件中。
- 对异步状态优先使用 AsyncValue。
- 复杂业务 Controller 优先使用 AsyncNotifier 或 Notifier。

3. 路由

- 使用 go_router 最新稳定版。
- 支持声明式路由。
- 支持登录鉴权重定向。
- 支持未登录自动跳转登录页。
- 支持登录后跳转首页。
- 支持 Splash 初始化完成后根据状态跳转。
- 支持 404 NotFoundPage。
- 支持 Web 可读路径。
- 路由路径必须常量化。
- 路由配置集中管理。
- 不要在页面中散落硬编码路径。

4. 网络层

- 使用 dio 最新稳定版。
- 封装 ApiClient。
- 支持：
  - baseUrl 分环境配置
  - headers 注入
  - token 注入
  - timeout 配置
  - 请求日志
  - 响应日志
  - 错误拦截
  - 统一响应解析
  - token 过期预留处理
  - 请求取消预留
- 网络层不能直接暴露给 UI。
- UI 不允许直接调用 dio。
- Repository 负责协调数据来源。
- Service 负责具体 API 请求。

5. 本地存储

- 普通配置使用 shared_preferences。
- 敏感信息如 token 使用 flutter_secure_storage。
- Web 平台 token 存储需要给出安全风险说明和可替代方案。
- 封装 StorageService。
- 封装 SecureStorageService。
- 业务代码不允许直接散落调用 shared_preferences 或 flutter_secure_storage。
- 主题、语言、首次启动、Feature Flags 等配置需要持久化。

6. 国际化

- 使用 Flutter 官方 gen_l10n 方案。
- 支持至少：
  - 简体中文 zh
  - 英文 en
- 提供：
  - app_zh.arb
  - app_en.arb
- 支持运行时切换语言。
- 当前语言持久化。
- 所有 UI 文案不得硬编码在页面中。
- LocaleController 使用 Riverpod 3 管理。
- App 启动时恢复语言设置。
- 语言切换后立即生效。

7. 主题

- 使用 Material 3 ColorScheme。
- 支持：
  - light
  - dark
  - system
- 主题模式持久化。
- ThemeController 使用 Riverpod 3 管理。
- 支持运行时切换主题。
- 主题配置集中管理。
- Typography 需要与 iPhone 17 Pro 基准设计系统结合。
- liquid glass 效果需要同时适配亮色和暗色主题。
- 不要在 Widget 中硬编码主题颜色，优先使用 ThemeData / ColorScheme / design tokens。

8. liquid_glass_widgets (参考: @/Users/es/flutterProjects/fubang-app/liquid_glass_widgets, https://pub.dev/packages/liquid_glass_widgets)

- 集成 liquid_glass_widgets: ^0.19.5。
- 不要只做孤立 Demo，要融合进整体模板视觉系统。
- 至少在以下位置使用：
  - Splash 页面背景或中心卡片
  - 登录页表单卡片
  - 注册页表单卡片
  - 首页信息卡片
  - 设置页分组卡片
  - 更新弹窗
  - 全局 GlassCard / GlassButton / GlassScaffold
- 需要封装统一组件：
  - GlassScaffold
  - GlassCard
  - GlassButton
  - GlassDialog
  - GlassListTile
  - GlassTextFieldContainer，如适合
- 如果 liquid_glass_widgets 的具体 API 不确定，请先暂停并要求我提供文档，或明确说明需要查询官方文档。不要编造不存在的 API。
- 如果该库在 Web/Desktop 上有兼容性问题，需要提供降级方案，例如普通半透明卡片 + BackdropFilter。

==================================================
四、环境配置
==================================================

必须支持 debug / prod 环境。

可以使用 dart-define、flavor 或统一 EnvConfig，但至少需要支持 dart-define。

环境配置至少包含：

- appName
- environmentName
- baseUrl
- enableLog
- enableVerboseLog
- enableMock
- enableCrashReport
- enableAnalytics
- enableNetworkMonitor
- versionCheckUrl
- featureFlags

debug 环境：

- 使用 debug baseUrl。
- 默认 enableMock = true。
- 打印详细日志。
- 打印 Provider 初始化日志。
- 打印网络请求和响应摘要。
- 允许显示调试入口。
- 可以启用 mock 登录、mock 注册、mock 版本更新。

prod 环境：

- 使用 prod baseUrl。
- 默认 enableMock = false。
- 日志最小化。
- 禁止输出敏感信息。
- 禁止输出 password、token、authorization、cookie。
- Crash Report 默认可开启。
- Analytics 默认可开启。
- 不显示调试入口。

必须提供运行命令示例：

flutter run --dart-define=APP_ENV=debug

flutter run --dart-define=APP_ENV=prod

flutter build apk --dart-define=APP_ENV=prod

flutter build appbundle --dart-define=APP_ENV=prod

flutter build ios --dart-define=APP_ENV=prod

flutter build web --dart-define=APP_ENV=prod

flutter build macos --dart-define=APP_ENV=prod

flutter build windows --dart-define=APP_ENV=prod

flutter build linux --dart-define=APP_ENV=prod

==================================================
五、日志系统
==================================================

必须封装 AppLogger。

日志方法至少包含：

- debug
- info
- warning
- error
- critical

要求：

1. debug 环境输出详细日志。
2. prod 环境仅输出 warning / error / critical。
3. prod 环境不能泄露敏感信息。
4. 日志必须支持脱敏。
5. 网络日志需要脱敏。
6. password、token、authorization、cookie、set-cookie、refreshToken 等字段必须脱敏。
7. Riverpod Provider 初始化、登录、注册、退出、版本检查、主题切换、语言切换、环境初始化等关键流程需要有日志。
8. 所有业务代码通过 AppLogger 输出日志，不要直接 print。
9. 可使用 logger 包，也可以自定义封装。
10. 需要预留 Crash Report 上报接口。

==================================================
六、全局错误处理
==================================================

必须实现统一错误体系。

需要定义：

- AppException
- NetworkException
- AuthException
- ValidationException
- StorageException
- VersionException
- UnknownException
- Failure

要求：

1. Service 层可以抛出 AppException。
2. Repository 层负责捕获异常并转换为 Failure。
3. Controller 层暴露 AsyncValue 或业务状态。
4. UI 层不直接处理底层异常。
5. UI 层只展示用户友好的错误信息。
6. debug 环境可以展示更多错误细节。
7. prod 环境隐藏敏感错误细节。
8. 全局 FlutterError.onError 需要接入。
9. PlatformDispatcher.instance.onError 需要接入。
10. Provider 未捕获错误需要记录日志。
11. Crash Report 预留接口需要能接收 error 和 stackTrace。

==================================================
七、全局 SnackBar / Toast
==================================================

必须实现全局消息提示能力。

需要封装：

- AppMessenger
- AppSnackBar
- AppToast，若合适
- Global messenger key 或基于 ScaffoldMessenger 的服务

要求：

1. 登录失败显示错误提示。
2. 注册成功显示成功提示。
3. 退出登录显示提示。
4. 网络错误显示提示。
5. 检查更新结果显示提示。
6. 清除缓存成功显示提示。
7. 支持 success / error / warning / info 类型。
8. 样式需要适配主题。
9. 样式需要符合 iPhone 17 Pro 基准视觉。
10. Web/Desktop 需要有合理最大宽度。
11. 不要在业务层直接依赖 BuildContext。

==================================================
八、统一 UI 状态组件
==================================================

必须实现统一的：

- AppLoadingView
- AppEmptyView
- AppErrorView
- AppRetryView
- AppSkeleton，可选
- AppProgressOverlay
- AsyncValueView

要求：

1. 页面 loading、empty、error 风格统一。
2. AsyncValueView 可以统一处理 AsyncValue 的 loading / error / data。
3. 错误状态需要支持 retry。
4. loading 样式要适配 liquid glass 视觉。
5. 空状态需要支持图标、标题、描述、操作按钮。
6. 桌面端和移动端需要自适应布局。

==================================================
九、Feature Flags
==================================================

必须实现 Feature Flags 基础能力。

需要支持：

- 本地默认 flags
- 环境级 flags
- debug/prod 差异
- 后续远端配置预留

至少包含：

- enableMockLogin
- enableVersionCheck
- enableCrashReport
- enableAnalytics
- enableNetworkMonitor
- enableLiquidGlassFallback
- enableDebugPanel
- enableForceUpdateMock

要求：

1. FeatureFlags 由 EnvConfig 提供默认值。
2. 可通过本地存储覆盖部分 debug flags。
3. prod 环境需要禁止危险 debug 功能。
4. UI 中可以根据 flags 显示或隐藏调试功能。

==================================================
十、AppLifecycle 管理
==================================================

必须实现 AppLifecycle 管理。

需要封装：

- AppLifecycleController
- AppLifecycleObserver

要求：

1. 监听 resumed / inactive / paused / detached / hidden。
2. App 回到前台时可以触发：
   - 检查登录状态
   - 检查版本更新
   - 刷新必要数据
3. App 进入后台时记录日志。
4. 预留锁屏、安全检查、token 刷新逻辑。
5. Web/Desktop 平台需要兼容处理。
6. 不要在页面里散落 WidgetsBindingObserver。

==================================================
十一、ResponsiveLayout
==================================================

必须实现统一响应式系统。

需要包含：

- AppBreakpoints
- ResponsiveLayout
- AdaptiveScaffold
- AdaptiveScale
- PlatformLayoutHelper

断点建议：

- compact：width < 600
- medium：600 <= width < 1024
- expanded：width >= 1024

要求：

1. compact 以 iPhone 17 Pro 为视觉基准。
2. medium 使用双栏或更宽卡片。
3. expanded 使用桌面布局。
4. 登录、注册页面在桌面端需要最大宽度。
5. 首页和设置页在桌面端可以使用 NavigationRail 或居中宽布局。
6. 所有页面不能在大屏上无限拉伸。
7. 所有设计 token 需要支持 adaptive scale。
8. 字体和控件可以随屏幕轻微缩放，但不能过度放大。

==================================================
十二、Crash Report 预留
==================================================

必须预留崩溃上报接口。

需要定义：

- CrashReporter
- NoopCrashReporter
- RemoteCrashReporter，预留

要求：

1. debug 默认使用 NoopCrashReporter。
2. prod 可通过 Feature Flags 开启。
3. 支持 recordError(error, stackTrace, reason)。
4. 支持 setUserId。
5. 支持 setCustomKey。
6. 不要直接接入具体厂商 SDK，但需要预留 Firebase Crashlytics / Sentry 接入位置。
7. 全局错误处理需要调用 CrashReporter。

==================================================
十三、Analytics 预留
==================================================

必须预留埋点接口，但不强制接入真实 SDK。

需要定义：

- AnalyticsService
- NoopAnalyticsService
- RemoteAnalyticsService，预留

要求：

1. 支持 logEvent。
2. 支持 setUserId。
3. 支持 setUserProperty。
4. 路由切换时预留页面曝光。
5. 登录、注册、退出、检查更新、切换主题、切换语言需要预留事件。
6. debug 环境可以打印事件。
7. prod 环境根据 Feature Flags 决定是否启用。

==================================================
十四、网络状态监听预留
==================================================

需要预留 NetworkMonitor 能力。

可以使用 connectivity_plus，也可以先做接口预留。

需要定义：

- NetworkStatus
- NetworkMonitor
- NoopNetworkMonitor
- ConnectivityNetworkMonitor，若引入依赖

要求：

1. 支持 online / offline / unknown。
2. 支持 Stream 监听网络变化。
3. 网络断开时可以显示全局提示。
4. 网络恢复时可以显示恢复提示。
5. debug/prod 均可使用，但需受 Feature Flags 控制。
6. 如果不直接实现真实监听，需要给出后续接入说明。

==================================================
十五、CI/CD 模板预留
==================================================

需要提供 GitHub Actions 预留模板。

至少包含：

.github/workflows/flutter_ci.yml

流程包括：

- checkout
- setup flutter stable
- flutter pub get
- dart format check
- flutter analyze
- flutter test
- build web，可选

要求：

1. CI 文件可以先作为基础模板。
2. 不要包含敏感密钥。
3. Android/iOS 签名发布只做说明，不要写死证书。
4. README 中说明如何扩展 CI/CD。

==================================================
十六、README
==================================================

必须生成 README.md。

README 至少包含：

1. 项目简介。
2. 技术栈。
3. 支持平台。
4. 项目结构说明。
5. 环境配置说明。
6. debug/prod 启动命令。
7. build_runner 命令。
8. 国际化生成说明。
9. 主题系统说明。
10. liquid_glass_widgets 集成说明。
11. 登录注册 mock 说明。
12. 版本更新 mock 说明。
13. 测试运行命令。
14. 构建命令。
15. CI/CD 说明。
16. 如何接入真实 API。
17. 如何接入 Crashlytics / Sentry。
18. 如何接入 Analytics。
19. 常见问题。
20. 后续扩展建议。

==================================================
十七、必须实现的页面
==================================================

请至少实现以下页面。

1. SplashPage

功能：

- 展示 App Logo。
- 展示初始化 loading。
- 使用 liquid glass 背景或中心卡片。
- 执行初始化流程。
- 初始化失败时显示错误和重试按钮。
- 初始化成功后根据登录状态跳转。
- UI 以 iPhone 17 Pro 为移动端基准。

初始化流程至少包含：

- 初始化环境配置。
- 初始化日志。
- 初始化本地存储。
- 初始化安全存储。
- 加载主题配置。
- 加载语言配置。
- 恢复登录状态。
- 初始化 Feature Flags。
- 初始化 CrashReporter。
- 初始化 AnalyticsService。
- 初始化 AppLifecycle。
- 检查版本更新，受 Feature Flags 控制。

2. LoginPage

功能：

- 邮箱输入。
- 密码输入。
- 登录按钮。
- 跳转注册页。
- loading 状态。
- error 状态。
- 表单校验。
- 忘记密码入口预留。
- liquid glass 登录卡片。
- 移动端以 iPhone 17 Pro 为视觉基准。
- 桌面端居中并限制最大宽度。

Mock 登录规则：

- 任意合法邮箱。
- 密码长度 >= 6。
- 返回 mock token 和 mock user。

3. RegisterPage

功能：

- 邮箱输入。
- 密码输入。
- 确认密码输入。
- 注册按钮。
- 返回登录。
- loading 状态。
- error 状态。
- 表单校验。
- liquid glass 注册卡片。

Mock 注册规则：

- 邮箱格式正确。
- 密码长度 >= 6。
- 两次密码一致。
- 返回 mock user 和 mock token，或注册后跳转登录页，请给出合理方案。

4. HomePage

功能：

- 显示当前用户。
- 显示当前环境。
- 显示当前平台。
- 显示当前 App 版本。
- 显示当前语言。
- 显示当前主题。
- 显示网络状态，若启用。
- 显示 Feature Flags 摘要，debug 模式可见。
- 设置页入口。
- 退出入口可选。
- liquid glass 信息卡片。
- 响应式布局。
- Web/Desktop 不得简单拉伸手机页面。

5. SettingsPage

功能：

- 主题切换：亮色 / 暗色 / 跟随系统。
- 语言切换：中文 / 英文。
- 检查更新。
- 清除缓存。
- 退出登录。
- 当前版本显示。
- 当前环境显示。
- debug 模式可显示 Feature Flags 调试入口。
- liquid glass 分组卡片。
- 响应式布局。

6. UpdateDialog

功能：

- 标题。
- 更新内容。
- 当前版本。
- 最新版本。
- 是否强制更新。
- 立即更新。
- 稍后提醒。
- 强制更新不可关闭。
- 普通更新可稍后提醒。
- 不同平台处理：
  - Android：跳转下载链接或应用市场。
  - iOS：跳转 App Store。
  - Web：提示刷新页面。
  - Desktop：跳转下载页。
- 使用 liquid glass 风格。
- 适配亮色和暗色主题。

7. NotFoundPage

功能：

- 显示路由不存在。
- 提供返回首页或登录页按钮。
- UI 风格与整体一致。

==================================================
十八、版本更新
==================================================

必须实现版本更新能力。

需要包含：

- VersionService
- VersionRepository
- VersionController
- VersionInfo
- UpdateDialog

VersionInfo 至少包含：

- currentVersion
- latestVersion
- buildNumber
- forceUpdate
- title
- description
- downloadUrl
- platform
- releaseDate，可选

要求：

1. 使用 package_info_plus 获取当前版本。
2. debug 环境可以使用 mock version API。
3. prod 环境预留真实 API。
4. 支持无更新、普通更新、强制更新三种状态。
5. 支持平台区分。
6. 支持启动时检查。
7. 支持设置页手动检查。
8. 强制更新弹窗不可关闭。
9. 普通更新可以稍后提醒。
10. Web 平台更新提示应为刷新页面。
11. Desktop 平台更新提示应为跳转下载页。
12. 移动端更新提示应跳转应用商店或下载链接。

==================================================
十九、登录注册与认证
==================================================

必须实现 Auth 模块。

分层结构：

features/auth/
  data/
    models/
    repositories/
    services/
  domain/
    entities/
    repositories/
  presentation/
    controllers/
    pages/
    widgets/

需要实现：

- User entity
- AuthToken model
- AuthState
- AuthService interface
- MockAuthService
- RemoteAuthService 预留
- AuthRepository
- AuthController
- LoginPage
- RegisterPage
- AuthForm validators

功能：

1. 登录。
2. 注册。
3. 退出登录。
4. token 保存。
5. token 清除。
6. 启动时恢复登录状态。
7. 登录状态路由守卫。
8. 当前用户 Provider。
9. 登录失败错误提示。
10. 注册成功提示。
11. 退出登录提示。
12. token 过期预留处理。
13. 密码和 token 禁止进入日志。

AuthController 推荐使用 AsyncNotifier 或 Notifier。

==================================================
二十、项目结构
==================================================

请采用 feature-first + core + app + shared 混合架构。

推荐结构：

lib/
  main.dart
  bootstrap.dart

  app/
    app.dart
    design/
      app_breakpoints.dart
      app_spacing.dart
      app_radius.dart
      app_sizing.dart
      app_typography.dart
      app_durations.dart
      app_shadows.dart
      app_glass_tokens.dart
      adaptive_scale.dart
      responsive_layout.dart
    environment/
      app_environment.dart
      env_config.dart
      env_provider.dart
      feature_flags.dart
    router/
      app_routes.dart
      app_router.dart
      route_refresh_notifier.dart
    theme/
      app_theme.dart
      app_color_schemes.dart
      theme_controller.dart
    localization/
      locale_controller.dart
      l10n_extensions.dart
    lifecycle/
      app_lifecycle_controller.dart
      app_lifecycle_observer.dart

  core/
    constants/
      app_constants.dart
      app_assets.dart
      app_storage_keys.dart
    errors/
      app_exception.dart
      failure.dart
      error_mapper.dart
      global_error_handler.dart
    extensions/
      context_extensions.dart
      async_value_extensions.dart
      string_extensions.dart
    logging/
      app_logger.dart
      log_sanitizer.dart
    network/
      api_client.dart
      api_interceptor.dart
      api_response.dart
      network_status.dart
      network_monitor.dart
    storage/
      storage_service.dart
      secure_storage_service.dart
    messaging/
      app_messenger.dart
      app_snackbar.dart
    crash/
      crash_reporter.dart
      noop_crash_reporter.dart
    analytics/
      analytics_service.dart
      noop_analytics_service.dart
    utils/
      validators.dart
      platform_utils.dart
      version_utils.dart
      debounce.dart
    widgets/
      app_loading_view.dart
      app_empty_view.dart
      app_error_view.dart
      app_retry_view.dart
      app_progress_overlay.dart
      async_value_view.dart
      glass_scaffold.dart
      glass_card.dart
      glass_button.dart
      glass_dialog.dart
      glass_list_tile.dart

  features/
    splash/
      presentation/
        controllers/
          splash_controller.dart
        pages/
          splash_page.dart

    auth/
      data/
        models/
          auth_token_model.dart
          user_model.dart
        repositories/
          auth_repository_impl.dart
        services/
          auth_service.dart
          mock_auth_service.dart
          remote_auth_service.dart
      domain/
        entities/
          user.dart
          auth_token.dart
        repositories/
          auth_repository.dart
      presentation/
        controllers/
          auth_controller.dart
        pages/
          login_page.dart
          register_page.dart
        widgets/
          auth_text_field.dart
          auth_submit_button.dart

    home/
      presentation/
        pages/
          home_page.dart
        widgets/
          home_info_card.dart
          environment_card.dart
          platform_card.dart

    settings/
      presentation/
        controllers/
          settings_controller.dart
        pages/
          settings_page.dart
        widgets/
          theme_selector.dart
          locale_selector.dart
          settings_section.dart

    version/
      data/
        models/
          version_info_model.dart
        repositories/
          version_repository_impl.dart
        services/
          version_service.dart
          mock_version_service.dart
          remote_version_service.dart
      domain/
        entities/
          version_info.dart
        repositories/
          version_repository.dart
      presentation/
        controllers/
          version_controller.dart
        widgets/
          update_dialog.dart

  shared/
    models/
    providers/
      package_info_provider.dart
      platform_provider.dart
    widgets/
      app_logo.dart
      adaptive_page.dart
      page_container.dart

test/
  features/
    auth/
      auth_controller_test.dart
    version/
      version_controller_test.dart
  app/
    theme_controller_test.dart
    locale_controller_test.dart
  widget/
    login_page_test.dart

.github/
  workflows/
    flutter_ci.yml

assets/
  images/
  icons/

lib/l10n/
  app_en.arb
  app_zh.arb

请根据实际最佳实践微调，但必须解释原因。

==================================================
二十一、必须实现的 Provider / Controller
==================================================

至少实现：

1. appBootstrapProvider
   - 负责 App 初始化。

2. envConfigProvider
   - 提供当前环境配置。

3. featureFlagsProvider
   - 提供功能开关。

4. appLoggerProvider
   - 提供日志能力。

5. storageServiceProvider
   - 提供普通存储。

6. secureStorageServiceProvider
   - 提供安全存储。

7. apiClientProvider
   - 提供网络请求能力。

8. authControllerProvider
   - 登录、注册、退出、恢复登录状态。

9. currentUserProvider
   - 当前用户信息。

10. themeControllerProvider
    - 当前主题模式、切换主题、持久化。

11. localeControllerProvider
    - 当前语言、切换语言、持久化。

12. versionControllerProvider
    - 检查版本更新。

13. routerProvider
    - go_router 实例。

14. appLifecycleControllerProvider
    - App 生命周期管理。

15. crashReporterProvider
    - 崩溃上报预留。

16. analyticsServiceProvider
    - 埋点预留。

17. networkMonitorProvider
    - 网络状态监听预留。

18. appMessengerProvider
    - 全局消息提示能力。

==================================================
二十二、推荐依赖
==================================================

请基于当前 pub.dev 最新稳定版本选择依赖。

至少考虑：

核心：

- flutter_riverpod
- riverpod_annotation
- riverpod_generator
- build_runner
- go_router
- dio
- freezed_annotation
- freezed
- json_annotation
- json_serializable

UI：

- liquid_glass_widgets: ^0.19.5
- flutter_svg，可选
- cached_network_image，可选

国际化：

- flutter_localizations
- intl

存储：

- shared_preferences
- flutter_secure_storage

日志：

- logger，或自定义封装

包信息：

- package_info_plus

平台能力：

- url_launcher
- device_info_plus，可选
- connectivity_plus，可选，用于网络状态监听

测试：

- flutter_test
- mocktail
- integration_test，可选
- riverpod_test，如适用且稳定

Lint：

- flutter_lints 或 very_good_analysis

如果某些依赖已经不推荐，或者与 Flutter 最新 stable / Riverpod 3 存在版本冲突，请主动说明，并选择更合适的替代方案。

不要编造不存在的依赖版本。请尽可能使用 pub.dev 最新稳定版本。如果不确定，请提醒我确认版本。

==================================================
二十三、代码质量要求
==================================================

必须满足：

1. 配置 analysis_options.yaml。
2. 使用 flutter_lints 或 very_good_analysis。
3. 尽量启用严格 lint。
4. 所有文件命名使用 snake_case。
5. 类名使用 PascalCase。
6. 变量和方法使用 lowerCamelCase。
7. 尽量避免 dynamic。
8. 尽量避免全局可变状态。
9. 业务逻辑不要写在 Widget 中。
10. Widget 只负责展示和用户交互。
11. Controller 负责状态变化。
12. Repository 负责数据协调。
13. Service 负责具体 API / 存储 / 平台能力调用。
14. UI 层不要直接访问 dio、shared_preferences、flutter_secure_storage。
15. 所有异常转换为统一 Failure。
16. 所有日志通过 AppLogger 输出。
17. 所有敏感日志必须脱敏。
18. 所有路由路径必须常量化。
19. 所有 UI 文案必须国际化。
20. 所有主题颜色从 ThemeData / ColorScheme / design tokens 获取。
21. 所有尺寸优先从 design tokens 获取。
22. 不要生成无法编译的伪代码。
23. 不要手写 .g.dart / .freezed.dart 文件。
24. 生成代码后说明需要运行的 build_runner 命令。
25. 每阶段完成后说明如何验证。

==================================================
二十四、安全要求
==================================================

必须满足：

1. 不要在日志中输出 password。
2. 不要在日志中输出 token。
3. 不要在日志中输出 authorization。
4. 不要在日志中输出 cookie。
5. 不要将生产密钥写死在代码中。
6. 敏感配置通过 dart-define 或安全配置注入。
7. 登录失败不要暴露过多服务端细节。
8. 注册、登录表单需要基础校验。
9. Web 环境下需要说明 token 存储风险。
10. prod 环境禁止 debug 面板。
11. prod 环境禁止 mock 登录，除非显式配置。
12. 错误提示要用户友好，不暴露后端实现。
13. Crash Report 上报前需要过滤敏感信息。

==================================================
二十五、测试要求
==================================================

必须提供基础测试结构。

至少包含：

- unit test
- widget test
- provider test

测试示例至少包括：

1. AuthController 登录成功。
2. AuthController 登录失败。
3. AuthController 退出登录。
4. ThemeController 切换主题。
5. LocaleController 切换语言。
6. VersionController 无更新。
7. VersionController 普通更新。
8. VersionController 强制更新。
9. LoginPage 表单校验。
10. SettingsPage 主题切换 UI，简单测试即可。

要求：

1. 测试不能依赖真实网络。
2. 使用 mock 服务。
3. 使用 ProviderContainer.test 或 Riverpod 3 推荐测试方式。
4. 测试中要能 override providers。
5. README 中提供测试命令。

==================================================
二十六、Mock 与真实 API 预留
==================================================

模板初始版本可以使用 Mock 数据，但必须预留真实 API 接入位置。

启动页、登录、注册、版本更新接口参考:
http://192.168.254.127:8091/api/v1/app/branding
Response Text: {"code":0,"msg":"success","data":{"revision":"20260622002111","splash":{"imageUrl":null,"enabled":false}

http://192.168.254.127:8091/api/v1/app/versions/latest
Response Text: {"code":0,"msg":"success","data":{"version":"1.5.6","description":"IOS 26 UI","downloadUrl":"https://app.fubonplus.com/download/fubang-v1.5.6.apk","iosUrl":"https://c0qjp.51xiuba.com/i/C99Z4XA9XOE4ZGGI","isForce":false,"isHotUpdate":false}}

http://192.168.254.127:8091/api/v1/auth/login
content-type: application/json; charset=utf-8
post参数:
UserLoginReq({this.mobile, this.password});
Response Text: {"code":0,"msg":"success","data":{"token":"b4046a03f4b24341bda7c4b98c1e1268","expire":"43199900"}}

http://192.168.254.127:8091/api/v1/auth/register
post参数:
UserRegisterReq({
this.username,
this.password,
this.realName,
this.idCard,
this.inviteCode, 
}); 


必须实现：

- MockAuthService
- RemoteAuthService
- MockVersionService
- RemoteVersionService

debug 环境：

- 默认 enableMock = true。
- 可以使用 mock 登录注册。
- 可以模拟版本更新。

prod 环境：

- 默认 enableMock = false。
- 使用 RemoteService 预留实现。
- 如果没有真实 API，可以返回明确的 UnimplementedException 或友好 Failure，但不要让 App 崩溃。

Mock 登录：

- 任意合法邮箱 + 长度 >= 6 的密码可登录成功。
- 返回 mock token 和 mock user。

Mock 注册：

- 邮箱格式正确。
- 密码长度 >= 6。
- 两次密码一致。
- 返回 mock user。

Mock 版本检查：

- 支持无更新。
- 支持普通更新。
- 支持强制更新。
- 可通过 Feature Flags 或 debug 设置切换模拟状态。



==================================================
二十七、跨平台适配要求
==================================================

1. 移动端

- UI 以 iPhone 17 Pro 为基准。
- 使用 SafeArea。
- 表单居中。
- 键盘弹起时页面可滚动。
- 按钮、输入框、卡片符合 iPhone 17 Pro 视觉比例。
- Android 保留 Material 交互体验。

2. 平板端

- 使用 medium 布局。
- 页面内容不要过宽。
- 设置页可使用双栏布局或居中宽卡片。

3. 桌面端

- 登录注册页最大宽度限制。
- 首页和设置页使用 expanded 布局。
- 可以使用 NavigationRail 或居中内容布局。
- 鼠标 hover / focus 状态自然。
- 窗口大小变化不崩。
- 不要简单拉伸手机 UI。

4. Web

- 支持浏览器刷新后恢复状态。
- 路由路径可读。
- token 存储风险需要说明。
- 更新检查时 Web 平台提示刷新。
- 支持响应式布局。
- 不要依赖移动端专属 API。

==================================================
二十八、交付顺序
==================================================

请严格按以下顺序交付。

第一阶段：架构设计

请先输出：

1. 架构方案。
2. 完整目录结构。
3. UI 设计系统方案。
4. iPhone 17 Pro 基准适配方案。
5. 关键依赖选择。
6. Riverpod 3 Provider 设计方案。
7. 环境配置方案。
8. 分阶段代码生成计划。
9. 需要我确认的问题。

不要在第一阶段直接生成全部代码。

第二阶段：项目基础配置

生成：

- pubspec.yaml
- analysis_options.yaml
- l10n.yaml
- README.md 初版
- .gitignore，如需要
- assets 目录说明
- .github/workflows/flutter_ci.yml

第三阶段：入口与 Bootstrap

生成：

- main.dart
- bootstrap.dart
- app.dart
- ProviderScope 初始化
- 全局错误处理
- 环境初始化
- 日志初始化

第四阶段：设计系统与响应式系统

生成：

- app_breakpoints.dart
- app_spacing.dart
- app_radius.dart
- app_sizing.dart
- app_typography.dart
- app_durations.dart
- app_shadows.dart
- app_glass_tokens.dart
- adaptive_scale.dart
- responsive_layout.dart
- adaptive_page.dart

第五阶段：环境、Feature Flags、日志

生成：

- EnvConfig
- AppEnvironment
- feature_flags.dart
- env providers
- AppLogger
- LogSanitizer

第六阶段：核心服务

生成：

- StorageService
- SecureStorageService
- ApiClient
- ApiInterceptor
- AppException
- Failure
- ErrorMapper
- AppMessenger
- CrashReporter
- AnalyticsService
- NetworkMonitor 预留

第七阶段：主题与国际化

生成：

- AppTheme
- AppColorSchemes
- ThemeController
- LocaleController
- app_zh.arb
- app_en.arb
- l10n extensions

第八阶段：路由

生成：

- AppRoutes
- AppRouter
- route refresh notifier
- 登录鉴权重定向
- NotFoundPage

第九阶段：Glass 统一组件

生成：

- GlassScaffold
- GlassCard
- GlassButton
- GlassDialog
- GlassListTile
- liquid glass fallback 方案

第十阶段：Auth 模块

生成：

- User
- AuthToken
- AuthService
- MockAuthService
- RemoteAuthService
- AuthRepository
- AuthController
- LoginPage
- RegisterPage
- Auth widgets
- 表单校验

第十一阶段：Splash 模块

生成：

- SplashController
- SplashPage
- 初始化流程
- 初始化失败重试
- 初始化后路由跳转

第十二阶段：Version 模块

生成：

- VersionInfo
- VersionService
- MockVersionService
- RemoteVersionService
- VersionRepository
- VersionController
- UpdateDialog

第十三阶段：Home 模块

生成：

- HomePage
- HomeInfoCard
- EnvironmentCard
- PlatformCard
- 响应式布局
- liquid glass 卡片

第十四阶段：Settings 模块

生成：

- SettingsPage
- SettingsController
- ThemeSelector
- LocaleSelector
- SettingsSection
- 清除缓存
- 检查更新
- 退出登录
- Feature Flags debug 区域

第十五阶段：AppLifecycle、Crash、Analytics、Network

生成或完善：

- AppLifecycleController
- AppLifecycleObserver
- CrashReporter 接入全局错误
- Analytics 事件预留
- NetworkMonitor 预留或实现

第十六阶段：测试

生成：

- AuthController tests
- ThemeController tests
- LocaleController tests
- VersionController tests
- LoginPage widget test
- 必要 mock

第十七阶段：最终说明

完善：

- README.md
- 运行命令
- 构建命令
- build_runner 命令
- 国际化命令
- 测试命令
- 如何接真实 API
- 如何接 Crashlytics / Sentry
- 如何接 Analytics
- 如何发布各平台

==================================================
二十九、每阶段输出要求
==================================================

每个阶段输出时，请按以下格式：

1. 本阶段目标。
2. 本阶段新增文件。
3. 本阶段修改文件。
4. 关键设计说明。
5. 完整代码。
6. 需要运行的命令。
7. 如何验证。
8. 下一阶段计划。

如果某个阶段文件过多，请拆成多个小批次。

每次输出代码时，必须标注文件路径，例如：

lib/features/auth/presentation/pages/login_page.dart

不要只输出片段，除非明确说明是在修改局部代码。

如果需要修改之前生成的文件，请明确指出修改位置和原因。

==================================================
三十、代码生成约束
==================================================

请严格遵守：

1. 不要一次性生成无法维护的巨大文件。
2. 每个文件职责单一。
3. 不要把所有 Provider 放到一个文件。
4. 不要把所有页面放到一个文件。
5. 不要把业务逻辑写在 Widget 中。
6. 不要使用 Riverpod legacy API。
7. 不要使用 GetX、Provider、Bloc 作为主状态管理。
8. 不要编造 liquid_glass_widgets 不存在的 API。
9. 不要编造依赖版本。
10. 不要手写生成文件，例如 .g.dart、.freezed.dart。
11. 如果需要 build_runner，请说明命令：
    dart run build_runner build --delete-conflicting-outputs
12. 如果 API 不确定，请暂停说明，不要猜测。
13. 如果依赖冲突，请优先保证 Flutter stable 和 Riverpod 3 兼容。
14. 如果发现前面代码有问题，请优先修复，不要继续堆新代码。
15. 所有代码应尽可能可以直接复制运行。
16. 所有页面文案必须国际化。
17. 所有尺寸优先使用 design tokens。
18. 所有颜色优先使用 ThemeData / ColorScheme。
19. 所有日志通过 AppLogger。
20. 所有错误通过 Failure / AppException。

==================================================
三十一、最终验收标准
==================================================

最终模板必须满足：

1. 可以 flutter pub get。
2. 可以运行 build_runner。
3. 可以 flutter analyze 通过，或仅有明确说明的可接受 warning。
4. 可以 flutter test。
5. 可以运行 debug 环境。
6. 可以运行 prod 环境。
7. 可以登录。
8. 可以注册。
9. 可以退出登录。
10. 可以启动时恢复登录状态。
11. 可以进行路由鉴权。
12. 可以显示 Splash。
13. 可以进入首页。
14. 可以进入设置页。
15. 可以切换主题。
16. 可以切换语言。
17. 可以检查版本更新。
18. 可以显示强制更新弹窗。
19. 可以显示普通更新弹窗。
20. 可以显示全局 SnackBar / Toast。
21. 可以展示 Loading / Empty / Error 统一状态。
22. 可以在移动端按 iPhone 17 Pro 视觉基准显示。
23. 可以在 Web/Desktop 上响应式显示。
24. 可以使用 liquid_glass_widgets 风格组件。
25. 可以 debug/prod 环境隔离。
26. prod 日志不泄露敏感信息。
27. 有 Crash Report 预留。
28. 有 Analytics 预留。
29. 有 Network Monitor 预留。
30. 有 CI/CD 模板。
31. 有 README。
32. 可以后续直接接真实后端 API。

请现在先输出第一阶段内容：

1. 架构方案。
2. 完整目录结构。
3. UI 设计系统方案。
4. iPhone 17 Pro 基准适配方案。
5. 关键依赖规划。
6. Riverpod 3 Provider 设计方案。
7. 环境配置方案。
8. 分阶段代码生成计划。
9. 需要我确认的问题。

不要直接开始生成全部代码。

请严格分阶段执行。每完成一个阶段就停止，等待我回复“继续”后再进入下一阶段。如果发现当前阶段代码存在编译问题，请优先修复，不要继续生成新模块。



