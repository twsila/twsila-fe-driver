import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:taxi_for_you/app/di.dart';
import 'package:taxi_for_you/presentation/main/pages/myprofile/bloc/my_profile_bloc.dart';
import 'package:taxi_for_you/presentation/service_registration/bloc/serivce_registration_bloc.dart';
import 'package:taxi_for_you/presentation/service_registration/view/pages/serivce_registration_first_step_view.dart';

import '../presentation/google_maps/bloc/maps_bloc.dart';
import '../presentation/google_maps/model/maps_repo.dart';
import '../presentation/login/bloc/login_bloc.dart';
import '../presentation/my_serivces/bloc/my_services_bloc.dart';
import '../presentation/otp/bloc/verify_otp_bloc.dart';
import '../utils/location/map_provider.dart';

blocProviders(BuildContext context) {
  return [
    BlocProvider.value(value: MapsBloc(MapsRepo())),
    BlocProvider.value(value: LoginBloc(loginUseCase: instance())),
    BlocProvider.value(
        value: VerifyOtpBloc(
            verifyOtpUseCase: instance(),
            generateOtpUseCase: instance(),
            loginUseCase: instance())),
    BlocProvider.value(
        value: ServiceRegistrationBloc(
            registrationServiceUseCase: instance(),
            carBrandsAndModelsUseCase: instance(),registrationUseCase: instance())),
    BlocProvider.value(value: MyServicesBloc(serviceStatusUseCase: instance())),
    BlocProvider.value(value: MyProfileBloc(logoutUseCase: instance())),
    ChangeNotifierProvider(create: (_) => MapProvider())
  ];
}
