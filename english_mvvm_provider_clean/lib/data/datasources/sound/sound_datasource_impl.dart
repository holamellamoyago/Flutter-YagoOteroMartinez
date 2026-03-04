import 'package:audioplayers/audioplayers.dart';
import 'package:english_mvvm_provider_clean/data/datasources/sound/sound_datasource.dart';

class SoundDatasourceImpl extends SoundDatasource {
  final AudioPlayer backgroundSound = AudioPlayer(playerId: 'background_sound');
  Source backgroundSource = AssetSource('sounds/background.mp3');

  @override
  void toggleBackgroundSound() {
    backgroundSound.play(backgroundSource);
  }

  @override
  void playBackgroundSound() {
    backgroundSound.play(backgroundSource);
    backgroundSound.setVolume(0.2);
  }

  @override
  void stopBackgroundSound() {
    backgroundSound.stop();
  }
}
