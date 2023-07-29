import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:taxi_for_you/domain/usecase/car_brands_usecase.dart';
import 'package:taxi_for_you/domain/usecase/registration_usecase.dart';
import 'package:taxi_for_you/presentation/service_registration/view/helpers/registration_request.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/service_type_model.dart';
import '../../../domain/model/car_brand_models_model.dart';
import '../../../domain/usecase/registration_services_usecase.dart';
import '../view/helpers/documents_helper.dart';
import '../view/helpers/documents_helper.dart';
import '../view/pages/service_registration_second_step.dart';

part 'serivce_registration_event.dart';

part 'serivce_registration_state.dart';

class ServiceRegistrationBloc
    extends Bloc<ServiceRegistrationEvent, ServiceRegistrationState> {
  RegistrationServiceUseCase registrationServiceUseCase;
  CarBrandsAndModelsUseCase carBrandsAndModelsUseCase;
  RegistrationUseCase registrationUseCase;
  final AppPreferences _appPreferences = instance<AppPreferences>();
  RegistrationRequest registrationRequest = RegistrationRequest.empty();
  static DocumentData carDocument = DocumentData();
  static DocumentData driverIdDocument = DocumentData();
  static DocumentData driverLicenseDocument = DocumentData();
  static DocumentData ownerIdDocument = DocumentData();

  String frontImageTitle = "";
  String backImageTitle = "";
  String expirationDateTitle = "";

  ServiceRegistrationBloc(
      {required this.registrationServiceUseCase,
      required this.carBrandsAndModelsUseCase,
      required this.registrationUseCase})
      : super(ServiceRegistrationInitial()) {
    on<GetServiceTypes>(_getServicesTypes);
    on<GetCarBrandAndModel>(_getCarBrandsAndModels);
    on<NavigateToUploadDocument>(_setDocumentData);
    on<SelectToUploadEvent>(_selectToUpload);
    on<SetDocumentForView>(_setDocumentDataForView);
    on<ChangeDocumentStatus>(_changeDocumentStatus);
    on<addCaptainData>(_addCaptainData);
    on<SetCaptainData>(_setCaptainData);
    on<SetFirstStepData>(_setFirstStepData);
    on<SetSecondStepData>(_setSecondStepData);
    on<RegisterCaptainWithService>(_registerCaptainWithService);
  }

  FutureOr<void> _addCaptainData(
      addCaptainData event, Emitter<ServiceRegistrationState> emit) async {
    if (event.captainPhoto != null && event.captainPhoto!.path != "" &&
        event.firstName != null &&
        event.firstName!.isNotEmpty &&
        event.lastName != null &&
        event.lastName!.isNotEmpty &&
        event.email != null &&
        event.email!.isNotEmpty &&
        event.gender != null &&
        event.gender!.isNotEmpty &&
        event.birthDate != null &&
        event.agreeWithTerms != null && event.agreeWithTerms != false) {
      emit(CaptainDataIsValid());
    }else{
      emit(CaptainDataIsNotValid());
    }
  }

  FutureOr<void> _getServicesTypes(
      GetServiceTypes event, Emitter<ServiceRegistrationState> emit) async {
    emit(ServiceRegistrationLoading());
    (await registrationServiceUseCase
            .execute(RegistrationServiceUseCaseInput()))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(ServicesTypesFail(failure.message))
                }, (serviceTypeList) async {
      // right -> data (success)
      // content
      // emit success state
      // navigate to main screen

      emit(ServicesTypesSuccess(serviceTypeList));
      // isUserLoggedInSuccessfullyStreamController.add(true);
    });
  }

  FutureOr<void> _getCarBrandsAndModels(
      GetCarBrandAndModel event, Emitter<ServiceRegistrationState> emit) async {
    emit(ServiceRegistrationLoading());
    (await carBrandsAndModelsUseCase.execute(CarBrandsAndModelsUseCaseInput()))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(CarBrandsAndModelsFail(failure.message))
                }, (carModelsList) async {
      // right -> data (success)
      // content
      // emit success state
      // navigate to main screen
      print(registrationRequest.vehicleTypeId);
      emit(CarBrandsAndModelsSuccess(carModelsList));
      // isUserLoggedInSuccessfullyStreamController.add(true);
    });
  }

  FutureOr<void> _registerCaptainWithService(RegisterCaptainWithService event,
      Emitter<ServiceRegistrationState> emit) async {
    emit(ServiceRegistrationLoading());
    (await registrationUseCase.execute(RegistrationUseCaseInput(
            firstName: registrationRequest.firstName!,
            lastName: registrationRequest.lastName!,
            mobile: registrationRequest.mobile!,
            email: registrationRequest.email!,
            gender: registrationRequest.gender!,
            dateOfBirth: registrationRequest.dateOfBirth!,
            driverServiceType: registrationRequest.driverServiceType!,
            vehicleTypeId: registrationRequest.vehicleTypeId!,
            carManufacturerTypeId: registrationRequest.carManufacturerTypeId!,
            carModelId: registrationRequest.carModelId!,
            carNotes: registrationRequest.carNotes!,
            plateNumber: registrationRequest.plateNumber!,
            driverImages: registrationRequest.driverImages!,
            isAcknowledged: registrationRequest.isAcknowledged ?? true)))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(ServiceRegistrationFail(failure.message))
                }, (carModelsList) async {
      // right -> data (success)
      // content
      // emit success state
      // navigate to main screen
      print(registrationRequest.vehicleTypeId);
      emit(ServiceRegistrationSuccess());
      // isUserLoggedInSuccessfullyStreamController.add(true);
    });
  }

  FutureOr<void> _setDocumentData(NavigateToUploadDocument event,
      Emitter<ServiceRegistrationState> emit) async {
    if (event.document == Documents.carDocument &&
        carDocument.frontImage != null &&
        carDocument.backImage != null &&
        carDocument.expireDate != null) {
      emit(DocumentDataState(
          event.documentTypeFront.displayPhotosTitles,
          event.documentTypeBack.displayPhotosTitles,
          event.documentTypeFront.displayExpirationDateTitles,
          carDocument.frontImage,
          carDocument.backImage,
          carDocument.expireDate));
    } else if (event.document == Documents.driverLicense &&
        driverLicenseDocument.frontImage != null &&
        driverLicenseDocument.backImage != null &&
        driverLicenseDocument.expireDate != null) {
      emit(DocumentDataState(
          event.documentTypeFront.displayPhotosTitles,
          event.documentTypeBack.displayPhotosTitles,
          event.documentTypeFront.displayExpirationDateTitles,
          driverLicenseDocument.frontImage,
          driverLicenseDocument.backImage,
          driverLicenseDocument.expireDate));
    } else if (event.document == Documents.driverId &&
        driverIdDocument.frontImage != null &&
        driverIdDocument.backImage != null &&
        driverIdDocument.expireDate != null) {
      emit(DocumentDataState(
        event.documentTypeFront.displayPhotosTitles,
        event.documentTypeBack.displayPhotosTitles,
        event.documentTypeFront.displayExpirationDateTitles,
        driverIdDocument.frontImage,
        driverIdDocument.backImage,
        driverIdDocument.expireDate,
      ));
    } else if (event.document == Documents.ownerId &&
        ownerIdDocument.frontImage != null &&
        ownerIdDocument.backImage != null &&
        ownerIdDocument.expireDate != null) {
      emit(DocumentDataState(
          event.documentTypeFront.displayPhotosTitles,
          event.documentTypeBack.displayPhotosTitles,
          event.documentTypeFront.displayExpirationDateTitles,
          ownerIdDocument.frontImage,
          ownerIdDocument.backImage,
          ownerIdDocument.expireDate));
    } else {
      emit(DocumentDataState(
          event.documentTypeFront.displayPhotosTitles,
          event.documentTypeBack.displayPhotosTitles,
          event.documentTypeFront.displayExpirationDateTitles,
          null,
          null,
          null));
    }
  }

  FutureOr<void> _setDocumentDataForView(
      SetDocumentForView event, Emitter<ServiceRegistrationState> emit) async {
    switch (event.documentPicked) {
      case 0:
        emit(DocumentPickedImage(
            frontImageFile: event.frontImage, pickedImage: 0));
        break;
      case 1:
        emit(DocumentPickedImage(
            backImageFile: event.backImage, pickedImage: 1));
        break;
      case 2:
        emit(DocumentPickedImage(
            backImageFile: event.backImage,
            expiryDate: event.expireDate,
            pickedImage: 2));
        break;
    }
  }

  FutureOr<void> _selectToUpload(SelectToUploadEvent event,
      Emitter<ServiceRegistrationState> emit) async {}

  FutureOr<void> _changeDocumentStatus(ChangeDocumentStatus event,
      Emitter<ServiceRegistrationState> emit) async {
    if (event.document == Documents.carDocument) {
      carDocument.frontImage = event.documentData.frontImage;
      carDocument.backImage = event.documentData.backImage;
      carDocument.expireDate = event.documentData.expireDate;
      carDocument.document = event.document;
      emit(CarDocumentValid(carDocument));
    } else if (event.document == Documents.driverLicense) {
      driverLicenseDocument.frontImage = event.documentData.frontImage;
      driverLicenseDocument.backImage = event.documentData.backImage;
      driverLicenseDocument.expireDate = event.documentData.expireDate;
      driverLicenseDocument.document = event.document;
      emit(driverLicenseValid(driverLicenseDocument));
    } else if (event.document == Documents.driverId) {
      driverIdDocument.frontImage = event.documentData.frontImage;
      driverIdDocument.backImage = event.documentData.backImage;
      driverIdDocument.expireDate = event.documentData.expireDate;
      driverIdDocument.document = event.document;
      emit(driverIdValid(driverIdDocument));
    } else if (event.document == Documents.ownerId) {
      ownerIdDocument.frontImage = event.documentData.frontImage;
      ownerIdDocument.backImage = event.documentData.backImage;
      ownerIdDocument.expireDate = event.documentData.expireDate;
      ownerIdDocument.document = event.document;
      emit(ownerIdValid(ownerIdDocument));
    }
  }

  FutureOr<void> _setCaptainData(
      SetCaptainData event, Emitter<ServiceRegistrationState> emit) async {
    bool renameFile = await isFileExist(event.captainPhoto);
    File captainPhoto;

    if (renameFile)
      captainPhoto =
          await changeFileNameOnly(event.captainPhoto, 'driver_photo.jpg');
    else
      captainPhoto = File(event.captainPhoto.path);

    registrationRequest.driverImages = [captainPhoto];
    registrationRequest.mobile = event.mobileNumber;
    registrationRequest.firstName = event.firstName;
    registrationRequest.lastName = event.lastName;
    registrationRequest.gender = event.gender;
    registrationRequest.email = event.email;
    registrationRequest.dateOfBirth = event.birthDate;
    emit(captainDataAddedState());
  }

  FutureOr<void> _setFirstStepData(
      SetFirstStepData event, Emitter<ServiceRegistrationState> emit) async {
    registrationRequest.driverServiceType = event.driverServiceType;
    registrationRequest.vehicleTypeId = event.vehicleTypeId;
    emit(FirstStepDataAddedState());
  }

  FutureOr<void> _setSecondStepData(
      SetSecondStepData event, Emitter<ServiceRegistrationState> emit) async {
    List<File> carPhotos = await prepareCarPhotosList(event.carPhotos);
    List<DocumentData> documents = [
      event.carDocumentPhotos,
      event.carDriverIdPhotos,
      event.carDriverLicensePhotos,
      event.carOwnerIdPhotos
    ];

    List<File> driverImages = await prepareDocumentsPhotosList(documents);

    registrationRequest.carManufacturerTypeId = event.carManufacturerTypeId;
    registrationRequest.carModelId = event.carModelId;
    registrationRequest.plateNumber = event.plateNumber;
    registrationRequest.carNotes = event.carNotes;
    registrationRequest.driverImages?.addAll(carPhotos);
    registrationRequest.driverImages?.addAll(driverImages);

    emit(SecondStepDataAddedState());
  }

  Future<File> changeFileNameOnly(XFile image, String newFileName) {
    File file = File(image.path);
    var path = image.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return file.copy(newPath);
  }

  Future<bool> isFileExist(XFile image) async {
    File file = File(image.path);
    return await file.existsSync();
  }

  Future<List<File>> prepareCarPhotosList(List<XFile> carPhotosList) async {
    List<File> carPhotos = [];
    int counter = 1;
    await Future.forEach(carPhotosList, (XFile carPhoto) async {
      File imageFile = await changeFileNameOnly(
          carPhoto, 'driver-car-photo-' + counter.toString() + '.jpg');
      counter++;
      carPhotos.add(imageFile);
    });
    return carPhotos;
  }

  Future<List<File>> prepareDocumentsPhotosList(
      List<DocumentData> documentsList) async {
    List<File> documentsImageList = [];
    await Future.forEach(documentsList, (DocumentData documentData) async {
      File frontImage = await changeFileNameOnly(documentData.frontImage!,
          documentData.document.toString() + '-front.jpg');
      File backImage = await changeFileNameOnly(documentData.backImage!,
          documentData.document.toString() + '-back.jpg');
      documentsImageList.add(frontImage);
      documentsImageList.add(backImage);
    });
    return documentsImageList;
  }
}
