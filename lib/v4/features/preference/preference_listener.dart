import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repos/local/preference_repo.dart';
import '../../service/preference/preference_service.dart';
import 'bloc/preference_bloc.dart';

class PreferenceListener extends StatelessWidget {
  const PreferenceListener({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PreferenceBloc(
        spService: PreferenceService(
          spRepo: context.read<PreferenceRepo>(),
        ),
      )..add(const PreferenceEventLoad()),
      child: child,
    );
  }
}
