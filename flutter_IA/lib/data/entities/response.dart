import 'dart:convert';

import 'package:flutter_ia/data/entities/candidate.dart';
import 'package:flutter_ia/data/entities/usage_metadata.dart';

Response responseFromJson(String str) => Response.fromJson(json.decode(str));

String responseToJson(Response data) => json.encode(data.toJson());

class Response {
    final List<Candidate> candidates;
    final UsageMetadata usageMetadata;
    final String modelVersion;
    final String responseId;

    Response({
        required this.candidates,
        required this.usageMetadata,
        required this.modelVersion,
        required this.responseId,
    });

    Response copyWith({
        List<Candidate>? candidates,
        UsageMetadata? usageMetadata,
        String? modelVersion,
        String? responseId,
    }) => 
        Response(
            candidates: candidates ?? this.candidates,
            usageMetadata: usageMetadata ?? this.usageMetadata,
            modelVersion: modelVersion ?? this.modelVersion,
            responseId: responseId ?? this.responseId,
        );

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        candidates: List<Candidate>.from(json["candidates"].map((x) => Candidate.fromJson(x))),
        usageMetadata: UsageMetadata.fromJson(json["usageMetadata"]),
        modelVersion: json["modelVersion"],
        responseId: json["responseId"],
    );

    Map<String, dynamic> toJson() => {
        "candidates": List<dynamic>.from(candidates.map((x) => x.toJson())),
        "usageMetadata": usageMetadata.toJson(),
        "modelVersion": modelVersion,
        "responseId": responseId,
    };
}



