// ignore_for_file: public_member_api_docs, sort_constructors_first

class AppUser {
  String name, email, username;
  String? image, createdAt;
  int? totalPoints;

  AppUser({
    required this.name,
    required this.email,
    required this.username,
    this.totalPoints,
    this.createdAt,
    this.image,
  });

  @override
  String toString() => "$name($email) imagen: $image";
}
