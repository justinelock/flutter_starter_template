import 'package:flutter/material.dart';
import 'package:flutter_starter_template/l10n/generated/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/design/app_radius.dart';
import '../../../../app/design/app_spacing.dart';
import '../../../../app/localization/l10n_extensions.dart';
import '../../../../app/theme/theme_extensions.dart';
import '../../../../core/constants/app_svg_assets.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/version_info.dart';

enum UpdateDialogAction { skip, update }

/// 版本更新弹窗：布局参考设计稿，玻璃卡片与主按钮仍走 liquid_glass_widgets 封装。
class UpdateDialog extends StatelessWidget {
  const UpdateDialog({required this.info, super.key});

  final VersionInfo info;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PopScope(
      canPop: !info.forceUpdate,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 360,
            // 小屏上限制弹窗高度并允许滚动，避免更新内容过多时纵向溢出。
            maxHeight: MediaQuery.sizeOf(context).height * 0.78,
          ),
          child: AppGlassCard(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                const _UpdateDialogIcon(),
                const SizedBox(height: AppSpacing.md),
                Text(
                  info.forceUpdate
                      ? l10n.requiredUpdateTitle
                      : l10n.updateAvailableTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.updateDialogSubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.45,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _VersionComparePanel(info: info, l10n: l10n),
                if (_releaseNotes(info.description).isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  _UpdateContentSection(
                    title: l10n.updateContentTitle,
                    items: _releaseNotes(info.description),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                _UpdateDialogActions(info: info, l10n: l10n),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static List<String> _releaseNotes(String description) {
    return description
        .split(RegExp(r'[\r\n]+'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  static String _formatVersion(String version) {
    final trimmed = version.trim();
    if (trimmed.isEmpty) return trimmed;
    return trimmed.startsWith('v') ? trimmed : 'v$trimmed';
  }
}

class _UpdateDialogIcon extends StatelessWidget {
  const _UpdateDialogIcon();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(AppRadius.control),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: AppSvgIcon(
          assetPath: AppSvgAssets.download,
          size: 28,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }
}

class _VersionComparePanel extends StatelessWidget {
  const _VersionComparePanel({required this.info, required this.l10n});

  final VersionInfo info;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(AppRadius.control),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _VersionCell(
                label: l10n.latestVersionShortLabel,
                version: UpdateDialog._formatVersion(info.latestVersion),
                versionColor: colorScheme.primary,
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: colorScheme.outlineVariant.withValues(alpha: 0.45),
            ),
            Expanded(
              child: _VersionCell(
                label: l10n.currentVersionShortLabel,
                version: UpdateDialog._formatVersion(info.currentVersion),
                versionColor: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VersionCell extends StatelessWidget {
  const _VersionCell({
    required this.label,
    required this.version,
    required this.versionColor,
  });

  final String label;
  final String version;
  final Color versionColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.sm,
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            version,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: versionColor,
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}

class _UpdateContentSection extends StatelessWidget {
  const _UpdateContentSection({
    required this.title,
    required this.items,
  });

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6, right: AppSpacing.xs),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                        height: 1.45,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpdateDialogActions extends StatelessWidget {
  const _UpdateDialogActions({required this.info, required this.l10n});

  final VersionInfo info;
  final AppLocalizations l10n;

  Future<void> _onUpdate(BuildContext context) async {
    if (info.platform == 'web') {
      if (!info.forceUpdate) {
        Navigator.of(context).pop(UpdateDialogAction.update);
      }
      return;
    }

    final uri = Uri.tryParse(info.downloadUrl);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    if (!info.forceUpdate && context.mounted) {
      Navigator.of(context).pop(UpdateDialogAction.update);
    }
  }

  @override
  Widget build(BuildContext context) {
    final updateLabel = info.platform == 'web'
        ? l10n.refreshAction
        : l10n.updateNowAction;

    // 参考布局：左侧「稍后再说」为纯文字，右侧「立即更新」保留 prominent 玻璃按钮。
    if (info.forceUpdate) {
      return AppGlassButton(
        label: updateLabel,
        expand: true,
        prominent: true,
        height: 44,
        onPressed: () => _onUpdate(context),
      );
    }

    final colors = context.colors;
    final labelColor = colors.textSecondary;

    return Row(
      children: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: labelColor,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () =>
              Navigator.of(context).pop(UpdateDialogAction.skip),
          child: Text(
            l10n.laterAction,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: AppGlassButton(
            label: updateLabel,
            expand: true,
            prominent: true,
            height: 44,
            onPressed: () => _onUpdate(context),
          ),
        ),
      ],
    );
  }
}
