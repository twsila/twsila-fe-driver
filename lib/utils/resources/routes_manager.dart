import 'package:flutter/material.dart';
import 'package:taxi_for_you/presentation/captain_registration/view/captain_registraion.dart';
import 'package:taxi_for_you/presentation/categories/categories_view.dart';
import 'package:taxi_for_you/presentation/custom_widgets_view.dart';
import 'package:taxi_for_you/presentation/goods_register/view/goods_register_view.dart';
import 'package:taxi_for_you/presentation/no_service_added/view/no_service_added_view.dart';
import 'package:taxi_for_you/presentation/service_registration/view/pages/serivce_registration_first_step_view.dart';
import 'package:taxi_for_you/presentation/service_registration/view/pages/service_registration_second_step.dart';
import 'package:taxi_for_you/presentation/trip_details/view/trip_client_details_view.dart';
import 'package:taxi_for_you/presentation/trip_details/view/trip_details_view.dart';
import 'package:taxi_for_you/presentation/trips/view/trips_view.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import 'package:taxi_for_you/presentation/otp/view/verify_otp_view.dart';
import '../../app/constants.dart';
import '../../app/di.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../presentation/canceld_trip/view/canceled_trip_view.dart';
import '../../presentation/immediate_trip/view/immediate_trip_view.dart';
import '../../presentation/login/view/login_view.dart';
import '../../presentation/main/main_view.dart';
import '../../presentation/onboarding/onboarding_view.dart';
import '../../presentation/pending_approval_driver/view/pending_approval_view.dart';
import '../../presentation/scheduled_trip/view/scheduled_trip_view.dart';
import '../../presentation/select_registation_type/view/registration_type_view.dart';
import '../../presentation/splash/splash_view.dart';

class Routes {
  static const String splashRoute = "/";
  static const String loginRoute = "/login";
  static const String captainRegisterRoute = "/captainRegister";
  static const String goodsRegisterRoute = "/goodsRegister";
  static const String registerUploadDocumentsRoute =
      "/registerUploadDocumentsRoute";
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
  static const String immediateTrip = "/immediateTrip";
  static const String scheduledTrip = "/scheduledTrip";
  static const String canceledTrip = "/canceledTrip";
  static const String customWidgetsTest = "/customWidgetsTest";
  static const String selectRegistrationType = "/selectRegistrationType";
  static const String noServicesAdded = "/noServicesAdded";
  static const String serviceRegistrationFirstStep =
      "/serviceRegistrationFirstStep";
  static const String serviceRegistrationSecondStep =
      "/serviceRegistrationSecondStep";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.categoriesRoute:
        return MaterialPageRoute(builder: (_) => const CategoriesView());
      case Routes.loginRoute:
        initLoginModule();
        final args = settings.arguments as LoginViewArguments;
        return MaterialPageRoute(
          builder: (_) => LoginView(
            registerAs: args.registerAs,
          ),
        );
      case Routes.serviceRegistrationFirstStep:
        initServiceRegistrationModule();
        return MaterialPageRoute(
            builder: (_) => const ServiceRegistrationFirstStepView());
      case Routes.serviceRegistrationSecondStep:
        initServiceRegistrationModule();
        return MaterialPageRoute(
            builder: (_) => const ServiceRegistrationSecondStep());
      case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => const OnBoardingView());
      case Routes.captainRegisterRoute:
        initCaptainRegisterModule();
        return MaterialPageRoute(
            builder: (_) => const CaptainRegistrationView());
      case Routes.goodsRegisterRoute:
        initGoodsRegisterModule();
        return MaterialPageRoute(builder: (_) => const GoodsRegisterView());
      case Routes.mainRoute:
        initHomeModule();
        return MaterialPageRoute(builder: (_) => const MainView());
      case Routes.verifyOtpRoute:
        final args = settings.arguments as VerifyArguments;
        initVerifyOtpModule();
        return MaterialPageRoute(
            builder: (_) => VerifyOtpView(
                  args.mobileNumberForApi,
                  args.mobileNumberForDisplay,
                ));
      case Routes.noServicesAdded:
        return MaterialPageRoute(builder: (_) => const NoServiceAddedView());
      case Routes.pendingApprovalRoute:
        return MaterialPageRoute(builder: (_) => const PendingApprovalDriver());
      case Routes.tripsRoute:
        return MaterialPageRoute(builder: (_) => const TripsView());
      case Routes.tripDetailsRoute:
        return MaterialPageRoute(builder: (_) => const TripDetailsView());
      case Routes.tripClientDetailsRoute:
        return MaterialPageRoute(builder: (_) => const TripClientDetailsView());
      case Routes.immediateTrip:
        return MaterialPageRoute(builder: (_) => const ImmediateTripView());
      case Routes.scheduledTrip:
        return MaterialPageRoute(builder: (_) => const ScheduledTripView());
      case Routes.canceledTrip:
        return MaterialPageRoute(builder: (_) => const CanceledTripView());
      case Routes.customWidgetsTest:
        return MaterialPageRoute(builder: (_) => const CustomWidgetsView());
      case Routes.selectRegistrationType:
        return MaterialPageRoute(builder: (_) => const RegistrationTypesView());
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
