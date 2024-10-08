part of 'custom_extensions.dart';

extension DurationX on Duration {
  String mmss() {
    final minutes = inMinutes.toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String mmssmm() {
    final minutes = inMinutes.toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    final millis = inMilliseconds.remainder(1000).toString().padLeft(3, '0');
    return '$minutes:$seconds.$millis';
  }
}
