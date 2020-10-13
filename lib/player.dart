import 'dart:typed_data';
import 'package:accordi/service_scale.dart';

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

    if (!kIsWeb) {
      String asset = "assets/sounds/Piano.sf2";
      log.i("Loading asset [$asset]...");
      _sound = await bundle.load(asset);
      //await player.unmute();

      log.i("Preparing player...");
      await fmPlayer.prepare(sf2: _sound, name: "Piano.sf2");
    }

    log.i("Initialization DONE");
    loaded = true;
  }

  void playMidiNote(Note note /*int note*/) {
    log.i("playMidiNote | note:${note.toStringShort()}");
    if (!kIsWeb) {
      int midiNote = ServiceScale.getMidiNote(note);
      fmPlayer.playMidiNote(midi: midiNote);
    } else {
      js.context.callMethod("playNote", ["${note.toStringShort()}" /*"C5"*/, "8n"]);
    }
  }
}
