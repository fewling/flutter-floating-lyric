import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utils/extensions/custom_extensions.dart';
import '../../../../blocs/lyric_detail/lyric_detail_bloc.dart';
import '../../../../routes/app_router.dart';
import '../../../../services/db/local/local_db_service.dart';

part '_dependency.dart';
part '_listener.dart';
part '_view.dart';

class LocalLyricDetailPage extends StatelessWidget {
  const LocalLyricDetailPage({required this.pathParams, super.key});

  final LocalLyricDetailPathParams pathParams;

  @override
  Widget build(BuildContext context) {
    return _Dependency(
      pathParams: pathParams,
      builder: (context) =>
          _Listener(builder: (context) => _View(pathParams: pathParams)),
    );
  }
}
