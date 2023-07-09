import 'package:easy_localization/easy_localization.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

enum AcceptanceType { PROPOSED, ACCEPTED, EXPIRED }

enum ShippingType { CHILLER, FROZEN, DRY }

enum DriverServiceType { PROPOSED, ACCEPTED, EXPIRED }

enum TankType { PROPOSED, ACCEPTED, EXPIRED }

enum SubmitStatus { SUBMITTED, NOT_SUBMITTED }

enum RegistrationStatus { PENDING, APPROVED }

enum NotificationType {
  REQUEST_EXECUTION,
  EARLY_NOTIFICATION_ON_TRIP_DAY,
  DRIVER_ON_HIS_WAY,
  DRIVER_ARRIVED,
  TRIP_LAUNCHED,
  TRIP_FINISHED
}

enum TripType {
  PERSON,
  CAR_AID,
  DRINK_WATER_TANK,
  FROZEN,
  FURNITURE,
  GOODS,
  OTHER_TANK
}

extension TripTypeIcon on TripType {
  String getIconAsset() {
    switch (this) {
      case TripType.PERSON:
        return ImageAssets.tripPersonsIc;
      case TripType.CAR_AID:
        return ImageAssets.tripPersonsIc;
      case TripType.DRINK_WATER_TANK:
        return ImageAssets.tripWaterTankIc;
      case TripType.FROZEN:
        return ImageAssets.tripFrozenIc;
      case TripType.FURNITURE:
        return ImageAssets.tripGoodsIc;
      case TripType.GOODS:
        return ImageAssets.tripGoodsIc;
      case TripType.OTHER_TANK:
        return ImageAssets.tripSwarekIc;
    }
  }
}

extension TripTypeTitle on TripType {
  String getTripTitle() {
    switch (this) {
      case TripType.PERSON:
        return AppStrings.personsTransportation.tr();
      case TripType.CAR_AID:
        return AppStrings.personsTransportation.tr();
      case TripType.DRINK_WATER_TANK:
        return AppStrings.waterCisterns.tr();
      case TripType.FROZEN:
        return AppStrings.freezers.tr();
      case TripType.FURNITURE:
        return AppStrings.furnitureTransportation.tr();
      case TripType.GOODS:
        return AppStrings.goodsDeliver.tr();
      case TripType.OTHER_TANK:
        return AppStrings.cisterns.tr();
    }
  }
}

enum TripModelType {
  ALL_TRIPS,
  SCHEDULED_TRIPS,
  TODAY_TRIPS,
  OFFERED_TRIPS,
  OLD_TRIPS
}

enum TripStatus {
  DRAFT,
  SUBMITTED,
  EVALUATION,
  PAYMENT,
  WAIT_FOR_TAKEOFF,
  TAKEOFF,
  EXECUTED,
  COMPLETED,
  CANCELLED
}
