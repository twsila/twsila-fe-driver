import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/trip_model.dart';
import '../../../utils/resources/assets_manager.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/page_builder.dart';

class TripDetailsView extends StatefulWidget {
  final TripModel tripModel;

  TripDetailsView({required this.tripModel});

  @override
  State<TripDetailsView> createState() => _TripDetailsViewState();
}

class _TripDetailsViewState extends State<TripDetailsView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  bool _displayLoadingIndicator = false;

  // the current step
  int _currentStep = 0;

  // Determines whether the stepper's orientation is vertical or horizontal
  // This variable can be changed by using the switch below
  bool _isVerticalStepper = true;

  // This function will be triggered when a step is tapped
  _stepTapped(int step) {
    setState(() => _currentStep = step);
  }

  // This function will be called when the continue button is tapped
  _stepContinue() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  // This function will be called when the cancel button is tapped
  _stepCancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
        appbar: true,
        context: context,
        body: _getContentWidget(context),
        scaffoldKey: _key,
        appBarTitle: AppStrings.requestDetails.tr(),
        centerTitle: true,
        displayLoadingIndicator: _displayLoadingIndicator,
        allowBackButtonInAppBar: true,
      ),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppMargin.m12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "${AppStrings.request.tr()} ${widget.tripModel.tripType}",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ColorManager.headersTextColor,
                        fontSize: FontSize.s24,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  _fromToWidget()
                ],
              ),
              Image.asset(
                ImageAssets.truckX4Ic,
                width: AppSize.s50,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _fromToWidget() {
    return Container();
  }
}

class TripDetailsArguments {
  TripModel tripModel;

  TripDetailsArguments({required this.tripModel});
}
