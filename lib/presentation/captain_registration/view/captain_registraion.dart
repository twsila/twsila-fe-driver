import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_input_field.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/routes_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/page_builder.dart';
import '../bloc/registration_bloc.dart';

class CaptainRegistrationView extends StatefulWidget {
  const CaptainRegistrationView({Key? key}) : super(key: key);

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
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
        resizeToAvoidBottomInsets: false,
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
    return BlocConsumer<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationLoading) {
          startLoading();
        } else {
          stopLoading();
        }
      },
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.all(AppSize.s12),
          child: Stack(children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
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
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 0,
                right: 0,
                child: CustomTextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.serviceRegistrationFirstStep);
                    }, text: AppStrings.continueStr.tr()))
          ]),
        );
      },
    );
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
    return Row(
      children: [
        Image.asset(
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
    );
  }

  Widget _inputFields() {
    return Column(
      children: [
        CustomTextInputField(
          labelText: AppStrings.userName.tr(),
          showLabelText: true,
          hintText: AppStrings.enterUserNameHere.tr(),
        ),
        CustomTextInputField(
          labelText: AppStrings.email.tr(),
          showLabelText: true,
          hintText: AppStrings.emailHint.tr(),
        ),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isFemale = false;
                    isMale = !isMale;
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
                    isFemale = !isFemale;
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
                });
              },
            ), //
            Row(
              children: [
                Text('${AppStrings.iReadAndAgreeWith.tr()} ',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: FontSize.s14,
                        color: ColorManager.headersTextColor,
                        fontWeight: FontWeight.normal)),
                Text(
                  '${AppStrings.termsAndConditions.tr()} ',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: FontSize.s14,
                      color: ColorManager.primary,
                      fontWeight: FontWeight.normal),
                ),
                Text(
                  AppStrings.tawsilaApplication.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: FontSize.s14,
                      color: ColorManager.headersTextColor,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ), //TextSizedBox
          ], //<Widget>[]
        ), //Row
      ],
    );
  }
}
