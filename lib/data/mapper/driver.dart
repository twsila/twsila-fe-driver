import 'package:taxi_for_you/utils/resources/constants_manager.dart';

import '../../app/constants.dart';
import '../../domain/model/driver_model.dart';
import '../response/responses.dart';

import '../../app/extensions.dart';

extension LoginResponseMapper on LoginResponse? {
  Driver toDomain() {
    return Driver(
      firstName: this?.driver!.firstName.orEmpty() ?? Constants.empty,
      lastName: this?.driver!.lastName.orEmpty() ?? Constants.empty,
      mobile: this?.driver!.mobile.orEmpty() ?? Constants.empty,
      email: this?.driver!.email.orEmpty() ?? Constants.empty,
      gender: this?.driver!.gender.orEmpty() ?? Constants.empty,
      dateOfBirth: this?.driver!.dateOfBirth.orEmpty() ?? Constants.empty,
      token: this?.token.orEmpty() ?? Constants.empty,
      userDevice: this!.userDevice,
      captainType: RegistrationConstants.captain,
      tokenExpirationTime:
          this?.tokenExpirationTime.orEmpty() ?? Constants.empty,
      id: this?.driver!.id.orZero() ?? Constants.zero,
      serviceType: this?.driver!.serviceType.orEmpty() ?? Constants.empty,
      registrationStatus:
          this?.driver!.registrationStatus.orEmpty() ?? Constants.empty,
      vehicleType: this!.driver!.vehicleType ?? null,
      carManufacturerType: this!.driver!.carManufacturerType,
      carModel: this!.driver!.carModel,
      canTransportFurniture: this?.driver!.canTransportFurniture ?? false,
      canTransportGoods: this?.driver!.canTransportFurniture ?? false,
      canTransportFrozen: this?.driver!.canTransportFurniture ?? false,
      hasWaterTank: this?.driver!.canTransportFurniture ?? false,
      hasOtherTanks: this?.driver!.canTransportFurniture ?? false,
      hasPacking: this?.driver!.canTransportFurniture ?? false,
      hasLoading: this?.driver!.canTransportFurniture ?? false,
      hasAssembly: this?.driver!.canTransportFurniture ?? false,
      hasLifting: this?.driver!.canTransportFurniture ?? false,
      plateNumber: this?.driver!.plateNumber.orEmpty() ?? Constants.empty,
      images: this?.driver!.images ?? [],
      rating: this?.driver!.rating ?? 0.0,
      acknowledged: this?.driver!.acknowledged ?? false,
      driverStatus: this?.driver!.driverStatus.orEmpty() ?? Constants.empty,
    );
  }
}
