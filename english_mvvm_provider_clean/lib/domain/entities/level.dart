class Level {
  int id, categoryID;
  String name;
  String? description;

  Level({
    required this.id,
    required this.categoryID,
    required this.name,
    this.description,
  });
}
