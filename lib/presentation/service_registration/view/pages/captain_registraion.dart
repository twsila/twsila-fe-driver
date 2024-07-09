import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_input_field.dart';
import 'package:taxi_for_you/presentation/service_registration/bloc/serivce_registration_bloc.dart';
import 'package:taxi_for_you/presentation/service_registration/view/pages/serivce_registration_first_step_view.dart';
import 'package:taxi_for_you/utils/ext/date_ext.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/routes_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../common/state_renderer/dialogs.dart';
import '../../../common/widgets/custom_scaffold.dart';
import '../../../common/widgets/page_builder.dart';

class CaptainRegistrationView extends StatefulWidget {

  String mobileNumber;

  CaptainRegistrationView({Key? key, required this.mobileNumber})
      : super(key: key);

  @override
  State<CaptainRegistrationView> createState() =>
      _CaptainRegistrationViewState();
}

class _CaptainRegistrationViewState extends State<CaptainRegistrationView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _displayLoadingIndicator = false;
  bool agreeWithTerms = false;
  bool isMale = false;
  bool isFemale = false;
  XFile? captainPhoto = XFile('');
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  String? birthDate;
  String? nationalIdNumber;
  String? nationalIdExpiryDate;
  Function()? continueFunction;
  ImagePicker imgpicker = ImagePicker();

  DateTime selectedDate = DateTime(2005, 1);

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
        appbar: true,
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
      if (state is captainDataAddedState) {
        Navigator.pushNamed(context, Routes.serviceRegistrationFirstStep,
            arguments: ServiceRegistrationFirstStepArguments(
                state.registrationRequest));
      }
      if (state is CaptainDataIsValid) {
        continueFunction = () {
          bool validate = _formKey.currentState!.validate();
          if (validate) {
            BlocProvider.of<ServiceRegistrationBloc>(context).add(
                SetCaptainData(
                    captainPhoto!,
                    widget.mobileNumber,
                    firstName!,
                    lastName!,
                    email ?? "",
                    gender!,
                    birthDate!,
                    nationalIdNumber!,
                    nationalIdExpiryDate!));
          }
        };
      }
      if (state is CaptainDataIsNotValid) {
        continueFunction = null;
      }
    }, builder: (context, state) {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Container(
            margin: EdgeInsets.all(AppSize.s8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _headerText(),
                  const SizedBox(
                    height: AppSize.s30,
                  ),
                  _uploadCaptainPhoto(),
                  const SizedBox(
                    height: AppSize.s28,
                  ),
                  _inputFields(),
                  CustomTextButton(
                      onPressed:
                          continueFunction != null ? continueFunction : null,
                      text: AppStrings.continueStr.tr())
                ],
              ),
            ),
          ),
        ),
      );
    });
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
                        captainPhoto = pickedfile;
                        validateInputsToContinue();
                        setState(() {});
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
                        captainPhoto = pickedfile;
                        validateInputsToContinue();
                        setState(() {});
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

  Widget _headerText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              '${AppStrings.welcomeInto.tr()} ',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: ColorManager.blackTextColor),
            ),
            Text(
              AppStrings.twsela.tr(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: ColorManager.primary),
            ),
          ],
        ),
        Text(
          AppStrings.pleaseResumePersonalData.tr(),
          style: Theme.of(context)
              .textTheme
              .displayLarge
              ?.copyWith(color: ColorManager.blackTextColor),
        ),
      ],
    );
  }

  Widget _uploadCaptainPhoto() {
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
            AppStrings.uploadCaptainPhoto.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: ColorManager.primary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _inputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextInputField(
          labelText: AppStrings.firstName.tr(),
          showLabelText: true,
          hintText: AppStrings.enterFirstNameHere.tr(),
          validateSpecialCharacter: true,
          isCharacterOnly: true,
          onChanged: (value) {
            firstName = value;
            validateInputsToContinue();
          },
        ),
        CustomTextInputField(
          labelText: AppStrings.lastName.tr(),
          showLabelText: true,
          hintText: AppStrings.enterLastNameHere.tr(),
          validateSpecialCharacter: true,
          isCharacterOnly: true,
          onChanged: (value) {
            lastName = value;
            validateInputsToContinue();
          },
        ),
        CustomTextInputField(
          labelText: AppStrings.email.tr(),
          showLabelText: true,
          hintText: AppStrings.emailHint.tr(),
          validateEmptyString: false,
          validateEmail: true,
          onChanged: (value) {
            email = value;
            validateInputsToContinue();
          },
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: AppMargin.m12),
          child: Text(
            AppStrings.birtDate.tr(),
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: ColorManager.headersTextColor),
          ),
        ),
        CustomDateOfBirth(),
        CustomTextInputField(
          labelText: AppStrings.nationalIdNumber.tr(),
          showLabelText: true,
          hintText: AppStrings.nationalIdNumberHint.tr(),
          validateEmptyString: true,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            nationalIdNumber = value;
            validateInputsToContinue();
          },
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: AppMargin.m12),
          child: Text(
            AppStrings.nationalIdExpiryDate.tr(),
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: ColorManager.headersTextColor),
          ),
        ),
        CustomNationalIdExpiryDateWidget(),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isFemale = false;
                    isMale = true;
                    gender = 'M';
                    validateInputsToContinue();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color:
                          isMale ? ColorManager.purpleFade : ColorManager.white,
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: ColorManager.borderColor)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p22, vertical: AppPadding.p12),
                      child: Text(
                        AppStrings.male.tr(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                fontSize: FontSize.s16,
                                color: ColorManager.headersTextColor,
                                fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: AppSize.s12,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isMale = false;
                    isFemale = true;
                    gender = 'F';
                    validateInputsToContinue();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: isFemale
                          ? ColorManager.purpleFade
                          : ColorManager.white,
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: ColorManager.borderColor)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p22, vertical: AppPadding.p12),
                      child: Text(
                        AppStrings.female.tr(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                fontSize: FontSize.s16,
                                color: ColorManager.headersTextColor,
                                fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSize.s10),
        Row(
          children: <Widget>[
            //SizedBox
            Checkbox(
              side: BorderSide(
                  color: ColorManager.secondaryColor, width: AppSize.s1_5),
              activeColor: ColorManager.secondaryColor,
              focusColor: ColorManager.primary,
              checkColor: ColorManager.white,
              value: agreeWithTerms,
              onChanged: (value) {
                setState(() {
                  agreeWithTerms = value!;
                  validateInputsToContinue();
                });
              },
            ), //
            Expanded(
              child: Wrap(
                children: [
                  Text(
                    '${AppStrings.iReadAndAgreeWith.tr()} ${AppStrings.termsAndConditions.tr()} ${AppStrings.tawsilaApplication.tr()}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: FontSize.s16,
                          color: ColorManager.headersTextColor,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ), //TextSizedBox
          ], //<Widget>[]
        ), //Row
      ],
    );
  }

  Widget CustomDateOfBirth() {
    return GestureDetector(
      onTap: () {
        _selectDate(context);
      },
      child: Container(
        margin: EdgeInsets.all(AppMargin.m12),
        padding: EdgeInsets.symmetric(horizontal: AppPadding.p12),
        height: AppSize.s46,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: ColorManager.borderColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p2),
              child: Text(
                birthDate != null
                    ? birthDate!.getTimeStampFromDate(pattern: 'dd MMM yyyy')
                    : AppStrings.birtDateHint.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: birthDate != null
                        ? ColorManager.headersTextColor
                        : ColorManager.hintTextColor),
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: ColorManager.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget CustomNationalIdExpiryDateWidget() {
    return GestureDetector(
      onTap: () {
        _selectNationalIdExpiryDate(context);
      },
      child: Container(
        margin: EdgeInsets.all(AppMargin.m12),
        padding: EdgeInsets.symmetric(horizontal: AppPadding.p12),
        height: AppSize.s46,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: ColorManager.borderColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p2),
              child: Text(
                nationalIdExpiryDate != null
                    ? nationalIdExpiryDate!
                        .getTimeStampFromDate(pattern: 'dd MMM yyyy')
                    : AppStrings.nationalIdExpiryDateHint.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: nationalIdExpiryDate != null
                        ? ColorManager.headersTextColor
                        : ColorManager.hintTextColor),
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: ColorManager.primary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1940, 8),
        lastDate: DateTime(2005, 1));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        birthDate = selectedDate.millisecondsSinceEpoch.toString();
        validateInputsToContinue();
      });
    }
  }
  Future<void> _selectNationalIdExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate:  DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(3000, 1));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        nationalIdExpiryDate = selectedDate.millisecondsSinceEpoch.toString();
        validateInputsToContinue();
      });
    }
  }

  void validateInputsToContinue() {
    BlocProvider.of<ServiceRegistrationBloc>(context).add(addCaptainData(
        captainPhoto: captainPhoto!,
        firstName: firstName,
        lastName: lastName,
        email: email,
        gender: gender,
        birthDate: birthDate,
        nationalIdNumber: nationalIdNumber,
        nationalIdExpiryDate: nationalIdExpiryDate,
        agreeWithTerms: agreeWithTerms));
  }
}

class captainRegistrationArgs {
  String mobileNumber;

  captainRegistrationArgs(this.mobileNumber);
}
