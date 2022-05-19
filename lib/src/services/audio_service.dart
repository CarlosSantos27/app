import 'dart:io';
import 'dart:math';
import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

import './shared_preferencess_service.dart';

class AudioFilePath {
  static const String Button1 = 'audio/Pase1.mp3';
  static const String Button2 = 'audio/Pase2.mp3';
  static const String Button3 = 'audio/Pase3.mp3';
  static const String Button4 = 'audio/Pase4.mp3';

  static const String Gol = 'audio/Gol.mp3';
  static const String End = 'audio/end2.mp3';
  static const String Pito = 'audio/Pito.mp3';
  static const String Answer = 'audio/answer.mp3';
  static const String Blocked = 'audio/Blocked.mp3';
  static const String Stadium = 'audio/Stadium.mp3';
  static const String Confirm3 = 'audio/Confirm3.mp3';
  static const String Register = 'audio/Register.mp3';
  static const String CoinsCharge = 'audio/coins.mp3';
  static const String MouseClick = 'audio/MouseClick.mp3';
  static const String NormalClick = 'audio/NormalClick.mp3';
  static const String WrongAnswer = 'audio/wrong_answer.mp3';
  static const String CorrectAnswer = 'audio/correct_answer.mp3';
  static const String AnimacionIntro = 'audio/AnimacionIntro.mp3';
  static const String CorrectAnswer2 = 'audio/correct_answer2.mp3';
}

class AudioService {
  AudioCache _audioCache;
  AudioPlayer _currentLoop;
  AudioPlayer _advancedPlayer;
  SharedPreferencesService _preferences;
  bool _mute;

  bool get isMute => _mute;

  void initState(SharedPreferencesService prefs) async {
    _advancedPlayer = AudioPlayer();
    _audioCache = new AudioCache(fixedPlayer: _advancedPlayer);
    _mute = !prefs.statusSound;
    _preferences = prefs;
    await loadDefaultAssets();
  }

  Future<bool> loadDefaultAssets() async {
    List<File> files = await _audioCache.loadAll([
      'audio/answer.mp3',
      'audio/AnimacionIntro.mp3',
      'audio/Blocked.mp3',
      'audio/Confirm3.mp3',
      'audio/Gol.mp3',
      'audio/Pase1.mp3',
      'audio/Pase2.mp3',
      'audio/Pase3.mp3',
      'audio/Pase4.mp3',
      'audio/NormalClick.mp3',
      'audio/MouseClick.mp3',
      'audio/end2.mp3',
      'audio/correct_answer.mp3',
      'audio/correct_answer2.mp3',
      'audio/Pito.mp3',
      'audio/Register.mp3',
      'audio/Stadium.mp3',
      'audio/wrong_answer.mp3',
      'audio/coins.mp3',
    ]);
    return files.length > 0;
  }

  play(String audioPath) {
    _audioCache.play(audioPath,
        mode: PlayerMode.LOW_LATENCY, volume: _mute ? 0.0 : 1.0);
  }

  Future<int> mute(bool status) {
    _mute = !status;
    _preferences.statusSound = !_mute;
    this.stopLoop();
    return _advancedPlayer.setVolume(status ? 0.0 : 1.0);
  }

  playRandomButton() {
    this.playRandomAudio([
      AudioFilePath.Button1,
      AudioFilePath.Button2,
      AudioFilePath.Button3,
      AudioFilePath.Button4
    ]);
  }

  playRandomAudio(List<String> audios) {
    final _random = Random();
    int soundIndex = _random.nextInt(audios.length);
    String audioPath = audios[soundIndex];
    this.play(audioPath);
  }

  void playLoop() async {
    var _audioCache2 = new AudioCache();
    _currentLoop = await _audioCache2.loop('audio/clock.mp3',
        mode: PlayerMode.LOW_LATENCY,
        stayAwake: true,
        volume: _mute ? 0.0 : 1.0);
  }

  void stopLoop() {
    if (_currentLoop != null) _currentLoop.stop();
  }

  void incrementRateOfCurrentLoop(double rate) {
    if (_currentLoop != null) {
      _currentLoop.setPlaybackRate(playbackRate: rate);
    }
  }

  void incrementRateTimer(
    AudioPlayer audioPlayer, {
    double rate = 1.0,
    rateIncremente = .1,
  }) {
    if (_mute) {
      return;
    }
    const oneSec = const Duration(seconds: 1);
    Timer.periodic(
      oneSec,
      (Timer timer) {
        if (timer.tick % 5 == 0) {
          rate = rate + rateIncremente;
          audioPlayer.setPlaybackRate(playbackRate: rate);
        }
        if (timer.tick % 20 == 0) {
          audioPlayer.stop();
        }
      },
    );
  }
}
