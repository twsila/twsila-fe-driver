// To parse this JSON data, do
//
//     final lookupsModel = lookupsModelFromJson(jsonString);

import 'dart:convert';

LookupsModel lookupsModelFromJson(String str) => LookupsModel.fromJson(json.decode(str));

String lookupsModelToJson(LookupsModel data) => json.encode(data.toJson());

class LookupsModel {
  bool success;
  String? message;
  String dateTime;
  Map<String, List<String>> result;

  LookupsModel({
    required this.success,
    this.message,
    required this.dateTime,
    required this.result,
  });

  factory LookupsModel.fromJson(Map<String, dynamic> json) => LookupsModel(
    success: json["success"],
    message: json["message"] ?? "",
    dateTime: json["dateTime"],
    result: Map.from(json["result"]).map((k, v) => MapEntry<String, List<String>>(k, List<String>.from(v.map((x) => x)))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "dateTime": dateTime,
    "result": Map.from(result).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x)))),
  };
}
