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
dart bin/dart_synth.dart
```

## Status

Currently only basic sine/sawooth tone playback on x86 Linux (under PulseAudio) works, see above Todo list for planned future features.
