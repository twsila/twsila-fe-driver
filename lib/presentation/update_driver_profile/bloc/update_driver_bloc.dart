import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taxi_for_you/app/constants.dart';

import '../../../domain/model/driver_model.dart';

part 'update_driver_event.dart';

part 'update_driver_state.dart';

class UpdateDriverBloc extends Bloc<UpdateDriverEvent, UpdateDriverState> {
  UpdateDriverBloc() : super(UpdateDriverInitial()) {
    on<splitAndOrganizeImagesList>(_splitAndOrganizeImagesList);
  }

  FutureOr<void> _splitAndOrganizeImagesList(splitAndOrganizeImagesList event,
      Emitter<UpdateDriverState> emit) async {
    emit(UpdateDriverLoading());

    List<String> carImageUrls = [];
    List<String> carDocumentsImageUrls = [];
    List<String> driverLicenseImageUrls = [];
    List<String> driverNationalIdImageUrls = [];
    List<String> ownerNationalIdImageUrls = [];

    await Future.forEach(event.driverImagesList, (DriverImage driverImage) {
      if (driverImage.imageName
          .contains(DriverImagesConstants.DRIVER_CAR_PHOTOS_IMAGE_STRING)) {
        carImageUrls.add(driverImage.imageUrl ?? "");
      }
      if (driverImage.imageName.contains(
          DriverImagesConstants.DRIVER_LICENSE_FRONT_IMAGE_STRING) ||
          driverImage.imageName.contains(
              DriverImagesConstants.DRIVER_LICENSE_BACK_IMAGE_STRING)) {
        driverLicenseImageUrls.add(driverImage.imageUrl ?? "");
      }
      if (driverImage.imageName.contains(
          DriverImagesConstants.CAR_DOCUMENT_FRONT_IMAGE_STRING) ||
          driverImage.imageName
              .contains(DriverImagesConstants.CAR_DOCUMENT_BACK_IMAGE_STRING)) {
        carDocumentsImageUrls.add(driverImage.imageUrl ?? "");
      }
      if (driverImage.imageName.contains(
          DriverImagesConstants.DRIVER_NATIONAL_ID_FRONT_IMAGE_STRING) ||
          driverImage.imageName.contains(
              DriverImagesConstants.DRIVER_NATIONAL_ID_BACK_IMAGE_STRING)) {
        driverNationalIdImageUrls.add(driverImage.imageUrl ?? "");
      }
      if (driverImage.imageName.contains(
          DriverImagesConstants.OWNER_NATIONAL_ID_FRONT_IMAGE_STRING) ||
          driverImage.imageName.contains(
              DriverImagesConstants.OWNER_NATIONAL_ID_BACK_IMAGE_STRING)) {
        ownerNationalIdImageUrls.add(driverImage.imageUrl ?? "");
      }
    });

    emit(driverOptimizedImagesSuccessState(
        carImageUrls, carDocumentsImageUrls, driverLicenseImageUrls,
        driverNationalIdImageUrls, ownerNationalIdImageUrls));
  }
}
