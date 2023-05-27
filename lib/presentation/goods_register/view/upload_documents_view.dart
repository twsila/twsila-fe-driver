import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_card.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_date_picker.dart';
import 'package:taxi_for_you/presentation/captain_registration/view/persons_register_view.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/routes_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import 'package:taxi_for_you/utils/resources/styles_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../utils/resources/assets_manager.dart';
import '../viewmodel/goods_register_viewmodel.dart';

class UploadDocumentsView extends StatefulWidget {
  UPLOAD_DOCUMENTS? uploadDocumentsFor;
  GoodsRegisterViewModel viewModel;

  UploadDocumentsView(
      {Key? key, this.uploadDocumentsFor, required this.viewModel})
      : super(key: key);

  @override
  State<UploadDocumentsView> createState() => _UploadDocumentsViewState();
}

class _UploadDocumentsViewState extends State<UploadDocumentsView> {
  final ImagePicker _imagePicker = instance<ImagePicker>();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  final TextEditingController _selectedDateController = TextEditingController();
  String uploadFor = "";
  String frontImageUrl = "";
  String backImageUrl = "";
  String appbarTitle = "";
  String frontImageTitle = "";
  String backImageTitle = "";
  String expireDateTitle = "";

  bool isInit = false;

  List<Stream<File>> streamsOutputs = [];
  List<Stream<String>> dateStreamsOutputs = [];

  late UploadDocumentsArguments arguments;

  late Object args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  handleUploadFor(String uploadFor) {
    this.uploadFor = uploadFor;
    switch (uploadFor) {
      case "UPLOAD_DOCUMENTS.CAR_DOCUMENT":
        appbarTitle = AppStrings.carDocumentsInfo.tr();
        frontImageTitle = AppStrings.carDocumentFrontImage.tr();
        backImageTitle = AppStrings.carDocumentBackImage.tr();
        expireDateTitle = AppStrings.carDocumentExpireDate.tr();
        streamsOutputs.add(widget.viewModel.outputCarDocumentFrontImage);
        streamsOutputs.add(widget.viewModel.outputCarDocumentBackImage);
        _selectedDateController.addListener(() {
          widget.viewModel
              .setCarDocumentExpireDate(_selectedDateController.text);
        });
        break;
      case "UPLOAD_DOCUMENTS.CAR_OWNER_LICENSE":
        appbarTitle = AppStrings.carDriverLicenseInfo.tr();
        frontImageTitle = AppStrings.carDriverLicenseFrontImage.tr();
        backImageTitle = AppStrings.carDriverLicenseBackImage.tr();
        expireDateTitle = AppStrings.carDriverLicenseExpireDate.tr();
        streamsOutputs.add(widget.viewModel.outputCarOwnerLicenseFrontImage);
        streamsOutputs.add(widget.viewModel.outputCarOwnerLicenseBackImage);
        _selectedDateController.addListener(() {
          widget.viewModel
              .setCarOwnerLicenseExpireDate(_selectedDateController.text);
        });
        break;
      case "UPLOAD_DOCUMENTS.CAR_OWNER_CARD_IDENITY":
        appbarTitle = AppStrings.carOwnerIdentityInfo.tr();
        frontImageTitle = AppStrings.carOwnerIdentityCardFrontImage.tr();
        backImageTitle = AppStrings.carOwnerIdentityCardBackImage.tr();
        expireDateTitle = AppStrings.carOwnerIdentityCardExpireDate.tr();
        streamsOutputs
            .add(widget.viewModel.outputCarOwnerIdentityCardFrontImage);
        streamsOutputs
            .add(widget.viewModel.outputCarOwnerIdentityCardBackImage);
        _selectedDateController.addListener(() {
          widget.viewModel
              .setCarOwnerIdentityCardExpireDate(_selectedDateController.text);
        });
        break;
      case "UPLOAD_DOCUMENTS.CAR_DRIVER_CARD_IDENITY":
        appbarTitle = AppStrings.carDriverIdentityInfo.tr();
        frontImageTitle = AppStrings.carDriverIdentityCardFrontImage.tr();
        backImageTitle = AppStrings.carDriverIdentityCardBackImage.tr();
        expireDateTitle = AppStrings.carDriverIdentityCardExpireDate.tr();
        streamsOutputs
            .add(widget.viewModel.outputCarDriverIdentityCardFrontImage);
        streamsOutputs
            .add(widget.viewModel.outputCarDriverIdentityCardBackImage);
        _selectedDateController.addListener(() {
          widget.viewModel
              .setCarDriverIdentityCardExpireDate(_selectedDateController.text);
        });
        break;
    }
  }

