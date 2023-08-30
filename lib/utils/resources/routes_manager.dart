import 'package:flutter/material.dart';
import 'package:taxi_for_you/presentation/rate_passenger/view/rate_passenger_view.dart';
import 'package:taxi_for_you/presentation/service_registration/view/pages/captain_registraion.dart';
import 'package:taxi_for_you/presentation/custom_widgets_view.dart';
import 'package:taxi_for_you/presentation/my_serivces/view/my_services_view.dart';
import 'package:taxi_for_you/presentation/service_registration/view/pages/serivce_registration_first_step_view.dart';
import 'package:taxi_for_you/presentation/service_registration/view/pages/service_applyed_success_view.dart';
import 'package:taxi_for_you/presentation/service_registration/view/pages/service_registration_second_step.dart';
import 'package:taxi_for_you/presentation/trip_details/view/trip_details_view.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import 'package:taxi_for_you/presentation/otp/view/verify_otp_view.dart';
import '../../app/constants.dart';
import '../../app/di.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../presentation/edit_user_profile/view/edit_profile_view.dart';
import '../../presentation/login/view/login_view.dart';
import '../../presentation/main/main_view.dart';
import '../../presentation/trip_execution/view/navigation_tracking_view.dart';
import '../../presentation/onboarding/onboarding_view.dart';
import '../../presentation/select_registation_type/view/registration_type_view.dart';
import '../../presentation/service_registration/view/pages/no_service_added_view.dart';
import '../../presentation/splash/splash_view.dart';
import '../../presentation/trip_execution/view/trip_execution_view.dart';

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
  static const String serviceAppliedSuccessfullyView =
      "/serviceAppliedSuccessfullyView";
  static const String myServices = "/myServices";
  static const String uploadDocument = "/uploadDocument";
  static const String tripDetails = "/tripDetails";
  static const String tripExecution = "/tripExecution";
  static const String locationTrackingPage = "/locationTrackingPage";
  static const String ratePassenger = "/ratePassenger";
  static const String editProfile = "/editProfile";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
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
      case Routes.myServices:
        return MaterialPageRoute(builder: (_) => const MyServicesView());
      case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => const OnBoardingView());
      case Routes.captainRegisterRoute:
        final args = settings.arguments as captainRegistrationArgs;
        return MaterialPageRoute(
            builder: (_) => CaptainRegistrationView(
                  mobileNumber: args.mobileNumber,
                ));
      case Routes.mainRoute:
        return MaterialPageRoute(builder: (_) => const MainView());
      case Routes.verifyOtpRoute:
        final args = settings.arguments as VerifyArguments;
        initVerifyOtpModule();
        return MaterialPageRoute(
            builder: (_) => VerifyOtpView(
                  args.mobileNumberForApi,
                  args.mobileNumberForDisplay,
                ));
      case Routes.tripDetails:
        final args = settings.arguments as TripDetailsArguments;
        return MaterialPageRoute(
            builder: (_) => TripDetailsView(
                  tripModel: args.tripModel,
                ));
      case Routes.tripExecution:
        final args = settings.arguments as TripExecutionArguments;
        return MaterialPageRoute(
            builder: (_) => TripExecutionView(
                  tripModel: args.tripModel,
                ));
      case Routes.noServicesAdded:
        return MaterialPageRoute(builder: (_) => const NoServiceAddedView());
      case Routes.ratePassenger:
        final args = settings.arguments as RatePassengerArguments;
        return MaterialPageRoute(
            builder: (_) => RatePassengerView(
                  tripDetailsModel: args.tripDetailsModel,
                ));
      case Routes.serviceAppliedSuccessfullyView:
        return MaterialPageRoute(
            builder: (_) => const ServiceAppliedSuccessView());
      case Routes.customWidgetsTest:
        return MaterialPageRoute(builder: (_) => const CustomWidgetsView());
      case Routes.selectRegistrationType:
        return MaterialPageRoute(builder: (_) => const RegistrationTypesView());
      case Routes.editProfile:
        final args = settings.arguments as EditProfileArguments;
        return MaterialPageRoute(
            builder: (_) => EditProfileView(
                  driver: args.driver,
                ));
      case Routes.locationTrackingPage:
        final args = settings.arguments as NavigationTrackingArguments;

        return MaterialPageRoute(
            builder: (_) => TrackingPage(
                  tripModel: args.tripModel,
                ));
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
