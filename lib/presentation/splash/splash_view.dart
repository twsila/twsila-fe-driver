import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../../utils/resources/assets_manager.dart';
import '../../utils/resources/color_manager.dart';
import '../../utils/resources/constants_manager.dart';
import '../../utils/resources/routes_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;
  final AppPreferences _appPreferences = instance<AppPreferences>();

  _startDelay() {
    _timer = Timer(const Duration(seconds: AppConstants.splashDelay), _goNext);
  }

  _goNext() async {
    _appPreferences.isUserLoggedIn().then((isUserLoggedIn) => {
          if (isUserLoggedIn)
            {
              // navigate to main screen
              Navigator.pushReplacementNamed(context, Routes.categoriesRoute)
            }
          else
            {
              // Navigate to Login Screen
              Navigator.pushReplacementNamed(context, Routes.loginRoute)
            }
        });
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(ImageAssets.logoImg),
            const SizedBox(height: 16),
            Hero(
              tag: 'app_name',
              child: Column(
                children: [
                  Text(
                    'app_title_en'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text(
                    'app_title_ar'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),  Text(
                    AppStrings.driverLabel.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
