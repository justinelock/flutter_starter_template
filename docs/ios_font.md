你是一名资深 Apple Human Interface Guidelines 设计师、iOS 26 视觉设计专家、Flutter UI 架构师、Material 3 Typography 专家、多平台响应式 UI 专家。

请为我的 Flutter 跨平台项目设计一套完整的字体大小系统和排版规范。

这套 Typography 系统需要同时满足：

1. 以 iOS 26 的视觉语言为标准。
2. 以 Liquid Glass 界面风格为核心场景。
3. 以 iPhone 17 Pro 作为移动端 compact 视觉基准。
4. 兼容 Flutter Material 3 TextTheme。
5. 兼容 Android / iOS / Web / Windows / macOS / Linux。
6. 支持不同平台、不同屏幕宽度、不同输入方式下的比例缩放。
7. 支持亮色 / 暗色主题。
8. 支持国际化，至少中文和英文。
9. 支持可访问性文本缩放。
10. 可直接集成到生产级 Flutter Starter Template。

请不要只给几个字号。请给我一套完整、专业、可落地、可维护、可直接用于 Flutter 的字体系统、排版 token 和代码实现。

==================================================
一、项目背景
==================================================

项目技术栈：

- Flutter 最新 stable
- Dart 最新 stable
- Material 3
- Riverpod 3
- go_router
- liquid_glass_widgets: ^0.19.5
- 支持平台：
    - Android
    - iOS
    - Web
    - Windows
    - macOS
    - Linux

视觉基准：

- 设计语言：iOS 26
- 视觉材质：Liquid Glass
- 移动端设备基准：iPhone 17 Pro
- compact 布局逻辑宽度基准：约 402 logical pixels
- compact 布局逻辑高度基准：约 874 logical pixels
- 其他设备按平台、屏幕宽度、输入方式和可读距离进行适配

注意：

Flutter 开发中请使用 logical pixels，不要使用物理像素。iPhone 17 Pro 只作为 compact 移动端视觉密度、控件比例、字号层级、行高、间距和信息密度的参考基准。

==================================================
二、总体设计目标
==================================================

请设计一套适合 iOS 26 + Liquid Glass 风格的 Typography 系统。

整体排版风格关键词：

- iOS 26
- Liquid Glass
- iPhone 17 Pro
- 清晰
- 轻盈
- 高级
- 克制
- 高可读性
- 层级明确
- 内容优先
- 大标题有呼吸感
- 正文舒适
- 标签紧凑
- 表单清楚
- 按钮稳定
- 中文英文都自然
- 多平台一致但不死板
- Material 3 兼容
- 可访问性友好

字体系统需要满足：

1. 移动端以 iPhone 17 Pro 为 1x 基准。
2. Android 手机应接近 iPhone 17 Pro 视觉比例，但保留 Material 3 排版习惯。
3. Web 需要考虑浏览器阅读距离和窗口宽度。
4. Desktop 需要考虑更远的阅读距离、鼠标交互和大屏信息密度。
5. Tablet 需要中间态排版，不要简单放大手机 UI。
6. 字体大小、行高、字重、字间距都要 token 化。
7. 所有 TextStyle 应从 TextTheme / AppTypographyTokens 获取，不要在页面中硬编码。
8. Liquid Glass 卡片上的文字需要更高对比度和稳定行高。
9. 中文和英文都要可读。
10. 支持系统字体缩放，但需要设置合理上下限，避免 UI 崩坏。

==================================================
三、iOS 26 Typography 设计标准
==================================================

请以 iOS 26 的视觉语言设计排版系统。

设计原则包括：

1. 内容优先

Typography 应服务于内容可读性。Liquid Glass、模糊、高光和背景层次不能影响文字阅读。

2. 层级清楚

标题、副标题、正文、辅助说明、标签、按钮、输入框、导航都需要明确层级。

3. 大标题有呼吸感

Splash、Home、Auth 页面中的大标题可以更具空间感，但不能过大导致压迫。

4. 正文舒适

正文需要在 iPhone 17 Pro 上保持舒适阅读。中文正文不宜过小，英文正文不宜过密。

5. Liquid Glass 场景下增强可读性

Glass 卡片上的文字需要：

- 更稳定的行高
- 适当增加字重
- 避免过细字体
- 避免过低对比度
- 小字号不得过浅
- 必要时配合 scrim / surface overlay

