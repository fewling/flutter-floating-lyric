part of 'custom_extensions.dart';

extension DurationX on Duration {
  String mmss() {
    final minutes = inMinutes;
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
