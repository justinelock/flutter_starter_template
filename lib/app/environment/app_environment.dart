enum AppEnvironment {
  debug,
  prod;

  static AppEnvironment fromDartDefine() {
    const value = String.fromEnvironment('APP_ENV', defaultValue: 'debug');
    return value == 'prod' ? AppEnvironment.prod : AppEnvironment.debug;
  }

  bool get isProd => this == AppEnvironment.prod;
}
