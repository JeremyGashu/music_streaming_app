/// Accepts duration
/// 
/// Returns string of human readable time format
String prettyDuration(Duration duration) {
  String seconds;
  final minutes = duration.inMinutes.remainder(60);
  final sec = duration.inSeconds.remainder(60);
  if (sec < 10)
    seconds = '0$sec';
  else
    seconds = '$sec';
  return '$minutes:$seconds';
}
