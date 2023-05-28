import 'dart:io';

import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_for_you/app/constants.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_card.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_checkbox.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_date_picker.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_dialog.dart';
import 'package:taxi_for_you/presentation/goods_register/view/upload_documents_view.dart';
import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../utils/resources/assets_manager.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/langauge_manager.dart';
import '../../../utils/resources/routes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../../utils/resources/styles_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../common/state_renderer/state_renderer_impl.dart';
import '../../common/widgets/custom_dropdown.dart';
import '../../common/widgets/custom_text_input_field.dart';
import '../../common/widgets/multi_pick_image.dart';
import '../viewmodel/goods_register_viewmodel.dart';

import 'dart:math' as math;

enum UPLOAD_DOCUMENTS {
  CAR_DOCUMENT,
  CAR_OWNER_LICENSE,
  CAR_OWNER_CARD_IDENITY,
  CAR_DRIVER_CARD_IDENITY,
  CAR_DOCUMENT_FRONT,
  CAR_OWNER_LICENSE_FRONT,
  CAR_OWNER_CARD_IDENITY_FRONT,
  CAR_DRIVER_CARD_IDENITY_FRONT,
  CAR_DOCUMENT_BACK,
  CAR_OWNER_LICENSE_BACK,
  CAR_OWNER_CARD_IDENITY_BACK,
  CAR_DRIVER_CARD_IDENITY_BACK,
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
      case UPLOAD_DOCUMENTS.CAR_DOCUMENT_FRONT:
        return 5;
      case UPLOAD_DOCUMENTS.CAR_OWNER_LICENSE_FRONT:
        return 6;
      case UPLOAD_DOCUMENTS.CAR_OWNER_CARD_IDENITY_FRONT:
        return 7;
      case UPLOAD_DOCUMENTS.CAR_DRIVER_CARD_IDENITY_FRONT:
        return 8;
      case UPLOAD_DOCUMENTS.CAR_DOCUMENT_BACK:
        return 9;
      case UPLOAD_DOCUMENTS.CAR_OWNER_LICENSE_BACK:
        return 10;
      case UPLOAD_DOCUMENTS.CAR_OWNER_CARD_IDENITY_BACK:
        return 11;
      case UPLOAD_DOCUMENTS.CAR_DRIVER_CARD_IDENITY_BACK:
        return 12;
    }
  }
}

class GoodsRegisterView extends StatefulWidget {
  const GoodsRegisterView({Key? key}) : super(key: key);

  @override
  _GoodsRegisterViewState createState() => _GoodsRegisterViewState();
}

class _GoodsRegisterViewState extends State<GoodsRegisterView> {
  final GoodsRegisterViewModel _viewModel = instance<GoodsRegisterViewModel>();
  final ImagePicker _imagePicker = instance<ImagePicker>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final _formKey = GlobalKey<FormState>();
  bool showPplDropdown = false;

  bool _isFurntitureTransportation = false;
  bool _isGoodsTransportation = false;
  bool _isFreezersTransportation = false;
  bool _isCisterns = false;
  bool _isFlatness = false;

  bool _isloadandunload = false;
  bool _isreassembleAndAssemble = false;
  bool _isWrapping = false;
  bool _isWinchCrane = false;