6. 暗色模式更克制

暗色模式下不要使用过亮纯白文字，避免视觉疲劳。主文字应接近柔和白，次级文字应保持足够对比度。

7. 亮色模式避免浅灰过度

亮色模式下次级文本不能太浅，避免不可读。

8. Flutter 化实现

不要依赖 iOS 私有字体。优先使用 Flutter 平台默认字体策略，并允许未来接入自定义字体。

==================================================
四、iPhone 17 Pro 字体基准
==================================================

请以 iPhone 17 Pro 为 compact 移动端字体基准。

要求：

1. compact 基准宽度：约 402 logical pixels。
2. compact 基准字号为 1x。
3. 其他手机根据宽度轻微缩放。
4. Android compact 尺寸可与 iOS compact 基本一致，但允许 Material 习惯微调。
5. Tablet 不应简单整体放大，应提高布局宽度和信息层级。
6. Desktop/Web 不应简单整体放大，应控制最大字号和内容宽度。
7. 表单、按钮、导航、卡片标题等 UI 字号需要稳定。
8. 阅读型内容可允许更大行高和最大宽度。
9. 所有字号需要设置最小值和最大值。
10. 需要支持 MediaQuery.textScaler 或 Flutter 最新文本缩放机制。

请设计一套 adaptive typography scale：

- baseWidth = 402
- minScale 建议 0.92 左右
- maxScale 手机建议 1.08 左右
- tablet scale 建议 1.04 - 1.12
- desktop scale 建议 1.00 - 1.10，不要无限放大
- web scale 根据内容区域宽度和设备类型控制
- 用户系统字体缩放需要被尊重，但在关键 UI 中可设置安全上限

请说明你的具体缩放算法。

==================================================
五、请输出的内容
==================================================

请按以下结构输出完整方案。

--------------------------------------------------
1. Typography 设计原则
--------------------------------------------------

请说明：

- 为什么符合 iOS 26 视觉标准
- 为什么适合 Liquid Glass 场景
- 为什么以 iPhone 17 Pro 作为 compact 基准
- 中文和英文排版分别要注意什么
- Flutter 多平台为什么不能简单使用固定字号
- 为什么需要 adaptive typography
- 为什么需要限制最大缩放
- 为什么不能在页面里硬编码 TextStyle

--------------------------------------------------
2. 字体族策略
--------------------------------------------------

请给出 Flutter 多平台字体族策略。

要求说明：

1. iOS / macOS：
    - 默认可使用系统字体风格，接近 San Francisco。
    - Flutter 中不要直接依赖私有字体文件。
2. Android：
    - 默认使用 Roboto 或平台默认字体。
    - 需要保持与 iOS 基准接近的视觉大小。
3. Web：
    - 使用系统字体栈。
    - 英文、中文都需要有 fallback。
4. Windows：
    - 使用 Segoe UI 或系统默认字体。
5. Linux：
    - 使用系统默认 Sans 字体。
6. 中文：
    - 需要考虑 PingFang SC、Noto Sans CJK、Microsoft YaHei、系统 fallback。
7. 可选：
    - 是否建议引入自定义字体。
    - 如果引入自定义字体，应该如何设计 fallback。

请给出推荐 fontFamily / fontFamilyFallback 策略。

--------------------------------------------------
3. 字体层级表
--------------------------------------------------

请设计完整字体层级。

至少包含：

Display：

- displayLarge
- displayMedium
- displaySmall

Headline：

- headlineLarge
- headlineMedium
- headlineSmall

Title：

- titleLarge
- titleMedium
- titleSmall

Body：

- bodyLarge
- bodyMedium
- bodySmall

Label：

- labelLarge
- labelMedium
- labelSmall

App 自定义层级：

- heroTitle
- pageTitle
- sectionTitle
- cardTitle
- cardSubtitle
- formLabel
- inputText
- inputPlaceholder
- buttonLarge
- buttonMedium
- buttonSmall
- navLabel
- tabLabel
- badgeText
- caption
- helperText
- errorText
- toastText
- dialogTitle
- dialogBody
- updateTitle
- updateDescription
- codeText，可选

每个层级请给出：

- baseFontSize
- lineHeight
- height 值
- fontWeight
- letterSpacing
- 使用场景
- 是否适合 glass surface
- compact / medium / expanded 建议缩放范围

要求：

