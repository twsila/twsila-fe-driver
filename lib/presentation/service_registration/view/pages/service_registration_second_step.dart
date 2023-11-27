import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_for_you/presentation/common/widgets/CustomAutoFullSms.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/service_registration/view/helpers/documents_helper.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';
import 'package:taxi_for_you/utils/dialogs/toast_handler.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/routes_manager.dart';

import '../../../../app/constants.dart';
import '../../../../domain/model/car_brand_models_model.dart';
import '../../../../utils/helpers/keep_alive_widget.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/font_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../../utils/resources/styles_manager.dart';
import '../../../../utils/resources/values_manager.dart';
import '../../../common/widgets/CustomVerificationCodeWidget.dart';
import '../../../common/widgets/custom_card.dart';
import '../../../common/widgets/custom_date_picker.dart';
import '../../../common/widgets/custom_scaffold.dart';
import '../../../common/widgets/multi_pick_image.dart';
import '../../../common/widgets/page_builder.dart';
import '../../bloc/serivce_registration_bloc.dart';
import '../helpers/registration_request.dart';
import '../widgets/uploadDocumentWidget.dart';

class ServiceRegistrationSecondStep extends StatefulWidget {
  final RegistrationRequest registrationRequest;

  const ServiceRegistrationSecondStep(
      {required this.registrationRequest, Key? key})
      : super(key: key);

  @override
  State<ServiceRegistrationSecondStep> createState() =>
      _ServiceRegistrationSecondStepState();
}

