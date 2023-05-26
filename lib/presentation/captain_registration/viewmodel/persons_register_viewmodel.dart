import 'dart:async';
import 'dart:io';
import 'package:taxi_for_you/domain/model/models.dart';

import '../../../domain/usecase/persons_register_usecase.dart';
import '../../base/baseviewmodel.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../app/functions.dart';
import '../../common/freezed_data_classes.dart';
import '../../common/state_renderer/state_renderer.dart';
import '../../common/state_renderer/state_renderer_impl.dart';
import '../../../utils/resources/strings_manager.dart';

class PersonsRegisterViewModel extends BaseViewModel
    with PersonsRegisterViewModelInput, PersonsRegisterViewModelOutput {
  StreamController serviceTypeStreamController =
      StreamController<String>.broadcast();
  StreamController serviceTypeCapacityStreamController =
      StreamController<String>.broadcast();
  StreamController plateNumberStreamController =
      StreamController<int>.broadcast();
  StreamController notesStreamController = StreamController<String>.broadcast();
  StreamController carBrandAndModelStreamController =
      StreamController<String>.broadcast();
  StreamController carDocumentFrontStreamController =
      StreamController<File>.broadcast();
  StreamController carOwnerLicenseFrontImageStreamController =
      StreamController<File>.broadcast();
  StreamController carOwnerIdentityCardFrontImageStreamController =
      StreamController<File>.broadcast();
  StreamController carDriverIdentityCardFrontImageStreamController =
      StreamController<File>.broadcast();
  StreamController carDocumentBackStreamController =
      StreamController<File>.broadcast();
  StreamController carOwnerLicenseBackImageStreamController =
      StreamController<File>.broadcast();
  StreamController carOwnerIdentityCardBackImageStreamController =
      StreamController<File>.broadcast();
  StreamController carDriverIdentityCardBackImageStreamController =
      StreamController<File>.broadcast();

  StreamController carDocumentExpireDateStreamController =
      StreamController<String>.broadcast();
  StreamController carOwnerLicenseExpireDateStreamController =
      StreamController<String>.broadcast();
  StreamController carOwnerIdentityCardExpireDateStreamController =
      StreamController<String>.broadcast();
  StreamController carDriverIdentityCardExpireDateStreamController =
      StreamController<String>.broadcast();

  StreamController areAllCarDocumentIsValidStreamController =
      StreamController<void>.broadcast();
  StreamController areAllCarOwnerIdentityIsValidStreamController =
      StreamController<void>.broadcast();
  StreamController areAllCarDriverLicenseIsValidStreamController =
      StreamController<void>.broadcast();
  StreamController areAllCarDriverIdentityIsValidStreamController =
      StreamController<void>.broadcast();

  StreamController areAllInputsValidStreamController =
      StreamController<void>.broadcast();

  StreamController isUserRegisteredInSuccessfullyStreamController =
      StreamController<bool>();
  final PersonsRegisterUseCase _registerUseCase;
  var registerObject = DriverRegstrationObj(
    "",
    "",
    0,
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  );

  PersonsRegisterViewModel(this._registerUseCase);

  // inputs
  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    serviceTypeStreamController.close();
    serviceTypeCapacityStreamController.close();
    plateNumberStreamController.close();
    notesStreamController.close();
    carBrandAndModelStreamController.close();
    areAllInputsValidStreamController.close();
    areAllCarDocumentIsValidStreamController.close();
    areAllCarOwnerIdentityIsValidStreamController.close();
    areAllCarDriverLicenseIsValidStreamController.close();
    areAllCarDriverIdentityIsValidStreamController.close();
    isUserRegisteredInSuccessfullyStreamController.close();
    carOwnerLicenseFrontImageStreamController.close();
    carOwnerIdentityCardFrontImageStreamController.close();
    carDriverIdentityCardFrontImageStreamController.close();
    carDocumentFrontStreamController.close();
    carDocumentBackStreamController.close();
    carOwnerLicenseBackImageStreamController.close();
    carOwnerIdentityCardBackImageStreamController.close();
    carDriverIdentityCardBackImageStreamController.close();
    carOwnerLicenseExpireDateStreamController.close();
    carOwnerIdentityCardExpireDateStreamController.close();
    carDriverIdentityCardExpireDateStreamController.close();
    carDocumentExpireDateStreamController.close();
    super.dispose();
  }

  @override
  Sink get inputAllInputsValid => areAllInputsValidStreamController.sink;

  @override
  register() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));

    (await _registerUseCase.execute(PersonsRegisterUseCaseInput(
            registerObject.serviceType,
            registerObject.serviceTypeCapacity,
            registerObject.plateNumber,
            registerObject.notes,
            registerObject.carBrandAndModel,
            registerObject.carDocumentFrontImage,
            registerObject.carOwnerLicenseFrontImage,
            registerObject.carOwnerIdentityCardFrontImage,
            registerObject.carDriverIdentityCardFrontImage)))
        .fold(
            (failure) => {
                  // left -> failure
                  inputState.add(ErrorState(
                      StateRendererType.popupErrorState, failure.message))
                }, (data) {
      // right -> data (success)
      // content
      inputState.add(ContentState());
      // navigate to main screen
      isUserRegisteredInSuccessfullyStreamController.add(true);
    });
  }

  @override
  // Stream<String?> get outputErrorPassword =>
  //     outputIsPasswordValid.map((isPasswordValid) =>
  //         isPasswordValid ? null : AppStrings.passwordInvalid.tr());

  @override
  Stream<bool> get outputAreAllInputsValid =>
      areAllInputsValidStreamController.stream.map((_) => _areAllInputsValid());

  // --  private functions

  bool _isCarBrandAndModelValid(String userName) {
    return true;
  }

  bool _isNotesValid(String userName) {
    return true;
  }

  bool _isPlateNumberValid(int userName) {
    return true;
  }

  bool _isMobileNumberValid(String mobileNumber) {
    return mobileNumber.length >= 10;
  }

  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }

  bool _areAllInputsValid() {
    return registerObject.serviceType.isNotEmpty &&
        registerObject.plateNumber != 0 &&
        registerObject.carBrandAndModel.isNotEmpty &&
        registerObject.carDocumentFrontImage.isNotEmpty &&
        registerObject.carDocumentBackImage.isNotEmpty &&
        registerObject.carDriverIdentityCardFrontImage.isNotEmpty &&
        registerObject.carDriverIdentityCardBackImage.isNotEmpty &&
        registerObject.carDriverIdentityCardExpireDate.isNotEmpty &&
        registerObject.carOwnerLicenseFrontImage.isNotEmpty &&
        registerObject.carOwnerLicenseBackImage.isNotEmpty &&
        registerObject.carOwnerLicenseExpireDate.isNotEmpty &&
        registerObject.carOwnerIdentityCardFrontImage.isNotEmpty &&
        registerObject.carOwnerIdentityCardBackImage.isNotEmpty &&
        registerObject.carOwnerIdentityCardExpireDate.isNotEmpty;
  }

  bool _areAllCarDocumentInputsValid() {
    return registerObject.carDocumentExpireDate.isNotEmpty &&
        registerObject.carDocumentBackImage.isNotEmpty &&
        registerObject.carDocumentFrontImage.isNotEmpty;
  }

  bool _areAllCarDriverLicenseInputsValid() {
    return registerObject.carOwnerLicenseExpireDate.isNotEmpty &&
        registerObject.carOwnerLicenseBackImage.isNotEmpty &&
        registerObject.carOwnerLicenseFrontImage.isNotEmpty;
  }

  bool _areAllCarDriverIdentityInputsValid() {
    return registerObject.carDriverIdentityCardExpireDate.isNotEmpty &&
        registerObject.carDriverIdentityCardBackImage.isNotEmpty &&
        registerObject.carDriverIdentityCardFrontImage.isNotEmpty;
  }

  bool _areAllCarOwnerIdentityInputsValid() {
    return registerObject.carOwnerIdentityCardExpireDate.isNotEmpty &&
        registerObject.carOwnerIdentityCardFrontImage.isNotEmpty &&
        registerObject.carOwnerIdentityCardBackImage.isNotEmpty;
  }

  validate() {
    inputAllInputsValid.add(null);
    inputCarDocumentInputsValid.add(null);
    inputAllCarDriverIdentityInputsValid.add(null);
    inputAllCarOwnerIdentityInputsValid.add(null);
    inputAllCarDriverLicenseInputsValid.add(null);
  }

  @override
  Sink get inputCarDocumentFrontImage => carDocumentFrontStreamController.sink;

  @override
  Sink get inputCarDriverIdentityCardFrontImage =>
      carDriverIdentityCardFrontImageStreamController.sink;

  @override
  Sink get inputCarOwnerIdentityCardFrontImage =>
      carOwnerIdentityCardFrontImageStreamController.sink;

  @override
  Sink get inputCarOwnerLicenseFrontImage =>
      carOwnerLicenseFrontImageStreamController.sink;

  @override
  Sink get inputCarDocumentBackImage => carDocumentBackStreamController.sink;

  @override
  Sink get inputCarDriverIdentityCardBackImage =>
      carDriverIdentityCardBackImageStreamController.sink;

  @override
  Sink get inputCarOwnerIdentityCardBackImage =>
      carOwnerIdentityCardBackImageStreamController.sink;

  @override
  Sink get inputCarOwnerLicenseBackImage =>
      carOwnerLicenseBackImageStreamController.sink;

  @override
  Sink get inputCardBrandAndModel => carBrandAndModelStreamController.sink;

  @override
  Sink get inputNotes => notesStreamController.sink;

  @override
  Sink get inputPlateNumber => plateNumberStreamController.sink;

  @override
  Sink get inputServiceCapacity => serviceTypeCapacityStreamController.sink;

  @override
  Sink get inputServiceType => serviceTypeStreamController.sink;

  @override
  Sink get inputCarDocumentExpireDate =>
      carDocumentExpireDateStreamController.sink;

  @override
  Sink get inputCarDriverIdentityCardExpireDate =>
      carDriverIdentityCardExpireDateStreamController.sink;

  @override
  Sink get inputCarOwnerIdentityCardExpireDate =>
      carOwnerIdentityCardExpireDateStreamController.sink;

  @override
  Sink get inputCarOwnerLicenseExpireDate =>
      carOwnerLicenseExpireDateStreamController.sink;

  @override
  Sink get inputAllCarDriverIdentityInputsValid =>
      areAllCarDriverIdentityIsValidStreamController.sink;

  @override
  Sink get inputAllCarDriverLicenseInputsValid =>
      areAllCarDriverLicenseIsValidStreamController.sink;

  @override
  Sink get inputAllCarOwnerIdentityInputsValid =>
      areAllCarOwnerIdentityIsValidStreamController.sink;

  @override
  Sink get inputCarDocumentInputsValid =>
      areAllCarDocumentIsValidStreamController.sink;

  @override
  Stream<File> get outputCarDocumentFrontImage =>
      carDocumentFrontStreamController.stream.map((file) => file);

  @override
  Stream<File> get outputCarDriverIdentityCardFrontImage =>
      carDriverIdentityCardFrontImageStreamController.stream
          .map((file) => file);

  @override
  Stream<File> get outputCarOwnerIdentityCardFrontImage =>
      carOwnerIdentityCardFrontImageStreamController.stream.map((file) => file);

  @override
  Stream<File> get outputCarOwnerLicenseFrontImage =>
      carOwnerLicenseFrontImageStreamController.stream.map((file) => file);

  @override
  Stream<File> get outputCarDocumentBackImage =>
      carDocumentBackStreamController.stream.map((file) => file);

  @override
  Stream<File> get outputCarDriverIdentityCardBackImage =>
      carDriverIdentityCardBackImageStreamController.stream.map((file) => file);

  @override
  Stream<File> get outputCarOwnerIdentityCardBackImage =>
      carOwnerIdentityCardBackImageStreamController.stream.map((file) => file);

  @override
  Stream<File> get outputCarOwnerLicenseBackImage =>
      carOwnerLicenseBackImageStreamController.stream.map((file) => file);

  @override
  Stream<String> get outputCarDocumentExpireDate =>
      carDocumentExpireDateStreamController.stream
          .map((expireDate) => expireDate);

  @override
  Stream<String> get outputCarDriverIdentityCardExpireDate =>
      carDriverIdentityCardExpireDateStreamController.stream
          .map((expireDate) => expireDate);

  @override
  Stream<String> get outputCarOwnerIdentityCardExpireDate =>
      carOwnerIdentityCardExpireDateStreamController.stream
          .map((expireDate) => expireDate);

  @override
  Stream<bool> get outputAreAllCarDocumentsInputsValid =>
      areAllCarDocumentIsValidStreamController.stream
          .map((_) => _areAllCarDocumentInputsValid());

  @override
  Stream<bool> get outputAreAllCarDriverIdentityInputsValid =>
      areAllCarDriverIdentityIsValidStreamController.stream
          .map((_) => _areAllCarDriverIdentityInputsValid());

  @override
  Stream<bool> get outputAreCarDriverLicenseInputsValid =>
      areAllCarDriverLicenseIsValidStreamController.stream
          .map((_) => _areAllCarDriverLicenseInputsValid());

  @override
  Stream<bool> get outputAreCarOwnerIdentityInputsValid =>
      areAllCarOwnerIdentityIsValidStreamController.stream
          .map((_) => _areAllCarOwnerIdentityInputsValid());

  @override
  Stream<String> get outputCarOwnerLicenseExpireDate =>
      carOwnerLicenseExpireDateStreamController.stream
          .map((expireDate) => expireDate);

  @override
  Stream<String?> get outputErrorCardBrandAndModel =>
      throw UnimplementedError();

  @override
  Stream<String?> get outputErrorNotes => throw UnimplementedError();

  @override
  Stream<String?> get outputErrorPlateNumber => throw UnimplementedError();

  @override
  Stream<bool> get outputIsCardBrandAndModelValid =>
      carBrandAndModelStreamController.stream.map(
          (carBrandAndModel) => _isCarBrandAndModelValid(carBrandAndModel));

  @override
  Stream<bool> get outputIsNotesValid =>
      notesStreamController.stream.map((notes) => _isNotesValid(notes));

  @override
  Stream<bool> get outputIsPlateNumberValid =>
      plateNumberStreamController.stream
          .map((PlateNumber) => _isPlateNumberValid(PlateNumber));

  @override
  // TODO: implement outputServiceType
  Stream<bool> get outputServiceType =>
      serviceTypeStreamController.stream.map((serviceType) =>
          serviceType == AppStrings.personsTransportation.tr() ? true : false);

  @override
  setCarDocumentFrontImage(File carDocumentFrontImage) {
    inputCarDocumentFrontImage.add(carDocumentFrontImage);
    if (carDocumentFrontImage.path.isNotEmpty) {
      //  update register view object
      registerObject.carDocumentFrontImage = carDocumentFrontImage.path;
    } else {
      // reset profilePicture value in register view object
      registerObject.carDocumentFrontImage = "";
    }
    validate();
  }

  @override
  setCarDriverIdentityCardFrontImage(File carDriverIdentityCardFrontImage) {
    inputCarDriverIdentityCardFrontImage.add(carDriverIdentityCardFrontImage);
    if (carDriverIdentityCardFrontImage.path.isNotEmpty) {
      //  update register view object
      registerObject.carDriverIdentityCardFrontImage =
          carDriverIdentityCardFrontImage.path;
    } else {
      // reset profilePicture value in register view object
      registerObject.carDriverIdentityCardFrontImage = "";
    }
    validate();
  }

  @override
  setCarOwnerIdentityCardFrontImage(File carOwnerIdentityCardFrontImage) {
    inputCarOwnerIdentityCardFrontImage.add(carOwnerIdentityCardFrontImage);
    if (carOwnerIdentityCardFrontImage.path.isNotEmpty) {
      //  update register view object
      registerObject.carOwnerIdentityCardFrontImage =
          carOwnerIdentityCardFrontImage.path;
    } else {
      // reset profilePicture value in register view object
      registerObject.carOwnerIdentityCardFrontImage = "";
    }
    validate();
  }

  @override
  setCarOwnerLicenseFrontImage(File carOwnerLicenseFrontImage) {
    inputCarOwnerLicenseFrontImage.add(carOwnerLicenseFrontImage);
    if (carOwnerLicenseFrontImage.path.isNotEmpty) {
      //  update register view object
      registerObject.carOwnerLicenseFrontImage = carOwnerLicenseFrontImage.path;
    } else {
      // reset profilePicture value in register view object
      registerObject.carOwnerLicenseFrontImage = "";
    }
    validate();
  }

  @override
  setCarDocumentBackImage(File carDocumentBackImage) {
    inputCarDocumentBackImage.add(carDocumentBackImage);
    if (carDocumentBackImage.path.isNotEmpty) {
      //  update register view object
      registerObject.carDocumentBackImage = carDocumentBackImage.path;
    } else {
      // reset profilePicture value in register view object
      registerObject.carDocumentBackImage = "";
    }
    validate();
  }

  @override
  setCarDriverIdentityCardBackImage(File carDriverIdentityCardBackImage) {
    inputCarDriverIdentityCardBackImage.add(carDriverIdentityCardBackImage);
    if (carDriverIdentityCardBackImage.path.isNotEmpty) {
      //  update register view object
      registerObject.carDriverIdentityCardBackImage =
          carDriverIdentityCardBackImage.path;
    } else {
      // reset profilePicture value in register view object
      registerObject.carDriverIdentityCardBackImage = "";
    }
    validate();
  }

  @override
  setCarOwnerIdentityCardBackImage(File carOwnerIdentityCardBackImage) {
    inputCarOwnerIdentityCardBackImage.add(carOwnerIdentityCardBackImage);
    if (carOwnerIdentityCardBackImage.path.isNotEmpty) {
      //  update register view object
      registerObject.carOwnerIdentityCardBackImage =
          carOwnerIdentityCardBackImage.path;
    } else {
      // reset profilePicture value in register view object
      registerObject.carOwnerIdentityCardBackImage = "";
    }
    validate();
  }

  @override
  setCarOwnerLicenseBackImage(File carOwnerLicenseBackImage) {
    inputCarOwnerLicenseBackImage.add(carOwnerLicenseBackImage);
    if (carOwnerLicenseBackImage.path.isNotEmpty) {
      //  update register view object
      registerObject.carOwnerLicenseBackImage = carOwnerLicenseBackImage.path;
    } else {
      // reset profilePicture value in register view object
      registerObject.carOwnerLicenseBackImage = "";
    }
    validate();
  }

  @override
  setCardBrandAndModel(String cardBrandAndModel) {
    inputCardBrandAndModel.add(cardBrandAndModel);
    if (_isCarBrandAndModelValid(cardBrandAndModel)) {
      //  update register view object
      registerObject.carBrandAndModel = cardBrandAndModel;
    } else {
      // reset email value in register view object
      registerObject.carBrandAndModel = "";
    }
    validate();
  }

  @override
  setNotes(String note) {
    inputNotes.add(note);
    if (_isNotesValid(note)) {
      //  update register view object
      registerObject.notes = note;
    } else {
      // reset email value in register view object
      registerObject.notes = "";
    }
    validate();
  }

  @override
  setPlateNumber(int plateNumber) {
    inputPlateNumber.add(plateNumber);
    if (_isPlateNumberValid(plateNumber)) {
      //  update register view object
      registerObject.plateNumber = plateNumber;
    } else {
      // reset email value in register view object
      registerObject.plateNumber = 0;
    }
    validate();
  }

  @override
  setServiceCapacity(String serviceCapacity) {
    inputServiceCapacity.add(serviceCapacity);
    registerObject.serviceTypeCapacity = serviceCapacity;
    validate();
  }

  @override
  setServiceType(String serviceType) {
    inputServiceType.add(serviceType);
    registerObject.serviceType = serviceType;
    validate();
  }

  @override
  setCarDocumentExpireDate(String carDocumentExpireDate) {
    inputCarDocumentExpireDate.add(carDocumentExpireDate);
    registerObject.carDocumentExpireDate = carDocumentExpireDate;
    validate();
  }

  @override
  setCarDriverIdentityCardExpireDate(String carDriverIdentityCardExpireDate) {
    inputCarDriverIdentityCardExpireDate.add(carDriverIdentityCardExpireDate);
    registerObject.carDriverIdentityCardExpireDate =
        carDriverIdentityCardExpireDate;
    validate();
  }

  @override
  setCarOwnerIdentityCardExpireDate(String carOwnerIdentityCardExpireDate) {
    inputCarOwnerIdentityCardExpireDate.add(carOwnerIdentityCardExpireDate);
    registerObject.carOwnerIdentityCardExpireDate =
        carOwnerIdentityCardExpireDate;
    validate();
  }

  @override
  setCarOwnerLicenseExpireDate(String carOwnerLicenseExpireDate) {
    inputCarOwnerLicenseExpireDate.add(carOwnerLicenseExpireDate);
    registerObject.carOwnerLicenseExpireDate = carOwnerLicenseExpireDate;
    validate();
  }
}

