import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/filter_trips/view/widgets/city_filter_widget.dart';
import 'package:taxi_for_you/presentation/filter_trips/view/widgets/from_to_date_widget.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../utils/resources/assets_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/page_builder.dart';

class FilterTripsView extends StatefulWidget {
  FilterTripsView();

  @override
  State<FilterTripsView> createState() => _FilterTripsViewState();
}

class _FilterTripsViewState extends State<FilterTripsView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();

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
        FromToDateWidget(),
        CityFilterWidget(),
        Spacer(),
        CustomTextButton(
          text: AppStrings.searchTrips.tr(),
          isWaitToEnable: false,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
