import '../oscillators.dart';
import 'wasm_helper.dart';

class WasmSawOscillator implements Oscillator {
  late final WasmOscillator _wasmOsc;

  WasmSawOscillator(int sampleRate, double frequency) {
    _wasmOsc = WasmOscillator('osc.wasm', 'SawOscillator');
    _wasmOsc.frequency = frequency;
  }

  @override
  double next() => _wasmOsc.nextSample();
}
