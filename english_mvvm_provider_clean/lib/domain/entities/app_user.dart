// ignore_for_file: public_member_api_docs, sort_constructors_first

class AppUser {
  String uid, name, photoURL, username;
  String? image, createdAt;
  int? totalPoints;

  AppUser({
    required this.uid,
    required this.name,
    required this.photoURL,
    required this.username,
    this.totalPoints,
    this.createdAt,
    this.image,
  });

  @override
  String toString() => "$name($photoURL) imagen: $image";
}
