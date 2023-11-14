import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taxi_for_you/domain/model/current_location_model.dart';
import 'package:taxi_for_you/domain/model/date_filter_model.dart';
import 'package:taxi_for_you/domain/model/location_filter_model.dart';
import 'package:taxi_for_you/domain/usecase/trips_usecase.dart';

import '../../../../../app/app_prefs.dart';
import '../../../../../app/constants.dart';
import '../../../../../app/di.dart';
import '../../../../../domain/model/trip_details_model.dart';
import '../../../../../domain/model/trip_model.dart';
import '../../../../../domain/usecase/lookups_usecase.dart';
import '../../../../../utils/resources/constants_manager.dart';

part 'search_trips_event.dart';

part 'search_trips_state.dart';

class SearchTripsBloc extends Bloc<SearchTripsEvent, SearchTripsState> {
  final AppPreferences _appPreferences = instance<AppPreferences>();

  SearchTripsBloc() : super(SearchTripsInitial()) {
    on<GetTripsTripModuleId>(_getTripsByModuleId);
    on<getLookups>(_getLookups);
  }

  FutureOr<void> _getLookups(
      getLookups event, Emitter<SearchTripsState> emit) async {
    emit(SearchTripsLoading());

    LookupsUseCase lookupsUseCase = instance<LookupsUseCase>();
    (await lookupsUseCase.execute(LookupsUseCaseInput())).fold(
        (failure) => {
              // left -> failure
              //emit failure state

              emit(SearchTripsFailure(failure.message, failure.code.toString()))
            }, (lookupsResponse) async {
      // right -> data (success)
      // content
      // emit success state
      List<String> englishTitles = lookupsResponse.result.tripModelType;
      List<String> arabicTitles = lookupsResponse.result.tripModelTypeAr;

      emit(GetLookupsSuccessState(
          englishTripTitles: englishTitles, arabicTripTitles: arabicTitles));
    });
  }

  FutureOr<void> _getTripsByModuleId(
      GetTripsTripModuleId event, Emitter<SearchTripsState> emit) async {
    emit(SearchTripsLoading());
    TripsUseCase tripsUseCase = instance<TripsUseCase>();
    String endPoint = _appPreferences.getCachedDriver()?.captainType ==
            RegistrationConstants.captain
        ? EndPoints.DriversTrips
        : EndPoints.BusinessOwnerTrips;
    (await tripsUseCase.execute(TripsInput(
            endPoint,
            event.tripTypeId,
            _appPreferences.getCachedDriver()?.id ?? -1,
            event.dateFilter?.toJson() ?? null,
            event.locationFilter?.toJson() ?? null,
            event.currentLocation?.toJson() ?? null,
            event.sortCriterion)))
        .fold(
            (failure) => {
                  // left -> failure
                  //emit failure state

                  emit(SearchTripsFailure(
                      failure.message, failure.code.toString()))
                }, (trips) async {
      // right -> data (success)
      // content
      // emit success state

      emit(SearchTripsSuccess(trips));
    });
  }
}
