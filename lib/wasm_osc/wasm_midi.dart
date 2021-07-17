import 'wasm_helper.dart';

class WasmMidi {
  late final WasmHelper _helper;

  WasmMidi() {
    _helper = WasmHelper('osc.wasm', debug: true);
  }

  double midi2freq(int midinote) {
    final notefreq = _helper.getFunction('notefreq');
    return notefreq(midinote.toDouble());
  }
}
