import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../../../app/localization/l10n_extensions.dart';
import '../../../../app/theme/theme_controller.dart';
import '../../../../core/widgets/app_glass_segmented_control.dart';

class ThemeSelector extends ConsumerWidget {
  const ThemeSelector({super.key});

  int _indexForMode(ThemeMode mode) => switch (mode) {
    ThemeMode.system => 0,
    ThemeMode.light => 1,
    ThemeMode.dark => 2,
  };

  ThemeMode _modeForIndex(int index) => switch (index) {
    0 => ThemeMode.system,
    1 => ThemeMode.light,
    _ => ThemeMode.dark,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeControllerProvider);
    final l10n = context.l10n;

    return AppGlassSegmentedControl(
      selectedIndex: _indexForMode(mode),
      onSegmentSelected: (index) => ref
          .read(themeControllerProvider.notifier)
          .setThemeMode(_modeForIndex(index)),
      segments: [
        GlassSegment(label: l10n.systemOption),
        GlassSegment(label: l10n.lightOption),
        GlassSegment(label: l10n.darkOption),
      ],
    );
  }
}