abstract class PersonsRegisterViewModelInput {
  Sink get inputServiceType;

  Sink get inputServiceCapacity;

  Sink get inputNotes;

  Sink get inputPlateNumber;

  Sink get inputCardBrandAndModel;

  Sink get inputCarDocumentFrontImage;

  Sink get inputCarDocumentBackImage;

  Sink get inputCarDocumentExpireDate;

  Sink get inputCarOwnerLicenseFrontImage;

  Sink get inputCarOwnerLicenseBackImage;

  Sink get inputCarOwnerLicenseExpireDate;

  Sink get inputCarOwnerIdentityCardFrontImage;

  Sink get inputCarOwnerIdentityCardBackImage;

  Sink get inputCarOwnerIdentityCardExpireDate;

  Sink get inputCarDriverIdentityCardFrontImage;

  Sink get inputCarDriverIdentityCardBackImage;

  Sink get inputCarDriverIdentityCardExpireDate;

  Sink get inputCarDocumentInputsValid;

  Sink get inputAllCarDriverLicenseInputsValid;

  Sink get inputAllCarOwnerIdentityInputsValid;

  Sink get inputAllCarDriverIdentityInputsValid;

  Sink get inputAllInputsValid;

  register();

  setServiceType(String serviceType);

  setServiceCapacity(String serviceCapacity);

