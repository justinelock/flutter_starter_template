import 'package:flutter/material.dart';

import '../../app/design/app_breakpoints.dart';
import '../../app/design/app_spacing.dart';

/// 全局页面容器组件 (PageContainer)
/// 
/// 该组件用于统一控制应用内所有页面的内边距和最大宽度。
/// 它是响应式布局的核心组件，确保内容在不同屏幕尺寸下都能保持良好的可读性和美感。
class PageContainer extends StatelessWidget {
  /// 构造函数
  /// [child] 需要包装的内容。
  /// [maxWidth] 容器的最大宽度，默认为设计系统中定义的桌面端内容宽度。
  const PageContainer({
    required this.child,
    this.maxWidth = AppBreakpoints.desktopContentMaxWidth,
    super.key,
  });

  /// 内部子组件
  final Widget child;
  
  /// 最大宽度限制
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      // 使用 Center 确保在大屏（如 Web/Desktop）上内容居中显示。
      child: ConstrainedBox(
        // 限制内容的最大宽度，防止在宽屏下行宽过长导致阅读疲劳。
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          // 统一应用全局页面边距，确保视觉一致性。
          padding: const EdgeInsets.all(AppSpacing.page),
          child: child,
        ),
      ),
    );
  }
}
