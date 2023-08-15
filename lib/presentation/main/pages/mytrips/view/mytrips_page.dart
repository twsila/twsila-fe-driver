import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_for_you/app/constants.dart';
import 'package:taxi_for_you/presentation/trip_execution/view/trip_execution_view.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../../../app/app_prefs.dart';
import '../../../../../app/di.dart';
import '../../../../../domain/model/trip_details_model.dart';
import '../../../../../domain/model/trip_model.dart';
import '../../../../../utils/ext/enums.dart';
import '../../../../../utils/resources/assets_manager.dart';
import '../../../../../utils/resources/routes_manager.dart';
import '../../../../../utils/resources/strings_manager.dart';
import '../../../../common/widgets/custom_card.dart';
import '../../../../common/widgets/custom_scaffold.dart';
import '../../../../common/widgets/page_builder.dart';
import '../../../../trip_details/view/trip_details_view.dart';
import '../bloc/my_trips_bloc.dart';

class MyTripsPage extends StatefulWidget {
  const MyTripsPage({Key? key}) : super(key: key);

  @override
  _MyTripsPageState createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  bool _loadingTripsList = false;
  List<TripDetailsModel> trips = [];
  bool _displayLoadingIndicator = false;
  List<MyTripsListModel> items = [
    MyTripsListModel("TODAY_TRIPS", AppStrings.onGoing.tr()),
    MyTripsListModel("SCHEDULED_TRIPS", AppStrings.scheduled.tr()),
    MyTripsListModel("OLD_TRIPS", AppStrings.last.tr()),
  ];
  int current = 0;

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
    BlocProvider.of<MyTripsBloc>(context)
        .add(GetTripsTripModuleId(items[current].tripModelTypeId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
          appbar: false,
          context: context,
          body: _getContentWidget(context),
          scaffoldKey: _key,
          displayLoadingIndicator: _displayLoadingIndicator,
          allowBackButtonInAppBar: false,
          extendBodyBehindAppBar: true),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return BlocConsumer<MyTripsBloc, MyTripsState>(
      listener: (context, state) {
        if (state is MyTripsLoading) {
          _loadingTripsList = true;
        } else {
          _loadingTripsList = false;
        }

        if (state is MyTripsSuccess) {
          trips = state.trips;
        }
      },
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.all(AppSize.s12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: AppSize.s20,
              ),
              _headerText(),
              SizedBox(
                height: AppSize.s20,
              ),

              /// CUSTOM TABBAR
              _MyTripsTitlesTabsBar(),

              /// MAIN BODY
              _tripsListView(),
            ],
          ),
        );
      },
    );
  }

  Widget _tripsListView() {
    return Expanded(
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
    );
  }

  ListView _TripsListView(List<TripDetailsModel> tripsTitles) {
    return ListView(
        scrollDirection: Axis.vertical,
        children:
            List.generate(trips.length, (index) => tripItemView(trips[index])));
  }

  tripItemView(TripDetailsModel trip) {
    String? date;
    if (trip.tripDetails.date != null) {
      date = handleDateString(trip.tripDetails.date!);
    }
    return CustomCard(
      onClick: () {
        Navigator.pushNamed(context, Routes.tripExecution,
            arguments: TripExecutionArguments(trip));
        // Navigator.pushNamed(context, Routes.tripDetails,
        //     arguments: TripDetailsArguments(tripModel: trip));
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
                  fontWeight: FontWeight.bold),
            ),
            Divider(
              color: ColorManager.dividerColor,
              thickness: 1,
            ),
            SizedBox(
              height: AppSize.s4,
            ),
            Text(
              getTripStatusDiscs(trip.tripDetails.tripStatus.toString()),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: getTripStatusDisColor(
                      trip.tripDetails.tripStatus.toString()),
                  fontSize: FontSize.s16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: AppSize.s4,
            ),
            Visibility(
              visible:
                  getTripStatusSubDis(trip.tripDetails.tripStatus.toString())
                      .isNotEmpty,
              child: Text(
                getTripStatusSubDis(trip.tripDetails.tripStatus.toString()),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ColorManager.headersTextColor,
                    fontSize: FontSize.s14,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerText() {
    return Text(
      AppStrings.myTrips.tr(),
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: ColorManager.headersTextColor, fontSize: FontSize.s28),
    );
  }

  Widget _MyTripsTitlesTabsBar() {
    return Container(
      height: AppSize.s39,
      color: ColorManager.purpleFade,
      alignment: Alignment.center,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (ctx, index) {
            return tabsTitleWidget(index);
          }),
    );
  }

  Widget tabsTitleWidget(int index) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              current = index;
              BlocProvider.of<MyTripsBloc>(context)
                  .add(GetTripsTripModuleId(items[current].tripModelTypeId));
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.all(5),
            width: AppSize.s100,
            height: AppSize.s28,
            decoration: BoxDecoration(
                color:
                    current == index ? Colors.white : ColorManager.purpleFade,
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                    color: current == index ? Colors.white : Colors.transparent,
                    width: 2)),
            child: Center(
              child: Text(
                items[index].title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.s14,
                    color: current == index
                        ? ColorManager.headersTextColor
                        : ColorManager.purpleMainTextColor),
              ),
            ),
          ),
        ),
      ],
    );
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

class MyTripsListModel {
  String tripModelTypeId;
  String title;

  MyTripsListModel(this.tripModelTypeId, this.title);
}
