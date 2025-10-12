// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/widgets.dart';

class AppUser {
  String name, email;
  String? image;

  AppUser({required this.name, required this.email, this.image});

  @override
  String toString() => "$name($email) imagen: $image";
}
