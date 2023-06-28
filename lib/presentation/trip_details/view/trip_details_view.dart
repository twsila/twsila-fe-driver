import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_input_field.dart';
import 'package:taxi_for_you/presentation/google_maps/model/location_model.dart';
import 'package:taxi_for_you/presentation/google_maps/view/google_maps_widget.dart';
import 'package:taxi_for_you/presentation/trip_details/widgets/dotted_seperator.dart';
import 'package:taxi_for_you/utils/dialogs/toast_handler.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../domain/model/trip_model.dart';
import '../../../utils/resources/assets_manager.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../common/widgets/custom_bottom_sheet.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/custom_text_button.dart';
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
  bool _enableSendOffer = false;

  void _showTripRouteBottomSheet(LocationModel pickup,
      LocationModel destination) {
    CustomBottomSheet.heightWrappedBottomSheet(
      context: context,
      draggableScrollableSheet: false,
      enableDrag: false,
      items: [
        Container(
          height: MediaQuery
              .of(context)
              .size
              .height / 2,
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
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                        color: ColorManager.black, fontSize: FontSize.s16),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _enableSendOffer = true;
                  } else {
                    _enableSendOffer = false;
                  }
                },
              ),
              CustomTextButton(
                isWaitToEnable: false,
                text: AppStrings.sendOffer.tr(),
                onPressed: () {
                  if (_enableSendOffer)
                    Navigator.pop(context);
                  else
                    ToastHandler(context).showToast(
                        'enter valid price', Toast.LENGTH_SHORT);
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
    return Container(
      margin: EdgeInsets.all(AppMargin.m12),
      child: SingleChildScrollView(
        child: Expanded(
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
              Divider(
                color: ColorManager.lineColor,
                thickness: 1.0,
              ),
              SizedBox(
                height: AppSize.s14,
              ),
              _thingsToDeliver(),
              Container(
                height: AppSize.s60,
              ),
              _actionWithTripWidget(widget.tripModel.tripStatus),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionWithTripWidget(TripStatus tripStatus) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomTextButton(
            text: AppStrings.acceptRequestWith.tr(),
            onPressed: () {},
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

  Widget _thingsToDeliver() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.goodsToDeliver.tr(),
            style: Theme
                .of(context)
                .textTheme
                .bodySmall
                ?.copyWith(
                color: ColorManager.purpleMainTextColor,
                fontSize: FontSize.s14,
                fontWeight: FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _customerInfoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _IconTextDataWidget(
            "${AppStrings.from.tr()} ${widget.tripModel.passenger
                .firstName} ${widget.tripModel.passenger.lastName}",
            ImageAssets.tripDetailsProfileIc),
        SizedBox(
          height: AppSize.s8,
        ),
        _IconTextDataWidget(
            "${AppStrings.withBudget.tr()} ${widget.tripModel.clientOffer
                .toString()}",
            ImageAssets.tripDetailsVisaIcon),
        SizedBox(
          height: AppSize.s8,
        ),
        _IconTextDataWidget(
            widget.tripModel.date != null
                ? "${AppStrings.scheduled.tr()} ${widget.tripModel.date}"
                : "${AppStrings.from.tr()}",
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
          style: Theme
              .of(context)
              .textTheme
              .bodySmall
              ?.copyWith(
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${AppStrings.request.tr()} ${widget.tripModel.tripType}",
              style: Theme
                  .of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                  color: ColorManager.headersTextColor,
                  fontSize: FontSize.s24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Image.asset(
          ImageAssets.truckX4Ic,
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
                "${AppStrings.from.tr()} ${widget.tripModel.pickupLocation
                    .locationName}",
                overflow: TextOverflow.clip,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                    color: ColorManager.headersTextColor,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: AppSize.s18,
              ),
              Text(
                "${AppStrings.to.tr()} ${widget.tripModel.destination
                    .locationName}",
                overflow: TextOverflow.clip,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
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
                locationName: widget.tripModel.pickupLocation.locationName,
                latitude: widget.tripModel.pickupLocation.latitude,
                longitude: widget.tripModel.pickupLocation.longitude),
            LocationModel(
                locationName: widget.tripModel.destination.locationName,
                latitude: widget.tripModel.destination.latitude,
                longitude: widget.tripModel.destination.longitude));
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
                  style: Theme
                      .of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
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
  TripModel tripModel;

  TripDetailsArguments({required this.tripModel});
}
