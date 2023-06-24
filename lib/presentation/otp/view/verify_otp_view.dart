import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:taxi_for_you/data/network/error_handler.dart';
import 'package:taxi_for_you/presentation/login/login_viewmodel.dart';
import 'package:taxi_for_you/presentation/otp/bloc/verify_otp_bloc.dart';
import 'package:taxi_for_you/presentation/service_registration/view/pages/captain_registraion.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';
import 'package:taxi_for_you/utils/dialogs/toast_handler.dart';
import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/driver_model.dart';
import '../../../utils/helpers/language_helper.dart';
import '../../../utils/resources/assets_manager.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/routes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../common/widgets/CustomAutoFullSms.dart';
import '../../common/widgets/custom_countdown_timer.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/page_builder.dart';

import 'dart:math' as math;

class VerifyOtpView extends StatefulWidget {
  String mobileNumberForApi;
  String mobileNumberForDisplay;

  VerifyOtpView(this.mobileNumberForApi, this.mobileNumberForDisplay,
      {Key? key})
      : super(key: key);

  @override
  State<VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends State<VerifyOtpView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _displayLoadingIndicator = false;

  final _formKey = GlobalKey<FormState>();
  GlobalKey globalKey = GlobalKey();

  final AppPreferences _appPreferences = instance<AppPreferences>();
  bool isTimerFinished = false;

  TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    // BlocProvider.of<VerifyOtpBloc>(context)
    //     .add(SendOtpEvent(widget.mobileNumberForApi));

    // ToastHandler(context)
    //     .showToast(AppStrings.otpValidated.tr(), Toast.LENGTH_LONG);
    BlocProvider.of<VerifyOtpBloc>(context).add(MakeLoginEvent(
        /*'1234567890'*/
        widget.mobileNumberForApi,
        _appPreferences.getAppLanguage()));

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
      ),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return BlocConsumer<VerifyOtpBloc, VerifyOtpState>(
      listener: (context, state) async {
        if (state is VerifyOtpLoading) {
          startLoading();
        } else {
          stopLoading();
        }
        if (state is GenerateOtpSuccess) {
          ToastHandler(context).showToast(
              "${AppStrings.otpIs.tr()} ${state.otp}", Toast.LENGTH_LONG);
        }
        if (state is GenerateOtpFail) {
          CustomDialog(context).showErrorDialog(
              "", "", AppStrings.cannotSendOtp.tr(), onBtnPressed: () {
            Navigator.pop(context);
          });
        }
        if (state is VerifyOtpSuccess) {
          ToastHandler(context)
              .showToast(AppStrings.otpValidated.tr(), Toast.LENGTH_LONG);
          BlocProvider.of<VerifyOtpBloc>(context).add(MakeLoginEvent(
              widget.mobileNumberForApi, _appPreferences.getAppLanguage()));
        }
        if (state is VerifyOtpFail) {
          if (state.code == ResponseMessage.NOT_FOUND) {
            CustomDialog(context)
                .showErrorDialog("", "", AppStrings.wrongOtp.tr());
          }
        }
        if (state is LoginSuccessState) {
          _appPreferences.setUserLoggedIn();
          await _appPreferences.setDriver(state.driver);
          Driver? driver = _appPreferences.getCachedDriver();
          if (driver != null) {
            Navigator.pushReplacementNamed(context, Routes.mainRoute);
          }
        }
        if (state is LoginFailState) {
          if (state.errorCode == ResponseCode.NOT_FOUND.toString()) {
            Navigator.pushReplacementNamed(context, Routes.captainRegisterRoute,
                arguments:
                captainRegistrationArgs(widget.mobileNumberForApi));
          } else {
            CustomDialog(context).showErrorDialog('', '', state.message);
          }
        }
      },
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSize.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: AppSize.s40,
              ),
              Text(
                AppStrings.enterVerificationCode.tr(),
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(fontSize: FontSize.s26),
              ),
              Text(
                AppStrings.enterHereSentCodeForNumber.tr(),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: FontSize.s16,
                    color: ColorManager.formLabelTextColor),
              ),
              Text(
                LanguageHelper()
                    .replaceArabicNumber(widget.mobileNumberForDisplay),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: FontSize.s16, color: ColorManager.blackTextColor),
              ),
              const SizedBox(
                height: AppSize.s30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CustomVerificationCodeWidget(
                  autoFocus: false,
                  onCodeSubmitted: (code) {
                    BlocProvider.of<VerifyOtpBloc>(context)
                        .add(VerifyOtpBEEvent(widget.mobileNumberForApi, code));
                  },
                  controller: otpController,
                  onCodeChanged: (otpChangedValue) {},
                ),
              ),
              const SizedBox(
                height: AppSize.s30,
              ),
              Text(
                AppStrings.didNotReceiveTheCode.tr(),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: FontSize.s16, color: ColorManager.blackTextColor),
              ),
              const SizedBox(
                height: AppSize.s4,
              ),
              isTimerFinished
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          isTimerFinished = false;
                          BlocProvider.of<VerifyOtpBloc>(context)
                              .add(ReSendOtpEvent(widget.mobileNumberForApi));
                        });
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            ImageAssets.retryIcon,
                            width: AppSize.s16,
                          ),
                          const SizedBox(
                            width: AppSize.s10,
                          ),
                          Text(
                            AppStrings.resendCode.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: FontSize.s16,
                                    color: ColorManager.primary),
                          ),
                        ],
                      ))
                  : CustomCountDownTimer(
                      onTimerFinished: () {
                        setState(() {
                          isTimerFinished = true;
                        });
                      },
                    ),
            ],
          ),
        );
      },
    );
  }
}

class VerifyArguments {
  String mobileNumberForApi;
  String mobileNumberForDisplay;

  VerifyArguments(this.mobileNumberForApi, this.mobileNumberForDisplay);
}
