part of 'serivce_registration_bloc.dart';

@immutable
abstract class ServiceRegistrationEvent {}

class GetServiceTypes extends ServiceRegistrationEvent {
  GetServiceTypes();
}

class GetCarBrandAndModel extends ServiceRegistrationEvent {
  GetCarBrandAndModel();
}

class RegisterCaptainWithService extends ServiceRegistrationEvent {
  RegisterCaptainWithService();
}

class RegisterBOWithService extends ServiceRegistrationEvent {
  final BusinessOwnerModel businessOwnerModel;

  RegisterBOWithService({required this.businessOwnerModel});
}

class addCaptainData extends ServiceRegistrationEvent {
  XFile? captainPhoto;
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  String? birthDate;
  bool? agreeWithTerms;

  addCaptainData(
      {this.captainPhoto,
      this.firstName,
      this.lastName,
      this.email,
      this.gender,
      this.birthDate,
      this.agreeWithTerms});
}

class NavigateToUploadDocument extends ServiceRegistrationEvent {
  final DocumentType documentTypeFront;
  final DocumentType documentTypeBack;
  final Documents document;

  NavigateToUploadDocument(
    this.documentTypeFront,
    this.documentTypeBack,
    this.document,
  );
}

class SetDocumentData extends ServiceRegistrationEvent {
  final DocumentType documentType;
  final XFile frontImage;
  final XFile backImage;
  final String expireDate;

  SetDocumentData(
      this.documentType, this.frontImage, this.backImage, this.expireDate);
}

class ChangeDocumentStatus extends ServiceRegistrationEvent {
  Documents document;
  DocumentData documentData;

  ChangeDocumentStatus(this.document, this.documentData);
}

class SelectToUploadEvent extends ServiceRegistrationEvent {
  final Documents document;

  SelectToUploadEvent(this.document);
}

class SetDocumentForView extends ServiceRegistrationEvent {
  Documents? document;
  XFile? frontImage;
  XFile? backImage;
  String? expireDate;
  int documentPicked;

  SetDocumentForView(
      {this.document,
      this.frontImage,
      this.backImage,
      this.expireDate,
      required this.documentPicked});
}

class SetCaptainData extends ServiceRegistrationEvent {
  XFile captainPhoto;
  String mobileNumber;
  String firstName;
  String lastName;
  String? email;
  String gender;
  String birthDate;

  SetCaptainData(this.captainPhoto, this.mobileNumber, this.firstName,
      this.lastName, this.email, this.gender, this.birthDate);
}

class SetFirstStepData extends ServiceRegistrationEvent {
  final String driverServiceType;
  final String vehicleTypeId;
  final String vehicleShapeId;
  final AdditionalServicesModel additionalServicesModel ;

  SetFirstStepData(this.driverServiceType, this.vehicleTypeId,this.vehicleShapeId,this.additionalServicesModel);
}

class SetSecondStepData extends ServiceRegistrationEvent {
  final String carManufacturerTypeId;
  final String carModelId;
  final String plateNumber;
  final String carNotes;
  final List<XFile> carPhotos;
  DocumentData carDocumentPhotos;
  DocumentData carDriverLicensePhotos;
  DocumentData carDriverIdPhotos;
  DocumentData carOwnerIdPhotos;

  SetSecondStepData(
      this.carManufacturerTypeId,
      this.carModelId,
      this.plateNumber,
      this.carNotes,
      this.carPhotos,
      this.carDocumentPhotos,
      this.carDriverLicensePhotos,
      this.carDriverIdPhotos,
      this.carOwnerIdPhotos);
}

class RegisterCaptainEvent extends ServiceRegistrationEvent {}
