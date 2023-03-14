import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taxi_for_you/presentation/login/login_viewmodel.dart';
import 'package:taxi_for_you/presentation/otp/viewmodel/verify_otp_viewmodel.dart';

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
import '../../common/widgets/custom_back_button.dart';
import '../../common/widgets/custom_verification_code_widget.dart';

class VerifyOtpView extends StatefulWidget {
  VerifyOtpView({Key? key}) : super(key: key);

  @override
  State<VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends State<VerifyOtpView> {
  final VerifyOTPViewModel _viewModel = instance<VerifyOTPViewModel>();
  final LoginViewModel _loginViewModel = instance<LoginViewModel>();
  final _formKey = GlobalKey<FormState>();
  GlobalKey globalKey = GlobalKey();

  final AppPreferences _appPreferences = instance<AppPreferences>();

  _bind() {
    _viewModel.start();
    _viewModel.setPhoneNumber(
      _loginViewModel.loginObject.countryCode +
          _loginViewModel.loginObject.phoneNumber,
    );
    print(_loginViewModel.loginObject.countryCode +
        _loginViewModel.loginObject.phoneNumber);
    _viewModel.generateOtp();
    _viewModel.isCodeIsSentStreamController.stream.listen((isOTPSent) {
      if (isOTPSent) {
        Fluttertoast.showToast(
            msg: "Code sent",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });

    _viewModel.isCodeIsVerifiedStreamController.stream
        .listen((isCodeIsVerified) {
      if (isCodeIsVerified) {
        // navigate to main screen
        SchedulerBinding.instance.addPostFrameCallback((_) {
          // _appPreferences.setUserLoggedIn();
          Navigator.of(context).pushReplacementNamed(Routes.registerRoute);
        });
      }
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FlowState>(
      stream: _viewModel.outputState,
      builder: (context, snapshot) {
        // _getContentWidget();
        return snapshot.data
                ?.getScreenWidget(context, _getContentWidget(), () {}) ??
            _getContentWidget();
      },
    );
  }

  Widget _getContentWidget() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSize.s16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomBackButton(
                    onPressed: () {
                      _loginViewModel.goPrevious();
                    },
                  ),
                ),
                const SizedBox(height: AppSize.s8),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.phoneVerification.tr(),
                      style: Theme.of(context).textTheme.titleLarge,
                    )),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Image(image: AssetImage(ImageAssets.verifyOtpGraphic)),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppStrings.enterOtpHint.tr(),
                    style: getRegularStyle(
                        color: ColorManager.black, fontSize: FontSize.s16),
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 500));
                        RenderObject? object =
                            globalKey.currentContext?.findRenderObject();
                        object?.showOnScreen();
                      },
                      child: CustomVerificationCodeWidget(
                        onComplete: (stringCode) {
                          _viewModel.setCode(stringCode);
                          _viewModel.verifyOtp();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: AppSize.s20,
                    ),
                    Align(
                        key: globalKey,
                        alignment: FractionalOffset.bottomCenter,
                        child: InkWell(
                          onTap: () => _viewModel.generateOtp(),
                          child: Text(
                            AppStrings.sendOtpAgainHint.tr(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
