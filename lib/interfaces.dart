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
