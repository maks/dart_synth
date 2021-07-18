import 'dart:io';
import 'package:wasm/wasm.dart';

class WasmHelper {
  late final WasmModule _wasmModule;
  late final WasmInstance _instance = _wasmModule.builder().build();

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

  WasmGlobal? getGlobal(String name) {
    return _instance.lookupGlobal(name);
  }
}
