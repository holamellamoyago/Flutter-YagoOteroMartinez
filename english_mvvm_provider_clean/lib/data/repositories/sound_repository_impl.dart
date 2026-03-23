import 'package:english_mvvm_provider_clean/data/datasources/sound/sound_datasource.dart';
import 'package:english_mvvm_provider_clean/domain/repositories/sound_repository.dart';

class SoundRepositoryImpl extends SoundRepository {
  final SoundDatasource datasource;

  SoundRepositoryImpl({required this.datasource});

  @override
  void playBackgroundSound() {
    return datasource.playBackgroundSound();
  }

  @override
  void stopBackgroundSound() {
    return datasource.stopBackgroundSound();
  }

  @override
  void playCorrectSound() {
    return datasource.playCorrectSound();
  }

  @override
  void playErrorSound() {
    return datasource.playErrorSound();
  }
}
