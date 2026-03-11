// To parse this JSON data, do
//
//     final contents = contentsFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_ia/data/entities/content.dart';

Contents contentsFromJson(String str) => Contents.fromJson(json.decode(str));

String contentsToJson(Contents data) => json.encode(data.toJson());

class Contents {
    final List<Content> contents;

    Contents({
        required this.contents,
    });

    Contents copyWith({
        List<Content>? contents,
    }) => 
        Contents(
            contents: contents ?? this.contents,
        );

    factory Contents.fromJson(Map<String, dynamic> json) => Contents(
        contents: List<Content>.from(json["contents"].map((x) => Content.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "contents": List<dynamic>.from(contents.map((x) => x.toJson())),
    };
}


