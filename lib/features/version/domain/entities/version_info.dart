class VersionInfo {
  const VersionInfo({
    required this.currentVersion,
    required this.latestVersion,
    required this.buildNumber,
    required this.forceUpdate,
    required this.title,
    required this.description,
    required this.downloadUrl,
    required this.platform,
  });

  final String currentVersion;
  final String latestVersion;
  final String buildNumber;
  final bool forceUpdate;
  final String title;
  final String description;
  final String downloadUrl;
  final String platform;

  bool get hasUpdate => currentVersion != latestVersion;
}