  void handleViewModelOutputStream(String uploadFor) {
    switch (uploadFor) {
      case "UPLOAD_DOCUMENTS.CAR_DOCUMENT":
        Stream<File> documentFrontOutputStream =
            widget.viewModel.outputCarDocumentFrontImage;
        Stream<File> documentBackOutputStream =
            widget.viewModel.outputCarDocumentBackImage;
        Stream<String> documentExpireDateOutputStream =
            widget.viewModel.outputCarDocumentExpireDate;
        streamsOutputs.add(documentFrontOutputStream);
        streamsOutputs.add(documentBackOutputStream);
        dateStreamsOutputs.add(documentExpireDateOutputStream);
        break;
      case "UPLOAD_DOCUMENTS.CAR_OWNER_LICENSE":
        Stream<File> documentFrontOutputStream =
            widget.viewModel.outputCarDocumentFrontImage;
        Stream<File> documentBackOutputStream =
            widget.viewModel.outputCarDocumentBackImage;

        Stream<String> carOwnerLicenseExpireDate =
            widget.viewModel.outputCarOwnerLicenseExpireDate;
        streamsOutputs.add(documentFrontOutputStream);
        streamsOutputs.add(documentBackOutputStream);
        dateStreamsOutputs.add(carOwnerLicenseExpireDate);

        break;
      case "UPLOAD_DOCUMENTS.CAR_OWNER_CARD_IDENITY":
        Stream<File> documentFrontOutputStream =
            widget.viewModel.outputCarDocumentFrontImage;
        Stream<File> documentBackOutputStream =
            widget.viewModel.outputCarDocumentBackImage;
        Stream<String> carOwnerIdentityExpireDate =
            widget.viewModel.outputCarOwnerIdentityCardExpireDate;
        streamsOutputs.add(documentFrontOutputStream);
        streamsOutputs.add(documentBackOutputStream);
        dateStreamsOutputs.add(carOwnerIdentityExpireDate);
        break;
      case "UPLOAD_DOCUMENTS.CAR_DRIVER_CARD_IDENITY":
        Stream<File> documentFrontOutputStream =
            widget.viewModel.outputCarDocumentFrontImage;
        Stream<File> documentBackOutputStream =
            widget.viewModel.outputCarDocumentBackImage;
        Stream<String> carDriverExpireDate =
            widget.viewModel.outputCarDriverIdentityCardExpireDate;

        streamsOutputs.add(documentFrontOutputStream);
        streamsOutputs.add(documentBackOutputStream);
        dateStreamsOutputs.add(carDriverExpireDate);
        break;
    }
  }

