import 'dart:async';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/domain/model/trip_model.dart';
import 'package:taxi_for_you/presentation/trip_execution/view/widgets/bottom_info_widget.dart';
import 'package:taxi_for_you/presentation/trip_execution/view/widgets/customer_info_draggable.dart';
import 'package:taxi_for_you/presentation/trip_execution/view/widgets/map_widget.dart';
import '../../../app/app_prefs.dart';
import '../../../app/di.dart';

class TrackingPage extends StatefulWidget {
  TripModel tripModel;

  TrackingPage({Key? key, required this.tripModel}) : super(key: key);

  @override
  State<TrackingPage> createState() => TrackingPageState();
}

class TrackingPageState extends State<TrackingPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExpandableBottomSheet(
        animationCurveExpand: Curves.easeInToLinear,
        enableToggle: true,
        background: MapWidget(
          tripModel: widget.tripModel,
        ),
        persistentHeader: CustomerInfoHeader(
          tripModel: widget.tripModel,
        ),
        expandableContent: BottomInfoWidget(
          tripModel: widget.tripModel,
        ),
      ),
    );
  }
}

class NavigationTrackingArguments {
  TripModel tripModel;

  NavigationTrackingArguments(this.tripModel);
}