1. iPhone 17 Pro compact 基准下正文 bodyMedium 建议在 15-16 logical pixels。
2. bodyLarge 可在 16-17。
3. titleLarge 可在 22-24。
4. headlineLarge 可在 30-34。
5. displayLarge 不应过度夸张，除非用于 Splash / Hero。
6. labelSmall 不应小于 11。
7. 错误提示不应小于 12。
8. 输入框文字建议 16，避免移动端输入体验差。
9. 按钮文字建议 15-17。
10. 导航标签建议 11-13。
11. 中文行高应略宽松。
12. 英文字间距可以更克制。

--------------------------------------------------
4. 多平台缩放规则
--------------------------------------------------

请设计不同平台字体缩放规则。

需要覆盖：

- iOS
- Android
- Web
- Windows
- macOS
- Linux
- Tablet
- Desktop
- Foldable，可选

请至少说明：

1. iOS compact：
    - 以 1.0 scale 为基准。
2. Android compact：
    - 0.98 - 1.02 范围，视觉上接近 iPhone 17 Pro。
3. Tablet：
    - 标题可略放大，正文不宜过大。
4. Web：
    - 正文可略大，但要受内容宽度限制。
5. Desktop：
    - 控件文字不要过大，阅读正文可略增。
6. macOS：
    - 可以稍微更接近 iOS 视觉。
7. Windows：
    - 注意 Segoe UI 视觉大小可能与 SF/Roboto 不同。
8. Linux：
    - 字体 fallback 差异较大，需要保守字号。
9. 大屏不要整体等比放大。
10. 用户无障碍 text scale 需要尊重，但关键控件需要保护布局。

请给出一个 Flutter 可实现的 AdaptiveTypographyScale 算法，考虑：

- screenWidth
- platform
- layoutClass
- textScaler
- minScale
- maxScale
- isDesktop
- isWeb
- isTablet

--------------------------------------------------
5. Liquid Glass 场景下的排版规则
--------------------------------------------------

请专门说明 glass surface 上的字体策略。

包括：

1. GlassCard 上的标题字号。
2. GlassCard 上的正文字号。
3. GlassDialog 标题和正文。
4. UpdateDialog 标题、版本号、更新内容。
5. Splash 页面 Logo 文本和副标题。
6. Login / Register 表单标题和输入文字。
7. SnackBar / Toast 文案。
8. NavigationBar / NavigationRail 文案。
9. 暗色 glass 上文字颜色和字重建议。
10. 亮色 glass 上文字颜色和字重建议。
11. 复杂背景上文字如何增强可读性。
12. 什么时候应该增加 fontWeight。
13. 什么时候应该增加 lineHeight。
14. 什么时候不应该使用太小字体。

--------------------------------------------------
6. 中文 / 英文 / 多语言排版规则
--------------------------------------------------

请说明：

1. 中文正文推荐字号。
2. 英文正文推荐字号。
3. 中文标题是否需要更高字重。
4. 英文标题是否需要调整 letterSpacing。
5. 中英文混排注意事项。
6. ARB 国际化文案长度变化如何影响 UI。
7. 德语、法语等长文本扩展预留，可选。
8. 阿拉伯语 RTL 预留，可选。
9. 按钮文字过长时如何处理。
10. 设置页 ListTile 文案如何避免溢出。
11. Web/Desktop 上如何限制阅读宽度。

--------------------------------------------------
7. Material 3 TextTheme
--------------------------------------------------

请生成完整 Material 3 TextTheme 方案。

至少包含：

- displayLarge
- displayMedium
- displaySmall
- headlineLarge
- headlineMedium
- headlineSmall
- titleLarge
- titleMedium
- titleSmall
- bodyLarge
- bodyMedium
- bodySmall
- labelLarge
- labelMedium
- labelSmall

每个 TextStyle 需要包含：

- fontSize
- height
- fontWeight
- letterSpacing
- color 不要写死，优先由 Theme 使用时指定，或使用 ColorScheme.onSurface

请说明每个 TextTheme 对应 App 中什么场景。

--------------------------------------------------
8. AppTypographyTokens
--------------------------------------------------

请设计 AppTypographyTokens ThemeExtension。

至少包括：

- heroTitle
- pageTitle
- sectionTitle
- cardTitle
- cardSubtitle
- formLabel
- inputText
- inputPlaceholder
- buttonLarge
- buttonMedium
- buttonSmall
- navLabel
- tabLabel
- badgeText
- caption
- helperText
- errorText
- toastText
- dialogTitle
- dialogBody
- updateTitle
- updateVersion
- updateDescription
- codeText

