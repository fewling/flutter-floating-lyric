import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_info.g.dart';

@riverpod
FutureOr<PackageInfo> packageInfo(PackageInfoRef ref) async {
  final packageInfo = await PackageInfo.fromPlatform();
  return packageInfo;
}

@riverpod
FutureOr<String> version(VersionRef ref) {
  return ref.watch(packageInfoProvider).when(
        data: (packageInfo) => packageInfo.version,
        error: (e, s) => e.toString(),
        loading: () => 'Loading...',
      );
}

@riverpod
FutureOr<String> buildNumber(BuildNumberRef ref) {
  return ref.watch(packageInfoProvider).when(
        data: (packageInfo) => packageInfo.buildNumber,
        error: (e, s) => e.toString(),
        loading: () => 'Loading...',
      );
}
