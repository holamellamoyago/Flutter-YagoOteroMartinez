import 'package:audioplayers/audioplayers.dart';
import 'package:english_mvvm_provider_clean/data/datasources/sound/sound_datasource.dart';

class SoundDatasourceImpl extends SoundDatasource {
  final AudioPlayer backgroundPlayer = AudioPlayer(
    playerId: 'background_player',
  );

  final AudioPlayer responsesPlayer = AudioPlayer(playerId: 'responses_player');

  SoundDatasourceImpl() {
    backgroundPlayer.setVolume(0.4);
    responsesPlayer.setVolume(0.4);
  }

  @override
  void playBackgroundSound() {
    Source backgroundSource = AssetSource('sounds/background.mp3');
    backgroundPlayer.play(backgroundSource);
  }

  @override
  void stopBackgroundSound() {
    backgroundPlayer.stop();
  }

  @override
  void playCorrectSound() {
    print('Reproduciendo sonido');
    Source correctSource = AssetSource('sounds/correct.mp3');
    backgroundPlayer.play(correctSource);
  }

  @override
  void playErrorSound() {
    // TODO: implement playErrorSound
  }
}
