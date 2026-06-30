// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Flutter 启动模板';

  @override
  String get login => '登录';

  @override
  String get register => '注册';

  @override
  String get settings => '设置';

  @override
  String get home => '首页';

  @override
  String get signInTitle => '登录';

  @override
  String get registerTitle => '创建账号';

  @override
  String get emailLabel => '邮箱';

  @override
  String get mobileLabel => '手机号';

  @override
  String get usernameLabel => '用户名';

  @override
  String get realNameLabel => '真实姓名';

  @override
  String get idCardLabel => '身份证号';

  @override
  String get inviteCodeLabel => '邀请码';

  @override
  String get passwordLabel => '密码';

  @override
  String get confirmPasswordLabel => '确认密码';

  @override
  String get createAccountAction => '创建账号';

  @override
  String get backToLoginAction => '返回登录';

  @override
  String get passwordMismatch => '两次输入的密码不一致';

  @override
  String get emailRequired => '请输入邮箱';

  @override
  String get emailInvalid => '请输入有效邮箱';

  @override
  String get mobileRequired => '请输入手机号';

  @override
  String get usernameRequired => '请输入用户名';

  @override
  String get realNameRequired => '请输入真实姓名';

  @override
  String get idCardRequired => '请输入身份证号';

  @override
  String get passwordRequired => '请输入密码';

  @override
  String get passwordMinLength => '密码至少需要 6 个字符';

  @override
  String get invalidCredentials => '账号或密码不正确';

  @override
  String get genericError => '操作失败，请稍后重试';

  @override
  String get loginSuccess => '登录成功';

  @override
  String get loginFailed => '登录失败';

  @override
  String get registerSuccess => '注册成功';

  @override
  String get registerFailed => '注册失败';

  @override
  String get logoutSuccess => '已退出登录';

  @override
  String get cacheCleared => '缓存已清除';

  @override
  String get noUpdates => '当前已是最新版本';

  @override
  String get updateCheckFailed => '检查更新失败';

  @override
  String get themeSection => '主题';

  @override
  String get languageSection => '语言';

  @override
  String get appSection => '应用';

  @override
  String get versionLabel => '版本';

  @override
  String get loading => '加载中';

  @override
  String get environmentLabel => '环境';

  @override
  String get checkUpdates => '检查更新';

  @override
  String get clearCache => '清除缓存';

  @override
  String get logout => '退出登录';

  @override
  String get debugFeatureFlags => '调试功能开关';

  @override
  String get systemOption => '跟随系统';

  @override
  String get lightOption => '浅色';

  @override
  String get darkOption => '深色';

  @override
  String get chineseOption => '中文';

  @override
  String get englishOption => '英文';

  @override
  String get userLabel => '用户';

  @override
  String get guestUser => '访客';

  @override
  String get platformLabel => '平台';

  @override
  String get featureFlags => '功能开关';

  @override
  String get requiredUpdateTitle => '需要更新';

  @override
  String get updateAvailableTitle => '发现新版本';

  @override
  String get updateDialogSubtitle => '为了获得更好的使用体验，请更新至最新版本';

  @override
  String get updateContentTitle => '更新内容';

  @override
  String get latestVersionShortLabel => '最新版本';

  @override
  String get currentVersionShortLabel => '当前版本';

  @override
  String currentVersionLabel(Object version) {
    return '当前版本：$version';
  }

  @override
  String latestVersionLabel(Object version) {
    return '最新版本：$version';
  }

  @override
  String get laterAction => '稍后再说';

  @override
  String get refreshAction => '刷新';

  @override
  String get updateNowAction => '立即更新';

  @override
  String get backHomeAction => '返回首页';

  @override
  String get retryAction => '重试';

  @override
  String get packageInfoLoadFailed => '无法加载应用版本';

  @override
  String get pageNotFound => '页面不存在';

  @override
  String get initializing => '初始化中...';
}
