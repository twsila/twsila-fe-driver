import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_for_you/domain/model/models.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_dialog.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_scaffold.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_input_field.dart';
import 'package:taxi_for_you/presentation/otp/view/verify_otp_view.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';
import 'package:taxi_for_you/utils/dialogs/toast_handler.dart';
import 'package:taxi_for_you/utils/helpers/language_helper.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';

import 'dart:math' as math;
import '../../../app/app_prefs.dart';
import '../../../app/constants.dart';
import '../../../app/di.dart';
import '../../../utils/resources/assets_manager.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/routes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../common/widgets/page_builder.dart';
import '../bloc/login_bloc.dart';

class LoginView extends StatefulWidget {
  String registerAs;

  LoginView({Key? key, required this.registerAs}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  bool _displayLoadingIndicator = false;
  CountryCodes selectedCountry = Constants.countryList.first;
  Function()? onPressFun;
  String mobileNumber = "";
  final TextEditingController _controller = TextEditingController();
   String onChangValue = "";

  @override
  void initState() {
    setCountryCodeValue(selectedCountry);
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
          appbar: true,
          context: context,
          body: _getContentWidget(context),
          scaffoldKey: _key,
          displayLoadingIndicator: _displayLoadingIndicator,
          allowBackButtonInAppBar: true,
          appBarActions: [
            SizedBox(
                width: AppSize.s120, child: Image.asset(ImageAssets.appBarLogo))
          ]),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginLoadingState) {
          startLoading();
        } else {
          stopLoading();
        }

        if (state is LoginSuccessState) {
          // _appPreferences.setUserLoggedIn();
          _appPreferences.setDriver(state.driver);
          if (_appPreferences.getCachedDriver() != null) {
            String validMobileNumber =
                LanguageHelper().replaceEnglishNumber(mobileNumber);
            Navigator.pushNamed(context, Routes.verifyOtpRoute,
                arguments: VerifyArguments(validMobileNumber, mobileNumber));
          }
        }

        // if (state is LoginFailState) {
        //   CustomDialog(context).showErrorDialog('title', 'desc', state.message);
        // }
        else if (state is LoginIsAllInputNotValid) {
          onPressFun = null;
        } else if (state is LoginIsAllInputValid) {
          onPressFun = () {
            FocusScope.of(context).unfocus();
            String validMobileNumber =
                LanguageHelper().replaceEnglishNumber(mobileNumber);
            // BlocProvider.of<LoginBloc>(context).add(MakeLoginEvent(
            //     validMobileNumber, _appPreferences.getAppLanguage()));
            Navigator.pushNamed(context, Routes.verifyOtpRoute,
                arguments: VerifyArguments(validMobileNumber, mobileNumber));
          };
        } else if (state is LoginIsAllInputNotValid) {
          onPressFun = null;
        }
      },
      builder: (context, state) {
        return Container(
            padding: const EdgeInsets.only(
                top: AppPadding.p40,
                right: AppPadding.p20,
                left: AppPadding.p20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      AppStrings.welcomeInto.tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      width: AppSize.s8,
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
                  AppStrings.enterPhoneNumberToContinue.tr(),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold, fontSize: FontSize.s26),
                ),
                const SizedBox(
                  height: AppSize.s18,
                ),
                phoneNumberWidget(),
                const SizedBox(
                  height: AppSize.s30,
                ),
                CustomTextButton(
                  onPressed: onPressFun,
                  text: AppStrings.continueStr.tr(),
                  icon: Icon(
                    Icons.arrow_forward,
                    color: onPressFun != null
                        ? ColorManager.white
                        : ColorManager.disableTextColor,
                  ),
                ),
                const Spacer(),
                // showArabicKeyboard
                //     ? Container(
                //         color: Colors.black,
                //         child: VirtualKeyboard(
                //           fontSize: 20,
                //           textColor: Colors.white,
                //           textController: _controller,
                //           type: VirtualKeyboardType.Alphanumeric,
                //           defaultLayouts: const [
                //             VirtualKeyboardDefaultLayouts.Arabic
                //           ],
                //         ),
                //       )
                //     : Container(),
              ],
            ));
      },
    );
  }

  void _showBottomSheet() {
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
            child: ListView.builder(
              itemCount: Constants.countryList.length,
              itemBuilder: (context, index) {
                final selectedCountry = Constants.countryList[index];
                return InkWell(
                  onTap: () {
                    setState(() {
                      setCountryCodeValue(selectedCountry);
                      Navigator.pop(context);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(AppPadding.p12),
                    child: Row(
                      children: [
                        Image.asset(
                          selectedCountry.flagPath,
                          width: AppSize.s20,
                        ),
                        const SizedBox(
                          width: AppSize.s8,
                        ),
                        Text(
                          '(${selectedCountry.countryPhoneKey.tr()})',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: ColorManager.blackTextColor),
                        ),
                        const SizedBox(
                          width: AppSize.s8,
                        ),
                        Text(
                          selectedCountry.countryName.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: ColorManager.blackTextColor),
                        )
                      ],
                    ),
                  ),
                );
              },
            )));
  }

  Widget phoneNumberWidget() {
    return Transform(
      alignment: Alignment.center,
      transform:
          Matrix4.rotationY(LanguageHelper().isRtl(context) ? 0 : math.pi),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 6,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(
                  LanguageHelper().isRtl(context) ? 0 : math.pi),
              child: CustomTextInputField(
                inputFormatter: [ArabicNumbersTextFormatter()],
                controller: _controller,
                borderColor: ColorManager.white,
                fillColor: ColorManager.thirdAccentColor,
                textColor: ColorManager.blackTextColor,
                textAlign: TextAlign.left,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  onChangValue = value;
                  mobileNumber = selectedCountry.countryPhoneKey + value;
                  BlocProvider.of<LoginBloc>(context)
                      .add(CheckInputIsValidEvent(value));
                },
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: InkWell(
              onTap: () {
                _showBottomSheet();
              },
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(
                    LanguageHelper().isRtl(context) ? 0 : math.pi),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: AppSize.s47,
                      decoration: BoxDecoration(
                          color: ColorManager.forthAccentColor,
                          borderRadius: BorderRadius.circular(2)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              LanguageHelper().replaceArabicNumber(
                                  selectedCountry.countryPhoneKey.tr()),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      color: ColorManager.black,
                                      fontSize: FontSize.s16),
                            ),
                            const SizedBox(
                              width: AppSize.s8,
                            ),
                            Image.asset(
                              selectedCountry.flagPath,
                              width: AppSize.s20,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setCountryCodeValue(CountryCodes selectedCountry) {
    this.selectedCountry = selectedCountry;
    if (selectedCountry.countryIsoCode == 'SA') {
      this.selectedCountry.countryPhoneKey = '+966';
    } else {
      this.selectedCountry.countryPhoneKey = '+20';
    }
    mobileNumber = selectedCountry.countryPhoneKey + onChangValue;
  }
}

class LoginViewArguments {
  String registerAs;

  LoginViewArguments(this.registerAs);
}
