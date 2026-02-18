import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../../../../../utils/extensions/custom_extensions.dart';
import '../../../../blocs/permission/permission_bloc.dart';
import '../../../../blocs/preference/preference_bloc.dart';
import '../../../../widgets/language_selector.dart';

part '_dependency.dart';
part '_listener.dart';
part '_view.dart';
part '_widgets/_notification_listener_permission_page_body.dart';
part '_widgets/_system_alert_window_permission_page_body.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _Dependency(
      builder: (context) => _Listener(builder: (context) => const _View()),
    );
  }
}
