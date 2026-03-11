class PromptTokensDetail {
    final String modality;
    final int tokenCount;

    PromptTokensDetail({
        required this.modality,
        required this.tokenCount,
    });

    PromptTokensDetail copyWith({
        String? modality,
        int? tokenCount,
    }) => 
        PromptTokensDetail(
            modality: modality ?? this.modality,
            tokenCount: tokenCount ?? this.tokenCount,
        );

    factory PromptTokensDetail.fromJson(Map<String, dynamic> json) => PromptTokensDetail(
        modality: json["modality"],
        tokenCount: json["tokenCount"],
    );

    Map<String, dynamic> toJson() => {
        "modality": modality,
        "tokenCount": tokenCount,
    };
}