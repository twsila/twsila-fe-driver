import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_for_you/app/constants.dart';
import 'package:taxi_for_you/presentation/main/pages/mytrips/view/widgets/ongoing_item.dart';
import 'package:taxi_for_you/presentation/main/pages/mytrips/view/widgets/precedent_item.dart';
import 'package:taxi_for_you/presentation/main/pages/mytrips/view/widgets/scheduled_item.dart';
import 'package:taxi_for_you/presentation/trip_execution/view/trip_execution_view.dart';
import 'package:taxi_for_you/utils/ext/date_ext.dart';
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
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<MyTripsBloc>(context)
            .add(GetTripsTripModuleId(items[current].tripModelTypeId));
      },
      child: BlocConsumer<MyTripsBloc, MyTripsState>(
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
      ),
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
      date = trip.tripDetails.date!.getTimeStampFromDate();
    }
    return current == 0
        ? OngoingItemView(
            trip: trip,
            currentTripModelId: items[current].tripModelTypeId,
            date: date ?? "")
        : current == 1
            ? ScheduledItemView(
                trip: trip,
                currentTripModelId: items[current].tripModelTypeId,
                date: date ?? "")
            : PrecedentItemView(
                trip: trip,
                currentTripModelId: items[current].tripModelTypeId,
                date: date ?? "");
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
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: MediaQuery.of(context).size.width * 0.008,
          ),
          itemBuilder: (BuildContext context, int index) {
            return tabsTitleWidget(index);
          },
        ));
    //   child: ListView.builder(
    //       physics: const NeverScrollableScrollPhysics(),
    //       itemCount: items.length,
    //       shrinkWrap: true,
    //       scrollDirection: Axis.horizontal,
    //       itemBuilder: (ctx, index) {
    //         return tabsTitleWidget(index);
    //       }),
    // );
  }

  Widget tabsTitleWidget(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          current = index;
          BlocProvider.of<MyTripsBloc>(context)
              .add(GetTripsTripModuleId(items[current].tripModelTypeId));
        });
      },
      child: FittedBox(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.all(5),
          width: AppSize.s100,
          decoration: BoxDecoration(
              color: current == index ? Colors.white : ColorManager.purpleFade,
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
