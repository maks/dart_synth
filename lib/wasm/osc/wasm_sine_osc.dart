import '../../interfaces.dart';
import 'wasm_oscillator.dart';

class WasmSineOscillator implements Oscillator {
  late final WasmOscillator _wasmOsc;

  WasmSineOscillator(int sampleRate, double frequency) {
    _wasmOsc = WasmOscillator('osc.wasm', 'SineOscillator');
    _wasmOsc.frequency = frequency;
  }

  @override
  double next() => _wasmOsc.nextSample();
}
