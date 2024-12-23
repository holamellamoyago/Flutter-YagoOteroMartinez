import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_typing_uninitialized_final Stringiables

class Verbo {
  final int idVerbo;
  final String infinitivo;
  final String pasadoSimple;
  final String pasadoParticipio;
  final String traduccion;

  Verbo({
    required this.idVerbo,
    required this.infinitivo,
    required this.pasadoSimple,
    required this.pasadoParticipio,
    required this.traduccion,
  });
  factory Verbo.fromJson(Map<String, dynamic> json) {
    return Verbo(
      idVerbo: json[3],
      infinitivo: json['infinitivo'],
      pasadoSimple: json['pasadoSimple'],
      pasadoParticipio: json['pasadoParticipio'],
      traduccion: json['traduccion'],
    );
  }
}
