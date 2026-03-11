import 'package:flutter_ia/data/entities/prompt_token_detail.dart';

class UsageMetadata {
    final int promptTokenCount;
    final int candidatesTokenCount;
    final int totalTokenCount;
    final List<PromptTokensDetail> promptTokensDetails;
    final int thoughtsTokenCount;

    UsageMetadata({
        required this.promptTokenCount,
        required this.candidatesTokenCount,
        required this.totalTokenCount,
        required this.promptTokensDetails,
        required this.thoughtsTokenCount,
    });

    UsageMetadata copyWith({
        int? promptTokenCount,
        int? candidatesTokenCount,
        int? totalTokenCount,
        List<PromptTokensDetail>? promptTokensDetails,
        int? thoughtsTokenCount,
    }) => 
        UsageMetadata(
            promptTokenCount: promptTokenCount ?? this.promptTokenCount,
            candidatesTokenCount: candidatesTokenCount ?? this.candidatesTokenCount,
            totalTokenCount: totalTokenCount ?? this.totalTokenCount,
            promptTokensDetails: promptTokensDetails ?? this.promptTokensDetails,
            thoughtsTokenCount: thoughtsTokenCount ?? this.thoughtsTokenCount,
        );

    factory UsageMetadata.fromJson(Map<String, dynamic> json) => UsageMetadata(
        promptTokenCount: json["promptTokenCount"],
        candidatesTokenCount: json["candidatesTokenCount"],
        totalTokenCount: json["totalTokenCount"],
        promptTokensDetails: List<PromptTokensDetail>.from(json["promptTokensDetails"].map((x) => PromptTokensDetail.fromJson(x))),
        thoughtsTokenCount: json["thoughtsTokenCount"],
    );

    Map<String, dynamic> toJson() => {
        "promptTokenCount": promptTokenCount,
        "candidatesTokenCount": candidatesTokenCount,
        "totalTokenCount": totalTokenCount,
        "promptTokensDetails": List<dynamic>.from(promptTokensDetails.map((x) => x.toJson())),
        "thoughtsTokenCount": thoughtsTokenCount,
    };
}
