// To parse this JSON data, do
//
//     final facebookClassify = facebookClassifyFromJson(jsonString);

import 'dart:convert';

List<FacebookClassify> facebookClassifyFromJson(String str) => List<FacebookClassify>.from(json.decode(str).map((x) => FacebookClassify.fromJson(x)));

String facebookClassifyToJson(List<FacebookClassify> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FacebookClassify {
  FacebookClassify({
    required this.score,
    required this.label,
  });

  double score;
  String label;

  factory FacebookClassify.fromJson(Map<String, dynamic> json) => FacebookClassify(
    score: json["score"].toDouble(),
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "score": score,
    "label": label,
  };
}
