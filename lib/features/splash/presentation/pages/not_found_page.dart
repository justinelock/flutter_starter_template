import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/localization/l10n_extensions.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/typography_extensions.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/widgets/glass_scaffold.dart';
import '../../../../shared/widgets/page_container.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final typography = context.typography;

    return AppGlassScaffold(
      body: PageContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.pageNotFound, style: typography.pageTitle),
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
