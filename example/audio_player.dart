import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:libao/libao.dart';

void playbackWorker(SendPort replyPort) {
  final requestsPort = ReceivePort();
  final player = AudioPlayer();
  player.play();
  requestsPort.listen((message) {
    if (message is TransferableTypedData) {
      player.buffer.add(message.materialize().asUint8List());
    } else if (message is Uint8List) {
      player.buffer.add(message);
    } else if (message is String) {
      switch (message) {
        case 'stop':
          player.stop();
          requestsPort.close();
      }
    } else {
      print('playback Isolate received unexpected data:$message');
    }
  });
  // send the port we're listening on to our parent isolate to receive ongoing requests
  replyPort.send(requestsPort.sendPort);
}

class AudioPlayer {
  static const bits = 16;
  static const channels = 2;
  static const rate = 44100;

  final buffer = StreamController<Uint8List>();
  late final ao;
  late final device;
  late final StreamSubscription streamSubscription;

  AudioPlayer() {
    ao = Libao.open();

    ao.initialize();

    final driverId = ao.defaultDriverId();

    print(ao.driverInfo(driverId));

    device = ao.openLive(
      driverId,
      bits: bits,
      channels: channels,
      rate: rate,
    );
  }
  Future<void> play() async {
    streamSubscription = buffer.stream.listen((data) {
      ao.play(device, data);
    });
  }

  void stop() {
    streamSubscription.cancel();
    ao.close(device);
    ao.shutdown();
    print('audio player stopped');
  }
}
