import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

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

  const bufferedSamples = 64 * 4;
  const bufferSize =
      AudioPlayer.bits ~/ 8 * AudioPlayer.channels * bufferedSamples;
  final buffer = Uint8List(bufferSize);

  print('sample buffer size: $bufferedSamples');

  Oscillator osc = WasmSineOscillator(AudioPlayer.rate, freq);

  final freeverb = WasmFreeverb();
  freeverb.wet = 1.0;
  freeverb.width = 0.5;
  freeverb.roomSize = 0.7;
  freeverb.dampening = 0.1;
  print('Reverb settings\n'
      'wet:${freeverb.wet} room:${freeverb.roomSize} width:${freeverb.width}'
      ' damp:${freeverb.dampening} frozen: ${freeverb.frozen}');

  final reverbline = WasmStereoSignal(freeverb.helper);
  final mainline = WasmStereoSignal(freeverb.helper);

  const buffersPerSec = AudioPlayer.rate / bufferedSamples;
  var playbackDurationInSec = 3 * buffersPerSec;

  var oscVolume = 0.7;
  // fill buffer with audio
  while (playbackDurationInSec-- > 0) {
    for (var i = 0; i < bufferedSamples; i++) {
      reverbline.clear();
      mainline.clear();
      var output = osc.next() * oscVolume;

      mainline.addMonoSignal(output, 1.0, 0.1);
      reverbline.addStereoSignal(mainline, 0.5, 0.0);
      freeverb.tick(reverbline);

      final sampleLeft =
          ((mainline.left + reverbline.left) * volume * 32768.0).toInt();
      final sampleRight =
          ((mainline.right + reverbline.right) * volume * 32768.0).toInt();

      buffer[4 * i] = sampleLeft & 0xff;
      buffer[4 * i + 2] = sampleRight & 0xff;
      buffer[4 * i + 1] = (sampleLeft >> 8) & 0xff;
      buffer[4 * i + 3] = (sampleRight >> 8) & 0xff;

    }
    toIsolateSendPort.send(TransferableTypedData.fromList([buffer]));
    // toIsolateSendPort.send(buffer);
    oscVolume = oscVolume <= 0 ? 0 : (oscVolume - 0.001);
  }

  toIsolateSendPort.send('stop');
  await isoSubcription.cancel();
}
