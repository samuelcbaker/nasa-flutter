import 'dart:convert';

import 'package:nasa_flutter/domain/entities/nasa_image.dart';
import 'package:nasa_flutter/extensions/date_extension.dart';

class NasaImageModel extends NasaImage {
  NasaImageModel({
    required super.title,
    required super.explanation,
    required super.url,
    required super.date,
  });

  NasaImageModel copyWith({
    String? title,
    String? explanation,
    String? url,
    DateTime? date,
  }) {
    return NasaImageModel(
      title: title ?? this.title,
      explanation: explanation ?? this.explanation,
      url: url ?? this.url,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'explanation': explanation,
      'url': url,
      'date': date.format(),
    };
  }

  factory NasaImageModel.fromEntity(NasaImage entity) {
    return NasaImageModel(
      title: entity.title,
      explanation: entity.explanation,
      url: entity.url,
      date: entity.date,
    );
  }

  factory NasaImageModel.fromMap(Map<String, dynamic> map) {
    return NasaImageModel(
      title: map['title'] as String,
      explanation: map['explanation'] as String,
      url: map['url'] as String,
      date: (map['date'] as String).toDate() ?? DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory NasaImageModel.fromJson(String source) =>
      NasaImageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NasaImageModel(title: $title, explanation: $explanation, url: $url, date: $date)';
  }

  @override
  bool operator ==(covariant NasaImageModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.explanation == explanation &&
        other.url == url &&
        other.date == date;
  }

  @override
  int get hashCode {
    return title.hashCode ^ explanation.hashCode ^ url.hashCode ^ date.hashCode;
  }
}
