// ignore_for_file: public_member_api_docs, sort_constructors_first

class AppUser {
  String name, email, createdAt;
  String? image, username;
  int totalPoints;

  AppUser({
    required this.name,
    required this.email,
    required this.totalPoints,
    required this.createdAt,
    this.username,
    this.image,
  });

  @override
  String toString() => "$name($email) imagen: $image";
}
