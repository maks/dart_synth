import 'dart:math';

/// ref: https://github.com/petersalomonsen/javascriptmusic/blob/master/wasmaudioworklet/synth1/assembly/synth/sineoscillator.class.ts
///
class SineOscillator {
  int position = 0;
  final double frequency;
  final sampleRate;

  SineOscillator(this.sampleRate, this.frequency);

  double next() {
    final ret = sin(pi * 2 * (position) / (1 << 16));
    position =
        (((position) + (frequency / sampleRate) * 0x10000).toInt()) & 0xffff;

    return ret;
  }
}
