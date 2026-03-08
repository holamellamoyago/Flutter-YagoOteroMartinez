import 'dart:convert';

List<Asset> assetFromJson(String str) => List<Asset>.from(json.decode(str).map((x) => Asset.fromJson(x)));

String assetToJson(List<Asset> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Asset {
    final String itemtype;
    final String name;
    final String href;

    Asset({
        required this.itemtype,
        required this.name,
        required this.href,
    });

    Asset copyWith({
        String? itemtype,
        String? name,
        String? href,
    }) => 
        Asset(
            itemtype: itemtype ?? this.itemtype,
            name: name ?? this.name,
            href: href ?? this.href,
        );

    factory Asset.fromJson(Map<String, dynamic> json) => Asset(
        itemtype: json["itemtype"],
        name: json["name"],
        href: json["href"],
    );

    Map<String, dynamic> toJson() => {
        "itemtype": itemtype,
        "name": name,
        "href": href,
    };
}
