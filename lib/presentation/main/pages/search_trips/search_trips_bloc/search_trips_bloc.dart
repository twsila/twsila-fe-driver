import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taxi_for_you/domain/model/current_location_model.dart';
import 'package:taxi_for_you/domain/model/date_filter_model.dart';
import 'package:taxi_for_you/domain/model/location_filter_model.dart';
import 'package:taxi_for_you/domain/usecase/trips_usecase.dart';

import '../../../../../app/app_prefs.dart';
import '../../../../../app/di.dart';
import '../../../../../domain/model/trip_details_model.dart';
import '../../../../../domain/model/trip_model.dart';
import '../../../../../domain/usecase/lookups_usecase.dart';

part 'search_trips_event.dart';

part 'search_trips_state.dart';

class SearchTripsBloc extends Bloc<SearchTripsEvent, SearchTripsState> {
  TripsUseCase tripsUseCase;
  LookupsUseCase lookupsUseCase;
  final AppPreferences _appPreferences = instance<AppPreferences>();

  SearchTripsBloc({required this.tripsUseCase, required this.lookupsUseCase})
      : super(SearchTripsInitial()) {
    on<GetTripsTripModuleId>(_getTripsByModuleId);
    on<getLookups>(_getLookups);
  }

  FutureOr<void> _getLookups(
      getLookups event, Emitter<SearchTripsState> emit) async {
    emit(SearchTripsLoading());
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
    (await tripsUseCase.execute(TripsInput(
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
