import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:taxi_for_you/presentation/main/pages/myprofile/bloc/my_profile_bloc.dart';
import 'package:taxi_for_you/presentation/main/pages/myprofile/my_profile_view.dart';
import 'package:taxi_for_you/presentation/main/pages/mytrips/view/mytrips_page.dart';
import 'package:taxi_for_you/presentation/main/pages/search_trips/view/search_trips_page.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';

import '../../utils/location/map_provider.dart';
import '../../utils/resources/assets_manager.dart';
import '../../utils/resources/color_manager.dart';
import '../../utils/resources/strings_manager.dart';
import '../../utils/resources/values_manager.dart';
import '../common/state_renderer/dialogs.dart';
import '../common/widgets/custom_text_button.dart';
import '../google_maps/bloc/maps_bloc.dart';
import '../google_maps/bloc/maps_events.dart';
import '../google_maps/bloc/maps_state.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<Widget> pages = [
    SearchTripsPage(),
    MyTripsPage(),
    MyProfilePage(),
  ];
  List<String> titles = [
    AppStrings.myProfile.tr(),
    AppStrings.myTrips.tr(),
    AppStrings.searchTrips.tr(),
  ];

  var _title = AppStrings.home.tr();
  var _currentIndex = 0;


  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  getCurrentLocation() async {
    BlocProvider.of<MapsBloc>(context, listen: false).add(GetCurrentLocation());
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        CustomDialog(context).showCupertinoDialog(
            AppStrings.exitApp.tr(),
            AppStrings.areYouSureYouWantToExitFromApp.tr(),
            AppStrings.exit.tr(),
            AppStrings.cancel.tr(),
            ColorManager.error, () {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        }, () {
          Navigator.of(context).pop(false);
        });
        return true;
      },
      child: Scaffold(
        body: pages[_currentIndex],
        bottomNavigationBar: BlocConsumer<MapsBloc, MapsState>(
          listener: (context, state) {
            if (state is CurrentLocationFailed) {
              CustomDialog(context).showWaringDialog(
                  '', '', AppStrings.needLocationPermission.tr(),
                  onBtnPressed: () {
                Geolocator.openLocationSettings();
              });
            } else if (state is CurrentLocationLoadedSuccessfully) {
              Provider.of<MapProvider>(context, listen: false).currentLocation =
                  state.currentLocation;
            }
          },
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: ColorManager.lightGrey, spreadRadius: AppSize.s1)
              ]),
              child: BottomNavigationBar(
                selectedItemColor: ColorManager.headersTextColor,
                unselectedItemColor: ColorManager.hintTextColor,
                currentIndex: _currentIndex,
                backgroundColor: ColorManager.thirdAccentColor,
                onTap: onTap,
                items: [
                  BottomNavigationBarItem(
                      icon:
                          SvgPicture.asset(ImageAssets.searchTripsInactiveIcon),
                      label: AppStrings.searchTrips.tr(),
                      activeIcon:
                          SvgPicture.asset(ImageAssets.searchTripsActiveIcon)),
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset(ImageAssets.myTripsInactiveIcon),
                      label: AppStrings.myTrips.tr(),
                      activeIcon:
                          SvgPicture.asset(ImageAssets.myTripsActiveIcon)),
                  BottomNavigationBarItem(
                      icon: SvgPicture.asset(ImageAssets.profileInactiveIcon),
                      label: AppStrings.myProfile.tr(),
                      activeIcon:
                          SvgPicture.asset(ImageAssets.profileActiveIcon)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  onTap(int index) {
    setState(() {
      _currentIndex = index;
      _title = titles[index];
    });
  }
}
