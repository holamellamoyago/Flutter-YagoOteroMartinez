import 'package:english_mvvm_provider_clean/domain/repositories/sound_repository.dart';
import 'package:flutter/material.dart';

class SoundProvider extends ChangeNotifier {
  final SoundRepository repository;
  bool _playing = true;

  SoundProvider({required this.repository});

  IconData get backgroundIcon =>
      _playing ? Icons.volume_up_sharp : Icons.volume_off_sharp;

  void initialize() {
    repository.playBackgroundSound();
  }

  void toggleBackgroundSound() {
    _playing
        ? repository.stopBackgroundSound()
        : repository.playBackgroundSound();

    _playing = !_playing;
    notifyListeners();
  }

  void playErrorSound() {
    if (!_playing) return;

    repository.playErrorSound();
  }

  void playCorrectSound() {
    if (!_playing) return;

    repository.playCorrectSound();
  }
}
