import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../repos/local/local_db_repo.dart';
import '../../repos/local/preference_repo.dart';
import '../../service/preference/preference_service.dart';
import '../../services/lrclib/repo/lrclib_repository.dart';
import '../app_info/bloc/app_info_bloc.dart';
import '../preference/bloc/preference_bloc.dart';

class GlobalDependencyInjector extends StatelessWidget {
  const GlobalDependencyInjector({
    super.key,
    required this.child,
    required this.isar,
    required this.pref,
  });

  final Widget child;
  final Isar isar;
  final SharedPreferences pref;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => LocalDbRepo(isar),
        ),
        RepositoryProvider(
          create: (context) => LrcLibRepository(),
        ),
        RepositoryProvider(
          create: (context) => PreferenceRepo(sharedPreferences: pref),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => PreferenceBloc(
              spService: PreferenceService(
                spRepo: context.read<PreferenceRepo>(),
              ),
            )..add(const PreferenceEventLoad()),
          ),
          BlocProvider(
            create: (context) => AppInfoBloc()..add(const AppInfoLoaded()),
          ),
        ],
        child: child,
      ),
    );
  }
}
