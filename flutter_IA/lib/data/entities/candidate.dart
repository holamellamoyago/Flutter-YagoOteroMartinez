import 'package:flutter_ia/data/entities/content.dart';

class Candidate {
    final Content content;
    final String finishReason;
    final int index;

    Candidate({
        required this.content,
        required this.finishReason,
        required this.index,
    });

    Candidate copyWith({
        Content? content,
        String? finishReason,
        int? index,
    }) => 
        Candidate(
            content: content ?? this.content,
            finishReason: finishReason ?? this.finishReason,
            index: index ?? this.index,
        );

    factory Candidate.fromJson(Map<String, dynamic> json) => Candidate(
        content: Content.fromJson(json["content"]),
        finishReason: json["finishReason"],
        index: json["index"],
    );

    Map<String, dynamic> toJson() => {
        "content": content.toJson(),
        "finishReason": finishReason,
        "index": index,
    };
}