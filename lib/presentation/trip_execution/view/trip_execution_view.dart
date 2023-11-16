import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:im_stepper/stepper.dart';
import 'package:taxi_for_you/domain/model/trip_model.dart';
import 'package:taxi_for_you/domain/model/trip_status_step_model.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_stepper.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/trip_execution/helper/location_helper.dart';
import 'package:taxi_for_you/utils/dialogs/toast_handler.dart';
import 'package:taxi_for_you/utils/ext/enums.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/langauge_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/app_prefs.dart';
import '../../../app/constants.dart';
import '../../../app/di.dart';
import '../../../domain/model/trip_details_model.dart';
import '../../../utils/resources/assets_manager.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/routes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/page_builder.dart';
import '../../google_maps/model/location_model.dart';
import '../../google_maps/model/maps_repo.dart';
import '../../trip_details/view/more_details_widget/more_details_widget.dart';
import '../bloc/trip_execution_bloc.dart';
import 'navigation_tracking_view.dart';

class TripExecutionView extends StatefulWidget {
  TripDetailsModel tripModel;

  TripExecutionView({required this.tripModel});

  @override
  State<TripExecutionView> createState() => _TripExecutionViewState();
}

class _TripExecutionViewState extends State<TripExecutionView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  bool _displayLoadingIndicator = false;
  MapsRepo mapsRepo = MapsRepo();
  late Timer _timer;
  late double distanceBetweenCurrentAndSource;
  LocationModel? currentLocation;
  bool isUserArrivedSource = false;
  TripStatusStepModel tripStatusStepModel =
      TripStatusStepModel(0, TripStatus.WAIT_FOR_TAKEOFF.name);

  // REQUIRED: USED TO CONTROL THE STEPPER.
  int activeStep = 0; // Initial step set to 0.

  // OPTIONAL: can be set directly.
  int dotCount = 5;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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

  void getCurrentLocation() async {
    currentLocation = await mapsRepo.getUserCurrentLocation();
    distanceBetweenCurrentAndSource = LocationHelper()
        .distanceBetweenTwoLocationInMeters(
            lat1: currentLocation!.latitude,
            long1: currentLocation!.longitude,
            lat2: widget.tripModel.tripDetails.pickupLocation.latitude!,
            long2: widget.tripModel.tripDetails.pickupLocation.longitude!);

    if (distanceBetweenCurrentAndSource <= 100) {
      ToastHandler(context).showToast("arrived pickup location", null);
      isUserArrivedSource = true;
      BlocProvider.of<TripExecutionBloc>(context).add(
          changeTripStatus(widget.tripModel, TripStatus.TAKEOFF.name, true));
    }
  }

  @override
  void initState() {
    BlocProvider.of<TripExecutionBloc>(context)
        .add(getTripStatusForStepper(tripDetailsModel: widget.tripModel));
    _timer = Timer.periodic(
        Duration(seconds: Constants.refreshCurrentLocationSeconds),
        (Timer t) async {});
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

        if (state is TripStatusChangedSuccess) {
          if (state.isLastStep) {
            Navigator.pop(context);
          } else if (state.openMapWidget) {
            Navigator.pushNamed(context, Routes.locationTrackingPage,
                arguments: NavigationTrackingArguments(widget.tripModel));
            this.tripStatusStepModel.stepIndex++;
          } else {
            this.tripStatusStepModel.stepIndex++;
          }
        }
        if (state is TripCurrentStepSuccess) {
          this.tripStatusStepModel = state.tripStatusStepModel;
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Container(
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
                TripStepperWidget(tripStatusStepModel),
                Divider(
                  color: ColorManager.lineColor,
                  thickness: 1.0,
                ),
                TripDetailsWidget(),
                MoreDetailsWidget(
                  transportationBaseModel: widget.tripModel.tripDetails,
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
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
                "${widget.tripModel.tripDetails.passenger!.firstName} ${widget.tripModel.tripDetails.passenger!.lastName}"),
            GestureDetector(
              onTap: () {
                launchUrl(Uri(
                    scheme: 'tel',
                    path:
                        '${widget.tripModel.tripDetails.passenger!.mobile.toString()}'));
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
                "${widget.tripModel.tripDetails.clientOffer} ${AppStrings.ryalSuadi.tr()}"),
            detailsItem(
                widget.tripModel.tripDetails.date != null
                    ? ImageAssets.scheduledTripIc
                    : ImageAssets.tripDetailsAsapIcon,
                AppStrings.type.tr(),
                widget.tripModel.tripDetails.date != null
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
        Expanded(
          child: Text(
            "${getTitle(widget.tripModel.tripDetails.tripType!)}",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: ColorManager.headersTextColor,
                fontSize: FontSize.s24,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
          width: AppSize.s16,
        ),
        Image.asset(
          getIconName(widget.tripModel.tripDetails.tripType!),
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
        Expanded(
          child: Text(
            "${AppStrings.from.tr()} ${widget.tripModel.tripDetails.pickupLocation.locationName} - ${widget.tripModel.tripDetails.destinationLocation!.locationName}",
            overflow: TextOverflow.clip,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: ColorManager.headersTextColor,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget TripStepperWidget(TripStatusStepModel tripStatusStepModel) {
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
          currentStep: tripStatusStepModel.stepIndex,
          onStepContinue: () {
            switch (tripStatusStepModel.stepIndex) {
              case 0:
                BlocProvider.of<TripExecutionBloc>(context).add(
                    changeTripStatus(widget.tripModel,
                        TripStatus.WAIT_FOR_TAKEOFF.name, false,
                        openMapWidget: false));
                break;
              case 1:
                BlocProvider.of<TripExecutionBloc>(context).add(
                    changeTripStatus(
                        widget.tripModel, TripStatus.TAKEOFF.name, true,
                        openMapWidget: true));

                break;
              case 2:
                BlocProvider.of<TripExecutionBloc>(context).add(
                    changeTripStatus(
                        widget.tripModel, TripStatus.EXECUTED.name, true,
                        openMapWidget: false));
                break;
              case 3:
                BlocProvider.of<TripExecutionBloc>(context).add(
                    changeTripStatus(
                        widget.tripModel, TripStatus.COMPLETED.name, true,
                        isLastStep: true, openMapWidget: false));
                break;
            }
          },
          onStepTapped: (int index) {},
          steps: <CustomStep>[
            CustomStep(
                isActive: widget.tripModel.tripDetails.date != null
                    ? false
                    : tripStatusStepModel.stepIndex == 0,
                continueIconWidget: Image.asset(ImageAssets.driveIc),
                title: Text(
                  AppStrings.startTripNowAndMoveToPickupLocation.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: widget.tripModel.tripDetails.date != null
                          ? ColorManager.formHintTextColor
                          : ColorManager.headersTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.s14),
                ),
                content: Container(),
                continueButtonLabel: widget.tripModel.tripDetails.date != null
                    ? ''
                    : AppStrings.movedToClient.tr(),
                cancelButtonLabel: ''),
            CustomStep(
                isActive: widget.tripModel.tripDetails.date != null
                    ? false
                    : tripStatusStepModel.stepIndex == 1,
                continueIconWidget: Image.asset(ImageAssets.navigationIc),
                title: Text(
                  AppStrings.tripStartedMoveNow.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: widget.tripModel.tripDetails.date != null
                          ? ColorManager.formHintTextColor
                          : ColorManager.headersTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.s14),
                ),
                content: widget.tripModel.tripDetails.date != null
                    ? Container()
                    : Container(
                        child: Text(
                          '${AppStrings.estimatedTimeToArrivePickupLocationIs.tr()} 15 ${AppStrings.minute.tr()}',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: ColorManager.grey1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: FontSize.s12),
                        ),
                      ),
                continueButtonLabel: widget.tripModel.tripDetails.date != null
                    ? ''
                    : AppStrings.navigationToPickupLocation.tr(),
                cancelButtonLabel: ''),
            CustomStep(
                isActive: widget.tripModel.tripDetails.date != null
                    ? false
                    : tripStatusStepModel.stepIndex == 2,
                continueIconWidget: Image.asset(ImageAssets.driveIc),
                title: Text(
                  AppStrings.youArrivedPickupLocation.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: widget.tripModel.tripDetails.date != null
                          ? ColorManager.formHintTextColor
                          : ColorManager.headersTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.s14),
                ),
                content: widget.tripModel.tripDetails.date != null
                    ? Container()
                    : Container(
                        child: Text(
                          '${AppStrings.pleaseShipGoodsAndMoveToDestinationLocation.tr()}',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: ColorManager.grey1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: FontSize.s12),
                        ),
                      ),
                continueButtonLabel: widget.tripModel.tripDetails.date != null
                    ? ''
                    : AppStrings.tripStartedMoveNow.tr(),
                cancelButtonLabel: ''),
            CustomStep(
                isActive: widget.tripModel.tripDetails.date != null
                    ? false
                    : tripStatusStepModel.stepIndex == 3,
                continueIconWidget: Image.asset(ImageAssets.tripFinishIc),
                continueButtonBGColor: ColorManager.secondaryColor,
                title: Text(
                  AppStrings.youArrivedDestinationLocation.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: widget.tripModel.tripDetails.date != null
                          ? ColorManager.formHintTextColor
                          : ColorManager.headersTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.s14),
                ),
                content: widget.tripModel.tripDetails.date != null
                    ? Container()
                    : Container(
                        child: Text(
                          '${AppStrings.pleaseLeaveGoodsAndCloseTheTrip.tr()}',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: ColorManager.grey1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: FontSize.s12),
                        ),
                      ),
                continueButtonLabel: widget.tripModel.tripDetails.date != null
                    ? ''
                    : AppStrings.cancel.tr(),
                cancelButtonLabel: ''),
          ],
        ),
      ),
    );
  }
}

class TripExecutionArguments {
  TripDetailsModel tripModel;

  TripExecutionArguments(this.tripModel);
}
