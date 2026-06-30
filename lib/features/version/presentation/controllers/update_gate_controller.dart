import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/version_info.dart';

final updateGateControllerProvider =
    NotifierProvider<UpdateGateController, UpdateGateState>(
      UpdateGateController.new,
      name: 'updateGateControllerProvider',
    );

class UpdateGateState {
  const UpdateGateState._({this.info});

  const UpdateGateState.idle() : this._();
  const UpdateGateState.pending(VersionInfo info) : this._(info: info);

  final VersionInfo? info;

  bool get hasPendingUpdate => info != null;
}

class UpdateGateController extends Notifier<UpdateGateState> {
  Completer<void>? _decisionCompleter;

  @override
  UpdateGateState build() => const UpdateGateState.idle();

  Future<void> waitForDecision(VersionInfo info) {
    if (!info.hasUpdate) return Future<void>.value();

    // 步骤 1：发现更新时进入 pending 状态，Splash 页面据此弹出阻塞式更新对话框。
    final completer = Completer<void>();
    _decisionCompleter = completer;
    state = UpdateGateState.pending(info);

    // 步骤 2：SplashController 会 await 这个 Future；只有用户选择允许继续时才完成。
    return completer.future;
  }

  void continueToApp() {
    // 步骤 1：普通更新选择“稍后”或点击“更新”后，释放 Splash 路由守卫。
    _decisionCompleter?.complete();
    _decisionCompleter = null;

    // 步骤 2：恢复 idle，避免路由切换后重复弹出同一个更新弹窗。
    state = const UpdateGateState.idle();
  }
}
