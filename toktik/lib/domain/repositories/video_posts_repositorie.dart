import 'package:toktik/domain/entities/video_post.dart';

abstract class VideoPostRepositorie {
  Future<List<VideoPost>> getTrendingVideosByPage(int page);

  Future<List<VideoPost>> getFavouriteVideosByUser(String userID);

}
