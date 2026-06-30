import 'package:flutter/material.dart';

import '../../../../app/theme/typography_extensions.dart';
import '../../../../core/constants/app_svg_assets.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/glass_card.dart';

/// 首页信息卡片：标题/数值分别使用 [cardTitle] 与 [cardSubtitle] token。
class HomeInfoCard extends StatelessWidget {
  const HomeInfoCard({
    required this.title,
    required this.value,
    this.iconAsset,
    super.key,
  });

  final String title;
  final String value;
  /// SVG 资源路径，未传时回退到通用信息图标。
  final String? iconAsset;

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colorScheme = Theme.of(context).colorScheme;

    return AppGlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSvgIcon(
            assetPath: iconAsset ?? AppSvgAssets.info,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: typography.cardTitle,
                ),
                Text(
                  value,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: typography.cardSubtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
