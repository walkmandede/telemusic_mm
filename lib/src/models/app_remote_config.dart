class AppRemoteConfig {
  final int iosCloudVersion;
  final int androidCloudVersion;

  AppRemoteConfig(
      {required this.iosCloudVersion, required this.androidCloudVersion});

  factory AppRemoteConfig.fromMap({required Map<String, dynamic> data}) {
    return AppRemoteConfig(
      androidCloudVersion:
          int.tryParse(data["android-cloud-version"].toString()) ?? -1,
      iosCloudVersion: int.tryParse(data["ios-cloud-version"].toString()) ?? -1,
    );
  }
}
