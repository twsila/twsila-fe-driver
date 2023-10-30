import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_for_you/domain/usecase/accept_offer_usecase.dart';
import 'package:taxi_for_you/domain/usecase/add_driver_bo_usecase.dart';
import 'package:taxi_for_you/domain/usecase/add_offer_usecase.dart';
import 'package:taxi_for_you/domain/usecase/bo_accept_offer_usecase.dart';
import 'package:taxi_for_you/domain/usecase/bo_assign_driver_to_trip_usecase.dart';
import 'package:taxi_for_you/domain/usecase/bo_suggest_new_offer_usecase.dart';
import 'package:taxi_for_you/domain/usecase/car_brands_usecase.dart';
import 'package:taxi_for_you/domain/usecase/change_trip_status_usecase.dart';
import 'package:taxi_for_you/domain/usecase/get_business_owner_drivers_usecase.dart';
import 'package:taxi_for_you/domain/usecase/logout_usecase.dart';
import 'package:taxi_for_you/domain/usecase/lookups_usecase.dart';
import 'package:taxi_for_you/domain/usecase/rate_passenger_usecase.dart';
import 'package:taxi_for_you/domain/usecase/registration_bo_usecase.dart';
import 'package:taxi_for_you/domain/usecase/registration_services_usecase.dart';
import 'package:taxi_for_you/domain/usecase/registration_usecase.dart';
import 'package:taxi_for_you/domain/usecase/search_driver_mobile_usecase.dart';
import 'package:taxi_for_you/domain/usecase/service_status_usecase.dart';
import 'package:taxi_for_you/domain/usecase/trip_summary_usecase.dart';
import 'package:taxi_for_you/domain/usecase/trips_usecase.dart';
import 'package:taxi_for_you/domain/usecase/update_profile_usecase.dart';
import 'package:taxi_for_you/domain/usecase/verify_otp_usecase.dart';
import 'package:taxi_for_you/presentation/service_registration/view/pages/captain_registraion.dart';
import 'package:taxi_for_you/presentation/login/bloc/login_bloc.dart';
import 'package:taxi_for_you/presentation/otp/bloc/verify_otp_bloc.dart';

