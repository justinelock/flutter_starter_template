import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// 主界面底部 Tab 切换：走 [StatefulNavigationShell] 分支，无路由翻页动画。
void switchMainTab(BuildContext context, int index) {
  StatefulNavigationShell.of(context).goBranch(
    index,
    // 已在当前分支时避免重复入栈。
    initialLocation: index == StatefulNavigationShell.of(context).currentIndex,
  );
}