  @override
  void initState() {
    final widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        UploadDocumentsArguments _screenArguments = ModalRoute.of(context)
            ?.settings
            .arguments as UploadDocumentsArguments;
        setState(() {
          handleUploadFor(_screenArguments.uploadDocumentFor);
          handleViewModelOutputStream(uploadFor);
        });
      }
    });
    // _bind();
    isInit = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: Text(
          appbarTitle,
          style: getRegularStyle(
              color: ColorManager.primary, fontSize: FontSize.s16),
        ),
        elevation: AppSize.s0,
        backgroundColor: ColorManager.white,
        iconTheme: IconThemeData(color: ColorManager.primary),
      ),
      body: isInit
          ? _getContentWidget()
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _getContentWidget() {
    return SingleChildScrollView(
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
                      frontImageTitle,
                      style: getRegularStyle(
                          color: ColorManager.black, fontSize: FontSize.s14),
                    ),
                    const SizedBox(height: AppSize.s8),
                    streamsOutputs.isNotEmpty
                        ? _getMediaWidget(streamsOutputs[0], "_FRONT")
                        : CircularProgressIndicator()
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
                      backImageTitle,
                      style: getRegularStyle(
                          color: ColorManager.black, fontSize: FontSize.s14),
                    ),
                    const SizedBox(
                      height: AppSize.s8,
                    ),
                    streamsOutputs.isNotEmpty
                        ? _getMediaWidget(streamsOutputs[1], "_BACK")
                        : const CircularProgressIndicator()
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
                      expireDateTitle,
                      style: getRegularStyle(
                          color: ColorManager.black, fontSize: FontSize.s14),
                    ),
                    const SizedBox(
                      height: AppSize.s8,
                    ),
                    CustomDatePickerWidget(
                        labelText: AppStrings.selectDate.tr(),
                        onSelectDate: (date) {
                          handleSelectedExpireDate(uploadFor, date);
                        },
                        pickTime: false)
                  ],
                ),
                onClick: () {}),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    // Navigator.pushReplacementNamed(context, Routes.registerRoute);
                    Navigator.pop(context);
                  },
                  child: Text(AppStrings.finish.tr())),
            )
          ],
        ),
      ),
    );
  }

  Widget _getMediaWidget(Stream<File> documentOutputStream, String imageDim) {
    return Padding(
      padding: const EdgeInsets.only(
          left: AppPadding.p8, right: AppPadding.p8, top: AppPadding.p12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: AppSize.s40,
          ),
          StreamBuilder<File>(
            stream: documentOutputStream,
            builder: (context, snapshot) {
              return _imagePicketByUser(snapshot.data);
            },
          ),
          const SizedBox(
            height: AppSize.s60,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  _showPicker(context, uploadFor + imageDim);
                },
                child: Text(AppStrings.addPhoto.tr())),
          )
        ],
      ),
    );
  }

  Widget _imagePicketByUser(File? image) {
    if (image != null && image.path.isNotEmpty) {
      // return image
      return SizedBox(
          width: AppSize.s190, height: AppSize.s190, child: Image.file(image));
    } else {
      return SizedBox(
          width: 60,
          height: 60,
          child: SvgPicture.asset(ImageAssets.photoCameraIc));
    }
  }

  _showPicker(BuildContext context, String uploadFor) {
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
                  _imageFromGallery(uploadFor);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(AppStrings.photoCamera.tr()),
                onTap: () {
                  _imageFromCamera(uploadFor);
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
        });
  }

  _imageFromGallery(String uploadFor) async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    handleViewModelDocuments(uploadFor, File(image?.path ?? ""));
  }

  _imageFromCamera(String uploadFor) async {
    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    handleViewModelDocuments(uploadFor, File(image?.path ?? ""));
  }

  void handleViewModelDocuments(String selectedType, File image) {
    switch (selectedType) {
      case "UPLOAD_DOCUMENTS.CAR_DOCUMENT_FRONT":
        widget.viewModel.setCarDocumentFrontImage(image);
        break;

      case "UPLOAD_DOCUMENTS.CAR_OWNER_LICENSE_FRONT":
        widget.viewModel.setCarOwnerLicenseFrontImage(image);
        break;

      case "UPLOAD_DOCUMENTS.CAR_OWNER_CARD_IDENITY_FRONT":
        widget.viewModel.setCarOwnerIdentityCardFrontImage(image);
        break;

      case "UPLOAD_DOCUMENTS.CAR_DRIVER_CARD_IDENITY_FRONT":
        widget.viewModel.setCarDriverIdentityCardFrontImage(image);
        break;
      case "UPLOAD_DOCUMENTS.CAR_DOCUMENT_BACK":
        widget.viewModel.setCarDocumentBackImage(image);
        break;

      case "UPLOAD_DOCUMENTS.CAR_OWNER_LICENSE_BACK":
        widget.viewModel.setCarOwnerLicenseBackImage(image);
        break;

      case "UPLOAD_DOCUMENTS.CAR_OWNER_CARD_IDENITY_BACK":
        widget.viewModel.setCarOwnerIdentityCardBackImage(image);
        break;

      case "UPLOAD_DOCUMENTS.CAR_DRIVER_CARD_IDENITY_BACK":
        widget.viewModel.setCarDriverIdentityCardBackImage(image);
        break;

      default:
        if (kDebugMode) {
          print('no selected type');
        }
    }
  }

  void handleSelectedExpireDate(String uploadFor, String date) {
    switch (uploadFor) {
      case "UPLOAD_DOCUMENTS.CAR_DOCUMENT":
        widget.viewModel.setCarDocumentExpireDate(date);
        break;
      case "UPLOAD_DOCUMENTS.CAR_OWNER_LICENSE":
        widget.viewModel.setCarOwnerLicenseExpireDate(date);
        break;
      case "UPLOAD_DOCUMENTS.CAR_OWNER_CARD_IDENITY":
        widget.viewModel.setCarOwnerIdentityCardExpireDate(date);
        break;
      case "UPLOAD_DOCUMENTS.CAR_DRIVER_CARD_IDENITY":
        widget.viewModel.setCarDriverIdentityCardExpireDate(date);
        break;
    }
  }
}

class UploadDocumentsArguments {
  String uploadDocumentFor;

  UploadDocumentsArguments({required this.uploadDocumentFor});
}
