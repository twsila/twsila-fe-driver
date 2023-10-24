import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taxi_for_you/domain/model/current_location_model.dart';
import 'package:taxi_for_you/domain/model/location_filter_model.dart';
import 'package:taxi_for_you/domain/model/sorting_model.dart';
import 'package:taxi_for_you/domain/model/trip_model.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_card.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/main/pages/search_trips/search_trips_bloc/search_trips_bloc.dart';
import 'package:taxi_for_you/presentation/trip_details/view/trip_details_view.dart';
import 'package:taxi_for_you/presentation/trip_execution/view/trip_execution_view.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';
import 'package:taxi_for_you/utils/ext/enums.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/langauge_manager.dart';
import 'package:taxi_for_you/utils/resources/routes_manager.dart';

import '../../../../../app/app_prefs.dart';
import '../../../../../app/constants.dart';
import '../../../../../app/di.dart';
import '../../../../../domain/model/date_filter_model.dart';
import '../../../../../domain/model/trip_details_model.dart';
import '../../../../../utils/resources/strings_manager.dart';
import '../../../../../utils/resources/values_manager.dart';
import '../../../../common/widgets/custom_scaffold.dart';
import '../../../../common/widgets/page_builder.dart';
import '../../../../google_maps/model/location_model.dart';
import '../../../../google_maps/model/maps_repo.dart';
import '../../../../trip_execution/helper/location_helper.dart';

List<String> tripsTitles = [];
List<String> englishTripTitles = [];

class SearchTripsPage extends StatefulWidget {
  const SearchTripsPage({Key? key}) : super(key: key);

  @override
  _SearchTripsPageState createState() => _SearchTripsPageState();
}

