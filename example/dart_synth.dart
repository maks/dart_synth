import 'dart:typed_data';

import 'package:dart_synth/oscillators.dart';
import 'package:dart_synth/wasm/midi/wasm_midi.dart';
import 'package:dart_synth/wasm/osc/wasm_saw_osc.dart';
import 'package:libao/libao.dart';

void main(List<String> args) {
  int? midinote;
  var freq = 440.0;

  if (args.length == 1) {
    midinote = int.parse(args[0]);
    freq = WasmMidi().midi2freq(midinote);
    print('freq: $freq');
  }
  print('playing...$midinote');

  final ao = Libao.open();

  ao.initialize();

  final driverId = ao.defaultDriverId();

  print(ao.driverInfo(driverId));

  const bits = 16;
  const channels = 2;
  const rate = 44100;

  final device = ao.openLive(
    driverId,
    bits: bits,
    channels: channels,
    rate: rate,
  );

  const volume = 0.5;

  // Number of bytes * Channels * Sample rate.
  const bufferSize = bits ~/ 8 * channels * rate;
  final buffer = Uint8List(bufferSize);

  final Oscillator osc = WasmSawOscillator(rate, freq);

  for (var i = 0; i < rate; i++) {
    final sample = (osc.next() * volume * 32768.0).toInt();
    // Left = Right.
    buffer[4 * i] = buffer[4 * i + 2] = sample & 0xff;
    buffer[4 * i + 1] = buffer[4 * i + 3] = (sample >> 8) & 0xff;
  }

  ao.play(device, buffer);

  ao.close(device);
  ao.shutdown();
}