要求：

1. AppTypographyTokens 可以通过 Theme.of(context).extension 获取。
2. 每个 token 是 TextStyle。
3. ThemeExtension 需要实现 copyWith 和 lerp。
4. 需要 light / dark 都可用。
5. 颜色可以从 ColorScheme / AppColorTokens 注入或在构造时生成。
6. 支持 adaptive scale。
7. 不要在页面中硬编码 TextStyle。

--------------------------------------------------
9. Flutter 代码
--------------------------------------------------

请生成可直接放入项目的代码。

必须生成以下文件：

1. lib/app/design/app_typography_scale.dart

包含：

- LayoutClass enum 或引用已有 AppBreakpoints
- AdaptiveTypographyScale
- 根据 screenWidth、platform、layoutClass 计算 scale
- clamp 逻辑
- 用户 text scale 合并策略
- iPhone 17 Pro baseWidth = 402
- compact / medium / expanded 缩放策略

2. lib/app/theme/app_text_theme.dart

包含：

- AppTextTheme
- buildTextTheme
- Material 3 TextTheme
- 根据 AdaptiveTypographyScale 生成字号
- 不硬编码颜色或只使用基础 onSurface
- 支持 fontFamilyFallback

3. lib/app/theme/app_typography_tokens.dart

包含：

- AppTypographyTokens extends ThemeExtension<AppTypographyTokens>
- 所有自定义 TextStyle token
- copyWith
- lerp
- light / dark 构建方法
- scale 支持

4. lib/app/theme/typography_extensions.dart

包含：

- BuildContext 扩展：
    - context.textTheme
    - context.typography
    - context.textScale
    - context.isLargeText
    - context.layoutClass，如需要

5. lib/app/theme/app_theme.dart 中如何接入的示例

包含：

- ThemeData.textTheme
- ThemeData.primaryTextTheme，如需要
- extensions 注入 AppTypographyTokens
- 与 AppColorTokens 配合

要求：

1. 使用 Dart null safety。
2. 使用 const 优先。
3. 不要使用 dynamic。
4. 不要使用已废弃 API。
5. TextStyle lerp 要正确。
6. ThemeExtension copyWith 要完整。
7. 字体大小不要散落在页面中。
8. 所有 TextStyle 从 TextTheme 或 AppTypographyTokens 获取。
9. 代码需要适合 Flutter 最新 stable。
10. 如果 Flutter API 有版本差异，请说明替代方案。

--------------------------------------------------
10. 使用示例
--------------------------------------------------

请给出以下使用示例：

1. 页面标题如何使用。
2. GlassCard 标题如何使用。
3. 表单 Label 如何使用。
4. TextField style 如何使用。
5. FilledButton 文本如何使用。
6. SnackBar / Toast 文本如何使用。
7. UpdateDialog 标题和正文如何使用。
8. HomePage 信息卡片文字如何使用。
9. SettingsPage ListTile 标题和副标题如何使用。
10. 如何根据系统 text scale 保持布局稳定。
11. 如何在 Web/Desktop 限制阅读区域宽度。
12. 如何避免 Text overflow。

--------------------------------------------------
11. 可访问性要求
--------------------------------------------------

请说明：

1. 如何尊重系统字体缩放。
2. 什么时候限制最大 text scale。
3. 关键按钮在大字体下如何避免溢出。
4. 表单输入在大字体下如何保持可用。
5. Glass 背景下小字号如何保证可读性。
6. 文本对比度和字体大小的关系。
7. 中老年用户或视力弱用户如何适配。
8. Desktop 键盘导航 focus 状态下文字是否需要变化。
9. Web 浏览器缩放下如何保持布局。
10. 是否需要提供 App 内字体大小设置预留。

--------------------------------------------------
12. 最终检查清单
--------------------------------------------------

请给出 checklist：

- iPhone 17 Pro compact 下字号是否舒适
- Android compact 下是否接近基准
- Tablet 下是否不过度放大
- Desktop/Web 下是否不显得巨大
- 中文是否可读
- 英文是否可读
- 中英文混排是否自然
- TextField 是否至少 16
- Button 文本是否稳定
- labelSmall 是否不小于 11
- errorText 是否不小于 12
- GlassCard 上文字是否清楚
- 暗色模式文字是否不刺眼
- 亮色模式次级文字是否不太浅
- 系统 text scale 是否被尊重
- 大字体下是否不崩布局
- 所有 TextStyle 是否 token 化
- 页面中是否没有硬编码字号
- 是否兼容 Material 3
- 是否能接入 Riverpod 主题切换

