import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taxi_for_you/presentation/main/pages/home/view/home_page.dart';
import 'package:taxi_for_you/presentation/main/pages/notifications/notifications_page.dart';
import 'package:taxi_for_you/presentation/main/pages/search/search_page.dart';
import 'package:taxi_for_you/presentation/main/pages/settings/settings_page.dart';

import '../../utils/resources/assets_manager.dart';
import '../../utils/resources/color_manager.dart';
import '../../utils/resources/strings_manager.dart';
import '../../utils/resources/values_manager.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<Widget> pages = [
    HomePage(),
    SearchPage(),
    NotificationsPage(),
    SettingsPage()
  ];
  List<String> titles = [
    AppStrings.home.tr(),
    AppStrings.search.tr(),
    AppStrings.notifications.tr(),
    AppStrings.settings.tr(),
  ];

  var _title = AppStrings.home.tr();
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title, style: Theme.of(context).textTheme.titleSmall),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: ColorManager.lightGrey, spreadRadius: AppSize.s1)
        ]),
        child: BottomNavigationBar(
          selectedItemColor: ColorManager.headersTextColor,
          unselectedItemColor: ColorManager.hintTextColor,
          currentIndex: _currentIndex,
          backgroundColor: ColorManager.thirdAccentColor,
          onTap: onTap,
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.asset(ImageAssets.searchTripsInactiveIcon),
                label: AppStrings.searchTrips.tr(),
                activeIcon:
                    SvgPicture.asset(ImageAssets.searchTripsActiveIcon)),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(ImageAssets.myTripsInactiveIcon),
                label: AppStrings.myTrips.tr(),
                activeIcon: SvgPicture.asset(ImageAssets.myTripsActiveIcon)),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(ImageAssets.profileInactiveIcon),
                label: AppStrings.myProfile.tr(),
                activeIcon: SvgPicture.asset(ImageAssets.profileActiveIcon)),
          ],
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
