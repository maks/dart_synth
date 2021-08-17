import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:dart_synth/dart_osc/dart_sine_osc.dart';
import 'package:dart_synth/dart_synth.dart';

import 'audio_player.dart';

void main(List<String> args) async {
  int? midinote;
  var freq = 440.0;

  if (args.length == 1) {
    midinote = int.parse(args[0]);
    freq = WasmMidi().midi2freq(midinote);
    print('freq: $freq');
  }
  print('playing...$midinote');

  const volume = 0.5;

  final isolateResponsePort = ReceivePort();
  final playbackIsolate = await Isolate.spawn<SendPort>(
      playbackWorker, isolateResponsePort.sendPort);

  final isolateExitPort = ReceivePort();
  playbackIsolate.addOnExitListener(isolateExitPort.sendPort);
  isolateExitPort.listen((message) {
    print('playback isolate exited');
    isolateResponsePort.close();
    isolateExitPort.close();
  });

  final completer = Completer<SendPort>();

  final isoSubcription = isolateResponsePort.listen((message) {
    if (message is SendPort) {
      final mainToIsolateStream = message;
      completer.complete(mainToIsolateStream);
    } else {
      print('unexpected message from isolate:$message');
    }
  });

  final toIsolateSendPort = await completer.future;

  // ideally want to have 256 for ~5.8ms of latency at 44.1khz
  // currently need x32 bigger sample buffer to avoid under-runs on AMD 4800u :-(
  const bufferedSamples = 256 * 32;
  const bufferSize =
      AudioPlayer.bits ~/ 8 * AudioPlayer.channels * bufferedSamples;
  final buffer = Uint8List(bufferSize);

  print('sample buffer size: $bufferedSamples');

  final Oscillator osc = DartSineOscillator(AudioPlayer.rate, freq);

  const buffersPerSec = AudioPlayer.rate / bufferedSamples;
  var playbackDurationInSec = 3 * buffersPerSec;

  var oscVolume = 0.7;

  // fill buffer with audio
  while (playbackDurationInSec-- > 0) {
    for (var i = 0; i < bufferedSamples; i++) {
      var output = osc.next() * oscVolume;

      final sample = (osc.next() * volume * 32768.0).toInt();
      // Left = Right.
      buffer[4 * i] = buffer[4 * i + 2] = sample & 0xff;
      buffer[4 * i + 1] = buffer[4 * i + 3] = (sample >> 8) & 0xff;
    }
    toIsolateSendPort.send(TransferableTypedData.fromList([buffer]));
    // toIsolateSendPort.send(buffer);
    oscVolume = oscVolume <= 0 ? 0 : (oscVolume - 0.001);
  }

  toIsolateSendPort.send('stop');
  await isoSubcription.cancel();
}
