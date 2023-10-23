import 'package:easy_localization/easy_localization.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../../app/app_prefs.dart';
import '../../app/di.dart';

extension DateFormatString on String {
  String formatStringToDateString() {
    final AppPreferences _appPrefs = instance<AppPreferences>();
    return DateFormat('dd MMM yyyy/ hh:mm a', _appPrefs.getAppLanguage())
        .format(DateFormat('dd/MM/yyyy hh:mm:ss').parse(this));
  }

  String formatDate() {
    return DateFormat('yyyy-MM-d', AppStrings.en)
        .format(DateFormat('dd-MM-yyyy').parse(this));
  }

  String getCurrentDateFormatted(){
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }
}
