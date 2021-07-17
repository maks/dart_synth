import 'dart:io';
import 'package:wasm/wasm.dart';

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
    print('Loading wasm module [$wasmfilepath] ...');
    var wasmfile = Platform.script.resolve(wasmfilepath);
    var moduleData = File(wasmfile.path).readAsBytesSync();
    var module = WasmModule(moduleData);
    print(module.describe());

    // can't set samplerate yet as @petersalomonsen AS code uses wasm globals for that
    // and Dart WASM pkg doesn't yet support globals: https://github.com/dart-lang/wasm/issues/24
    // ignore: unused_local_variable
    const sample_rate = 44100;

    var builder = module.builder();
    var instance = builder.build();

    final cons = instance.lookupFunction('$oscClassname#constructor');
    _setFrequency = instance.lookupFunction('$oscClassname#set:frequency');
    _nextSample = instance.lookupFunction('$oscClassname#next');

    // calling a Assemblyscript constructor returns a i32 which is "reference" to the object created by it
    _oscObjectRef = cons(0);
  }

  double nextSample() => _nextSample(_oscObjectRef);
}

class WasmHelper {
  late final WasmModule _wasmModule;

  WasmHelper(final String wasmfilepath, {bool debug = false}) {
    print('Loading wasm module [$wasmfilepath] ...');
    var wasmfile = Platform.script.resolve(wasmfilepath);
    var moduleData = File(wasmfile.path).readAsBytesSync();
    _wasmModule = WasmModule(moduleData);
    if (debug) {
      print('Loaded WASM: ${_wasmModule.describe()}');
    }
  }

  dynamic getFunction(String functionName) {
    return _instance.lookupFunction('$functionName');
  }

  dynamic getMethod(String className, String methodName) {
    return _instance.lookupFunction('$className#$methodName');
  }

  WasmInstance get _instance => _wasmModule.builder().build();
}
