import 'package:english_mvvm_provider_clean/config/database_constants.dart';
import 'package:english_mvvm_provider_clean/domain/entities/app_user.dart';
import 'package:english_mvvm_provider_clean/domain/entities/level.dart';
import 'package:english_mvvm_provider_clean/domain/entities/level_category.dart';

  List<AppUser> mapearUsers(List<Map<String, dynamic>> lista) {
    Iterator it = lista.iterator;
    List<AppUser> users = [];

    while (it.moveNext()) {
      Map<String, dynamic> map = it.current;
      users.add(
        AppUser(
          uid: map[DatabaseConstants.userUID] ?? "no uid",
          name: map[DatabaseConstants.globalName] ?? "no name",
          photoURL: map[DatabaseConstants.userPhotoURL] ?? "no photo_url",
          username: map[DatabaseConstants.userUsername] ?? "no username",
          image: map[DatabaseConstants.userPhotoURL] ?? "",
          totalPoints: map[DatabaseConstants.userTotalPoints] ?? 999,
          createdAt: map[DatabaseConstants.userCreatedAt],
        ),
      );
    }

    return users;
  }

  
  List<LevelCategory> mapearLevelCategories(List<Map<String, dynamic>> data) {
    List<LevelCategory> categories = [];

    for (var i = 0; i < data.length; i++) {
      Map<String, dynamic> map = data[i];

      LevelCategory levelCategory = LevelCategory(
        id: map[DatabaseConstants.idCategoria],
        name: map[DatabaseConstants.globalName],
      );

      categories.add(levelCategory);
    }
    
    return categories;
  }


    List<Level> mapearLevels(List<Map<String, dynamic>> data) {
    List<Level> levels = [];

    for (var i = 0; i < data.length; i++) {
      Map<String, dynamic> mapa = data[i];
      Level level = Level(
        id: mapa[DatabaseConstants.idLevel],
        categoryID: mapa[DatabaseConstants.levelCategory],
        name: mapa[DatabaseConstants.globalName],
        description: mapa[DatabaseConstants.levelDescription],
        completed:  false
      );
      levels.add(level);
    }

    return levels;
  }