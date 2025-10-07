import 'package:hive_ce/hive.dart';

import '../models/lyric_model.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([AdapterSpec<LrcModel>()])
class HiveAdapters {}
