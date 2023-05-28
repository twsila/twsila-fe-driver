import 'package:taxi_for_you/domain/model/vehicleModel.dart';

class ServiceTypeModel {
  String serviceName;
  List<VehicleModel> VehicleModels;
  bool isSelected;

  ServiceTypeModel(this.serviceName, this.VehicleModels,{this.isSelected = false});
}
