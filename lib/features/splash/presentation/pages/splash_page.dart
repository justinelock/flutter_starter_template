import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/localization/l10n_extensions.dart';
import '../../../../app/theme/theme_extensions.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../version/presentation/controllers/update_gate_controller.dart';
import '../../../version/presentation/widgets/update_dialog.dart';
import '../controllers/splash_controller.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrap = ref.watch(appBootstrapProvider);
    ref.listen(updateGateControllerProvider, (previous, next) {
      final info = next.info;
      if (info == null) return;

      // 启动更新弹窗必须由 Splash 页面发起，这样 SplashController 可以等待用户决策后再放行路由。
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!context.mounted) return;
        final action = await showDialog<UpdateDialogAction>(
          context: context,
          barrierDismissible: false,
          builder: (context) => UpdateDialog(info: info),
        );

        // 普通更新点“稍后”或“更新”后继续；强制更新不会返回 action，因此不会放行。
        if (action != null) {
          ref.read(updateGateControllerProvider.notifier).continueToApp();
        }
      });
    });

    return Scaffold(
      body: bootstrap.when(
        data: (_) => const _SplashContent(),
        loading: () => const _SplashContent(loading: true),
        error: (error, stackTrace) => AppErrorView(
          message: error.toString(),
          onRetry: () => ref.read(appBootstrapProvider.notifier).retry(),
        ),
      ),
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent({this.loading = false});

  static const _splashAsset = 'assets/images/splash.png';

  final bool loading;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final gradients = context.gradients;
    final colors = context.colors;

    // 步骤 1：启动图铺满整个屏幕，不使用 SafeArea 裁剪，保证状态栏和底部区域也有品牌背景。
    return Stack(
      fit: StackFit.expand,
      children: [
        // 步骤 1a：文档 splash 渐变作为底色，图片未加载时也有统一视觉。
        DecoratedBox(
          decoration: BoxDecoration(gradient: gradients.splash),
        ),
        Image.asset(
          _splashAsset,
          fit: BoxFit.cover,
          semanticLabel: l10n.appTitle,
        ),

        // 步骤 2：叠加轻量 scrim 渐变，让加载提示在不同亮度区域上都保持可读。
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colors.backgroundOverlay.withValues(alpha: 0),
                colors.scrimSoft,
                colors.scrimStrong,
              ],
            ),
          ),
        ),

        // 步骤 3：初始化中才显示加载提示；初始化完成后由路由守卫跳转。
        if (loading)
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
                child: AppLoadingView(message: l10n.initializing),
              ),
            ),
          ),
      ],
    );
  }
}
