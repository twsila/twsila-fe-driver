import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/register_business_owner_viewmodel.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/widgets/header_widget.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/widgets/input_fields.dart';
import 'package:taxi_for_you/presentation/common/state_renderer/dialogs.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_scaffold.dart';
import 'package:taxi_for_you/presentation/common/widgets/page_builder.dart';
import 'package:taxi_for_you/presentation/login/bloc/login_bloc.dart';
import 'package:taxi_for_you/presentation/service_registration/bloc/serivce_registration_bloc.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';
import 'package:taxi_for_you/utils/resources/constants_manager.dart';
import 'package:taxi_for_you/utils/resources/routes_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../../utils/resources/assets_manager.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/strings_manager.dart';

class RegisterBusinessOwnerScreen extends StatefulWidget {
  final String mobileNumber;

  RegisterBusinessOwnerScreen({Key? key, required this.mobileNumber})
      : super(key: key);

  @override
  State<RegisterBusinessOwnerScreen> createState() =>
      _RegisterBusinessOwnerScreenState();
}

class _RegisterBusinessOwnerScreenState
    extends State<RegisterBusinessOwnerScreen> {
  XFile? captainPhoto = XFile('');
  ImagePicker imgpicker = ImagePicker();
  final RegisterBusinessOwnerViewModel businessOwnerViewModel =
      RegisterBusinessOwnerViewModel();

  @override
  void initState() {
    businessOwnerViewModel.bind(widget.mobileNumber);
    super.initState();
  }

  @override
  void dispose() {
    businessOwnerViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state is LoginLoadingState) {
              setState(() {
                businessOwnerViewModel.displayLoadingIndicator = true;
              });
            } else {
              setState(() {
                businessOwnerViewModel.displayLoadingIndicator = false;
              });
            }
            if (state is LoginSuccessState) {
              businessOwnerViewModel.appPreferences.setUserLoggedIn();
              DriverBaseModel cachedDriver = state.driver;
              cachedDriver.captainType = RegistrationConstants.businessOwner;
              await businessOwnerViewModel.appPreferences
                  .setDriver(cachedDriver);
              DriverBaseModel? driver =
                  businessOwnerViewModel.appPreferences.getCachedDriver();
              if (driver != null) {
                Navigator.pushReplacementNamed(
                    context, Routes.welcomeToTwsilaBO);
              }
            }
            if (state is LoginFailState) {
              CustomDialog(context).showErrorDialog('', '', state.message);
            }
          },
          child: const SizedBox(),
        ),
        BlocListener<ServiceRegistrationBloc, ServiceRegistrationState>(
            listener: (context, state) {
              if (state is ServiceRegistrationLoading) {
                setState(() {
                  businessOwnerViewModel.displayLoadingIndicator = true;
                });
              } else {
                setState(() {
                  businessOwnerViewModel.displayLoadingIndicator = false;
                });
                if (state is ServiceBORegistrationSuccess) {
                  BlocProvider.of<LoginBloc>(context).add(
                    MakeLoginBOEvent(
                      businessOwnerViewModel.mobileNumberController.text,
                      businessOwnerViewModel.appPreferences.getAppLanguage(),
                    ),
                  );
                }
                if (state is ServiceRegistrationFail) {
                  CustomDialog(context).showErrorDialog('', '', state.message);

                  // Navigator.pushReplacementNamed(context, Routes.welcomeToTwsilaBO);
                }
              }
            },
            child: CustomScaffold(
              pageBuilder: PageBuilder(
                scaffoldKey: businessOwnerViewModel.scaffoldKey,
                context: context,
                resizeToAvoidBottomInsets: true,
                displayLoadingIndicator:
                    businessOwnerViewModel.displayLoadingIndicator,
                body: Container(
                  margin: const EdgeInsets.all(AppMargin.m28),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RegistrationBOHeaderWidget(),
                        const SizedBox(height: AppSize.s20),
                        _uploadBOPhoto(),
                        const SizedBox(height: AppSize.s20),
                        RegistartionBOInputFields(
                            viewModel: businessOwnerViewModel),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget _uploadBOPhoto() {
    return GestureDetector(
      onTap: () {
        openImages();
      },
      child: Row(
        children: [
          captainPhoto != null && captainPhoto!.path != ""
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Image.file(
                    File(captainPhoto!.path),
                    width: AppSize.s60,
                    height: AppSize.s60,
                  ))
              : Image.asset(
                  ImageAssets.personIcon,
                  width: AppSize.s36,
                  height: AppSize.s36,
                ),
          const SizedBox(
            width: AppSize.s12,
          ),
          Text(
            AppStrings.uploadBusinessOwnerPhoto.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: ColorManager.primary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  openImages() async {
    showModalBottomSheet(
        elevation: 10,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) => Container(
              height: 150,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: () async {
                      try {
                        var pickedfile = await imgpicker.pickImage(
                            source: ImageSource.gallery);
                        setState(() {
                          captainPhoto = pickedfile;
                          businessOwnerViewModel
                              .businessOwnerModel.profileImage = captainPhoto;
                        });
                      } catch (e) {
                        ShowDialogHelper.showErrorMessage(
                            e.toString(), context);
                      }
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppStrings.gallery.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  const SizedBox(height: 32),
                  InkWell(
                    onTap: () async {
                      try {
                        var pickedfile = await imgpicker.pickImage(
                          source: ImageSource.camera,
                        );
                        setState(() {
                          captainPhoto = pickedfile;
                          businessOwnerViewModel
                              .businessOwnerModel.profileImage = captainPhoto;
                        });
                      } catch (e) {
                        ShowDialogHelper.showErrorMessage(
                            e.toString(), context);
                      }
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppStrings.camera.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                ],
              ),
            ));
  }
}

class BoRegistrationArguments {
  String mobileNumber;

  BoRegistrationArguments(this.mobileNumber);
}
