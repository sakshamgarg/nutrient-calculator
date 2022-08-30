import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

// To parse this JSON data, do
//
//     final facebookSegment = facebookSegmentFromJson(jsonString);


List<FacebookSegment> facebookSegmentFromJson(String str) => List<FacebookSegment>.from(json.decode(str).map((x) => FacebookSegment.fromJson(x)));

String facebookSegmentToJson(List<FacebookSegment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FacebookSegment {
  FacebookSegment({
    required this.score,
    required this.label,
    required this.box,
  });

  double score;
  String label;
  Box box;

  factory FacebookSegment.fromJson(Map<String, dynamic> json) => FacebookSegment(
    score: json["score"].toDouble(),
    label: json["label"],
    box: Box.fromJson(json["box"]),
  );

  Map<String, dynamic> toJson() => {
    "score": score,
    "label": label,
    "box": box.toJson(),
  };
}

class Box {
  Box({
    required this.xmin,
    required this.ymin,
    required this.xmax,
    required this.ymax,
  });

  int xmin;
  int ymin;
  int xmax;
  int ymax;

  factory Box.fromJson(Map<String, dynamic> json) => Box(
    xmin: json["xmin"],
    ymin: json["ymin"],
    xmax: json["xmax"],
    ymax: json["ymax"],
  );

  Map<String, dynamic> toJson() => {
    "xmin": xmin,
    "ymin": ymin,
    "xmax": xmax,
    "ymax": ymax,
  };
}
