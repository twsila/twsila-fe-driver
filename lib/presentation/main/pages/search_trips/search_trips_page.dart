import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';

import '../../../../app/app_prefs.dart';
import '../../../../app/di.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../../utils/resources/values_manager.dart';
import '../../../common/widgets/custom_scaffold.dart';
import '../../../common/widgets/page_builder.dart';

List<TripTitleModel> tripsTitles = [
  TripTitleModel("كل الرحلات"),
  TripTitleModel("رحلات اليوم"),
  TripTitleModel("رحلات مجدولة"),
  TripTitleModel("تم ارسال عرض"),
  TripTitleModel("رحلات مجدولة"),
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
  String onChangValue = "";

  ListView _TripsTitleListView(List<TripTitleModel> tripsTitles) {
    return ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(tripsTitles.length,
            (index) => tripTitleItemView(tripsTitles[index])));
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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.symmetric(vertical: AppSize.s8),
              height: AppSize.s40,
              child: _TripsTitleListView(tripsTitles))
        ],
      ),
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
}

class TripTitleModel {
  String title;
  bool? isSelected;

  TripTitleModel(this.title, {this.isSelected = false});
}
