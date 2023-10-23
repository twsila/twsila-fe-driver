import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:taxi_for_you/app/di.dart';
import 'package:taxi_for_you/presentation/business_owner_cars_and_drivers/bloc/bo_drivers_cars_bloc.dart';
import 'package:taxi_for_you/presentation/main/pages/myprofile/bloc/my_profile_bloc.dart';
import 'package:taxi_for_you/presentation/main/pages/search_trips/search_trips_bloc/search_trips_bloc.dart';
import 'package:taxi_for_you/presentation/rate_passenger/bloc/rate_passenger_bloc.dart';
import 'package:taxi_for_you/presentation/service_registration/bloc/serivce_registration_bloc.dart';
import 'package:taxi_for_you/presentation/service_registration/view/pages/serivce_registration_first_step_view.dart';
import 'package:taxi_for_you/presentation/trip_execution/bloc/trip_execution_bloc.dart';

import '../presentation/google_maps/bloc/maps_bloc.dart';
import '../presentation/google_maps/model/maps_repo.dart';
import '../presentation/login/bloc/login_bloc.dart';
import '../presentation/main/pages/mytrips/bloc/my_trips_bloc.dart';
import '../presentation/my_serivces/bloc/my_services_bloc.dart';
import '../presentation/otp/bloc/verify_otp_bloc.dart';
import '../presentation/trip_details/bloc/trip_details_bloc.dart';
import '../utils/location/map_provider.dart';

blocProviders(BuildContext context) {
  return [
    BlocProvider.value(value: MapsBloc(MapsRepo())),
    BlocProvider.value(
        value: LoginBloc(
      loginUseCase: instance(),
      loginBOUseCase: instance(),
      appPreferences: instance(),
    )),
    BlocProvider.value(
        value: VerifyOtpBloc(
            verifyOtpUseCase: instance(),
            generateOtpUseCase: instance(),
            loginUseCase: instance())),
    BlocProvider.value(
        value: ServiceRegistrationBloc(
            registrationServiceUseCase: instance(),
            carBrandsAndModelsUseCase: instance(),
            registrationBOUseCase: instance(),
            registrationUseCase: instance())),
    BlocProvider.value(value: MyServicesBloc(serviceStatusUseCase: instance())),
    BlocProvider.value(
        value: MyProfileBloc(
            logoutUseCase: instance(), boLogoutUseCase: instance())),
    BlocProvider.value(
        value: RatePassengerBloc(ratePassengerUseCase: instance())),
    BlocProvider.value(
        value: SearchTripsBloc(
            tripsUseCase: instance(), lookupsUseCase: instance())),
    BlocProvider.value(value: MyTripsBloc(myTripsUseCase: instance())),
    BlocProvider.value(
        value: TripExecutionBloc(
            changeTripStatusUseCase: instance(),
            tripSummaryUseCase: instance())),
    BlocProvider.value(
        value: TripDetailsBloc(
            acceptOfferUseCase: instance(),
            addOfferUseCase: instance(),
            tripSummaryUseCase: instance(),
            boAcceptOfferUseCase: instance(),
            boSuggestNewOfferUseCase: instance())),
    BlocProvider.value(
        value: BoDriversCarsBloc(
      businessOwnerDriversUseCase: instance(),
      searchDriversByMobileUseCase: instance(),
      addDriverForBOUseCase: instance(),
      assignDriverToTripUseCase: instance(),
      appPreferences: instance(),
    )),
    ChangeNotifierProvider(create: (_) => MapProvider()),
  ];
}
