class Level {
  int id, categoryID;
  String name;
  String? description;
  bool completed;

  Level({
    required this.id,
    required this.categoryID,
    required this.name,
    required this.completed,
    this.description,
  });
}
