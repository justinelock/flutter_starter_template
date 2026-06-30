import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../../app/localization/l10n_extensions.dart';
import '../../../../app/localization/locale_controller.dart';
import '../../../../core/widgets/app_glass_segmented_control.dart';

class LocaleSelector extends ConsumerWidget {
  const LocaleSelector({super.key});

  int _indexForCode(String code) => switch (code) {
    'system' => 0,
    'zh' => 1,
    _ => 2,
  };

  String _codeForIndex(int index) => switch (index) {
    0 => 'system',
    1 => 'zh',
    _ => 'en',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);
    final value = locale?.languageCode ?? 'system';
    final l10n = context.l10n;

    return AppGlassSegmentedControl(
      selectedIndex: _indexForCode(value),
      onSegmentSelected: (index) {
        final selected = _codeForIndex(index);
        // system 代表不固定 Locale，让 Flutter 跟随系统语言；其他选项写入持久化设置。
        ref
            .read(localeControllerProvider.notifier)
            .setLocale(selected == 'system' ? null : Locale(selected));
      },
      segments: [
        GlassSegment(label: l10n.systemOption),
        GlassSegment(label: l10n.chineseOption),
        GlassSegment(label: l10n.englishOption),
      ],
    );
  }
}
