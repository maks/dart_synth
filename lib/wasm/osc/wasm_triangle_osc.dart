import '../../interfaces.dart';
import 'wasm_oscillator.dart';

class WasmTriangleOscillator implements Oscillator {
  late final WasmOscillator _wasmOsc;

  WasmTriangleOscillator(int sampleRate, double frequency) {
    _wasmOsc = WasmOscillator('osc.wasm', 'TriangleOscillator');
    _wasmOsc.frequency = frequency;
  }

  @override
  double next() => _wasmOsc.nextSample();
}
