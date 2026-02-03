class AppVersion {

  String latestVersion;
  String osPlatform;
  int status;

  AppVersion({
    required this.latestVersion,
    required this.osPlatform,
    required this.status,
  });

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    return AppVersion(
      latestVersion: json['latestVersion'],
      osPlatform: json['osPlatform'],
      status: json['status'] ?? 0,
    );
  }
}