class _ServiceRegistrationSecondStepState
    extends State<ServiceRegistrationSecondStep> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _displayLoadingIndicator = false;
  bool _loadingCars = false;
  List<CarModel>? carModelList;
  CarModel? selectedCarModel;
  String plateNumberValidation = "";
  TextEditingController _carNotesController = TextEditingController();
  TextEditingController _plateNumberController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  List<XFile> carPhotos = [];

  DocumentData documentData = DocumentData();
  DocumentData carDocument = DocumentData();
  DocumentData driverIdDocument = DocumentData();
  DocumentData driverLicenseDocument = DocumentData();
  DocumentData ownerIdDocument = DocumentData();

  String plateNumber = "";
  String carNotes = "";

  String front = "";
  String back = "";
  String expiry = "";

  XFile? frontImageFile;
  XFile? backImageFile;
  String? expiryDate;

  Documents selectedDocument = Documents.carDocument;

  bool isCarDocumentValid = false;
  bool isDriverIdValid = false;
  bool isDriverLicValid = false;
  bool isOwnerIdValid = false;

  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    _carNotesController.text =
        widget.registrationRequest.carNotes?.toString() ?? "";
    _plateNumberController.text =
        widget.registrationRequest.plateNumber?.toString() ?? "";

    BlocProvider.of<ServiceRegistrationBloc>(context)
        .add(GetCarBrandAndModel());
    super.initState();
  }

  @override
  void dispose() {
    clearDocumentData();
    super.dispose();
  }

  Future<void> _animateTo(int _page) async {
    _pageController.jumpToPage(
      _page,
    );
  }

  void startLoading() {
    setState(() {
      _displayLoadingIndicator = true;
    });
  }

  void stopLoading() {
    setState(() {
      _displayLoadingIndicator = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
        appbar: false,
        context: context,
        body: _getContentWidget(context),
        scaffoldKey: _key,
        displayLoadingIndicator: _displayLoadingIndicator,
        allowBackButtonInAppBar: true,
      ),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return BlocConsumer<ServiceRegistrationBloc, ServiceRegistrationState>(
      listener: (context, state) {
        print(state.toString());
        if (state is ServiceRegistrationLoading) {
          startLoading();
        } else {
          stopLoading();
        }
        if (state is CarBrandsAndModelsSuccess) {
          _loadingCars = false;
          carModelList = state.carModelList;
          if (widget.registrationRequest.carModelId != null &&
              carModelList != null) {
            selectedCarModel = carModelList!.firstWhere((element) =>
                element.id.toString() == widget.registrationRequest.carModelId);
          }
        }

        if (state is ServiceRegistrationSuccess) {
          Navigator.pushReplacementNamed(
              context, Routes.serviceAppliedSuccessfullyView);
        }
        if (state is ServiceRegistrationFail) {
          CustomDialog(context).showErrorDialog('', '', state.message);
        }
        //this state handle when user upload image the state place the correct photo in correct ui
        if (state is DocumentPickedImage) {
          switch (state.pickedImage) {
            case 0:
              frontImageFile = state.frontImageFile;
              documentData.frontImage = frontImageFile;
              break;
            case 1:
              backImageFile = state.backImageFile;
              documentData.backImage = backImageFile;
              break;
            case 2:
              expiryDate = state.expiryDate;
              documentData.expireDate = expiryDate;
              break;
          }
        }
        //this state handle if user upload document data before the state place the uploaded document, if not there is no document placed
        if (state is DocumentDataState) {
          front = state.documentPhotoFrontTitle;
          back = state.documentPhotoBackTitle;
          expiry = state.documentExpirationDateTitle;

          frontImageFile = state.frontImageFile;
          backImageFile = state.backImageFile;
          expiryDate = state.expiryDate;

          _animateTo(1);
        }
        //check if user upload the document or not
        if (state is CarDocumentValid) {
          carDocument = state.carDocument;
          isCarDocumentValid = true;
        }
        if (state is driverIdValid) {
          driverIdDocument = state.driverIdDocument;
          isDriverIdValid = true;
        }
        if (state is ownerIdValid) {
          ownerIdDocument = state.ownerIdDocument;
          isOwnerIdValid = true;
        }
        if (state is driverLicenseValid) {
          driverLicenseDocument = state.driverLicenseDocument;
          isDriverLicValid = true;
        }

        if (state is SecondStepDataAddedState) {
          BlocProvider.of<ServiceRegistrationBloc>(context)
              .add(RegisterCaptainWithService());
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                KeepAlivePage(child: SecondStepRegistration()),
                UploadDocumentPage(selectedDocument)
              ]),
        );
      },
    );
  }

  Widget SecondStepRegistration() {
    return Container(
      margin: EdgeInsets.only(
          left: AppMargin.m16, right: AppMargin.m16, top: AppMargin.m16),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.close),
              ),
            ),
            SizedBox(
              height: AppSize.s10,
            ),
            Text(
              AppStrings.stepTwo.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorManager.headersTextColor),
            ),
            Text(
              AppStrings.carData.tr(),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: FontSize.s30,
                  color: ColorManager.headersTextColor),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  carModelList != null
                      ? _showBottomSheet(carModelList ?? [])
                      : _loadingCars;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: ColorManager.borderColor, width: 1),
                ),
                child: Padding(
                  padding: EdgeInsets.all(AppPadding.p8),
                  child: _loadingCars
                      ? Center(
                          child: CircularProgressIndicator(
                            color: ColorManager.primary,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedCarModel
                                      ?.carManufacturerId.carManufacturer ??
                                  "${AppStrings.carModelAndBrand.tr()} (${AppStrings.required.tr()})",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      fontSize: FontSize.s16,
                                      color: ColorManager.titlesTextColor),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: ColorManager.primary,
                            )
                          ],
                        ),
                ),
              ),
            ),
            SizedBox(
              height: AppSize.s16,
            ),
            Text(
              AppStrings.plateNumber.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: FontSize.s14, color: ColorManager.titlesTextColor),
            ),
            SizedBox(
              height: AppSize.s12,
            ),
            CustomVerificationCode(
              plateNumberController: _plateNumberController,
              onChanged: (value) {
                plateNumber = value;
                setState(() {
                  if ((!RegExp(r'^([0-9-٠-٩]*[a-zA-Zء-ي]){3}([0-9-٠-٩]{1,3})*$')
                      .hasMatch(value))) {
                    plateNumberValidation =
                        AppStrings.plateNumberValidationMessage.tr();
                  } else {
                    plateNumberValidation = "";
                    widget.registrationRequest.plateNumber = plateNumber;
                  }
                });
              },
              validator: (value) {},
              onComplete: (value) {},
            ),
            Visibility(
                visible: plateNumberValidation.isNotEmpty,
                child: Text(
                  plateNumberValidation,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: FontSize.s12, color: ColorManager.error),
                )),
            SizedBox(
              height: AppSize.s18,
            ),
            TextFormField(
              controller: _carNotesController,
              onChanged: (value) {
                carNotes = value;
                widget.registrationRequest.carNotes = carNotes;
              },
              decoration: new InputDecoration(
                fillColor: Colors.white,
                border: InputBorder.none,
                hintText: AppStrings.carNotesHint.tr(),
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: ColorManager.hintTextColor),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    borderSide: BorderSide(color: ColorManager.borderColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    borderSide: BorderSide(color: ColorManager.borderColor)),
                filled: true,
                contentPadding:
                    EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
              ),
            ),
            MutliPickImageWidget(
              (List<XFile>? images) {
                images != null ? carPhotos = images : [];
              },
              AppStrings.uploadCarPhotos.tr(),
              AppStrings.addPhotos.tr(),
              Image.asset(ImageAssets.photosIcon, width: AppSize.s20),
              ColorManager.secondaryColor,
              widget.registrationRequest,
              fontSize: FontSize.s10,
            ),
            isCarDocumentValid
                ? documentIsValidWidget(
                    AppStrings.uploadCarDocumentPhoto.tr(),
                    Documents.carDocument,
                    DocumentType.carDocumentFront,
                    DocumentType.carDocumentBack,
                  )
                : UploadDocumentWidget(
                    AppStrings.uploadCarDocumentPhoto.tr(),
                    AppStrings.documentPhoto.tr(),
                    Image.asset(ImageAssets.photosIcon, width: AppSize.s20),
                    DocumentType.carDocumentFront,
                    DocumentType.carDocumentBack,
                    _pageController, () {
                    selectedDocument = Documents.carDocument;
                    BlocProvider.of<ServiceRegistrationBloc>(context).add(
                        NavigateToUploadDocument(
                            DocumentType.carDocumentFront,
                            DocumentType.carDocumentBack,
                            Documents.carDocument));
                  }),
            isDriverLicValid
                ? documentIsValidWidget(
                    AppStrings.uploadCarDriverLicPhoto.tr(),
                    Documents.driverLicense,
                    DocumentType.driverLicenseFront,
                    DocumentType.driverLicenseBack,
                  )
                : UploadDocumentWidget(
                    AppStrings.uploadCarDriverLicPhoto.tr(),
                    AppStrings.carDriverLicPhoto.tr(),
                    Image.asset(ImageAssets.documentIcon, width: AppSize.s20),
                    DocumentType.driverLicenseFront,
                    DocumentType.driverLicenseBack,
                    _pageController, () {
                    selectedDocument = Documents.driverLicense;
                    BlocProvider.of<ServiceRegistrationBloc>(context).add(
                        NavigateToUploadDocument(
                            DocumentType.driverLicenseFront,
                            DocumentType.driverLicenseBack,
                            Documents.driverLicense));
                  }),
            isOwnerIdValid
                ? documentIsValidWidget(
                    AppStrings.uploadCarOwnerIDPhoto.tr(),
                    Documents.ownerId,
                    DocumentType.ownerIdFront,
                    DocumentType.ownerIdBack,
                  )
                : UploadDocumentWidget(
                    AppStrings.uploadCarOwnerIDPhoto.tr(),
                    AppStrings.carOwnerIdPhoto.tr(),
                    Image.asset(ImageAssets.documentIcon, width: AppSize.s20),
                    DocumentType.ownerIdFront,
                    DocumentType.ownerIdBack,
                    _pageController, () {
                    selectedDocument = Documents.ownerId;
                    BlocProvider.of<ServiceRegistrationBloc>(context).add(
                        NavigateToUploadDocument(DocumentType.ownerIdFront,
                            DocumentType.ownerIdBack, Documents.ownerId));
                  }),
            isDriverIdValid
                ? documentIsValidWidget(
                    AppStrings.uploadCarDriverIDPhoto.tr(),
                    Documents.driverId,
                    DocumentType.driverIdFront,
                    DocumentType.driverIdBack,
                  )
                : UploadDocumentWidget(
                    AppStrings.uploadCarDriverIDPhoto.tr(),
                    AppStrings.carDriverIdPhoto.tr(),
                    Image.asset(ImageAssets.documentIcon, width: AppSize.s20),
                    DocumentType.driverIdFront,
                    DocumentType.driverIdBack,
                    _pageController, () {
                    selectedDocument = Documents.driverId;
                    BlocProvider.of<ServiceRegistrationBloc>(context).add(
                        NavigateToUploadDocument(
                            DocumentType.driverIdFront,
                            DocumentType.driverLicenseBack,
                            Documents.driverId));
                  }),
            CustomTextButton(
              text: AppStrings.applyRequest.tr(),
              onPressed: () {
                if (selectedCarModel != null &&
                    plateNumber != "" &&
                    plateNumberValidation.isEmpty &&
                    carPhotos.length != 0 &&
                    isCarDocumentValid &&
                    isDriverIdValid &&
                    isDriverLicValid &&
                    isOwnerIdValid) {
                  BlocProvider.of<ServiceRegistrationBloc>(context).add(
                      SetSecondStepData(
                          selectedCarModel!.carManufacturerId.id.toString(),
                          selectedCarModel!.id.toString(),
                          plateNumber,
                          carNotes,
                          carPhotos,
                          carDocument,
                          driverLicenseDocument,
                          driverIdDocument,
                          ownerIdDocument));
                } else {
                  ToastHandler(context).showToast(
                      'please enter required fields', Toast.LENGTH_SHORT);
                }
                // Navigator.pushNamed(context, Routes.mainRoute);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget UploadDocumentPage(Documents documents) {
    return WillPopScope(
      onWillPop: () async {
        _pageController.jumpToPage(
          0,
        );
        return false;
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomCard(
                  bodyWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: AppSize.s8,
                      ),
                      Text(
                        front,
                        style: getRegularStyle(
                            color: ColorManager.black, fontSize: FontSize.s18),
                      ),
                      const SizedBox(height: AppSize.s8),
                      _getMediaWidget(0, documents)
                    ],
                  ),
                  onClick: () {}),
              CustomCard(
                  bodyWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: AppSize.s8,
                      ),
                      Text(
                        back,
                        style: getRegularStyle(
                            color: ColorManager.black, fontSize: FontSize.s18),
                      ),
                      const SizedBox(
                        height: AppSize.s8,
                      ),
                      _getMediaWidget(1, documents)
                    ],
                  ),
                  onClick: () {}),
              CustomCard(
                  bodyWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: AppSize.s8,
                      ),
                      Text(
                        expiry,
                        style: getRegularStyle(
                            color: ColorManager.black, fontSize: FontSize.s18),
                      ),
                      const SizedBox(
                        height: AppSize.s8,
                      ),
                      expiryDate != null && expiryDate!.isNotEmpty
                          ? Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                    AppStrings.selectDate.tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            color:
                                                ColorManager.headersTextColor),
                                  ),
                                ),
                                SizedBox(
                                  width: AppSize.s6,
                                ),
                                Flexible(
                                  flex: 4,
                                  child: Container(
                                    padding: EdgeInsets.all(AppPadding.p8),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: ColorManager.borderColor),
                                        borderRadius: BorderRadius.circular(2)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          expiryDate!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                  color: ColorManager
                                                      .headersTextColor),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              expiryDate = null;
                                            });
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: ColorManager.error,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : CustomDatePickerWidget(
                              labelText: AppStrings.selectDate.tr(),
                              onSelectDate: (date) {
                                expiryDate = date;
                                documentData.expireDate = date;

                                BlocProvider.of<ServiceRegistrationBloc>(
                                        context)
                                    .add(SetDocumentForView(
                                        documentPicked: 2, expireDate: date));
                              },
                              pickTime: false)
                    ],
                  ),
                  onClick: () {}),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextButton(
                    onPressed: () {
                      setState(() {
                        if (documentData.frontImage != null &&
                            documentData.backImage != null &&
                            documentData.expireDate != null) {
                          documentData.document = selectedDocument;
                          BlocProvider.of<ServiceRegistrationBloc>(context).add(
                              ChangeDocumentStatus(
                                  selectedDocument, documentData));
                        }
                        _pageController.jumpToPage(
                          0,
                        );
                      });
                    },
                    text: AppStrings.finish.tr(),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget documentIsValidWidget(
    String title,
    Documents documents,
    DocumentType documentTypeFront,
    DocumentType documentTypeBack,
  ) {
    return GestureDetector(
      onTap: () {
        selectedDocument = documents;
        BlocProvider.of<ServiceRegistrationBloc>(context).add(
            NavigateToUploadDocument(
                documentTypeFront, documentTypeBack, documents));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: ColorManager.titlesTextColor, fontSize: FontSize.s16),
          ),
          Icon(
            Icons.check_circle_rounded,
            color: ColorManager.primary,
          )
        ],
      ),
    );
  }

  Widget _getMediaWidget(int imageDir, Documents documents) {
    return Padding(
      padding: const EdgeInsets.only(
          left: AppPadding.p8, right: AppPadding.p8, top: AppPadding.p12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: AppSize.s40,
          ),
          imageDir == 0
              ? frontImageFile != null
                  ? _imagePicketByUser(frontImageFile)
                  : _imagePicketByUser(null)
              : backImageFile != null
                  ? _imagePicketByUser(backImageFile)
                  : _imagePicketByUser(null),
          const SizedBox(
            height: AppSize.s60,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextButton(
                onPressed: () {
                  _showPicker(context, documents, imageDir);
                },
                text: AppStrings.addPhoto.tr()),
          )
        ],
      ),
    );
  }

  Widget _imagePicketByUser(XFile? image) {
    if (image != null && image.path.isNotEmpty) {
      // return image
      return SizedBox(
          width: AppSize.s190,
          height: AppSize.s190,
          child: Image.file(File(image.path)));
    } else {
      return SizedBox(
          width: 60,
          height: 60,
          child: SvgPicture.asset(ImageAssets.photoCameraIc));
    }
  }

  _showPicker(BuildContext context, Documents document, int imageDir) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Wrap(
            children: [
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera),
                title: Text(AppStrings.photoGallery.tr()),
                onTap: () {
                  _imageFromGallery(document, imageDir);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(AppStrings.photoCamera.tr()),
                onTap: () {
                  _imageFromCamera(document, imageDir);
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
        });
  }

  _imageFromGallery(Documents documents, int imageDir) async {
    var image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: Constants.IMAGE_QUALITY_COMPRESS);
    BlocProvider.of<ServiceRegistrationBloc>(context).add(imageDir == 0
        ? SetDocumentForView(
            document: documents, frontImage: image, documentPicked: imageDir)
        : SetDocumentForView(
            document: documents, backImage: image, documentPicked: imageDir));
  }

  _imageFromCamera(Documents documents, int imageDir) async {
    var image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: Constants.IMAGE_QUALITY_COMPRESS);
    BlocProvider.of<ServiceRegistrationBloc>(context).add(imageDir == 0
        ? SetDocumentForView(
            document: documents, frontImage: image, documentPicked: imageDir)
        : SetDocumentForView(
            document: documents, backImage: image, documentPicked: imageDir));
  }

  void _showBottomSheet(List<CarModel> carModelList) {
    showModalBottomSheet(
        elevation: 10,
        context: context,
        backgroundColor: ColorManager.white,
        builder: (ctx) => carModelList != null
            ? ListView.builder(
                itemCount: carModelList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        Navigator.pop(context);
                        selectedCarModel = carModelList[index];
                        widget.registrationRequest.carModelId =
                            selectedCarModel!.id.toString();
                      });
                    },
                    child: ListTile(
                        title: Text(carModelList[index].modelName),
                        subtitle: Text(carModelList[index]
                            .carManufacturerId
                            .carManufacturer)),
                  );
                },
              )
            : CircularProgressIndicator(
                color: ColorManager.primary,
              ));
  }

  void clearDocumentData() {
    ServiceRegistrationBloc.carDocument = DocumentData();
    ServiceRegistrationBloc.driverIdDocument = DocumentData();
    ServiceRegistrationBloc.driverLicenseDocument = DocumentData();
    ServiceRegistrationBloc.ownerIdDocument = DocumentData();
  }
}

class UploadDocumentsArguments {
  String frontImageTitle;
  String backImageTitle;
  String expirationDateTitle;
  PageController pageController;

  UploadDocumentsArguments(this.frontImageTitle, this.backImageTitle,
      this.expirationDateTitle, this.pageController);
}

class DocumentData {
  XFile? frontImage;
  XFile? backImage;
  String? expireDate;
  Documents? document;

  DocumentData(
      {this.frontImage, this.backImage, this.expireDate, this.document});
}

class ServiceRegistrationSecondStepArguments {
  RegistrationRequest registrationRequest;

  ServiceRegistrationSecondStepArguments(this.registrationRequest);
}
