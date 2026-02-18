import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/lyric_model.dart';
import '../../../repos/local/preference_repo.dart';
import '../../../service/platform_methods/permission_channel_service.dart';
import '../../blocs/permission/permission_bloc.dart';
import '../../blocs/preference/preference_bloc.dart';
import '../../enums/app_locale.dart';
import '../../routes/app_router.dart';

part '_dependency.dart';
part '_listener.dart';
part '_view.dart';

class MainApp extends StatelessWidget {
  const MainApp({required this.pref, required this.lrcBox, super.key});

  final SharedPreferences pref;
  final Box<LrcModel> lrcBox;

  @override
  Widget build(BuildContext context) {
    return MainAppDependency(
      pref: pref,
      lrcBox: lrcBox,
      builder: (context, appRouter) => MainAppListener(
        builder: (context) => MainAppView(appRouter: appRouter),
      ),
    );
  }
}
