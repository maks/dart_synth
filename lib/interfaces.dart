abstract class Oscillator {
  double next();
}

abstract class Envelope {
  Envelope(
    double attackStep,
    double decayStep,
    double sustainLevel,
    double releaseStep,
  );

  double next();

  void attack();

  void release();

  void isDone();
}

abstract class StereoSignal {
  double left = 0;
  double right = 0;

  final int ref = 0;

  void clear();

  /// Add left and right values directly to the signal
  void add(double left, right);

  /// Add stereo signal with simple (not proper) panning
  void addStereoSignal(StereoSignal signal, double level, double pan);

  void addMonoSignal(double signal, double level, double pan);
}

abstract class Freeverb {
  double? wet;
  double? roomSize;
  double? width;
  double? dampening;
  bool? frozen;

  Freeverb({
    double? wet,
    double? dry,
    double? width,
    double? inputGain,
    double? dampening,
    double? roomSize,
    bool? frozen,
  });

  void tick(StereoSignal signal);
}
