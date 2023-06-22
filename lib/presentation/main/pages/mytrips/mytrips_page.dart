import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../utils/resources/strings_manager.dart';

class MyTripsPage extends StatefulWidget {
  const MyTripsPage({Key? key}) : super(key: key);

  @override
  _MyTripsPageState createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(AppStrings.myTrips.tr()),
    );
  }
}
