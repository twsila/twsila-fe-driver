import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_for_you/domain/usecase/accept_offer_usecase.dart';
import 'package:taxi_for_you/domain/usecase/add_offer_usecase.dart';
import 'package:taxi_for_you/domain/usecase/car_brands_usecase.dart';
import 'package:taxi_for_you/domain/usecase/change_trip_status_usecase.dart';
import 'package:taxi_for_you/domain/usecase/logout_usecase.dart';
import 'package:taxi_for_you/domain/usecase/lookups_usecase.dart';
import 'package:taxi_for_you/domain/usecase/registration_services_usecase.dart';
import 'package:taxi_for_you/domain/usecase/registration_usecase.dart';
import 'package:taxi_for_you/domain/usecase/service_status_usecase.dart';
import 'package:taxi_for_you/domain/usecase/trip_summary_usecase.dart';
import 'package:taxi_for_you/domain/usecase/trips_usecase.dart';
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
import '../presentation/login/login_viewmodel.dart';
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
}

initLoginModule() {
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    instance.registerLazySingleton<LoginViewModel>(
        () => LoginViewModel(instance()));
    instance.registerLazySingleton<LoginBloc>(
        () => LoginBloc(loginUseCase: instance()));
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
