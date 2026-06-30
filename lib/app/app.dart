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

class StarterApp extends ConsumerWidget {
  const StarterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeControllerProvider);
    final locale = ref.watch(localeControllerProvider);
    final messengerKey = ref.watch(appMessengerKeyProvider);

    // 使用 onGenerateTitle 从当前 Locale 取应用标题，避免 MaterialApp 中硬编码用户可见文案。
    // 同时挂载全局 ScaffoldMessengerKey，让 Controller/Service 之外的统一消息服务可安全展示 SnackBar。
    return AppLifecycleObserver(
      child: MaterialApp.router(
        onGenerateTitle: (context) => context.l10n.appTitle,
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: messengerKey,
        routerConfig: router,
        // Theme 在根节点根据 View/MediaQuery 计算自适应字号；系统 text scale 会被保留。
        theme: AppTheme.light(context),
        darkTheme: AppTheme.dark(context),
        themeMode: themeMode,
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
