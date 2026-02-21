import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../blocs/font_selection/font_selection_bloc.dart';
import '../../../../blocs/preference/preference_bloc.dart';
import '../../../../utils/extensions/custom_extensions.dart';
import '../../main_app.dart';

part '_dependency.dart';
part '_listener.dart';
part '_view.dart';

class FontsPage extends StatelessWidget {
  const FontsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _Dependency(
      builder: (context) => _Listener(builder: (context) => const _View()),
    );
  }
}
