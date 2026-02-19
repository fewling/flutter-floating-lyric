import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../models/lyric_model.dart';
import '../../../../../utils/extensions/custom_extensions.dart';
import '../../../../../widgets/fail_import_dialog.dart';
import '../../../../../widgets/loading_widget.dart';
import '../../../../blocs/lyric_list/lyric_list_bloc.dart';
import '../../../../routes/app_router.dart';
import '../../../../services/db/local/local_db_service.dart';
import '../../../../services/lrc/lrc_process_service.dart';
import '../../main_app.dart';

part '_dependency.dart';
part '_listener.dart';
part '_view.dart';

class LocalLyricsPage extends StatelessWidget {
  const LocalLyricsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _Dependency(
      builder: (context) => _Listener(builder: (context) => const _View()),
    );
  }
}
