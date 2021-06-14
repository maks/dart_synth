# A sandbox for audio synth experimentation in Dart.


The current plan is to create enough infrastructure to run WASM code from [Peter Salomonsens awesome TS based synth](https://github.com/petersalomonsen/javascriptmusic/tree/master/wasmaudioworklet/synth1/assembly/synth).


Status:

[x] Playback using Dart on Linux via Libao (using Pulseaudio on Ubuntu)
[x] Playback sine wave test tone using AssemblyScript ported to Dart
[] Call wasm (wasmaudioworklet AS compiled to wasm) from Dart, preferably using upcoming wasm package via FFI
[] create standalone exe
[] midi support using [flutter_midi_command](https://pub.dev/packages/flutter_midi_command)

