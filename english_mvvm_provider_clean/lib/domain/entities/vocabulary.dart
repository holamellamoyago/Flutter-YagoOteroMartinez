// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class Vocabulary {
  int id;
  int categoryID;
  String english;
  String spanish;
  
  Vocabulary({
    required this.id,
    required this.categoryID,
    required this.english,
    required this.spanish,
  });
}
