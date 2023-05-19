import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../app/constants.dart';
import '../../../utils/resources/color_manager.dart';

class CustomVerificationCodeWidget extends StatefulWidget {
  Function(String) onComplete;

  CustomVerificationCodeWidget({Key? key, required this.onComplete})
      : super(key: key);

  @override
  State<CustomVerificationCodeWidget> createState() =>
      _CustomVerificationCodeWidgetState();
}

class _CustomVerificationCodeWidgetState
    extends State<CustomVerificationCodeWidget> {
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: AppSize.s50,
      height: AppSize.s50,
      margin: const EdgeInsets.all(2),
      textStyle: TextStyle(
          fontSize: 20,
          color: ColorManager.blackTextColor,
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: ColorManager.forthAccentColor,
        borderRadius: BorderRadius.circular(2),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      color: ColorManager.secondaryAccentColor,
      borderRadius: BorderRadius.circular(2),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: ColorManager.secondaryAccentColor,
      ),
    );
    return Pinput(
      length: Constants.otpSize,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      showCursor: Constants.showCursorOtpField,
      onCompleted: widget.onComplete,
    );
  }
}
