// ignore_for_file: public_member_api_docs, sort_constructors_first

class AppUser {
  String name, email;
  String? image, username, createdAt;
  int? totalPoints;

  AppUser({
    required this.name,
    required this.email,
    this.totalPoints,
    this.createdAt,
    this.username,
    this.image,
  });

  @override
  String toString() => "$name($email) imagen: $image";
}
