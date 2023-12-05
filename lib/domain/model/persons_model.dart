import 'package:taxi_for_you/domain/model/lookups_model.dart';
import 'package:taxi_for_you/domain/model/transportation_base_model.dart';
import 'package:taxi_for_you/domain/model/vehicle_model.dart';

class PersonsModel extends TransportationBaseModel {
  bool isWoman = false;
  VehicleModel? vehicleType;
  int? vehicleId;

  PersonsModel();

  PersonsModel.fromJson(Map<String, dynamic> json) {
    fromJSON(json);
    isWoman = json['isWoman'] == null
        ? false
        : json['isWoman'] is String
            ? json['isWoman'] == 'true'
            : json['isWoman'];
    vehicleType = json['vehicleType'] != null
        ? VehicleModel.fromJson(json['vehicleType'])
        : null;
  }

  Map<String, dynamic> toPersonsJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data = toJSON();
    if (vehicleType != null) {
      data['vehicleType'] = vehicleType;
    }
    data['isWoman'] = isWoman.toString();
    return data;
  }

  PersonsModel copyWith(PersonsModel personsModel) {
    return PersonsModel.fromJson(personsModel.toPersonsJson());
  }
}
