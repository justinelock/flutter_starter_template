import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_snackbar.dart';

/// 全局消息 Key Provider
/// 
/// 逻辑说明：
/// 使用 GlobalKey 管理 ScaffoldMessengerState。这允许我们在不持有 BuildContext 的情况下
/// （例如在异步逻辑、Repository 或 Controller 中）安全地向用户发送全局通知。
final appMessengerKeyProvider = Provider<GlobalKey<ScaffoldMessengerState>>(
  (ref) => GlobalKey<ScaffoldMessengerState>(),
  name: 'appMessengerKeyProvider',
);

/// 应用消息服务 Provider
/// 
/// 将 AppMessenger 注入到 Riverpod 中，方便全应用共享统一的消息弹出逻辑。
final appMessengerProvider = Provider<AppMessenger>(
  (ref) => AppMessenger(ref.watch(appMessengerKeyProvider)),
  name: 'appMessengerProvider',
);

/// 全局消息服务 (AppMessenger)
/// 
/// 负责在应用顶层显示 SnackBar 提示。
/// 封装了对 ScaffoldMessenger 的操作，屏蔽了 UI 细节，使得业务层只需关注消息内容和类型。
class AppMessenger {
  /// 构造函数，注入全局 Navigator/Messenger Key。
  const AppMessenger(this._key);

  final GlobalKey<ScaffoldMessengerState> _key;

  /// 显示提示消息
  /// 
  /// [message] 需要展示给用户的文本内容。
  /// [type] 消息类型（info, success, warning, error），决定了样式的底色和图标。
  /// 
  /// 逻辑说明：
  /// 1. 检查当前 context 是否可用，防止在极端情况下（如应用已关闭）调用。
  /// 2. 自动隐藏当前正在显示的 SnackBar，确保新消息能立即弹出而不需要排队等待。
  /// 3. 使用 AppSnackBar 统一构建符合设计系统的视觉组件。
  void show(String message, {AppSnackBarType type = AppSnackBarType.info}) {
    final context = _key.currentContext;
    if (context == null) return;
    
    _key.currentState
      ?..hideCurrentSnackBar() // 立即清除当前提示，保证反馈的即时性
      ..showSnackBar(AppSnackBar.build(context, message, type));
  }
}
