你是一名同时精通 iOS 26 Liquid Glass、Apple Human Interface Guidelines、Flutter Material 3、Riverpod 3、glassmorphism 和设计系统工程化的专家。

请为我生成一套以 iPhone 17 Pro 为基准的移动端 Flutter App 主题模板和颜色系统。

目标：
- 设备基准：iPhone 17 Pro，6.3-inch OLED，2622 × 1206，460 ppi
- 视觉风格：iOS 26 Liquid Glass + glassmorphism + Material 3
- 技术栈：Flutter、Material 3、Riverpod 3
- 支持：Light Theme、Dark Theme、System Theme
- 输出必须适合真实生产项目，而不是 Demo

请包含：

一、设计系统
- 完整 Light / Dark 颜色 token
- Material 3 ColorScheme 映射
- Liquid Glass 专用 token
- Glassmorphism 参数
- Blur、opacity、radius、shadow、stroke、gradient token
- 文本颜色、图标颜色、边框颜色、分割线颜色
- 状态颜色：success、warning、error、info
- 可访问性说明，保证亮色和暗色可读性

二、颜色基准
Light:
background #F7F8FB
surface #FFFFFF
surfaceElevated #FFFFFF
primary #0A84FF
primaryContainer #D8E9FF
secondary #7C5CFF
secondaryContainer #E9E3FF
tertiary #00B8D9
tertiaryContainer #D6F7FF
accent #FF9F0A
error #FF453A
success #30D158
warning #FFD60A
textPrimary #111827
textSecondary #4B5563
textTertiary #8E8E93
outline #D1D5DB

Dark:
background #070A0F
surface #0D1117
surfaceElevated #151A23
primary #2997FF
primaryContainer #003A66
secondary #9B8CFF
secondaryContainer #31236B
tertiary #64D2FF
tertiaryContainer #003D4F
accent #FFB340
error #FF6961
success #32D74B
warning #FFD60A
textPrimary #F5F7FA
textSecondary #C9CED6
textTertiary #8E96A3
outline #303744

Glass Tokens:
glassBackgroundLight rgba(255,255,255,0.58)
glassBackgroundDark rgba(20,24,32,0.54)
glassStrokeLight rgba(255,255,255,0.72)
glassStrokeDark rgba(255,255,255,0.14)
glassTintPrimary rgba(10,132,255,0.16)
glassTintSecondary rgba(124,92,255,0.16)
glassOuterShadowLight rgba(15,23,42,0.12)
glassOuterShadowDark rgba(0,0,0,0.38)
blurSmall 12
blurMedium 24
blurLarge 40

三、Flutter 工程输出
请生成以下内容：
1. app_colors.dart
2. glass_tokens.dart
3. theme_extensions.dart
4. app_theme.dart
5. theme_mode_controller.dart
6. theme_providers.dart
7. main.dart 接入示例
8. LiquidGlassCard 组件
9. LiquidGlassButton 组件
10. LiquidGlassBottomBar 组件

四、Riverpod 3 集成要求
- 使用 ProviderScope
- 使用 Notifier / Provider 组织主题状态
- 支持 ThemeMode.system / light / dark
- 不在 Widget 中硬编码主题逻辑
- 预留持久化接口
- 代码适合大型项目扩展

五、输出格式
- 先给设计说明
- 再给颜色 token 表
- 再给 Dart 代码
- 再给 Riverpod 集成方式
- 最后给组件使用示例

请确保代码完整、命名清晰、可复制运行，并且整体视觉接近 iOS 26 Liquid Glass，而不是普通半透明卡片。