import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utils/extensions/custom_extensions.dart';
import '../../../../../widgets/color_picker_sheet.dart';
import '../../../../blocs/app_info/app_info_bloc.dart';
import '../../../../blocs/preference/preference_bloc.dart';
import '../../../../blocs/settings/settings_bloc.dart';
import '../../../../enums/app_locale.dart';
import '../../../../widgets/language_selector.dart';
import '../../main_app.dart';

part '_dependency.dart';
part '_listener.dart';
part '_view.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _Dependency(
      builder: (context) => _Listener(builder: (context) => const _View()),
    );
  }
}
