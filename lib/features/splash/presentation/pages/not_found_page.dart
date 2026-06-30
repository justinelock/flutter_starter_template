import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/l10n_extensions.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/widgets/glass_scaffold.dart';
import '../../../../shared/widgets/page_container.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // 404 页面只提供返回首页的安全路径，避免用户停留在无效路由。
    return AppGlassScaffold(
      body: PageContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.pageNotFound,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            AppGlassButton(
              label: l10n.backHomeAction,
              onPressed: () => context.go(AppRoutes.home),
            ),
          ],
        ),
      ),
    );
  }
}