==================================================
六、推荐初始字号倾向
==================================================

请优先参考以下 iPhone 17 Pro compact 基准字号，但你可以根据专业判断优化。

Material 3 TextTheme 建议基准：

- displayLarge: 40
- displayMedium: 36
- displaySmall: 32

- headlineLarge: 30
- headlineMedium: 27
- headlineSmall: 24

- titleLarge: 22
- titleMedium: 18
- titleSmall: 16

- bodyLarge: 17
- bodyMedium: 16
- bodySmall: 14

- labelLarge: 15
- labelMedium: 13
- labelSmall: 11.5

App 自定义 Typography 建议基准：

- heroTitle: 34
- pageTitle: 28
- sectionTitle: 20
- cardTitle: 18
- cardSubtitle: 14
- formLabel: 14
- inputText: 16
- inputPlaceholder: 16
- buttonLarge: 16
- buttonMedium: 15
- buttonSmall: 13
- navLabel: 12
- tabLabel: 13
- badgeText: 11
- caption: 12
- helperText: 12
- errorText: 12.5
- toastText: 14
- dialogTitle: 21
- dialogBody: 15
- updateTitle: 22
- updateVersion: 13
- updateDescription: 15
- codeText: 13

行高建议：

- 标题：1.12 - 1.22
- 正文：1.38 - 1.52
- 中文正文：1.45 - 1.58
- 按钮：1.15 - 1.25
- Label：1.15 - 1.30
- Toast / SnackBar：1.30 - 1.42
- Dialog 正文：1.42 - 1.55

字重建议：

- display / hero: FontWeight.w700 或 w800
- headline: FontWeight.w700
- title: FontWeight.w600
- body: FontWeight.w400
- body emphasis: FontWeight.w500
- label: FontWeight.w500 或 w600
- button: FontWeight.w600
- glass surface 小字：必要时使用 w500 增强可读性

letterSpacing 建议：

- 中文：多数情况 0 或轻微负值，不要过大
- 英文大标题：-0.4 到 -0.8
- 英文标题：-0.2 到 -0.4
- 正文：0 到 0.1
- label：0.1 到 0.3
- button：0.1 到 0.2

==================================================
七、跨平台缩放倾向
==================================================

请参考以下缩放倾向，但可以优化：

compact：

- iPhone 17 Pro: 1.00
- 小屏手机 width < 360: 0.94 - 0.97
- 普通 Android 手机: 0.98 - 1.02
- 大屏手机 width > 430: 1.02 - 1.06

medium：

- 平板竖屏: 1.04 - 1.08
- 平板横屏: 1.05 - 1.10
- 折叠屏: 1.02 - 1.08

expanded：

- Web 小窗口: 1.00 - 1.04
- Desktop 普通窗口: 1.02 - 1.08
- 大桌面屏: 标题可到 1.10，正文不建议超过 1.06
- macOS 可略接近 iOS，Windows/Linux 保守

用户 text scale：

- 默认尊重系统 text scale
- 普通内容最大可到 1.3 - 1.5
- 关键控件可限制到 1.2 - 1.3
- 页面整体应允许滚动，避免截断
- 不要强制禁用无障碍字体缩放

==================================================
八、输出格式
==================================================

请按以下顺序输出：

1. Typography 设计原则。
2. 字体族策略。
3. 字体层级表。
4. 多平台缩放规则。
5. Liquid Glass 场景排版规则。
6. 中文 / 英文 / 多语言排版规则。
7. Material 3 TextTheme 方案。
8. AppTypographyTokens 方案。
9. Flutter 文件代码。
10. 使用示例。
11. 可访问性说明。
12. 最终检查清单。

请给出完整、专业、可直接落地的方案。

请注意：这是 Flutter 多平台项目，不要只按 iOS 单平台思维设计。iOS 26 和 iPhone 17 Pro 是视觉基准，但 Android、Web、Windows、macOS、Linux 都需要按平台阅读距离、字体渲染差异、窗口大小和输入方式做比例缩放与适配。
