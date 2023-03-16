import 'package:flutter/material.dart';
import 'package:taxi_for_you/presentation/categories/categories_view.dart';
import 'package:taxi_for_you/presentation/trip_details/view/trip_client_details_view.dart';
import 'package:taxi_for_you/presentation/trip_details/view/trip_details_view.dart';
import 'package:taxi_for_you/presentation/trips/view/trips_view.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import 'package:taxi_for_you/presentation/otp/view/verify_otp_view.dart';
import '../../app/di.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../presentation/login/login_view.dart';
import '../../presentation/main/main_view.dart';
import '../../presentation/onboarding/onboarding_view.dart';
import '../../presentation/pending_approval_driver/view/pending_approval_view.dart';
import '../../presentation/register/view/register_view.dart';
import '../../presentation/splash/splash_view.dart';

class Routes {
  static const String splashRoute = "/";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String onBoardingRoute = "/onBoarding";
  static const String mainRoute = "/main";
  static const String storeDetailsRoute = "/storeDetails";
  static const String verifyOtpRoute = "/verifyOtp";
  static const String categoriesRoute = "/categories";
  static const String goodsRoute = "/goods";
  static const String furnitureRoute = "/furniture";
  static const String pendingApprovalRoute = "/pendingApproval";
  static const String tripsRoute = "/trips";
  static const String tripDetailsRoute = "/tripDetails";
  static const String tripClientDetailsRoute = "/tripClientDetails";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.categoriesRoute:
        return MaterialPageRoute(builder: (_) => const CategoriesView());
      // case Routes.goodsRoute:
      //   return MaterialPageRoute(builder: (_) => const GoodsView());
      // case Routes.furnitureRoute:
      //   return MaterialPageRoute(builder: (_) => const FurnitureView());
      case Routes.loginRoute:
        initLoginModule();
        return MaterialPageRoute(builder: (_) => const LoginView());
      case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => const OnBoardingView());
      case Routes.registerRoute:
        initRegisterModule();
        return MaterialPageRoute(builder: (_) =>  const RegisterView());
      case Routes.mainRoute:
        initHomeModule();
        return MaterialPageRoute(builder: (_) => const MainView());
      case Routes.verifyOtpRoute:
        initVerifyOtpModule();
        return MaterialPageRoute(builder: (_) => VerifyOtpView());
      case Routes.pendingApprovalRoute:
        return MaterialPageRoute(builder: (_) => const PendingApprovalDriver());
      case Routes.tripsRoute:
        return MaterialPageRoute(builder: (_) => const TripsView());
      case Routes.tripDetailsRoute:
        return MaterialPageRoute(builder: (_) => const TripDetailsView());
      case Routes.tripClientDetailsRoute:
        return MaterialPageRoute(builder: (_) => const TripClientDetailsView());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text(AppStrings.noRouteFound.tr()),
              ),
              body: Center(child: Text(AppStrings.noRouteFound.tr())),
            ));
  }
}
