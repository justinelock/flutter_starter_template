import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart' as lg;

import '../../app/design/app_radius.dart';

/// 项目统一分段控件：指示器滑动无彩色光晕，圆角对齐 [AppRadius.control]。
class AppGlassSegmentedControl extends StatelessWidget {
  const AppGlassSegmentedControl({
    required this.segments,
    required this.selectedIndex,
    required this.onSegmentSelected,
    super.key,
  });

  final List<lg.GlassSegment> segments;
  final int selectedIndex;
  final ValueChanged<int> onSegmentSelected;

  @override
  Widget build(BuildContext context) {
    return lg.GlassSegmentedControl(
      segments: segments,
      selectedIndex: selectedIndex,
      onSegmentSelected: onSegmentSelected,
      borderRadius: AppRadius.control,
      interactionBehavior: lg.GlassInteractionBehavior.scaleOnly,
      glowColor: Colors.transparent,
      glowRadius: 0,
    );
  }
}
