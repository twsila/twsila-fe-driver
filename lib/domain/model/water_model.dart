import 'package:taxi_for_you/domain/model/transportation_base_model.dart';

import 'lookup_item.dart';

class WaterModel extends TransportationBaseModel {
  LookupItem? tankType;

  WaterModel();

  WaterModel.fromJson(Map<String, dynamic> json) {
    fromJSON(json);
    if (json['tankSize'] != null) {
      tankType = LookupItem.fromJson(json['tankSize']);
    }
  }

  Map<String, dynamic> toWaterJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data = toJSON();
    if (tankType != null) {
      data['tankSize'] = tankType!.id.toString();
    }
    return data;
  }

  Map<String, dynamic> toWaterCopyJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data = toJSON();
    if (tankType != null) {
      data['tankSize'] = tankType!.toJson();
    }
    return data;
  }

  WaterModel copyWith(WaterModel waterModel) {
    return WaterModel.fromJson(waterModel.toWaterCopyJson());
  }
}