class _SearchTripsPageState extends State<SearchTripsPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  bool _displayLoadingIndicator = false;
  bool _loadingTripsList = false;

  MapsRepo mapsRepo = MapsRepo();
  LocationModel? currentLocation;
  String currentCityName = '';
  CurrentLocationFilter? currentLocationFilter;

  int currentSortingIndex = 0;
  List<TripDetailsModel> trips = [];
  DateFilter? dateFilter = null;
  List<SortingModel> sortingModelList = [
    SortingModel(SortCriterion.REQUEST_DATE, AppStrings.requestedDate.tr()),
    SortingModel(SortCriterion.NEAREST_TO_ME, AppStrings.nearestToMe.tr()),
    SortingModel(SortCriterion.LIGHT_WEIGHT, AppStrings.lightWeight.tr()),
    SortingModel(SortCriterion.SHORT_DISTANCE, AppStrings.shortestWay.tr()),
    SortingModel(SortCriterion.HIGH_PRICE, AppStrings.highestPrice.tr()),
    SortingModel(
        SortCriterion.TOP_RATED_CLIENT, AppStrings.highestRateClient.tr()),
  ];
  int currentIndex = 0;

  getCurrentLocation() async {
    try {
      if (currentLocation == null) {
        currentLocation = await mapsRepo.getUserCurrentLocation();
        currentLocationFilter = CurrentLocationFilter(
                latitude: currentLocation!.latitude,
                longitude: currentLocation!.longitude,
                cityName: '');
        currentCityName = await LocationHelper().getCityNameByCoordinates(
            currentLocation!.latitude, currentLocation!.longitude);
        currentLocationFilter!.cityName = currentCityName;
      }
    } catch (e) {
      CustomDialog(context).showWaringDialog(
          '', '', AppStrings.needLocationPermission.tr(), onBtnPressed: () {
        Geolocator.openLocationSettings();
      });
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        elevation: 10,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) => Container(
            padding: EdgeInsets.all(AppSize.s14),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
            alignment: Alignment.center,
            child: ListView.builder(
              itemCount: sortingModelList.length,
              itemBuilder: (context, index) {
                final selectedSortModel = sortingModelList[index];
                return InkWell(
                  onTap: () {
                    setState(() {
                      currentSortingIndex = index;
                      BlocProvider.of<SearchTripsBloc>(context).add(
                          GetTripsTripModuleId(
                              tripTypeId: 'ALL_TRIPS',
                              sortCriterion:
                                  selectedSortModel.id.name.toString(),
                              currentLocation: currentLocationFilter));
                      Navigator.pop(context);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(AppPadding.p12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedSortModel.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: ColorManager.headersTextColor),
                        ),
                        const SizedBox(
                          width: AppSize.s8,
                        ),
                        Visibility(
                          visible: currentSortingIndex == index,
                          child: Icon(
                            Icons.check,
                            color: ColorManager.purpleMainTextColor,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )));
  }

  ListView _TripsTitleListView(List<String> tripsTitles) {
    return ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
            tripsTitles.length, (index) => tripTitleItemView(index)));
  }

  ListView _TripsListView(List<TripDetailsModel> tripsTitles) {
    return ListView(
        scrollDirection: Axis.vertical,
        children:
            List.generate(trips.length, (index) => tripItemView(trips[index])));
  }

  void startLoading() {
    setState(() {
      _displayLoadingIndicator = true;
    });
  }

  void stopLoading() {
    setState(() {
      _displayLoadingIndicator = false;
    });
  }

  @override
  void initState() {
    // BlocProvider.of<SearchTripsBloc>(context).add(getLookups());
    BlocProvider.of<SearchTripsBloc>(context).add(GetTripsTripModuleId(
        tripTypeId: 'ALL_TRIPS',
        sortCriterion:
            sortingModelList[currentSortingIndex].id.name.toString()));

    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
          appbar: true,
          context: context,
          body: _getContentWidget(context),
          scaffoldKey: _key,
          displayLoadingIndicator: _displayLoadingIndicator,
          allowBackButtonInAppBar: false,
          appBarTitle: AppStrings.twsela.tr(),
          appBarBackgroundColor: ColorManager.white,
          showLanguageChange: true,
          centerTitle: true,
          appBarActions: [
            GestureDetector(
              onTap: () async {
                FilterTripsModel filterData =
                    await Navigator.pushNamed(context, Routes.filterTrips)
                        as FilterTripsModel;
                BlocProvider.of<SearchTripsBloc>(context).add(
                    GetTripsTripModuleId(
                        tripTypeId: 'ALL_TRIPS',
                        dateFilter: filterData.dateFilter,
                        locationFilter: filterData.locationFilter,
                        currentLocation: filterData.currentLocation));
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: AppMargin.m8),
                height: AppSize.s30,
                width: AppSize.s30,
                child: Image.asset(
                  ImageAssets.filterIcon,
                ),
              ),
            ),
          ],
          extendBodyBehindAppBar: true),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return BlocConsumer<SearchTripsBloc, SearchTripsState>(
      listener: (context, state) {
        if (state is SearchTripsLoading) {
          _loadingTripsList = true;
        } else {
          _loadingTripsList = false;
        }
        if (state is GetLookupsSuccessState) {
          englishTripTitles.addAll(state.englishTripTitles);
          tripsTitles.clear();
          if (_appPreferences.getAppLanguage() ==
              LanguageType.ARABIC.getValue()) {
            tripsTitles.addAll(state.arabicTripTitles);
          } else {
            tripsTitles.addAll(state.englishTripTitles);
          }
          BlocProvider.of<SearchTripsBloc>(context)
              .add(GetTripsTripModuleId(tripTypeId: 'ALL_TRIPS'));
        }

        if (state is SearchTripsSuccess) {
          trips = state.trips;
        }
        if (state is SearchTripsFailure) {
          CustomDialog(context)
              .showErrorDialog('', '', "${state.code} ${state.message}");
        }
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            getCurrentLocation();
            return false;
          },
          child: Stack(alignment: Alignment.center, children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: AppSize.s8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Container(
                  //           height: AppSize.s40,
                  //           child: _TripsTitleListView(tripsTitles)),
                  //     ),
                  //   ],
                  // ),
                  Expanded(
                    child: _loadingTripsList
                        ? Center(
                            child: CircularProgressIndicator(
                              color: ColorManager.purpleMainTextColor,
                            ),
                          )
                        : trips.length == 0
                            ? Center(
                                child: Text(
                                  AppStrings.noTripsAvailable.tr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: ColorManager.error),
                                ),
                              )
                            : Container(child: _TripsListView(trips)),
                  )
                ],
              ),
            ),
            Positioned(
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextButton(
                    onPressed: () {
                      _showBottomSheet();
                    },
                    width: AppSize.s130,
                    height: AppSize.s40,
                    fontSize: FontSize.s12,
                    backgroundColor: ColorManager.secondaryColor,
                    isWaitToEnable: false,
                    icon: Image.asset(
                      ImageAssets.sortingIcon,
                      width: 20,
                    ),
                    text: AppStrings.sortBy.tr(),
                  ),
                ))
          ]),
        );
      },
    );
  }

  tripTitleItemView(int index) {
    return Container(
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentIndex = index;
            BlocProvider.of<SearchTripsBloc>(context).add(GetTripsTripModuleId(
                tripTypeId: 'ALL_TRIPS', dateFilter: null));
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: AppSize.s3),
          padding: EdgeInsets.symmetric(horizontal: AppSize.s6),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: currentIndex == index
                  ? ColorManager.purpleMainTextColor
                  : ColorManager.white,
              border: Border.all(color: ColorManager.borderColor)),
          child: Center(
            child: Text(
              tripsTitles[index],
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: currentIndex == index
                      ? ColorManager.white
                      : ColorManager.headersTextColor,
                  fontSize: FontSize.s14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  tripItemView(TripDetailsModel trip) {
    String? date;
    if (trip.tripDetails.date != null) {
      date = handleDateString(trip.tripDetails.date!);
    }
    return CustomCard(
      onClick: () {
        if (trip.tripDetails.acceptedOffer != null)
          Navigator.pushNamed(context, Routes.tripExecution,
                  arguments: TripExecutionArguments(trip))
              .then((value) => BlocProvider.of<SearchTripsBloc>(context).add(
                  GetTripsTripModuleId(
                      tripTypeId: 'ALL_TRIPS', dateFilter: null)));
        else
          Navigator.pushNamed(context, Routes.tripDetails,
                  arguments: TripDetailsArguments(tripModel: trip))
              .then((value) => BlocProvider.of<SearchTripsBloc>(context).add(
                  GetTripsTripModuleId(
                      tripTypeId: 'ALL_TRIPS', dateFilter: null)));
      },
      bodyWidget: Container(
        margin: EdgeInsets.all(AppMargin.m8),
        padding: EdgeInsets.only(
            top: AppPadding.p8,
            left: AppPadding.p8,
            right: AppPadding.p8,
            bottom: AppPadding.p2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: ColorManager.primaryBlueBackgroundColor,
                  padding: EdgeInsets.all(AppPadding.p2),
                  child: Padding(
                    padding: const EdgeInsets.all(AppPadding.p4),
                    child: Row(
                      children: [
                        Image.asset(
                          trip.tripDetails.date != null &&
                                  trip.tripDetails.date != ""
                              ? ImageAssets.scheduledTripIc
                              : ImageAssets.asSoonAsPossibleTripIc,
                          width: AppSize.s14,
                        ),
                        SizedBox(
                          width: AppSize.s4,
                        ),
                        Text(
                          date != null && date != ""
                              ? AppStrings.scheduled.tr() + " : ${date}"
                              : AppStrings.asSoonAsPossible.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: ColorManager.headersTextColor,
                                  fontSize: FontSize.s12,
                                  fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                // SvgPicture.asset(ImageAssets.truckIc,),
                Image.asset(
                  getIconName(trip.tripDetails.tripType!),
                  width: AppSize.s40,
                ),
              ],
            ),
            SizedBox(
              height: AppSize.s4,
            ),
            Text(
              getTitle(trip.tripDetails.tripType!),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorManager.headersTextColor,
                  fontSize: FontSize.s14,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: AppSize.s4,
            ),
            Text(
              "${trip.tripDetails.pickupLocation.locationName} - ${trip.tripDetails.destinationLocation.locationName}",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorManager.headersTextColor,
                  fontSize: FontSize.s14,
                  fontWeight: FontWeight.normal),
            ),
            Divider(
              color: ColorManager.dividerColor,
              thickness: 1,
            ),
            SizedBox(
              height: AppSize.s4,
            ),
            tripStatusWidget(trip),
          ],
        ),
      ),
    );
  }

  Widget tripStatusWidget(TripDetailsModel trip) {
    if (trip.tripDetails.offers!.length == 0 &&
        trip.tripDetails.acceptedOffer == null) {
      return Text(
        AppStrings.waitingCaptainsOffers.tr(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: ColorManager.supportTextColor,
            fontSize: FontSize.s16,
            fontWeight: FontWeight.bold),
      );
    } else if (trip.tripDetails.offers!.length > 0 &&
        trip.tripDetails.acceptedOffer == null) {
      return handleOfferStatus(trip.tripDetails.offers![0]);
    } else if (trip.tripDetails.acceptedOffer != null) {
      return Text(
        AppStrings.offerAccepted.tr(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: ColorManager.primary,
            fontSize: FontSize.s16,
            fontWeight: FontWeight.bold),
      );
    } else {
      return Container();
    }
  }

  Text handleOfferStatus(Offer offer) {
    if (offer.acceptanceStatus == AcceptanceType.PROPOSED.name) {
      return Text(
          "${AppStrings.offerHasBeenSent.tr()} (${offer.driverOffer} ${AppStrings.ryalSuadi.tr()})",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ColorManager.purpleMainTextColor,
              fontSize: FontSize.s16,
              fontWeight: FontWeight.bold));
    } else if (offer.acceptanceStatus == AcceptanceType.EXPIRED.name) {
      return Text(
          "${AppStrings.clientRejectYourOffer.tr()} (${offer.driverOffer} ${AppStrings.ryalSuadi.tr()})",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ColorManager.error,
              fontSize: FontSize.s16,
              fontWeight: FontWeight.bold));
    } else {
      return Text(
          "${AppStrings.offerAccepted.tr()} (${offer.driverOffer} ${AppStrings.ryalSuadi.tr()})",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ColorManager.primary,
              fontSize: FontSize.s16,
              fontWeight: FontWeight.bold));
    }
  }

  String handleDateString(String dateString) {
    DateTime parseDate =
        new DateFormat(Constants.dateFormatterString).parse(dateString);
    String date = DateFormat(
            Constants.dateFormatterString, _appPreferences.getAppLanguage())
        .format(parseDate);
    return date;
  }
}

class TripTitleModel {
  int id;
  String title;
  bool? isSelected;

  TripTitleModel(this.id, this.title, {this.isSelected = false});
}

class FilterTripsModel {
  DateFilter? dateFilter;
  LocationFilter? locationFilter;
  CurrentLocationFilter? currentLocation;

  FilterTripsModel(this.dateFilter, this.locationFilter, this.currentLocation);
}
