import 'package:flutter/material.dart';

import '../constants/app_svg_assets.dart';
import 'app_svg_icon.dart';

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
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          if (description != null)
            Text(description!, textAlign: TextAlign.center),
          if (action != null) ...[const SizedBox(height: 16), action!],
        ],
      ),
    );
  }
}
