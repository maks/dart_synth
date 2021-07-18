import '../../interfaces.dart';
import '../wasm_helper.dart';

/// Wrap access to a oscillator defined in WASM
/// we expect the wasm to be a AssemblyScript class which has a
/// method for setting freq and a method called 'next'
class WasmEnvelope implements Envelope {
  // need to use dynamic as lookupFunction() doesn't return WasmFunction but dynamic, for easy calling as Dart functions
  late final dynamic _nextSample;
  late final dynamic _attack;
  late final dynamic _release;
  late final dynamic _isDone;
  late final int _oscObjectRef;

  WasmEnvelope(
    double attackStep,
    double decayStep,
    double sustainLevel,
    double releaseStep,
  ) {
    const wasmfilepath = 'osc.wasm';
    const wasmClassname = 'Envelope';
    final helper = WasmHelper(wasmfilepath);

    final cons = helper.getMethod(wasmClassname, 'constructor');
    _attack = helper.getMethod(wasmClassname, 'attack');
    _release = helper.getMethod(wasmClassname, 'release');
    _isDone = helper.getMethod(wasmClassname, 'isDone');
    _nextSample = helper.getMethod(wasmClassname, 'next');

    // calling a Assemblyscript constructor returns a i32 which is "reference" to the object created by it
    _oscObjectRef = cons(0, attackStep, decayStep, sustainLevel, releaseStep);
  }

  @override
  void attack() => _attack(_oscObjectRef);

  @override
  void isDone() => _isDone(_oscObjectRef);

  @override
  double next() => _nextSample(_oscObjectRef);

  @override
  void release() => _release(_oscObjectRef);
}
