import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/domain/model/current_location_model.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/domain/model/location_filter_model.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/model/Business_owner_model.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_checkbox.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/filter_trips/view/widgets/city_filter_widget.dart';
import 'package:taxi_for_you/presentation/filter_trips/view/widgets/fiter_by_service_widget.dart';
import 'package:taxi_for_you/presentation/filter_trips/view/widgets/from_to_date_widget.dart';
import 'package:taxi_for_you/utils/ext/enums.dart';
import 'package:taxi_for_you/utils/resources/constants_manager.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/date_filter_model.dart';
import '../../../utils/resources/assets_manager.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/page_builder.dart';
import '../../main/pages/search_trips/view/search_trips_page.dart';
import 'helpers/filtration_helper.dart';

class FilterTripsView extends StatefulWidget {
  FilterTripsView();

  @override
  State<FilterTripsView> createState() => _FilterTripsViewState();
}

class _FilterTripsViewState extends State<FilterTripsView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  DateFilter? dateFilter;
  LocationFilter? locationFilter;
  CurrentLocationFilter? currentLocationFilter;
  bool? isTodayDate;
  bool isOfferedTrip = false;
  int selectedOption = 1;
  DriverBaseModel? driverBaseModel;
  String? filteredServices;

  @override
  void initState() {
    driverBaseModel = _appPreferences.getCachedDriver()!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
          appbar: true,
          context: context,
          body: _build(context),
          scaffoldKey: _key,
          allowBackButtonInAppBar: true,
          appBarTitle: "عرض الرحلات",
          centerTitle: true),
    );
  }

  Widget _build(BuildContext context) {
    return Column(
      children: [
        FromToDateWidget(
          onSelectDate: (fromDate, toDate, todayDate) {
            dateFilter = DateFilter(
                startDate: fromDate, endDate: toDate, isToday: todayDate);
          },
        ),
        CityFilterWidget(
          onSelectLocationFilter: (pickup, destination, currentFilter) {
            locationFilter =
                LocationFilter(pickup: pickup, destination: destination);
            currentLocationFilter = currentFilter;
          },
        ),
        tripTypeFiltration(),
        Visibility(
          visible:
              driverBaseModel!.captainType == RegistrationConstants.captain &&
                  (driverBaseModel! as Driver).serviceTypes!.length > 1,
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: AppSize.s12,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.p12),
                  child: Text(
                    '${AppStrings.selectServiceType.tr()}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColorManager.titlesTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.s16),
                  ),
                ),
                FilterByServiceWidget(
                  serviceParams: driverBaseModel!.captainType ==
                          RegistrationConstants.captain
                      ? (driverBaseModel! as Driver).serviceTypes!
                      : FiltrationHelper().serviceTypesList,
                  onSelectedServices: (list) {
                    filteredServices = "";
                    filteredServices = list.join(',');
                  },
                ),
              ],
            ),
          ),
        ),

        // Spacer(),
        CustomTextButton(
          text: AppStrings.searchTrips.tr(),
          isWaitToEnable: false,
          onPressed: () {
            Navigator.pop(
                context,
                FilterTripsModel(
                    dateFilter: dateFilter ?? null,
                    locationFilter: locationFilter ?? null,
                    currentLocation: currentLocationFilter ?? null,
                    isOfferedTrips: isOfferedTrip,
                    boFilteredTrips: null,
                    driverFilteredTrips:
                        filteredServices != null && filteredServices!.isNotEmpty
                            ? filteredServices
                            : null));
          },
        )
      ],
    );
  }

  Widget filterGoodsOrFurnitureRadioButtons() {
    return Visibility(
      visible: false,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.p12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.goodsType.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ColorManager.titlesTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: FontSize.s16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: Text(
                      AppStrings.goods.tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    leading: Radio(
                      value: 1,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value! as int;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      AppStrings.furniture.tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    leading: Radio(
                      value: 2,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value! as int;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget tripTypeFiltration() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.p12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.tripType.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: ColorManager.titlesTextColor,
                fontWeight: FontWeight.bold,
                fontSize: FontSize.s16),
          ),
          SizedBox(
            height: AppSize.s12,
          ),
          CustomCheckBox(
              checked: isOfferedTrip,
              fieldName: AppStrings.offerHasBeenSent.tr(),
              onChange: (value) {
                isOfferedTrip = value;
              }),
        ],
      ),
    );
  }
}
