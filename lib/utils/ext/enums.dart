import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../../app/constants.dart';
import '../../domain/model/trip_model.dart';

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

String getIconName(String tripType) {
  switch (tripType) {
    case TripTypeConstants.furnitureType:
      return ImageAssets.tripGoodsIc;
    case TripTypeConstants.frozenType:
      return ImageAssets.tripFrozenIc;
    case TripTypeConstants.goodsType:
      return ImageAssets.tripGoodsIc;
    case TripTypeConstants.carAidType:
      return ImageAssets.tripSatahatIc;
    case TripTypeConstants.otherTankType:
      return ImageAssets.tripSwarekIc;
    case TripTypeConstants.drinkWaterType:
      return ImageAssets.tripWaterTankIc;
    default:
      return ImageAssets.tripGoodsIc;
  }
}

String getTitle(String tripType) {
  switch (tripType) {
    case TripTypeConstants.furnitureType:
      return AppStrings.request.tr() +
          ' ' +
          AppStrings.furnitureTransportation.tr();
    case TripTypeConstants.frozenType:
      return AppStrings.request.tr() + ' ' + AppStrings.freezers.tr();
    case TripTypeConstants.goodsType:
      return AppStrings.request.tr() + ' ' + AppStrings.goodsDeliver.tr();
    case TripTypeConstants.carAidType:
      return AppStrings.request.tr() +
          ' ' +
          AppStrings.carAid.tr();
    case TripTypeConstants.otherTankType:
      return AppStrings.request.tr() + ' ' + AppStrings.cisterns.tr();
    case TripTypeConstants.drinkWaterType:
      return AppStrings.wanet.tr() + ' ' + AppStrings.waterCisterns.tr();
    default:
      return AppStrings.request.tr() +
          ' ' +
          AppStrings.furnitureTransportation.tr();
  }
}

String getTripStatusDiscs(String tripStatus) {
  switch (tripStatus) {
    case TripStatusConstants.DRAFT:
      return AppStrings.draft_disc.tr();
    case TripStatusConstants.SUBMITTED:
      return AppStrings.submitted_disc.tr();
    case TripStatusConstants.EVALUATION:
      return AppStrings.evaluated_disc.tr();
    case TripStatusConstants.PAYMENT:
      return AppStrings.payment_disc.tr();
    case TripStatusConstants.WAIT_FOR_TAKEOFF:
      return AppStrings.wait_for_take_of_disc.tr();
    case TripStatusConstants.TAKEOFF:
      return AppStrings.take_off_disc.tr();
    case TripStatusConstants.EXECUTED:
      return AppStrings.executed_disc.tr();
    case TripStatusConstants.COMPLETED:
      return AppStrings.completed_disc.tr();
    case TripStatusConstants.CANCELLED:
      return AppStrings.canceled_disc.tr();
    default:
      return "";
  }
}



String getTripStatusSubDis(String tripStatus) {
  switch (tripStatus) {
    case TripStatusConstants.DRAFT:
      return "";
    case TripStatusConstants.SUBMITTED:
      return "";
    case TripStatusConstants.EVALUATION:
      return "";
    case TripStatusConstants.PAYMENT:
      return "";
    case TripStatusConstants.WAIT_FOR_TAKEOFF:
      return '${AppStrings.estimatedTimeToArrivePickupLocationIs.tr()} 15 ${AppStrings.minute.tr()}';
    case TripStatusConstants.TAKEOFF:
      return '${AppStrings.pleaseShipGoodsAndMoveToDestinationLocation.tr()}';
    case TripStatusConstants.EXECUTED:
      return '${AppStrings.pleaseLeaveGoodsAndCloseTheTrip.tr()}';
    case TripStatusConstants.COMPLETED:
      return "";
    case TripStatusConstants.CANCELLED:
      return "";
    default:
      return "";
  }
}

Color getTripStatusDisColor(String tripStatus) {
  switch (tripStatus) {
    case TripStatusConstants.DRAFT:
      return ColorManager.supportTextColor;
    case TripStatusConstants.SUBMITTED:
      return ColorManager.supportTextColor;
    case TripStatusConstants.EVALUATION:
      return ColorManager.supportTextColor;
    case TripStatusConstants.PAYMENT:
      return ColorManager.supportTextColor;
    case TripStatusConstants.WAIT_FOR_TAKEOFF:
      return ColorManager.primary;
    case TripStatusConstants.TAKEOFF:
      return ColorManager.primary;
    case TripStatusConstants.EXECUTED:
      return ColorManager.primary;
    case TripStatusConstants.COMPLETED:
      return ColorManager.primary;
    case TripStatusConstants.CANCELLED:
      return ColorManager.error;
    default:
      return ColorManager.secondaryColor;
  }
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
