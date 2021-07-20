import 'package:dart_synth/dart_synth.dart';

import '../wasm_helper.dart';

class WasmFreeverb implements Freeverb {
  late final int _oscObjectRef;
  late final dynamic _tick;
  late final dynamic _updateWetGains;
  late final dynamic _getWet;
  late final dynamic _setWet;
  late final dynamic _getRoomSize;
  late final dynamic _setRoomSize;
  late final dynamic _getWidth;
  late final dynamic _setWidth;
  late final dynamic _getDampening;
  late final dynamic _setDampening;
  late final dynamic _getFrozen;
  late final dynamic _setFrozen;

  late final WasmHelper helper;

  WasmFreeverb({
    double? wet,
    double? dry,
    double? width,
    double? inputGain,
    double? dampening,
    double? roomSize,
    bool? frozen,
  }) {
    const wasmfilepath = 'osc.wasm';
    const wasmClassname = 'Freeverb';
    helper = WasmHelper(wasmfilepath);

    final cons = helper.getMethod(wasmClassname, 'constructor');
    _tick = helper.getMethod(wasmClassname, 'tick');
    _updateWetGains = helper.getMethod(wasmClassname, 'update_wet_gains');
    _getWet = helper.getMethod(wasmClassname, 'get:wet');
    _setWet = helper.getMethod(wasmClassname, 'set:wet');
    _getRoomSize = helper.getMethod(wasmClassname, 'get:room_size');
    _setRoomSize = helper.getMethod(wasmClassname, 'set:room_size');
    _getWidth = helper.getMethod(wasmClassname, 'get:width');
    _setWidth = helper.getMethod(wasmClassname, 'set:width');
    _getDampening = helper.getMethod(wasmClassname, 'get:dampening');
    _setDampening = helper.getMethod(wasmClassname, 'set:dampening');
    _getFrozen = helper.getMethod(wasmClassname, 'get:frozen');

    // calling a Assemblyscript constructor returns a i32 which is "reference" to the object created by it
    _oscObjectRef = cons(0);
  }

  @override
  void tick(StereoSignal signal) => _tick(_oscObjectRef, signal.ref);

  @override
  double? get wet => _getWet(_oscObjectRef);

  @override
  set wet(double? _wet) {
    _setWet(_oscObjectRef, _wet);
    _updateWetGains(_oscObjectRef);
  }

  @override
  double? get roomSize => _getRoomSize(_oscObjectRef);

  @override
  set roomSize(double? _roomSize) {
    _setRoomSize(_oscObjectRef, _roomSize);
    _updateWetGains(_oscObjectRef);
  }

  @override
  double? get width => _getWidth(_oscObjectRef);

  @override
  set width(double? _width) {
    _setWidth(_oscObjectRef, _width);
    _updateWetGains(_oscObjectRef);
  }

  @override
  double? get dampening => _getDampening(_oscObjectRef);

  @override
  set dampening(double? _dampening) {
    _setDampening(_oscObjectRef, _dampening);
    _updateWetGains(_oscObjectRef);
  }

  @override
  bool? get frozen => _getFrozen(_oscObjectRef) == 0 ? false : true;

  @override
  set frozen(bool? _frozen) => _setFrozen(_oscObjectRef, _frozen);
}