  setNotes(String note);

  setPlateNumber(int plateNumber);

  setCardBrandAndModel(String cardBrandAndModel);

  setCarDocumentFrontImage(File carDocumentImage);

  setCarDocumentBackImage(File carDocumentImage);

  setCarDocumentExpireDate(String carDocumentExpireDate);

  setCarOwnerLicenseFrontImage(File carOwnerLicenseImage);

  setCarOwnerLicenseBackImage(File carOwnerLicenseImage);

  setCarOwnerLicenseExpireDate(String carOwnerLicenseExpireDate);

  setCarOwnerIdentityCardFrontImage(File carOwnerIdentityCardImage);

  setCarOwnerIdentityCardBackImage(File carOwnerIdentityCardImage);

  setCarOwnerIdentityCardExpireDate(String carOwnerIdentityCardExpireDate);

  setCarDriverIdentityCardFrontImage(File carDriverIdentityCardImage);

  setCarDriverIdentityCardBackImage(File carDriverIdentityCardImage);

  setCarDriverIdentityCardExpireDate(String carDriverIdentityCardExpireDate);
}

abstract class PersonsRegisterViewModelOutput {
  Stream<bool> get outputServiceType;

  Stream<bool> get outputIsPlateNumberValid;

  Stream<String?> get outputErrorPlateNumber;

