import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_storage_keys.dart';
import '../../core/storage/storage_service.dart';

/// 全局主题控制器 Provider
/// 
/// 逻辑说明：
/// 使用 Riverpod 的 Notifier 管理应用的 [ThemeMode] 状态。
/// 该 Provider 被 [StarterApp] 监听，从而实现全应用范围的主题动态切换。
final themeControllerProvider = NotifierProvider<ThemeController, ThemeMode>(
  ThemeController.new,
  name: 'themeControllerProvider',
);

/// 主题控制器 (ThemeController)
/// 
/// 负责管理亮色、暗色模式的切换，并将用户的选择持久化到本地存储中。
class ThemeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    // 【启动策略】：初始化时默认使用系统设置，同时异步从本地存储中恢复用户的历史选择。
    unawaited(_restore());
    return ThemeMode.system;
  }

  /// 切换主题模式
  /// 
  /// [mode] 目标主题模式（light, dark, system）。
  /// 逻辑说明：更新内存状态以立即触发 UI 刷新，并同步保存到磁盘以备下次启动使用。
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await ref
        .read(storageServiceProvider)
        .setString(AppStorageKeys.themeMode, mode.name);
  }

  /// 恢复持久化的主题配置
  /// 
  /// 逻辑说明：
  /// 从 [StorageService] 中读取已保存的主题枚举名称。
  /// 如果读取失败或数据不存在，则保持初始的 [ThemeMode.system]。
  Future<void> _restore() async {
    String? value;
    try {
      value = await ref
          .read(storageServiceProvider)
          .getString(AppStorageKeys.themeMode);
    } catch (_) {
      // 容错处理：若读取过程发生异常，忽略并保持默认状态。
      return;
    }
    
    if (value == null) return;
    
    // 将保存的字符串名称还原为枚举类型。
    state = ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }
}
