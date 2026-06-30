import 'package:flutter/widgets.dart';

import 'app_breakpoints.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    required this.compact,
    Widget? medium,
    Widget? expanded,
    super.key,
  }) : medium = medium ?? compact,
       expanded = expanded ?? medium ?? compact;

  final Widget compact;
  final Widget medium;
  final Widget expanded;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return switch (AppBreakpoints.fromWidth(constraints.maxWidth)) {
          AppLayoutSize.compact => compact,
          AppLayoutSize.medium => medium,
          AppLayoutSize.expanded => expanded,
        };
      },
    );
  }
}
