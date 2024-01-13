import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../../app/app_prefs.dart';
import '../../app/di.dart';


extension TimeStampFromDate on String {
  String getTimeStampFromDate({pattern = 'dd MMM yyyy/ hh:mm a'}) {
    final AppPreferences _appPrefs = instance<AppPreferences>();
    int? timestamp = int.tryParse(this);

    if (timestamp == null) {
      return '';
    }
    return DateFormat(pattern, _appPrefs.getAppLanguage())
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  TimeOfDay getTimeStampFromTimeOfDay({pattern = 'dd MMM yyyy/ hh:mm a'}) {
    final AppPreferences _appPrefs = instance<AppPreferences>();
    return TimeOfDay.fromDateTime(
        DateFormat(pattern, _appPrefs.getAppLanguage()).parse(this));
  }
}