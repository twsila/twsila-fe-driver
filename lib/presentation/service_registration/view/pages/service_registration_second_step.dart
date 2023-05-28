import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_for_you/presentation/common/widgets/CustomAutoFullSms.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';

import '../../../../app/app_prefs.dart';
import '../../../../app/di.dart';
import '../../../../domain/model/ServiceTypeModel.dart';
import '../../../../domain/model/car_brand_models_model.dart';
import '../../../../domain/model/vehicleModel.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/font_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../../utils/resources/values_manager.dart';
import '../../../common/widgets/CustomVerificationCodeWidget.dart';
import '../../../common/widgets/custom_scaffold.dart';
import '../../../common/widgets/multi_pick_image.dart';
import '../../../common/widgets/page_builder.dart';
import '../../bloc/serivce_registration_bloc.dart';
import '../widgets/services_card_widget.dart';

class ServiceRegistrationSecondStep extends StatefulWidget {
  const ServiceRegistrationSecondStep({Key? key}) : super(key: key);

  @override
  State<ServiceRegistrationSecondStep> createState() =>
      _ServiceRegistrationSecondStepState();
}

class _ServiceRegistrationSecondStepState
    extends State<ServiceRegistrationSecondStep> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  bool _displayLoadingIndicator = false;
  bool _loadingCars = false;
  List<CarModel>? carModelList;
  CarModel? selectedCarModel;

  @override
  void initState() {
    BlocProvider.of<ServiceRegistrationBloc>(context)
        .add(GetCarBrandAndModel());
    super.initState();
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
        if (state is ServiceRegistrationLoading) {
          startLoading();
        } else {
          stopLoading();
        }
        if (state is CarBrandsAndModelsSuccess) {
          _loadingCars = false;
          carModelList = state.carModelList;
        }
      },
      builder: (context, state) {
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
                      border:
                          Border.all(color: ColorManager.borderColor, width: 1),
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
                                  selectedCarModel?.carModel ??
                                      AppStrings.carModelAndBrand.tr(),
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
                      fontSize: FontSize.s14,
                      color: ColorManager.titlesTextColor),
                ),
                SizedBox(
                  height: AppSize.s12,
                ),
                CustomVerificationCode(
                  onComplete: (plateNumber) {},
                ),
                SizedBox(
                  height: AppSize.s18,
                ),
                TextFormField(
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
                        borderSide:
                            BorderSide(color: ColorManager.borderColor)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                        borderSide:
                            BorderSide(color: ColorManager.borderColor)),
                    filled: true,
                    contentPadding:
                        EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                  ),
                ),
                MutliPickImageWidget(
                  (List<XFile>? images) {
                    print(images!.length);
                  },
                  AppStrings.uploadCarPhotos.tr(),
                  AppStrings.addPhotos.tr(),
                  Image.asset(ImageAssets.photosIcon, width: AppSize.s20),
                  ColorManager.secondaryColor,
                  fontSize: FontSize.s10,
                ),
                MutliPickImageWidget((List<XFile>? images) {
                  print(images!.length);
                },
                    AppStrings.uploadCarDocumentPhoto.tr(),
                    AppStrings.documentPhoto.tr(),
                    Image.asset(ImageAssets.photosIcon, width: AppSize.s20),
                    ColorManager.secondaryColor,
                    addMultiplePhotos: false,
                    fontSize: FontSize.s10),
                MutliPickImageWidget((List<XFile>? images) {
                  print(images!.length);
                },
                    AppStrings.uploadCarDriverLicPhoto.tr(),
                    AppStrings.carDriverLicPhoto.tr(),
                    Image.asset(ImageAssets.documentIcon, width: AppSize.s20),
                    ColorManager.secondaryColor,
                    addMultiplePhotos: false,
                    fontSize: FontSize.s10),
                MutliPickImageWidget((List<XFile>? images) {
                  print(images!.length);
                },
                    AppStrings.uploadCarOwnerIDPhoto.tr(),
                    AppStrings.carOwnerIdPhoto.tr(),
                    Image.asset(ImageAssets.documentIcon, width: AppSize.s20),
                    ColorManager.secondaryColor,
                    addMultiplePhotos: false,
                    fontSize: FontSize.s10),
                MutliPickImageWidget((List<XFile>? images) {
                  print(images!.length);
                },
                    AppStrings.uploadCarDriverIDPhoto.tr(),
                    AppStrings.carDriverIdPhoto.tr(),
                    Image.asset(ImageAssets.documentIcon, width: AppSize.s20),
                    ColorManager.secondaryColor,
                    addMultiplePhotos: false,
                    fontSize: FontSize.s10),
                CustomTextButton(
                  text: AppStrings.applyRequest.tr(),
                  onPressed: () {},
                )
              ],
            ),
          ),
        );
      },
    );
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
                      });
                    },
                    child: ListTile(
                        title: Text(carModelList[index].carModel),
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
}
