import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:im_stepper/stepper.dart';
import 'package:taxi_for_you/domain/model/trip_model.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_stepper.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/utils/ext/enums.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/langauge_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../utils/resources/assets_manager.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/routes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/page_builder.dart';
import '../../trip_details/widgets/dotted_seperator.dart';
import '../bloc/trip_execution_bloc.dart';
import 'navigation_tracking_view.dart';

class TripExecutionView extends StatefulWidget {
  TripModel tripModel;

  TripExecutionView({required this.tripModel});

  @override
  State<TripExecutionView> createState() => _TripExecutionViewState();
}

class _TripExecutionViewState extends State<TripExecutionView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  bool _displayLoadingIndicator = false;
  int _index = 0;

  // REQUIRED: USED TO CONTROL THE STEPPER.
  int activeStep = 0; // Initial step set to 0.

  // OPTIONAL: can be set directly.
  int dotCount = 5;

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
    return BlocConsumer<TripExecutionBloc, TripExecutionState>(
      listener: (context, state) {
        if (state is TripExecutionLoading) {
          startLoading();
        } else {
          stopLoading();
        }
      },
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: AppSize.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tripDataHeader(),
              _fromToWidget(),
              Divider(
                color: ColorManager.lineColor,
                thickness: 1.0,
              ),
              TripStepperWidget(),
              Divider(
                color: ColorManager.lineColor,
                thickness: 1.0,
              ),
              TripDetailsWidget(),
            ],
          ),
        );
      },
    );
  }

  Widget TripDetailsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${AppStrings.tripDetails.tr()}",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ColorManager.purpleMainTextColor,
              fontSize: FontSize.s14,
              fontWeight: FontWeight.normal),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            detailsItem(
                ImageAssets.tripDetailsProfileIc,
                AppStrings.client.tr(),
                "${widget.tripModel.passenger!.firstName} ${widget.tripModel.passenger!.lastName}"),
            GestureDetector(
              onTap: () {
                launchUrl(Uri(
                    scheme: 'tel',
                    path: '${widget.tripModel.passenger!.mobile.toString()}'));
              },
              child: Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: ColorManager.purpleFade),
                child: Center(
                    child: Icon(
                  Icons.call_rounded,
                  color: ColorManager.purpleMainTextColor,
                )),
              ),
            )
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            detailsItem(
                ImageAssets.tripDetailsVisaIcon,
                AppStrings.withBudget.tr(),
                "${widget.tripModel.clientOffer} ${AppStrings.ryalSuadi.tr()}"),
            detailsItem(
                widget.tripModel.date != null
                    ? ImageAssets.scheduledTripIc
                    : ImageAssets.tripDetailsAsapIcon,
                AppStrings.type.tr(),
                widget.tripModel.date != null
                    ? AppStrings.scheduled.tr()
                    : AppStrings.asSoonAsPossible.tr()),
          ],
        )
      ],
    );
  }

  Widget tripDataHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${AppStrings.request.tr()} ${widget.tripModel.tripType!.getTripTitle()}",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorManager.headersTextColor,
                  fontSize: FontSize.s24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Image.asset(
          widget.tripModel.tripType!.getIconAsset(),
          width: AppSize.s50,
        ),
      ],
    );
  }

  Widget detailsItem(String iconPath, String title, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Image.asset(
            iconPath,
            width: AppSize.s18,
            height: AppSize.s20,
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorManager.headersTextColor,
                  fontSize: FontSize.s14,
                  fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            Text(
              data,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorManager.headersTextColor,
                  fontSize: FontSize.s16,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        )
      ],
    );
  }

  Widget _fromToWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 10,
        ),
        SvgPicture.asset(ImageAssets.locationPinTripDetailsIc),
        SizedBox(
          width: 10,
        ),
        Text(
          "${AppStrings.from.tr()} ${widget.tripModel.pickupLocation!.locationName} - ${widget.tripModel.destination!.locationName}",
          overflow: TextOverflow.clip,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ColorManager.headersTextColor,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget TripStepperWidget() {
    return Theme(
      data: ThemeData(
        colorScheme: Theme.of(context)
            .colorScheme
            .copyWith(primary: ColorManager.primary),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomStepper(
          // stepIndicatorAlignment is set to StepIndicatorAlignment.left by default if not configured
          stepIndicatorAlignment:
              _appPreferences.getAppLanguage() == LanguageType.ARABIC
                  ? StepIndicatorAlignment.right
                  : StepIndicatorAlignment.left,
          // dottedLine is set to false by default if not configured
          dottedLine: false,
          currentStep: _index,
          onStepCancel: () {
            if (_index > 0) {
              setState(() {
                _index -= 1;
              });
            }
          },
          onStepContinue: () {
            Navigator.pushNamed(context, Routes.locationTrackingPage,
                arguments: NavigationTrackingArguments(widget.tripModel));
            if (_index >= 0 && _index < 3) {
              setState(() {
                _index += 1;
              });
            } else {
              setState(() {
                _index = 0;
              });
            }
          },
          onStepTapped: (int index) {
            setState(() {
              _index = index;
            });
          },
          steps: <CustomStep>[
            CustomStep(
                isActive: _index == 0,
                title: Text(
                  AppStrings.startTripNowAndMoveToPickupLocation.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ColorManager.headersTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.s14),
                ),
                content: Container(
                  child: Text(
                      '${AppStrings.estimatedTimeToArrivePickupLocationIs.tr()}'),
                ),
                continueButtonLabel: AppStrings.tripStartedMoveNow.tr(),
                cancelButtonLabel: ''),
            CustomStep(
                isActive: _index == 1,
                title: Text(
                  AppStrings.tripStartedMoveNow.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ColorManager.headersTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.s14),
                ),
                content: Container(
                  child: Text(
                    '${AppStrings.estimatedTimeToArrivePickupLocationIs.tr()} 15 ${AppStrings.minute.tr()}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColorManager.grey1,
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.s12),
                  ),
                ),
                continueButtonLabel: AppStrings.navigationToPickupLocation.tr(),
                cancelButtonLabel: ''),
            CustomStep(
                isActive: _index == 2,
                title: Text(
                  AppStrings.youArrivedPickupLocation.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ColorManager.headersTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.s14),
                ),
                content: Container(
                  child: Text(
                    '${AppStrings.pleaseShipGoodsAndMoveToDestinationLocation.tr()} 15 ${AppStrings.minute.tr()}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColorManager.grey1,
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.s12),
                  ),
                ),
                continueButtonLabel: AppStrings.tripStartedMoveNow.tr(),
                cancelButtonLabel: ''),
            CustomStep(
                isActive: _index == 3,
                title: Text(
                  AppStrings.youArrivedDestinationLocation.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ColorManager.headersTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.s14),
                ),
                content: Container(
                  child: Text(
                    '${AppStrings.pleaseLeaveGoodsAndCloseTheTrip.tr()}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColorManager.grey1,
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.s12),
                  ),
                ),
                continueButtonLabel: AppStrings.cancel.tr(),
                cancelButtonLabel: ''),
          ],
        ),
      ),
    );
  }
}

class TripExecutionArguments {
  TripModel tripModel;

  TripExecutionArguments(this.tripModel);
}
