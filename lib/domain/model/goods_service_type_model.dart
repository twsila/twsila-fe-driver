// To parse this JSON data, do
//
//     final goodsServiceTypeModel = goodsServiceTypeModelFromJson(jsonString);

import 'dart:convert';

GoodsServiceTypeModel goodsServiceTypeModelFromJson(String str) => GoodsServiceTypeModel.fromJson(json.decode(str));

String goodsServiceTypeModelToJson(GoodsServiceTypeModel data) => json.encode(data.toJson());

class GoodsServiceTypeModel {
  int id;
  String serviceType;
  String serviceTypeAr;
  String serviceTypeParam;
  List<VehicleShape> vehicleShapes;
  GIcon icon;

  GoodsServiceTypeModel({
    required this.id,
    required this.serviceType,
    required this.serviceTypeAr,
    required this.serviceTypeParam,
    required this.vehicleShapes,
    required this.icon,
  });

  factory GoodsServiceTypeModel.fromJson(Map<String, dynamic> json) => GoodsServiceTypeModel(
    id: json["id"],
    serviceType: json["serviceType"],
    serviceTypeAr: json["serviceTypeAr"],
    serviceTypeParam: json["serviceTypeParam"],
    vehicleShapes: List<VehicleShape>.from(json["vehicleShapes"].map((x) => VehicleShape.fromJson(x))),
    icon: GIcon.fromJson(json["icon"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "serviceType": serviceType,
    "serviceTypeAr": serviceTypeAr,
    "serviceTypeParam": serviceTypeParam,
    "vehicleShapes": List<dynamic>.from(vehicleShapes.map((x) => x.toJson())),
    "icon": icon.toJson(),
  };
}

class GIcon {
  int id;
  String url;

  GIcon({
    required this.id,
    required this.url,
  });

  factory GIcon.fromJson(Map<String, dynamic> json) => GIcon(
    id: json["id"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
  };
}

class VehicleShape {
  int id;
  String shape;
  String shapeAr;

  VehicleShape({
    required this.id,
    required this.shape,
    required this.shapeAr,
  });

  factory VehicleShape.fromJson(Map<String, dynamic> json) => VehicleShape(
    id: json["id"],
    shape: json["shape"],
    shapeAr: json["shapeAr"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "shape": shape,
    "shapeAr": shapeAr,
  };
}
