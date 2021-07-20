import 'package:dart_synth/dart_synth.dart';

import '../wasm_helper.dart';

class WasmStereoSignal implements StereoSignal {
  late final int _oscObjectRef;
  late final dynamic _clear;
  late final dynamic _add;
  late final dynamic _addMonoSignal;
  late final dynamic _addStereoSignal;
  late final dynamic _getLeft;
  late final dynamic _getRight;
  late final dynamic _setLeft;
  late final dynamic _setRight;

  @override
  int get ref => _oscObjectRef;

  @override
  double get left => _getLeft(_oscObjectRef); //TODO get from wasm

  @override
  double get right => _getRight(_oscObjectRef); //TODO get from wasm

  @override
  set left(double _left) => _setLeft(_oscObjectRef, _left);

  @override
  set right(double _right) => _setRight(_oscObjectRef, _right);

  WasmStereoSignal(WasmHelper helper) {
    const wasmClassname = 'StereoSignal';

    final cons = helper.getMethod(wasmClassname, 'constructor');
    _clear = helper.getMethod(wasmClassname, 'clear');
    _add = helper.getMethod(wasmClassname, 'add');
    _addMonoSignal = helper.getMethod(wasmClassname, 'addMonoSignal');
    _addStereoSignal = helper.getMethod(wasmClassname, 'addStereoSignal');
    _getLeft = helper.getMethod(wasmClassname, 'get:left');
    _getRight = helper.getMethod(wasmClassname, 'get:right');
    _setLeft = helper.getMethod(wasmClassname, 'set:left');
    _setRight = helper.getMethod(wasmClassname, 'set:right');

    // calling a Assemblyscript constructor returns a i32 which is "reference" to the object created by it
    _oscObjectRef = cons(0);
  }

  @override
  void clear() => _clear(_oscObjectRef);

  @override
  void add(double left, right) => _add(_oscObjectRef, left, right);

  @override
  void addMonoSignal(double signal, double level, double pan) =>
      _addMonoSignal(_oscObjectRef, signal, level, pan);

  @override
  void addStereoSignal(StereoSignal signal, double level, double pan) =>
      _addStereoSignal(_oscObjectRef, signal.ref, level, pan);
}
