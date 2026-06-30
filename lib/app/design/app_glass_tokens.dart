import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import '../../app/design/app_radius.dart';

/// 项目级液态玻璃视觉参数，统一从 pub 依赖 `liquid_glass_widgets` 读取默认值。
class AppGlassTokens {
  const AppGlassTokens._();

  static const double opacityLight = 0.64;
  static const double opacityDark = 0.38;
  static const double borderOpacity = 0.22;
  static const double blurSigma = 20;

  /// 表面组件默认圆角，与 iOS 26 [GlassDefaults.borderRadius] 一致。
  static const double surfaceBorderRadius = AppRadius.control;

  /// 页面级玻璃层参数，供 [GlassScaffold] / [GlassTabBar] 等共享。
  static const LiquidGlassSettings pageSettings = LiquidGlassSettings(
    thickness: GlassDefaults.thickness,
    blur: GlassDefaults.blur,
    refractiveIndex: GlassDefaults.refractiveIndex,
    lightIntensity: GlassDefaults.lightIntensity,
    chromaticAberration: GlassDefaults.chromaticAberration,
  );

  /// 卡片、输入框等表面组件使用的略轻参数。
  static const LiquidGlassSettings surfaceSettings = LiquidGlassSettings(
    thickness: 24,
    blur: 4,
    refractiveIndex: 1.15,
  );
}
