import '../oscillators.dart';
import 'wasm_helper.dart';

class WasmTriangleOscillator implements Oscillator {
  late final WasmOscillator _wasmOsc;

  WasmTriangleOscillator(int sampleRate, double frequency) {
    _wasmOsc = WasmOscillator('../bin/osc.wasm', 'TriangleOscillator');
    _wasmOsc.frequency = frequency;
  }

  @override
  double next() => _wasmOsc.nextSample();
}
