class UserList {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final bool isPublic;
  final int carCount;
  final String? previewImage;
  final DateTime createdAt;

  UserList({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.isPublic = false,
    this.carCount = 0,
    this.previewImage,
    required this.createdAt,
  });

  factory UserList.fromJson(Map<String, dynamic> json) {
    return UserList(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      isPublic: json['is_public'] as bool? ?? false,
      carCount: json['car_count'] as int? ?? 0,
      previewImage: json['preview_image'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

/// Denormalized car entry in a list
class ListCarEntry {
  final String listId;
  final int carYear;
  final String carToyNum;
  final String carModelName;
  final String? carImageUrl;
  final String? carSeries;
  final DateTime addedAt;

  ListCarEntry({
    required this.listId,
    required this.carYear,
    required this.carToyNum,
    required this.carModelName,
    this.carImageUrl,
    this.carSeries,
    required this.addedAt,
  });

  factory ListCarEntry.fromJson(Map<String, dynamic> json) {
    return ListCarEntry(
      listId: json['list_id'] as String,
      carYear: json['car_year'] as int,
      carToyNum: json['car_toy_num'] as String,
      carModelName: json['car_model_name'] as String,
      carImageUrl: json['car_image_url'] as String?,
      carSeries: json['car_series'] as String?,
      addedAt: DateTime.parse(json['added_at'] as String),
    );
  }
}
