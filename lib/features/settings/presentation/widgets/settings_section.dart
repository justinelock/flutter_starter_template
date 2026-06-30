import 'package:flutter/material.dart';

import '../../../../app/design/app_spacing.dart';
import '../../../../app/theme/typography_extensions.dart';
import '../../../../core/widgets/glass_card.dart';

/// 设置页分组：标题使用 [sectionTitle] token。
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    required this.title,
    required this.children,
    this.grouped = false,
    super.key,
  });

  final String title;
  final List<Widget> children;
  /// 为 true 时卡片内边距归零，供 [AppGlassListTile] 分组列表使用。
  final bool grouped;

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;

    return AppGlassCard(
      padding: grouped ? EdgeInsets.zero : const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: grouped
                ? const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  )
                : EdgeInsets.zero,
            child: Text(title, style: typography.sectionTitle),
          ),
          ...children,
        ],
      ),
    );
  }
}
