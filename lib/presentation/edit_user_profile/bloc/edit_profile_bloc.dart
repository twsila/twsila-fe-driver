import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:taxi_for_you/data/network/requests.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/domain/usecase/update_profile_usecase.dart';
import 'package:taxi_for_you/utils/ext/enums.dart';
import 'package:taxi_for_you/utils/resources/constants_manager.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../business_owner/registration/model/Business_owner_model.dart';

part 'edit_profile_event.dart';

part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  UpdateProfileUseCase updateProfileUseCase;
  UpdateBOProfileUseCase updateBoProfileUseCase;
  final AppPreferences appPreferences = instance<AppPreferences>();

  EditProfileBloc({
    required this.updateProfileUseCase,
    required this.updateBoProfileUseCase,
  }) : super(EditProfileInitial()) {
    on<EditProfileDataEvent>(_editProfileDataEvent);
  }

  FutureOr<void> _editProfileDataEvent(
      EditProfileDataEvent event, Emitter<EditProfileState> emit) async {
    emit(EditProfileLoading());
    DriverBaseModel? user = appPreferences.getCachedDriver();
    if (user != null) {
      if (user.captainType == RegistrationConstants.captain) {
        (await updateProfileUseCase.execute(
          UpdateProfileUseCaseInput(user.id != null ? user.id! : 0,
              event.firstName, event.lastName, event.email, event.profilePhoto),
        ))
            .fold(
                (failure) => {
                      // left -> failure
                      //emit failure state

                      emit(EditProfileError(
                          failure.message, failure.code.toString()))
                    }, (driverModelResponse) async {
          // right -> data (success)
          // content
          // emit success state

          emit(EditProfileSuccess());

          UserDevice userDevice = await setUserDevice();
          Driver driver = Driver.fromJson(driverModelResponse.result);
          driver.userDevice = userDevice;
          await appPreferences.setDriver(driver);

        });
      } else {
        (await updateBoProfileUseCase.execute(
          UpdateProfileUseCaseInput(user.id != null ? user.id! : 0,
              event.firstName, event.lastName, event.email, event.profilePhoto),
        ))
            .fold(
                (failure) => {
                      // left -> failure
                      //emit failure state

                      emit(EditProfileError(
                          failure.message, failure.code.toString()))
                    }, (driverModelResponse) async {
          // right -> data (success)
          // content
          // emit success state

          emit(EditProfileSuccess());
          UserDevice userDevice = await setUserDevice();
          BusinessOwnerModel driver =
              BusinessOwnerModel.fromJson(driverModelResponse.result);
          driver.userDevice = userDevice;
          await appPreferences.setDriver(driver);
        });
      }
    }
  }

  Future<UserDevice> setUserDevice() async {
    late UserDevice userDevice;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String token = await appPreferences.getFCMToken() ?? '1';

    if (Platform.isIOS) {
      userDevice = UserDevice(
        deviceOs: 'iPhone',
        appVersion: packageInfo.version,
        registrationId: token,
      );
    } else {
      userDevice = UserDevice(
        deviceOs: 'Android',
        appVersion: packageInfo.version,
        registrationId: token,
      );
    }

    return userDevice;
  }
}
