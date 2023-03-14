import 'dart:io';

import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../utils/resources/assets_manager.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/routes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../../utils/resources/styles_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../common/state_renderer/state_renderer_impl.dart';
import '../../common/widgets/custom_dropdown.dart';
import '../../common/widgets/custom_text_input_field.dart';
import '../viewmodel/register_viewmodel.dart';

enum UPLOAD_DOCUMENTS {
  CAR_DOCUMENT,
  CAR_OWNER_LICENSE,
  CAR_OWNER_CARD_IDENITY,
  CAR_DRIVER_CARD_IDENITY
}

extension DocumentTypeNumber on UPLOAD_DOCUMENTS {
  int get documentTypeNumber {
    switch (this) {
      case UPLOAD_DOCUMENTS.CAR_DOCUMENT:
        return 1;
      case UPLOAD_DOCUMENTS.CAR_OWNER_LICENSE:
        return 2;
      case UPLOAD_DOCUMENTS.CAR_OWNER_CARD_IDENITY:
        return 3;
      case UPLOAD_DOCUMENTS.CAR_DRIVER_CARD_IDENITY:
        return 4;
    }
  }
}

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterViewModel _viewModel = instance<RegisterViewModel>();
  final ImagePicker _imagePicker = instance<ImagePicker>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final _formKey = GlobalKey<FormState>();
  bool showPplDropdown = false;
  List<String> list1 = ["نقل افراد", "نقل بضائع و اثاث"];
  List<String> list2 = [
    "حافلة 25 راكب",
    "حافلة 15 راكب",
    "سيدان 7 ركاب ",
    "سيدان 5 ركاب"
  ];

  final TextEditingController _numberPlateTextController =
      TextEditingController();
  final TextEditingController _notesTextController = TextEditingController();
  final TextEditingController _carModelAndBrandTextController =
      TextEditingController();

  bool _isAgreeChecked = false;

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  _bind() {
    _viewModel.start();
    _numberPlateTextController.addListener(() {
      _viewModel
          .setPlateNumber(int.parse(_carModelAndBrandTextController.text));
    });

    _notesTextController.addListener(() {
      _viewModel.setNotes(_notesTextController.text);
    });

    _carModelAndBrandTextController.addListener(() {
      _viewModel.setCardBrandAndModel(_carModelAndBrandTextController.text);
    });

    _viewModel.isUserRegisteredInSuccessfullyStreamController.stream
        .listen((isUserRegisterSuccessfully) {
      if (isUserRegisterSuccessfully) {
        // navigate to main screen
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _appPreferences.setUserLoggedIn();
          Navigator.of(context).pushReplacementNamed(Routes.categoriesRoute);
        });
      }
    });
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        elevation: AppSize.s0,
        backgroundColor: ColorManager.white,
        iconTheme: IconThemeData(color: ColorManager.primary),
      ),
      body: _getContentWidget(),
    );
  }

  Widget _getContentWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Text(
              "بيانات المركبة",
              style: getRegularStyle(
                  color: ColorManager.primary, fontSize: FontSize.s20),
            ),
          ),
          Container(
              padding: const EdgeInsets.only(
                  right: AppPadding.p28,
                  top: AppPadding.p28,
                  left: AppPadding.p28),
              child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "نرجو اختيار نوع الخدمة التى تقدمها ",
                            style: getRegularStyle(
                                color: ColorManager.primary,
                                fontSize: FontSize.s16),
                          ),
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: CustomDropDown(
                            backgroundColor: ColorManager.white,
                            isTitleBold: false,
                            stringsArr: list1,
                            isValid: true,
                            hintTextColor: ColorManager.grey,
                            hintText: 'اختر من هنا',
                            textColor: ColorManager.primary,
                            borderColor: ColorManager.grey,
                            onChanged: (selectedValue) {
                              _viewModel.setServiceType(selectedValue!);
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        StreamBuilder<bool>(
                            stream: _viewModel.outputServiceType,
                            builder: (context, snapshot) {
                              return snapshot.data ?? false
                                  ? Directionality(
                          textDirection: TextDirection.rtl,
                          child: CustomDropDown(
                            backgroundColor: ColorManager.white,
                            isTitleBold: false,
                            stringsArr: list2,
                            isValid: true,
                            hintTextColor: ColorManager.grey,
                            hintText: 'اختر من هنا',
                            textColor: ColorManager.primary,
                            borderColor: ColorManager.grey,
                            onChanged: (selectedValue) {
                                          _viewModel.setServiceCapacity(
                                              selectedValue!);
                            },
                          ),
                                    )
                                  : Container();
                            }),
                        numberField(
                            'رقم اللوحة',
                            CustomTextInputField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                _viewModel.setPlateNumber(int.parse(value));
                              },
                            )),
                        numberField(
                            'نوع السيارة و الموديل',
                            CustomTextInputField(
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                _viewModel.setCardBrandAndModel(value);
                              },
                            )),
                        numberField(
                            'اى ملاحظات خاصة بالسيارة',
                            CustomTextInputField(
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                _viewModel.setNotes(value);
                              },
                            )),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "تحميل صورة السيارة",
                            style: getRegularStyle(
                                color: ColorManager.primary,
                                fontSize: FontSize.s16),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              _showPicker(
                                  context, UPLOAD_DOCUMENTS.CAR_DOCUMENT);
                            },
                            child: _getMediaWidget("صورة استمارة السيارة",
                                _viewModel.outputCarDocumentImage)),
                        GestureDetector(
                            onTap: () {
                              _showPicker(
                                  context, UPLOAD_DOCUMENTS.CAR_OWNER_LICENSE);
                            },
                            child: _getMediaWidget("صورة رخصة قائد السيارة",
                                _viewModel.outputCarOwnerLicenseImage)),
                        GestureDetector(
                            onTap: () {
                              _showPicker(context,
                                  UPLOAD_DOCUMENTS.CAR_OWNER_CARD_IDENITY);
                            },
                            child: _getMediaWidget("صورة هوية مالك السيارة",
                                _viewModel.outputCarOwnerIdentityCardImage)),
                        GestureDetector(
                            onTap: () {
                              _showPicker(context,
                                  UPLOAD_DOCUMENTS.CAR_DRIVER_CARD_IDENITY);
                            },
                            child: _getMediaWidget("صورة  هوية قائد السيارة",
                                _viewModel.outputCarDriverIdentityCardImage)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "سيتم تحديد موعد لعمل مقابلة عبر احد تطبيقات الفيديو لمعاينة السيارة للتأكد من صحة بيانات لتفعيل الحساب",
                            textAlign: TextAlign.center,
                            style: getRegularStyle(
                                color: ColorManager.primary,
                                fontSize: FontSize.s12),
                          ),
                        ),
                        Text(
                          "السياسات و الشروط و الاحكام ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: ColorManager.primary,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  "اقر بان كافة البيانات صحيحة و انى قرات سياسات الشركة و موافق عليها",
                                  style: getRegularStyle(
                                      color: ColorManager.black,
                                      fontSize: FontSize.s10),
                                ),
                              ),
                              Checkbox(
                                  value: _isAgreeChecked,
                                  onChanged: (isChecked) {
                                    setState(() {
                                      _isAgreeChecked = isChecked!;
                                    });
                                  }),
                            ],
                          ),
                        ),
                        StreamBuilder<bool>(
                            stream: _viewModel.outputAreAllInputsValid,
                            builder: (context, snapshot) {
                              return Container(
                                margin: EdgeInsets.all(10),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: AppSize.s40,
                                  child: ElevatedButton(
                                      onPressed: ((snapshot.data == true &&
                                              _isAgreeChecked))
                                          ? () {
                                              // _viewModel.register();
                                              Navigator.pushReplacementNamed(
                                                  context,
                                                  Routes.pendingApprovalRoute);
                                            }
                                          : null,
                                      child: const Text("تــاكيــد")),
                                ),
                              );
                            }),
                      ],
                    )),
              )),
        ],
      ),
    );
  }

  Widget numberField(String text, Widget widget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 120,
          child: widget,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: getRegularStyle(
              color: ColorManager.primary, fontSize: FontSize.s16),
        ),
      ],
    );
  }

  _showPicker(BuildContext context, UPLOAD_DOCUMENTS uploadDocuments) {
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
                  _imageFromGallery(uploadDocuments);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(AppStrings.photoCamera.tr()),
                onTap: () {
                  _imageFromCamera(uploadDocuments);
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
        });
  }

  _imageFromGallery(UPLOAD_DOCUMENTS uploadDocumentType) async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    handleViewModelDocuments(uploadDocumentType, File(image?.path ?? ""));
  }

  _imageFromCamera(UPLOAD_DOCUMENTS uploadDocumentType) async {
    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    handleViewModelDocuments(uploadDocumentType, File(image?.path ?? ""));
  }

  void handleViewModelDocuments(UPLOAD_DOCUMENTS selectedType, File image) {
    switch (selectedType) {
      case UPLOAD_DOCUMENTS.CAR_DOCUMENT:
        _viewModel.setCarDocumentImage(image);
        break;

      case UPLOAD_DOCUMENTS.CAR_OWNER_LICENSE:
        _viewModel.setCarOwnerLicenseImage(image);
        break;

      case UPLOAD_DOCUMENTS.CAR_OWNER_CARD_IDENITY:
        _viewModel.setCarOwnerIdentityCardImage(image);
        break;

      case UPLOAD_DOCUMENTS.CAR_DRIVER_CARD_IDENITY:
        _viewModel.setCarDriverIdentityCardImage(image);
        break;

      default:
        if (kDebugMode) {
          print('no selected type');
        }
    }
  }

  Widget _getMediaWidget(String text, Stream<File> documentOutputStream) {
    return Padding(
      padding: const EdgeInsets.only(
          left: AppPadding.p8, right: AppPadding.p8, top: AppPadding.p12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child: StreamBuilder<File>(
            stream: documentOutputStream,
            builder: (context, snapshot) {
              return _imagePicketByUser(snapshot.data);
            },
          )),
          Flexible(
              child: Text(
            text,
            style: getRegularStyle(
                color: ColorManager.primary, fontSize: FontSize.s16),
          )),
        ],
      ),
    );
  }

  Widget _imagePicketByUser(File? image) {
    if (image != null && image.path.isNotEmpty) {
      // return image
      return Image.file(image);
    } else {
      return SizedBox(
          width: 60,
          height: 60,
          child: SvgPicture.asset(ImageAssets.photoCameraIc));
    }
  }
}
