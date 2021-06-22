import 'dart:math';

import '../oscillators.dart';

/// Port of petersalomonsen AssemblyScript sine oscillator, for initial testing only
///
/// ref: https://github.com/petersalomonsen/javascriptmusic/blob/master/wasmaudioworklet/synth1/assembly/synth/sineoscillator.class.ts
class DartSineOscillator implements Oscillator {
  int position = 0;
  final double frequency;
  final sampleRate;

  DartSineOscillator(this.sampleRate, this.frequency);

  @override
  double next() {
    final ret = sin(pi * 2 * (position) / (1 << 16));
    position =
        (((position) + (frequency / sampleRate) * 0x10000).toInt()) & 0xffff;

    return ret;
  }
}
