part of 'app_router.dart';

@freezed
sealed class MainRoutePathParams with _$MainRoutePathParams {
  const factory MainRoutePathParams.localLyricDetail({required String id}) =
      LocalLyricDetailPathParams;

  factory MainRoutePathParams.fromJson(Map<String, dynamic> json) =>
      _$MainRoutePathParamsFromJson(json);
}

extension MainRoutePathParamsX on MainRoutePathParams {
  Map<String, String> toPathJson() {
    final json = toJson()..remove('runtimeType');
    return json.map((key, value) => MapEntry(key, '$value'));
  }
}