import '../data/data_source/local_data_source.dart';
import '../data/data_source/remote_data_source.dart';
import '../data/network/app_api.dart';
import '../data/network/dio_factory.dart';
import '../data/network/network_info.dart';
import '../data/repository/repository_impl.dart';
import '../domain/repository/repository.dart';
import '../domain/usecase/generate_otp_usecase.dart';
import '../domain/usecase/login_usecase.dart';
import '../domain/usecase/mytrips_usecase.dart';
import '../presentation/login/view/login_viewmodel.dart';
import 'app_prefs.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  // app module, its a module where we put all generic dependencies

  // shared prefs instance
  final sharedPrefs = await SharedPreferences.getInstance();

  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // app prefs instance
  instance
      .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));

  // network info
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));

  // dio factory
  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

  Dio dio = await instance<DioFactory>().getDio();
  //app service client
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  // remote data source
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(instance<AppServiceClient>()));

  // local data source
  instance.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());

  // repository

  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance(), instance()));

  instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));

  instance.registerFactory<LoginBOUseCase>(() => LoginBOUseCase(instance()));
  instance
      .registerFactory<VerifyOtpUseCase>(() => VerifyOtpUseCase(instance()));
  instance.registerFactory<GenerateOtpUseCase>(
      () => GenerateOtpUseCase(instance()));
  instance.registerFactory<RegistrationServiceUseCase>(
      () => RegistrationServiceUseCase(instance()));
  instance.registerFactory<CarBrandsAndModelsUseCase>(
      () => CarBrandsAndModelsUseCase(instance()));
  instance.registerFactory<ServiceStatusUseCase>(
      () => ServiceStatusUseCase(instance()));
  instance.registerFactory<LogoutUseCase>(() => LogoutUseCase(instance()));
  instance.registerFactory<RegistrationUseCase>(
      () => RegistrationUseCase(instance()));
  instance.registerFactory<RegistrationBOUseCase>(
      () => RegistrationBOUseCase(instance()));
  instance.registerFactory<TripsUseCase>(() => TripsUseCase(instance()));
  instance.registerFactory<MyTripsUseCase>(() => MyTripsUseCase(instance()));
  instance.registerFactory<AcceptOfferUseCase>(
      () => AcceptOfferUseCase(instance()));
  instance.registerFactory<AddOfferUseCase>(() => AddOfferUseCase(instance()));
  instance.registerFactory<TripSummaryUseCase>(
      () => TripSummaryUseCase(instance()));
  instance.registerFactory<LookupsUseCase>(() => LookupsUseCase(instance()));
  instance.registerFactory<ChangeTripStatusUseCase>(
      () => ChangeTripStatusUseCase(instance()));
  instance.registerFactory<RatePassengerUseCase>(
      () => RatePassengerUseCase(instance()));
  instance.registerFactory<BusinessOwnerDriversUseCase>(
      () => BusinessOwnerDriversUseCase(instance()));
  instance.registerFactory<SearchDriversByMobileUseCase>(
      () => SearchDriversByMobileUseCase(instance()));
  instance.registerFactory<AddDriverForBOUseCase>(
      () => AddDriverForBOUseCase(instance()));
  instance.registerFactory<BoLogoutUseCase>(() => BoLogoutUseCase(instance()));
  instance.registerFactory<BoAssignDriverToTripUseCase>(
      () => BoAssignDriverToTripUseCase(instance()));
  instance.registerFactory<BOAcceptOfferUseCase>(
      () => BOAcceptOfferUseCase(instance()));
  instance.registerFactory<BoSuggestNewOfferUseCase>(
      () => BoSuggestNewOfferUseCase(instance()));
  instance.registerFactory<UpdateProfileUseCase>(
      () => UpdateProfileUseCase(instance()));
  instance.registerFactory<UpdateBOProfileUseCase>(
      () => UpdateBOProfileUseCase(instance()));
}

initLoginModule() {
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<LoginBOUseCase>()) {
    instance.registerFactory<LoginBOUseCase>(() => LoginBOUseCase(instance()));
  }
  if (!GetIt.I.isRegistered<LoginViewModel>()) {
    instance.registerLazySingleton<LoginViewModel>(
        () => LoginViewModel(instance()));
  }
  if (!GetIt.I.isRegistered<LoginBloc>()) {
    instance.registerLazySingleton<LoginBloc>(
      () => LoginBloc(
        loginUseCase: instance(),
        loginBOUseCase: instance(),
        appPreferences: instance(),
      ),
    );
  }
}

initServiceRegistrationModule() {
  if (!GetIt.I.isRegistered<RegistrationServiceUseCase>()) {
    instance.registerFactory<RegistrationServiceUseCase>(
        () => RegistrationServiceUseCase(instance()));
    instance.registerFactory<CarBrandsAndModelsUseCase>(
        () => CarBrandsAndModelsUseCase(instance()));
  }
}

initVerifyOtpModule() {
  if (!GetIt.I.isRegistered<VerifyOtpUseCase>() ||
      !GetIt.I.isRegistered<LoginUseCase>()) {
    instance.registerFactory<GenerateOtpUseCase>(
        () => GenerateOtpUseCase(instance()));
    instance
        .registerFactory<VerifyOtpUseCase>(() => VerifyOtpUseCase(instance()));
    instance.registerFactory<GenerateOtpUseCase>(
        () => GenerateOtpUseCase(instance()));

    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    instance.registerLazySingleton<VerifyOtpBloc>(() => VerifyOtpBloc(
        verifyOtpUseCase: instance(),
        generateOtpUseCase: instance(),
        loginUseCase: instance()));
  }
}
