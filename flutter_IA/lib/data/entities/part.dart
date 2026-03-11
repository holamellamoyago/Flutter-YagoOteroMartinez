class Part {
    final String text;

    Part({
        required this.text,
    });

    Part copyWith({
        String? text,
    }) => 
        Part(
            text: text ?? this.text,
        );

    factory Part.fromJson(Map<String, dynamic> json) => Part(
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "text": text,
    };
}
