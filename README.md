# A sandbox for audio synth experimentation in Dart.

The current plan is to create enough infrastructure to run WASM code from [Peter Salomonsens **awesome** AssemblyScript based synth](https://github.com/petersalomonsen/javascriptmusic/tree/master/wasmaudioworklet/synth1/assembly).


## TODO

- [x] Playback using Dart on Linux via Libao (using Pulseaudio on Ubuntu)
- [x] Playback sine wave test tone using AssemblyScript ported to Dart
- [x] Call wasm (AS compiled to wasm from @petersalomonsen repo) from Dart using upcoming wasm package via FFI
- [ ] interface to all "low-level" synth1 classes (oscillators, envelope, etc)
- [ ] interface to fx classes
- [ ] interface to "instruments" defined based on lowlevel synth classes
- [ ] create standalone exe
- [ ] midi support using [flutter_midi_command](https://pub.dev/packages/flutter_midi_command)


## Example

run to get sawtooth tone at 440hz playing for 1 sec:
```
dart example/dart_synth.dart
```

to play a sawtooth tone with a given midi note for 1 sec:
```
dart example/dart_synth.dart 77
```

Note: the wasm oscillator classes currently expect a wasm file called `osc.wasm` to be located in the same folder as the dart script being run, ie. `dart_synth.dart`.

## AS Audio WASM

The wasm file [osc.wasm](bin/osc.wab) used by dart-synth comes from the [AssemblyScript Audio project](https://github.com/maks/as-audio).

## Status

Currently only basic sine/sawooth tone playback on x86 Linux (under PulseAudio) works, see above Todo list for planned future features.