  List<String> list1 = [
    AppStrings.goodsTransportations.tr(),
  ];
  List<String> list2 = [
    AppStrings.largeVehicleOpened.tr(),
    AppStrings.largeVehicleClosed.tr(),
    AppStrings.truck.tr(),
    AppStrings.tipper.tr(),
    AppStrings.wanet.tr(),
    AppStrings.motocycles.tr(),
    AppStrings.waterCisterns.tr(),
    AppStrings.sanitationCisterns.tr(),
    AppStrings.freezer.tr(),
    AppStrings.flatness.tr(),
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
              AppStrings.carInfo.tr(),
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
                        Text(
                          AppStrings.pleaseEnterServiceYouProvide.tr(),
                          style: getRegularStyle(
                              color: ColorManager.primary,
                              fontSize: FontSize.s16),
                        ),
                        CustomDropDown(
                          backgroundColor: ColorManager.white,
                          isTitleBold: false,
                          stringsArr: list1,
                          isValid: true,
                          hintTextColor: ColorManager.grey,
                          hintText: AppStrings.selectFromHereHint.tr(),
                          textColor: ColorManager.primary,
                          borderColor: ColorManager.grey,
                          onChanged: (selectedValue) {
                            _viewModel.setServiceType(selectedValue!);
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        StreamBuilder<bool>(
                            stream: _viewModel.outputServiceType,
                            builder: (context, snapshot) {
                              return snapshot.data ?? false
                                  ? Column(
                                      children: [
                                        CustomDropDown(
                                          title: AppStrings.carType.tr(),
                                          backgroundColor: ColorManager.white,
                                          isTitleBold: false,
                                          stringsArr: list2,
                                          isValid: true,
                                          hintTextColor: ColorManager.grey,
                                          hintText: AppStrings
                                              .selectFromHereHint
                                              .tr(),
                                          textColor: ColorManager.primary,
                                          borderColor: ColorManager.grey,
                                          onChanged: (selectedValue) {
                                            _viewModel.setServiceCapacity(
                                                selectedValue!);
                                          },
                                        ),
                                      ],
                                    )
                                  : Container();
                            }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomCheckBox(
                              checked: _isFreezersTransportation,
                              fieldName: AppStrings.freezers.tr(),
                              onChange: (value) {
                                setState(() {
                                  _isFreezersTransportation = value;
                                });
                              },
                            ),
                            CustomCheckBox(
                              checked: _isFurntitureTransportation,
                              fieldName:
                                  AppStrings.furnitureTransportation.tr(),
                              onChange: (value) {
                                setState(() {
                                  _isFurntitureTransportation = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomCheckBox(
                              checked: _isGoodsTransportation,
                              fieldName: AppStrings.goodsTransportations.tr(),
                              onChange: (value) {
                                setState(() {
                                  _isGoodsTransportation = value;
                                });
                              },
                            ),
                            CustomCheckBox(
                              checked: _isCisterns,
                              fieldName: AppStrings.cisterns.tr(),
                              onChange: (value) {
                                setState(() {
                                  _isCisterns = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomCheckBox(
                              checked: _isFlatness,
                              fieldName: AppStrings.flatness.tr(),
                              onChange: (value) {
                                setState(() {
                                  _isFlatness = value;
                                });
                              },
                            ),
                          ],
                        ),
                        numberField(
                            AppStrings.plateNumber.tr(),
                            CustomTextInputField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                _viewModel.setPlateNumber(int.parse(value));
                              },
                            )),
                        numberField(
                            AppStrings.carModelAndBrand.tr(),
                            CustomTextInputField(
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                _viewModel.setCardBrandAndModel(value);
                              },
                            )),
                        numberField(
                            AppStrings.carNotes.tr(),
                            CustomTextInputField(
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                _viewModel.setNotes(value);
                              },
                            )),
                        // MutliPickImageWidget(
                        //   onPickedImages: (List<XFile>? images) {},
                        // ),
                        CustomCard(
                            onClick: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UploadDocumentsView(
                                    viewModel: _viewModel,
                                  ),
                                  settings: RouteSettings(
                                    name: Constants.UPLOAD_DOCUMENTS_TYPE,
                                    arguments: UploadDocumentsArguments(
                                        uploadDocumentFor: UPLOAD_DOCUMENTS
                                            .CAR_DOCUMENT
                                            .toString()),
                                  ),
                                ),
                              );
                            },
                            bodyWidget: StreamBuilder<bool>(
                                stream: _viewModel
                                    .outputAreAllCarDocumentsInputsValid,
                                builder: (context, snapshot) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppStrings.carDocumentsInfo.tr(),
                                        style: getRegularStyle(
                                            color: ColorManager.primary,
                                            fontSize: FontSize.s16),
                                      ),
                                      snapshot.data == true
                                          ? Icon(
                                              Icons.check_circle,
                                              color: ColorManager.green,
                                            )
                                          : Transform(
                                              alignment: Alignment.center,
                                              transform: Matrix4.rotationY(
                                                  isRtl() ? math.pi : 0),
                                              child: SvgPicture.asset(
                                                  ImageAssets
                                                      .rightArrowSettingsIc),
                                            ),
                                    ],
                                  );
                                })),
                        CustomCard(
                            onClick: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UploadDocumentsView(
                                    viewModel: _viewModel,
                                  ),
                                  settings: RouteSettings(
                                    name: Constants.UPLOAD_DOCUMENTS_TYPE,
                                    arguments: UploadDocumentsArguments(
                                        uploadDocumentFor: UPLOAD_DOCUMENTS
                                            .CAR_OWNER_LICENSE
                                            .toString()),
                                  ),
                                ),
                              );
                            },
                            bodyWidget: StreamBuilder<bool>(
                                stream: _viewModel
                                    .outputAreCarDriverLicenseInputsValid,
                                builder: (context, snapshot) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppStrings.carDriverLicenseInfo.tr(),
                                        style: getRegularStyle(
                                            color: ColorManager.primary,
                                            fontSize: FontSize.s16),
                                      ),
                                      snapshot.data == true
                                          ? Icon(
                                              Icons.check_circle,
                                              color: ColorManager.green,
                                            )
                                          : Transform(
                                              alignment: Alignment.center,
                                              transform: Matrix4.rotationY(
                                                  isRtl() ? math.pi : 0),
                                              child: SvgPicture.asset(
                                                  ImageAssets
                                                      .rightArrowSettingsIc),
                                            ),
                                    ],
                                  );
                                })),
                        CustomCard(
                            onClick: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UploadDocumentsView(
                                    viewModel: _viewModel,
                                  ),
                                  settings: RouteSettings(
                                    name: Constants.UPLOAD_DOCUMENTS_TYPE,
                                    arguments: UploadDocumentsArguments(
                                        uploadDocumentFor: UPLOAD_DOCUMENTS
                                            .CAR_OWNER_CARD_IDENITY
                                            .toString()),
                                  ),
                                ),
                              );
                            },
                            bodyWidget: StreamBuilder<bool>(
                                stream: _viewModel
                                    .outputAreCarOwnerIdentityInputsValid,
                                builder: (context, snapshot) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppStrings.carOwnerIdentityInfo.tr(),
                                        style: getRegularStyle(
                                            color: ColorManager.primary,
                                            fontSize: FontSize.s16),
                                      ),
                                      snapshot.data == true
                                          ? Icon(
                                              Icons.check_circle,
                                              color: ColorManager.green,
                                            )
                                          : Transform(
                                              alignment: Alignment.center,
                                              transform: Matrix4.rotationY(
                                                  isRtl() ? math.pi : 0),
                                              child: SvgPicture.asset(
                                                  ImageAssets
                                                      .rightArrowSettingsIc),
                                            ),
                                    ],
                                  );
                                })),
                        CustomCard(
                            onClick: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UploadDocumentsView(
                                    viewModel: _viewModel,
                                  ),
                                  settings: RouteSettings(
                                    name: Constants.UPLOAD_DOCUMENTS_TYPE,
                                    arguments: UploadDocumentsArguments(
                                        uploadDocumentFor: UPLOAD_DOCUMENTS
                                            .CAR_DRIVER_CARD_IDENITY
                                            .toString()),
                                  ),
                                ),
                              );
                            },
                            bodyWidget: StreamBuilder<bool>(
                                stream: _viewModel
                                    .outputAreAllCarDriverIdentityInputsValid,
                                builder: (context, snapshot) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppStrings.carDriverIdentityInfo.tr(),
                                        style: getRegularStyle(
                                            color: ColorManager.primary,
                                            fontSize: FontSize.s16),
                                      ),
                                      snapshot.data == true
                                          ? Icon(
                                              Icons.check_circle,
                                              color: ColorManager.green,
                                            )
                                          : Transform(
                                              alignment: Alignment.center,
                                              transform: Matrix4.rotationY(
                                                  isRtl() ? math.pi : 0),
                                              child: SvgPicture.asset(
                                                  ImageAssets
                                                      .rightArrowSettingsIc),
                                            ),
                                    ],
                                  );
                                })),
                        Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Text(
                            AppStrings.doYouHaveLaborAvailable.tr(),
                            textAlign: TextAlign.center,
                            style: getRegularStyle(
                                color: ColorManager.primary,
                                fontSize: FontSize.s14),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomCheckBox(
                              checked: _isloadandunload,
                              fieldName: AppStrings.loadAndUnload.tr(),
                              onChange: (value) {
                                setState(() {
                                  _isloadandunload = value;
                                });
                              },
                            ),
                            CustomCheckBox(
                              checked: _isreassembleAndAssemble,
                              fieldName: AppStrings.reassembleAndAssemble.tr(),
                              onChange: (value) {
                                setState(() {
                                  _isreassembleAndAssemble = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomCheckBox(
                              checked: _isWrapping,
                              fieldName: AppStrings.wrapping.tr(),
                              onChange: (value) {
                                setState(() {
                                  _isWrapping = value;
                                });
                              },
                            ),
                            CustomCheckBox(
                              checked: _isWinchCrane,
                              fieldName: AppStrings.winchCrane.tr(),
                              onChange: (value) {
                                setState(() {
                                  _isWinchCrane = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppStrings.registrationBottomHint.tr(),
                            textAlign: TextAlign.center,
                            style: getRegularStyle(
                                color: ColorManager.primary,
                                fontSize: FontSize.s12),
                          ),
                        ),
                        Text(
                          AppStrings.termsAndConditions.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: ColorManager.primary,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            children: [
                              Checkbox(
                                  value: _isAgreeChecked,
                                  onChanged: (isChecked) {
                                    setState(() {
                                      _isAgreeChecked = isChecked!;
                                    });
                                  }),
                              Flexible(
                                child: Text(
                                  AppStrings.agreeWithTermsAndConditions.tr(),
                                  style: getRegularStyle(
                                      color: ColorManager.black,
                                      fontSize: FontSize.s10),
                                ),
                              ),
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
                                      child: Text(AppStrings.confirm.tr())),
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
        Text(
          text,
          style: getRegularStyle(
              color: ColorManager.primary, fontSize: FontSize.s16),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 120,
          child: widget,
        ),
      ],
    );
  }

  bool isRtl() {
    return context.locale == ARABIC_LOCAL;
  }
}
