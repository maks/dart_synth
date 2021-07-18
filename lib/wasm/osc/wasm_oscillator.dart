import '../wasm_helper.dart';

/// Wrap access to a oscillator defined in WASM
/// we expect the wasm to be a AssemblyScript class which has a
/// method for setting freq and a method called 'next'
class WasmOscillator {
  // need to use dynamic as lookupFunction() doesn't return WasmFunction but dynamic, for easy calling as Dart functions
  late final dynamic _nextSample;
  late final dynamic _setFrequency;
  late final int _oscObjectRef;

  set frequency(double freq) => _setFrequency(_oscObjectRef, freq);

  WasmOscillator(final String wasmfilepath, String oscClassname) {
    const sampleRate = 44100.0;

    final helper = WasmHelper(wasmfilepath);

    final cons = helper.getMethod(oscClassname, 'constructor');
    _setFrequency = helper.getMethod(oscClassname, 'set:frequency');
    _nextSample = helper.getMethod(oscClassname, 'next');

    final sampleRateGlobal = helper.getGlobal('SAMPLERATE');

    sampleRateGlobal?.value = sampleRate;

    // calling a Assemblyscript constructor returns a i32 which is "reference" to the object created by it
    _oscObjectRef = cons(0);
  }

  double nextSample() => _nextSample(_oscObjectRef);
}
