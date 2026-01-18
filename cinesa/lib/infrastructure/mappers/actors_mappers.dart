import 'package:cinesa/domain/entities/actor.dart';
import 'package:cinesa/infrastructure/models/moviedb/credits_response.dart';

class ActorsMappers {
  static String imageDefault =
      "https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png";
      
  static Actor castToEntity(Cast cast) => Actor(
    id: cast.id,
    name: cast.name,
    profilePath: cast.profilePath == null ? imageDefault : cast.profilePath!,
    character: cast.character,
  );
}
