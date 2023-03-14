import 'dart:async';
import 'dart:io';
import 'package:taxi_for_you/domain/model/models.dart';

import '../../../domain/usecase/register_usecase.dart';
import '../../base/baseviewmodel.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../app/functions.dart';
import '../../common/freezed_data_classes.dart';
import '../../common/state_renderer/state_renderer.dart';
import '../../common/state_renderer/state_renderer_impl.dart';
import '../../../utils/resources/strings_manager.dart';

class RegisterViewModel extends BaseViewModel
    with RegisterViewModelInput, RegisterViewModelOutput {
  StreamController serviceTypeStreamController =
  StreamController<String>.broadcast();
  StreamController serviceTypeCapacityStreamController =
  StreamController<String>.broadcast();
  StreamController plateNumberStreamController =
  StreamController<int>.broadcast();
  StreamController notesStreamController = StreamController<String>.broadcast();
  StreamController carBrandAndModelStreamController =
  StreamController<String>.broadcast();
  StreamController carDocumentStreamController =
  StreamController<File>.broadcast();
  StreamController carOwnerLicenseImageStreamController =
  StreamController<File>.broadcast();
  StreamController carOwnerIdentityCardImageStreamController =
  StreamController<File>.broadcast();
  StreamController carDriverIdentityCardImageStreamController =
  StreamController<File>.broadcast();
  StreamController areAllInputsValidStreamController =
  StreamController<void>.broadcast();

  StreamController isUserRegisteredInSuccessfullyStreamController =
  StreamController<bool>();
  final RegisterUseCase _registerUseCase;
  var registerObject = DriverRegstrationObj(
      "",
      "",
      0,
      "",
      "",
      "",
      "",
      "",
      "");

  RegisterViewModel(this._registerUseCase);

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
    carOwnerLicenseImageStreamController.close();
    carOwnerIdentityCardImageStreamController.close();
    carDriverIdentityCardImageStreamController.close();
    carDocumentStreamController.close();
    areAllInputsValidStreamController.close();
    isUserRegisteredInSuccessfullyStreamController.close();
    super.dispose();
  }

  @override
  Sink get inputAllInputsValid => areAllInputsValidStreamController.sink;

  @override
  register() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));

    (await _registerUseCase.execute(RegisterUseCaseInput(
        registerObject.serviceType,
        registerObject.serviceTypeCapacity,
        registerObject.plateNumber,
        registerObject.notes,
        registerObject.carBrandAndModel,
        registerObject.carDocumentImage,
        registerObject.carOwnerLicenseImage,
        registerObject.carOwnerIdentityCardImage,
        registerObject.carDriverIdentityCardImage)))
        .fold(
            (failure) =>
        {
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
        registerObject.carDocumentImage.isNotEmpty &&
        registerObject.carDriverIdentityCardImage.isNotEmpty &&
        registerObject.carOwnerLicenseImage.isNotEmpty &&
        registerObject.carOwnerIdentityCardImage.isNotEmpty;
  }

  validate() {
    inputAllInputsValid.add(null);
  }

  @override
  Sink get inputCarDocumentImage => carDocumentStreamController.sink;

  @override
  Sink get inputCarDriverIdentityCardImage =>
      carDriverIdentityCardImageStreamController.sink;

  @override
  Sink get inputCarOwnerIdentityCardImage =>
      carOwnerIdentityCardImageStreamController.sink;

  @override
  Sink get inputCarOwnerLicenseImage =>
      carOwnerLicenseImageStreamController.sink;

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
  Stream<File> get outputCarDocumentImage =>
      carDocumentStreamController.stream.map((file) => file);

  @override
  Stream<File> get outputCarDriverIdentityCardImage =>
      carDriverIdentityCardImageStreamController.stream.map((file) => file);

  @override
  Stream<File> get outputCarOwnerIdentityCardImage =>
      carOwnerIdentityCardImageStreamController.stream.map((file) => file);

  @override
  Stream<File> get outputCarOwnerLicenseImage =>
      carOwnerLicenseImageStreamController.stream.map((file) => file);

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
      serviceTypeStreamController.stream.map((serviceType) => serviceType ==
          "نقل افراد" ? true : false);

  @override
  setCarDocumentImage(File carDocumentImage) {
    inputCarDocumentImage.add(carDocumentImage);
    if (carDocumentImage.path.isNotEmpty) {
      //  update register view object
      registerObject.carDocumentImage = carDocumentImage.path;
    } else {
      // reset profilePicture value in register view object
      registerObject.carDocumentImage = "";
    }
    validate();
  }

  @override
  setCarDriverIdentityCardImage(File carDriverIdentityCardImage) {
    inputCarDriverIdentityCardImage.add(carDriverIdentityCardImage);
    if (carDriverIdentityCardImage.path.isNotEmpty) {
      //  update register view object
      registerObject.carDriverIdentityCardImage =
          carDriverIdentityCardImage.path;
    } else {
      // reset profilePicture value in register view object
      registerObject.carDriverIdentityCardImage = "";
    }
    validate();
  }

  @override
  setCarOwnerIdentityCardImage(File carOwnerIdentityCardImage) {
    inputCarOwnerIdentityCardImage.add(carOwnerIdentityCardImage);
    if (carOwnerIdentityCardImage.path.isNotEmpty) {
      //  update register view object
      registerObject.carOwnerIdentityCardImage = carOwnerIdentityCardImage.path;
    } else {
      // reset profilePicture value in register view object
      registerObject.carOwnerIdentityCardImage = "";
    }
    validate();
  }

  @override
  setCarOwnerLicenseImage(File carOwnerLicenseImage) {
    inputCarOwnerLicenseImage.add(carOwnerLicenseImage);
    if (carOwnerLicenseImage.path.isNotEmpty) {
      //  update register view object
      registerObject.carOwnerLicenseImage = carOwnerLicenseImage.path;
    } else {
      // reset profilePicture value in register view object
      registerObject.carOwnerLicenseImage = "";
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


}

abstract class RegisterViewModelInput {
  Sink get inputServiceType;

  Sink get inputServiceCapacity;

  Sink get inputNotes;

  Sink get inputPlateNumber;

  Sink get inputCardBrandAndModel;

  Sink get inputCarDocumentImage;

  Sink get inputCarOwnerLicenseImage;

  Sink get inputCarOwnerIdentityCardImage;

  Sink get inputCarDriverIdentityCardImage;

  Sink get inputAllInputsValid;

  register();

  setServiceType(String serviceType);

  setServiceCapacity(String serviceCapacity);

  setNotes(String note);

  setPlateNumber(int plateNumber);

  setCardBrandAndModel(String cardBrandAndModel);

  setCarDocumentImage(File carDocumentImage);

  setCarOwnerLicenseImage(File carOwnerLicenseImage);

  setCarOwnerIdentityCardImage(File carOwnerIdentityCardImage);

  setCarDriverIdentityCardImage(File carDriverIdentityCardImage);
}

abstract class RegisterViewModelOutput {
  Stream<bool> get outputServiceType;

  Stream<bool> get outputIsPlateNumberValid;

  Stream<String?> get outputErrorPlateNumber;

  Stream<bool> get outputIsCardBrandAndModelValid;

  Stream<String?> get outputErrorCardBrandAndModel;

  Stream<bool> get outputIsNotesValid;

  Stream<String?> get outputErrorNotes;

  Stream<File> get outputCarDocumentImage;

  Stream<File> get outputCarOwnerLicenseImage;

  Stream<File> get outputCarOwnerIdentityCardImage;

  Stream<File> get outputCarDriverIdentityCardImage;

  Stream<bool> get outputAreAllInputsValid;
}
