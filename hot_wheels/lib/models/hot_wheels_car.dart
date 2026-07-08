class HotWheelsCar {
  final String? toyNum;
  final String modelName;
  final String? series;
  final String? seriesNum;
  final int year;
  final String? imageUrl;

  HotWheelsCar({
    this.toyNum,
    required this.modelName,
    this.series,
    this.seriesNum,
    required this.year,
    this.imageUrl,
  });

  factory HotWheelsCar.fromJson(Map<String, dynamic> json) {
    return HotWheelsCar(
      toyNum: json['toy_num'] as String?,
      modelName: json['model_name'] as String? ?? 'Unknown',
      series: json['series'] as String?,
      seriesNum: json['series_num'] as String?,
      year: json['year'] as int? ?? 0,
      imageUrl: json['image_url'] as String?,
    );
  }

  String get displayNumber => toyNum ?? '-';
  String get displaySeries => series ?? '';
}