  Stream<bool> get outputIsCardBrandAndModelValid;

  Stream<String?> get outputErrorCardBrandAndModel;

  Stream<bool> get outputIsNotesValid;

  Stream<String?> get outputErrorNotes;

  Stream<File> get outputCarDocumentFrontImage;

  Stream<File> get outputCarDocumentBackImage;

  Stream<String> get outputCarDocumentExpireDate;

  Stream<File> get outputCarOwnerLicenseFrontImage;

  Stream<File> get outputCarOwnerLicenseBackImage;

  Stream<String> get outputCarOwnerLicenseExpireDate;

  Stream<File> get outputCarOwnerIdentityCardFrontImage;

  Stream<File> get outputCarOwnerIdentityCardBackImage;

  Stream<String> get outputCarOwnerIdentityCardExpireDate;

  Stream<File> get outputCarDriverIdentityCardFrontImage;

  Stream<File> get outputCarDriverIdentityCardBackImage;

  Stream<String> get outputCarDriverIdentityCardExpireDate;

  Stream<bool> get outputAreAllCarDocumentsInputsValid;

  Stream<bool> get outputAreCarOwnerIdentityInputsValid;

  Stream<bool> get outputAreCarDriverLicenseInputsValid;

  Stream<bool> get outputAreAllCarDriverIdentityInputsValid;

  Stream<bool> get outputAreAllInputsValid;
}
