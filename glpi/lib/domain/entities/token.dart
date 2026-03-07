import 'dart:convert';

Token tokenFromJson(String str) => Token.fromJson(json.decode(str));

String tokenToJson(Token data) => json.encode(data.toJson());

class Token {
    final String tokenType;
    final int expiresIn;
    final String accessToken;
    final String refreshToken;

    Token({
        required this.tokenType,
        required this.expiresIn,
        required this.accessToken,
        required this.refreshToken,
    });

    Token copyWith({
        String? tokenType,
        int? expiresIn,
        String? accessToken,
        String? refreshToken,
    }) => 
        Token(
            tokenType: tokenType ?? this.tokenType,
            expiresIn: expiresIn ?? this.expiresIn,
            accessToken: accessToken ?? this.accessToken,
            refreshToken: refreshToken ?? this.refreshToken,
        );

    factory Token.fromJson(Map<String, dynamic> json) => Token(
        tokenType: json["token_type"],
        expiresIn: json["expires_in"],
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
    );

    Map<String, dynamic> toJson() => {
        "token_type": tokenType,
        "expires_in": expiresIn,
        "access_token": accessToken,
        "refresh_token": refreshToken,
    };
}
