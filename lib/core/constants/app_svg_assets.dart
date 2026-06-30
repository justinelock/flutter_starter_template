/// 集中管理 assets/svgs 下的 SVG 资源路径，避免页面散落硬编码路径。
class AppSvgAssets {
  const AppSvgAssets._();

  // 底部导航
  static const home = 'assets/svgs/home.svg';
  static const homeActive = 'assets/svgs/home-active.svg';
  static const settings = 'assets/svgs/i-settings.svg';

  // 通用操作
  static const arrowBack = 'assets/svgs/i-arrow-back.svg';
  static const arrowRight = 'assets/svgs/i-arrow-right.svg';
  static const refresh = 'assets/svgs/i-refresh.svg';
  static const trash = 'assets/svgs/i-trash-bin-trash.svg';
  static const exit = 'assets/svgs/i-exit.svg';
  static const download = 'assets/svgs/i-download.svg';

  // 首页信息卡片
  static const user = 'assets/svgs/user.svg';
  static const userActive = 'assets/svgs/user-active.svg';
  static const plugin = 'assets/svgs/i-plugin-2.svg';
  static const phone = 'assets/svgs/i-phone-calling.svg';
  static const stars = 'assets/svgs/i-stars-minimalistic.svg';

  // 设置相关
  static const theme = 'assets/svgs/i-theme.svg';
  static const language = 'assets/svgs/i-language.svg';
  static const info = 'assets/svgs/i-info.svg';

  // 状态提示
  static const danger = 'assets/svgs/i-danger-triangle.svg';
  static const notes = 'assets/svgs/i-notes.svg';

  // 品牌 Logo
  static const logo = 'assets/svgs/chart-active.svg';
}
