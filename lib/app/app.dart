import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_template/l10n/generated/app_localizations.dart';

import '../core/messaging/app_messenger.dart';
import 'lifecycle/app_lifecycle_observer.dart';
import 'localization/l10n_extensions.dart';
import 'localization/locale_controller.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

/// 应用根组件 (StarterApp)
/// 
/// 该组件是 Flutter 控件树的顶层，负责聚合所有的全局状态（路由、主题、国际化）。
/// 继承自 [ConsumerWidget] 以响应 Riverpod 状态的变化。
class StarterApp extends ConsumerWidget {
  const StarterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听路由配置：当登录状态变化引起路由重定向时，MaterialApp 会自动响应。
    final router = ref.watch(routerProvider);
    // 监听主题模式：支持亮色、暗色及跟随系统切换。
    final themeMode = ref.watch(themeControllerProvider);
    // 监听语言配置：支持动态切换应用语言。
    final locale = ref.watch(localeControllerProvider);
    // 获取全局消息 Key：用于在不依赖 BuildContext 的情况下弹出提示（如网络错误通知）。
    final messengerKey = ref.watch(appMessengerKeyProvider);

    // 【设计模式说明】：
    // 1. 使用 AppLifecycleObserver 包装，用于监听应用切后台、回前台等生命周期事件。
    // 2. 使用 MaterialApp.router 接入 go_router 体系，实现声明式路由管理。
    return AppLifecycleObserver(
      child: MaterialApp.router(
        // 【国际化优化】：使用 onGenerateTitle 确保标题能随语言动态变化，而不是在启动时硬编码。
        onGenerateTitle: (context) => context.l10n.appTitle,
        debugShowCheckedModeBanner: false,
        
        // 全局消息通道：将 ScaffoldMessengerKey 注入，使得 Repository/Service 层可以安全地触发 UI 消息。
        scaffoldMessengerKey: messengerKey,
        
        // 路由配置：由 app_router.dart 提供核心逻辑。
        routerConfig: router,
        
        // 主题配置：
        // AppTheme 内部会根据当前的 MediaQuery 处理屏幕适配和字号基准。
        theme: AppTheme.light(context),
        darkTheme: AppTheme.dark(context),
        themeMode: themeMode,
        
        // 国际化配置：
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
