import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taxi_for_you/domain/model/trip_model.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_card.dart';
import 'package:taxi_for_you/presentation/main/pages/search_trips/search_trips_bloc/search_trips_bloc.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';

import '../../../../../app/app_prefs.dart';
import '../../../../../app/di.dart';
import '../../../../../utils/resources/strings_manager.dart';
import '../../../../../utils/resources/values_manager.dart';
import '../../../../common/widgets/custom_scaffold.dart';
import '../../../../common/widgets/page_builder.dart';

List<TripTitleModel> tripsTitles = [
  TripTitleModel(1, "كل الرحلات"),
  TripTitleModel(2, "رحلات اليوم"),
  TripTitleModel(3, "رحلات مجدولة"),
  TripTitleModel(4, "تم ارسال عرض"),
  TripTitleModel(5, "رحلات مجدولة"),
];

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
  TripTitleModel selectedTripModule = tripsTitles[0];
  List<TripModel> trips = [];
  String dateFormatterString = 'dd/MM/yyyy';

  ListView _TripsTitleListView(List<TripTitleModel> tripsTitles) {
    return ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(tripsTitles.length,
            (index) => tripTitleItemView(tripsTitles[index])));
  }

  ListView _TripsListView(List<TripModel> tripsTitles) {
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
    BlocProvider.of<SearchTripsBloc>(context)
        .add(GetTripsTripModuleId(selectedTripModule.id));
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
    return BlocConsumer<SearchTripsBloc, SearchTripsState>(
      listener: (context, state) {
        if (state is SearchTripsLoading) {
          _loadingTripsList = true;
        } else {
          _loadingTripsList = false;
        }

        if (state is SearchTripsSuccess) {
          trips = state.trips;
        }
      },
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: AppSize.s8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: AppSize.s40, child: _TripsTitleListView(tripsTitles)),
              Expanded(
                child: _loadingTripsList
                    ? Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.purpleMainTextColor,
                        ),
                      )
                    : Container(child: _TripsListView(trips)),
              )
            ],
          ),
        );
      },
    );
  }

  tripTitleItemView(TripTitleModel titleModel) {
    return Container(
      child: GestureDetector(
        onTap: () {
          setState(() {
            titleModel.isSelected = !titleModel.isSelected!;
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: AppSize.s3),
          padding: EdgeInsets.symmetric(horizontal: AppSize.s6),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: titleModel.isSelected!
                  ? ColorManager.purpleMainTextColor
                  : ColorManager.white,
              border: Border.all(color: ColorManager.borderColor)),
          child: Center(
            child: Text(
              titleModel.title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: titleModel.isSelected!
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

  tripItemView(TripModel trip) {
    String? date;
    if (trip.date != null) {
      date = handleDateString(trip.date!);
    }
    return CustomCard(
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
                  child: Row(
                    children: [
                      SvgPicture.asset(trip.date != null && trip.date != ""
                          ? ImageAssets.scheduledTripIc
                          : ImageAssets.asSoonAsPossibleTripIc),
                      SizedBox(
                        width: AppSize.s4,
                      ),
                      Text(
                        date != null && date != ""
                            ? AppStrings.scheduled.tr() + " : ${date}"
                            : AppStrings.asSoonAsPossible.tr(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ColorManager.headersTextColor,
                            fontSize: FontSize.s12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SvgPicture.asset(ImageAssets.truckIc,),
              ],
            ),
            Text(
              trip.tripType,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorManager.headersTextColor,
                  fontSize: FontSize.s14,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "${trip.pickupLocation.locationName} - ${trip.destination.locationName}",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorManager.headersTextColor,
                  fontSize: FontSize.s14,
                  fontWeight: FontWeight.bold),
            ),
            Divider(
              color: ColorManager.dividerColor,
              thickness: 1,
            ),
            Text(
              trip.tripStatus == TripStatus.DRAFT
                  ? AppStrings.waitingCaptainsOffers.tr()
                  : "",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorManager.supportTextColor,
                  fontSize: FontSize.s14,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      onClick: () {},
    );
  }

  String handleDateString(String dateString) {
    DateTime parseDate = new DateFormat(dateFormatterString).parse(dateString);
    String date =
        DateFormat(dateFormatterString, _appPreferences.getAppLanguage())
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
