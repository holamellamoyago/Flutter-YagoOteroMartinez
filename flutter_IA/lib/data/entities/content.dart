import 'package:flutter_ia/data/entities/part.dart';

class Content {
    final List<Part> parts;

    Content({
        required this.parts,
    });

    Content copyWith({
        List<Part>? parts,
    }) => 
        Content(
            parts: parts ?? this.parts,
        );

    factory Content.fromJson(Map<String, dynamic> json) => Content(
        parts: List<Part>.from(json["parts"].map((x) => Part.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "parts": List<dynamic>.from(parts.map((x) => x.toJson())),
    };
}
