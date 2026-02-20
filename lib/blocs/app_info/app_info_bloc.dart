import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'app_info_bloc.freezed.dart';
part 'app_info_event.dart';
part 'app_info_state.dart';

class AppInfoBloc extends Bloc<AppInfoEvent, AppInfoState> {
  AppInfoBloc() : super(const AppInfoState()) {
    on<AppInfoEvent>(
      (event, emit) => switch (event) {
        _Started() => _onStarted(event, emit),
      },
    );
  }

  Future<void> _onStarted(_Started event, Emitter<AppInfoState> emit) async {
    final packageInfo = await PackageInfo.fromPlatform();

    emit(
      state.copyWith(
        version: packageInfo.version,
        buildNumber: packageInfo.buildNumber,
      ),
    );
  }
}
