# A sandbox for audio synth experimentation in Dart.


The current plan is to create enough infrastructure to run WASM code from [Peter Salomonsens awesome TS based synth](https://github.com/petersalomonsen/javascriptmusic/tree/master/wasmaudioworklet/synth1/assembly/synth).


## Status

- [x] Playback using Dart on Linux via Libao (using Pulseaudio on Ubuntu)
- [x] Playback sine wave test tone using AssemblyScript ported to Dart
- [x] Call wasm (AS compiled to wasm from @petersalomonsen repo) from Dart using upcoming wasm package via FFI
- [ ] create standalone exe
- [ ] midi support using [flutter_midi_command](https://pub.dev/packages/flutter_midi_command)


## Example

run to get sawtooth tone at 440hz playing for 1 sec:
```
dart bin/dart_synth.dart
```
