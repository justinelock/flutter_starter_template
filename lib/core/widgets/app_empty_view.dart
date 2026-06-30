import 'package:flutter/material.dart';

import '../../app/theme/typography_extensions.dart';
import '../constants/app_svg_assets.dart';
import 'app_svg_icon.dart';
class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    required this.title,
    this.description,
    this.action,
    super.key,
  });

  final String title;
  final String? description;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSvgIcon(
            assetPath: AppSvgAssets.notes,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(title, style: typography.cardTitle),
          if (description != null)
            Text(
              description!,
              textAlign: TextAlign.center,
              style: typography.cardSubtitle,
            ),
          if (action != null) ...[const SizedBox(height: 16), action!],
        ],
      ),
    );
  }
}
