import 'package:taxi_for_you/domain/model/transportation_base_model.dart';
class WaterModel extends TransportationBaseModel {
  String? tankDetails;

  WaterModel();

  WaterModel.fromJson(Map<String, dynamic> json) {
    fromJSON(json);
    tankDetails = json['tankDetails'];
  }

  Map<String, dynamic> toWaterJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data = toJSON();
    if (tankDetails != null) data['tankDetails'] = tankDetails.toString();
    return data;
  }

  WaterModel copyWith(WaterModel waterModel) {
    return WaterModel.fromJson(waterModel.toWaterJson());
  }
}
