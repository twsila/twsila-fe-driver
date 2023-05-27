import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/app/di.dart';
import 'package:taxi_for_you/utils/resources/langauge_manager.dart';

class LanguageHelper {
  String replaceArabicNumber(String input) {
    AppPreferences appPreferences = instance();
    String applang = appPreferences.getAppLanguage();

    if (applang == LanguageType.ARABIC.getValue()) {
      const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      const arabic = ['۰', '۱', '۲', '۳', '٤', '٥', '٦', '٧', '٨', '٩'];

      for (int i = 0; i < english.length; i++) {
        input = input.replaceAll(english[i], arabic[i]);
      }

      return input;
    } else {
      return input;
    }
  }

  String replaceEnglishNumber(String input) {
    AppPreferences appPreferences = instance();
    String applang = appPreferences.getAppLanguage();
    if (applang == LanguageType.ARABIC.getValue()) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['۰', '۱', '۲', '۳', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < arabic.length; i++) {
      input = input.replaceAll(arabic[i], english[i]);
    }
    return input;
    } else {
      return input;
    }
  }

  bool isRtl(BuildContext context) {
    return context.locale == ARABIC_LOCAL;
  }
}

class ArabicNumbersTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: LanguageHelper().replaceArabicNumber(newValue.text),
        selection: newValue.selection);
  }
}
