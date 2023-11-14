import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/presentation/business_owner_add_driver/view/assign_driver_sheet.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_network_image_widget.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_input_field.dart';
import 'package:taxi_for_you/presentation/google_maps/model/location_model.dart';
import 'package:taxi_for_you/presentation/google_maps/view/google_maps_widget.dart';
import 'package:taxi_for_you/presentation/trip_details/widgets/dotted_seperator.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';
import 'package:taxi_for_you/utils/dialogs/toast_handler.dart';
import 'package:taxi_for_you/utils/resources/constants_manager.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/trip_details_model.dart';
import '../../../utils/ext/enums.dart';
import '../../../utils/resources/assets_manager.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../business_owner_add_driver/view/add_driver_sheet.dart';
import '../../common/widgets/custom_bottom_sheet.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/custom_text_button.dart';
import '../../common/widgets/page_builder.dart';
import '../bloc/trip_details_bloc.dart';
import 'more_details_widget/more_details_widget.dart';

class TripDetailsView extends StatefulWidget {
  final TripDetailsModel tripModel;

  TripDetailsView({required this.tripModel});

  @override
  State<TripDetailsView> createState() => _TripDetailsViewState();
}

class _TripDetailsViewState extends State<TripDetailsView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  bool _displayLoadingIndicator = false;
  bool _enableSendOffer = false;
  double _driverOffer = 0.0;
  late DriverBaseModel driverBaseModel;
  bool showBusinessOwnerOfferActionsView = false;
  Driver? assignedDriverToTrip;

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
    print(widget.tripModel);
    driverBaseModel = _appPreferences.getCachedDriver()!;
    super.initState();
  }

  bottomSheetForAssignDriver(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return AssignDriverBottomSheetView(
            tripId: widget.tripModel.tripDetails.tripId!,
            onAssignDriver: (assignedDriver) {
              setState(() {
                if (assignedDriver != null) {
                  assignedDriverToTrip = assignedDriver;
                  this.showBusinessOwnerOfferActionsView = true;
                }
              });
            },
          );
        });
  }

  void _showTripRouteBottomSheet(
      LocationModel pickup, LocationModel destination) {
    CustomBottomSheet.heightWrappedBottomSheet(
      context: context,
      draggableScrollableSheet: false,
      enableDrag: false,
      items: [
        Container(
          height: MediaQuery.of(context).size.height / 2,
          child: GoogleMapsWidget(
            sourceLocation: pickup,
            destinationLocation: destination,
          ),
        ),
        CustomTextButton(
          text: AppStrings.back.tr(),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  void _showAnotherOfferBottomSheet() {
    CustomBottomSheet.heightWrappedBottomSheet(
      context: context,
      items: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextInputField(
                labelText: AppStrings.sendOfferWithPrice.tr(),
                showLabelText: true,
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppStrings.ryalSuadi.tr(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ColorManager.black,
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.s16),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _enableSendOffer = true;
                    _driverOffer = double.parse(value);
                  } else {
                    _enableSendOffer = false;
                  }
                },
              ),
              CustomTextButton(
                isWaitToEnable: false,
                text: AppStrings.sendOffer.tr(),
                onPressed: () {
                  if (_enableSendOffer) {
                    CustomDialog(context).showCupertinoDialog(
                        AppStrings.confirmSendOffer.tr(),
                        AppStrings.areYouSureToSendNewOffer.tr(),
                        AppStrings.confirm.tr(),
                        AppStrings.cancel.tr(),
                        ColorManager.primary, () {
                      BlocProvider.of<TripDetailsBloc>(context).add(AddOffer(
                          _appPreferences.getCachedDriver()!.id!,
                          widget.tripModel.tripDetails.tripId!,
                          _driverOffer,
                          _appPreferences
                              .getCachedDriver()!
                              .captainType
                              .toString(),
                          driverId: assignedDriverToTrip != null
                              ? assignedDriverToTrip!.id
                              : null));
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }, () {
                      Navigator.pop(context);
                    });
                  } else {
                    ToastHandler(context)
                        .showToast('enter valid price', Toast.LENGTH_SHORT);
                  }
                },
              )
            ],
          ),
        ),
      ],
    );
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
    return BlocConsumer<TripDetailsBloc, TripDetailsState>(
      listener: (context, state) {
        if (state is TripDetailsLoading) {
          startLoading();
        } else {
          stopLoading();
        }
        if (state is TripDetailsSuccess) {}

        if (state is NewOfferSentSuccess) {
          Navigator.pop(context);
        }

        if (state is OfferAcceptedSuccess) {
          CustomDialog(context).showSuccessDialog('', '', state.message,
              onBtnPressed: () {
            Navigator.pop(context);
          });
        }
        if (state is TripDetailsFail) {
          CustomDialog(context).showErrorDialog('', '', state.message,
              onBtnPressed: () {
            Navigator.pop(context);
          });
        }
      },
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.all(AppMargin.m12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _headerWidget(),
                _fromToWidget(),
                SizedBox(
                  height: AppSize.s20,
                ),
                _showTripRouteWidget(),
                SizedBox(
                  height: AppSize.s20,
                ),
                Divider(
                  color: ColorManager.lineColor,
                  thickness: 1.0,
                ),
                SizedBox(
                  height: AppSize.s20,
                ),
                _customerInfoWidget(),
                SizedBox(
                  height: AppSize.s20,
                ),
                MoreDetailsWidget(
                  transportationBaseModel: widget.tripModel.tripDetails,
                ),
                Container(
                  height: AppSize.s30,
                ),
                Center(child: _actionWithTripWidget(widget.tripModel)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _BoActionWithTripWidget(TripDetailsModel trip) {
    return (trip.tripDetails.acceptedOffer == null &&
            (trip.tripDetails.offers == null ||
                (trip.tripDetails.offers != null &&
                    trip.tripDetails.offers!.length >= 0)))
        ? this.showBusinessOwnerOfferActionsView
            ? _showBoTripActions()
            : CustomTextButton(
                text: AppStrings.assignDriver.tr(),
                isWaitToEnable: false,
                onPressed: () {
                  bottomSheetForAssignDriver(context);
                },
              )
        : _AcceptanceStatusWidget(trip);
  }

  Widget _showBoTripActions() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _handleAssignedDriverDetails(assignedDriverToTrip!),
          CustomTextButton(
            text:
                "${AppStrings.acceptRequestWith.tr()} ${widget.tripModel.tripDetails.clientOffer} (${AppStrings.rs.tr()})",
            onPressed: () {
              BlocProvider.of<TripDetailsBloc>(context).add(AcceptOffer(
                  _appPreferences.getCachedDriver()!.id!,
                  widget.tripModel.tripDetails.tripId!,
                  _appPreferences.getCachedDriver()!.captainType.toString(),
                  driverId: assignedDriverToTrip!.id));
            },
          ),
          CustomTextButton(
            isWaitToEnable: false,
            backgroundColor: ColorManager.white,
            textColor: ColorManager.headersTextColor,
            borderColor: ColorManager.purpleMainTextColor,
            text: AppStrings.sendAnotherPrice.tr(),
            onPressed: () {
              _showAnotherOfferBottomSheet();
            },
          ),
        ],
      ),
    );
  }

  Widget _handleAssignedDriverDetails(Driver driver) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              "${driver.carManufacturerType.carManufacturer} / ${driver.carModel.modelName}",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ColorManager.headersTextColor,
                  fontSize: FontSize.s16,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "${driver.firstName} ${driver.lastName} ",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ColorManager.headersTextColor,
                  fontSize: FontSize.s16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Container(
            width: 70,
            height: 50,
            child: CustomNetworkImageWidget(
                imageUrl: driver.images[0].imageUrl ?? ""))
      ],
    );
  }

  Widget _AcceptanceStatusWidget(TripDetailsModel trip) {
    return ((trip.tripDetails.offers!.isNotEmpty) &&
            trip.tripDetails.offers![0].acceptanceStatus ==
                AcceptanceType.PROPOSED.name)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: ColorManager.purpleMainTextColor,
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Text(
                      "${AppStrings.offerHasBeenSent.tr()} (${trip.tripDetails.offers![0].driverOffer} ${AppStrings.ryalSuadi.tr()})",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ColorManager.purpleMainTextColor,
                          fontSize: FontSize.s16,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              Text("${AppStrings.waitingClientReplay.tr()}",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ColorManager.accentTextColor,
                      fontSize: FontSize.s14,
                      fontWeight: FontWeight.bold))
            ],
          )
        : ((trip.tripDetails.offers!.isNotEmpty) &&
                trip.tripDetails.offers![0].acceptanceStatus ==
                    AcceptanceType.EXPIRED.name)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.error_outlined,
                        color: ColorManager.error,
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                          "${AppStrings.clientRejectYourOffer.tr()} (${trip.tripDetails.offers![0].driverOffer} ${AppStrings.ryalSuadi.tr()})",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: ColorManager.error,
                                  fontSize: FontSize.s16,
                                  fontWeight: FontWeight.bold)),
                    ],
                  ),
                  CustomTextButton(
                    isWaitToEnable: false,
                    backgroundColor: ColorManager.white,
                    textColor: ColorManager.headersTextColor,
                    borderColor: ColorManager.purpleMainTextColor,
                    text: AppStrings.sendAnotherPrice.tr(),
                    onPressed: () {
                      _showAnotherOfferBottomSheet();
                    },
                  ),
                ],
              )
            : _acceptOrSuggestNewOfferTrip(trip);
  }

  Widget _acceptOrSuggestNewOfferTrip(TripDetailsModel trip) {
    return ((driverBaseModel.captainType ==
                RegistrationConstants.businessOwner) &&
            (trip.tripDetails.offers != null &&
                trip.tripDetails.offers!.isEmpty))
        ? _BoActionWithTripWidget(trip)
        : Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextButton(
                  text:
                      "${AppStrings.acceptRequestWith.tr()} ${widget.tripModel.tripDetails.clientOffer} (${AppStrings.rs.tr()})",
                  onPressed: () {
                    BlocProvider.of<TripDetailsBloc>(context).add(AcceptOffer(
                        _appPreferences.getCachedDriver()!.id!,
                        widget.tripModel.tripDetails.tripId!,
                        _appPreferences
                            .getCachedDriver()!
                            .captainType
                            .toString()));
                  },
                ),
                CustomTextButton(
                  isWaitToEnable: false,
                  backgroundColor: ColorManager.white,
                  textColor: ColorManager.headersTextColor,
                  borderColor: ColorManager.purpleMainTextColor,
                  text: AppStrings.sendAnotherPrice.tr(),
                  onPressed: () {
                    _showAnotherOfferBottomSheet();
                  },
                ),
              ],
            ),
          );
  }

  Widget _actionWithTripWidget(TripDetailsModel trip) {
    return (trip.tripDetails.acceptedOffer == null &&
                trip.tripDetails.offers == null ||
            (trip.tripDetails.offers != null &&
                trip.tripDetails.offers!.length >= 0))
        ? _AcceptanceStatusWidget(trip)
        : Container();
  }

  Widget _customerInfoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _IconTextDataWidget(
            "${AppStrings.from.tr()} ${widget.tripModel.tripDetails.passenger!.firstName} ${widget.tripModel.tripDetails.passenger!.lastName}",
            ImageAssets.tripDetailsProfileIc),
        SizedBox(
          height: AppSize.s8,
        ),
        _IconTextDataWidget(
            "${AppStrings.withBudget.tr()} ${widget.tripModel.tripDetails.clientOffer.toString()}",
            ImageAssets.tripDetailsVisaIcon),
        SizedBox(
          height: AppSize.s8,
        ),
        _IconTextDataWidget(
            widget.tripModel.tripDetails.date != null
                ? "${AppStrings.scheduled.tr()} ${widget.tripModel.tripDetails.date}"
                : "${AppStrings.asSoonAsPossible.tr()}",
            ImageAssets.tripDetailsAsapIcon),
      ],
    );
  }

  Widget _IconTextDataWidget(String data, String iconPath) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          iconPath,
          width: AppSize.s18,
          height: AppSize.s18,
        ),
        SizedBox(
          width: AppSize.s14,
        ),
        Text(
          data,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ColorManager.headersTextColor,
              fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _headerWidget() {
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
        Image.asset(
          getIconName(widget.tripModel.tripDetails.tripType!),
          width: AppSize.s50,
        ),
      ],
    );
  }

  Widget _fromToWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          children: [
            SizedBox(
              height: AppSize.s8,
            ),
            SvgPicture.asset(ImageAssets.locationPinTripDetailsIc),
            Container(
              height: AppSize.s36,
              child: DashLineView(
                fillRate: .88,
                direction: Axis.vertical,
              ),
            ),
            SvgPicture.asset(ImageAssets.locationPinTripDetailsIc)
          ],
        ),
        SizedBox(
          width: AppSize.s10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${AppStrings.from.tr()} ${widget.tripModel.tripDetails.pickupLocation.locationName}",
                overflow: TextOverflow.clip,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ColorManager.headersTextColor,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: AppSize.s18,
              ),
              Text(
                "${AppStrings.to.tr()} ${widget.tripModel.tripDetails.destinationLocation.locationName}",
                overflow: TextOverflow.clip,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ColorManager.headersTextColor,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _showTripRouteWidget() {
    return GestureDetector(
      onTap: () {
        _showTripRouteBottomSheet(
            LocationModel(
                locationName:
                    widget.tripModel.tripDetails.pickupLocation.locationName!,
                latitude: widget.tripModel.tripDetails.pickupLocation.latitude!,
                longitude:
                    widget.tripModel.tripDetails.pickupLocation.longitude!),
            LocationModel(
                locationName: widget
                    .tripModel.tripDetails.destinationLocation.locationName!,
                latitude:
                    widget.tripModel.tripDetails.destinationLocation.latitude!,
                longitude: widget
                    .tripModel.tripDetails.destinationLocation.longitude!));
      },
      child: FittedBox(
        child: Container(
          color: ColorManager.purpleFade,
          padding: EdgeInsets.symmetric(
              horizontal: AppPadding.p8, vertical: AppPadding.p4),
          child: Center(
            child: Row(
              children: [
                Text(
                  "${AppStrings.showTripRoute.tr()}",
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ColorManager.purpleMainTextColor,
                      fontSize: FontSize.s14,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: AppSize.s6,
                ),
                SvgPicture.asset(
                  ImageAssets.mapButtonIcon,
                  width: AppSize.s12,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TripDetailsArguments {
  TripDetailsModel tripModel;

  TripDetailsArguments({required this.tripModel});
}
