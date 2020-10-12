import 'dart:typed_data';
import 'logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'dart:js' as js;

final AudioPlayer player = new AudioPlayer._private();

class AudioPlayer {
  final log = getLogger("AudioPlayer");

  ByteData _sound;
  final FlutterMidi fmPlayer = FlutterMidi();
  bool loaded = false;

  AudioPlayer._private();

  void load(AssetBundle bundle) async {
    log.i("load");

    String asset = "assets/sounds/Piano.sf2";
    log.i("Loading asset [$asset]...");
    _sound = await bundle.load(asset);
    //await player.unmute();

    log.i("Preparing player...");
    await fmPlayer.prepare(sf2: _sound, name: "Piano.sf2");

    log.i("Initialization DONE");
    loaded = true;
  }

  void playMidiNote(int note) {
    log.i("playMidiNote | note:$note");
    if (!kIsWeb) {
      fmPlayer.playMidiNote(midi: note);
    } else {
      js.context.callMethod("playNote", [note /*"C5"*/, "8n"]);
    }
  }
}
