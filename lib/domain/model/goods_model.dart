import 'package:taxi_for_you/domain/model/transportation_base_model.dart';

import '../../utils/helpers/double_prase.dart';

class GoodsModel extends TransportationBaseModel {
  String? packagingType;
  String? materialType;
  double? payloadWeight;
  bool containsLoading = false;
  bool containsPacking = false;
  bool containsLift = false;

  GoodsModel();

  GoodsModel.fromJson(Map<String, dynamic> json) {
    fromJSON(json);
    if (json['payloadWeight'] != null) {
      payloadWeight = dynamicToDouble(json['payloadWeight']);
    }
    if (json['packingDetails'] != null &&
        json['packingDetails']['description'] != null) {
      packagingType = json['packingDetails']['description'];
    }

    if (json['materialDetails'] != null &&
        json['materialDetails']['description'] != null) {
      materialType = json['materialDetails']['description'];
    }
    if (json['materialDetails'] != null &&
        json['materialDetails']['description'] != null) {
      materialType = json['materialDetails']['description'];
    }
    containsLoading = json['containsLoading'] is String
        ? json['containsLoading'] == "true"
        : json['containsLoading'];
    containsPacking = json['containsPacking'] is String
        ? json['containsPacking'] == "true"
        : json['containsPacking'];
    containsLift = json['containsLift'] is String
        ? json['containsLift'] == true
        : json['containsLift'];
  }

  Map<String, dynamic> toGoodsJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data = toJSON();
    if (payloadWeight != null) {
      data['payloadWeight'] = payloadWeight.toString();
    }
    if (packagingType != null) {
      data['packingDetails'] = packagingType.toString();
    }
    if (materialType != null) data['materialDetails'] = materialType.toString();
    data['containsLoading'] = containsLoading.toString();
    data['containsPacking'] = containsPacking.toString();
    data['containsLift'] = containsLift.toString();
    return data;
  }

  GoodsModel copyWith(GoodsModel goodsModel) {
    return GoodsModel.fromJson(goodsModel.toGoodsJson());
  }
}

class DropdownModel {
  int id;
  String description;

  DropdownModel({required this.id, required this.description});

  factory DropdownModel.fromJson(Map<String, dynamic> json) {
    return DropdownModel(id: json['id'], description: json['description']);
  }

  Map<String, dynamic> toGoodsJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id.toString();
    data['description'] = description;
    return data;
  }
}
