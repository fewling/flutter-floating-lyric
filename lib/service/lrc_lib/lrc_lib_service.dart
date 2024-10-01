import '../../services/lrclib/data/lrclib_response.dart';
import '../../services/lrclib/repo/lrclib_repository.dart';

class LrcLibService {
  LrcLibService({
    required LrcLibRepository lrcLibRepository,
  }) : _lrcLibRepository = lrcLibRepository;

  final LrcLibRepository _lrcLibRepository;

  Future<LrcLibResponse> fetch({
    required String trackName,
    required String artistName,
    required String albumName,
    required int duration,
  }) async {
    return _lrcLibRepository.getLyric(
      trackName: trackName,
      artistName: artistName,
      albumName: albumName,
      duration: duration,
    );
  }
}
