import '../oscillators.dart';
import 'wasm_helper.dart';

class WasmSineOscillator implements SineOscillator {
  late final WasmOscillator _wasmOsc;

  WasmSineOscillator(int sampleRate, double frequency) {
    _wasmOsc =
        WasmOscillator('../../as-audio/build/osc.wasm', 'SineOscillator');
    _wasmOsc.frequency = frequency;
  }

  @override
  double next() => _wasmOsc.nextSample();
}
