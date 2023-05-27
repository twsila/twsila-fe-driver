import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/ServiceTypeModel.dart';
import '../../../domain/usecase/registration_services_usecase.dart';

part 'registration_event.dart';

part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationServiceUseCase registrationServiceUseCase;
  final AppPreferences _appPreferences = instance<AppPreferences>();

  RegistrationBloc({required this.registrationServiceUseCase})
      : super(RegistrationInitial()) {}
}
