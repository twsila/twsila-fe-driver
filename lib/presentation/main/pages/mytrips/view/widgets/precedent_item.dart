import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/rate_passenger/view/rate_passenger_view.dart';
import 'package:taxi_for_you/utils/ext/date_ext.dart';

import '../../../../../../domain/model/trip_details_model.dart';
import '../../../../../../utils/ext/enums.dart';
import '../../../../../../utils/resources/assets_manager.dart';
import '../../../../../../utils/resources/color_manager.dart';
import '../../../../../../utils/resources/font_manager.dart';
import '../../../../../../utils/resources/routes_manager.dart';
import '../../../../../../utils/resources/strings_manager.dart';
import '../../../../../../utils/resources/values_manager.dart';
import '../../../../../common/widgets/custom_card.dart';
import '../../../../../trip_execution/view/trip_execution_view.dart';
import '../../bloc/my_trips_bloc.dart';

class PrecedentItemView extends StatefulWidget {
  TripDetailsModel trip;
  String currentTripModelId;
  String date;

  PrecedentItemView(
      {required this.trip,
      required this.currentTripModelId,
      required this.date});

  @override
  State<PrecedentItemView> createState() => _PrecedentItemViewState();
}

class _PrecedentItemViewState extends State<PrecedentItemView> {
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onClick: () {
        Navigator.pushNamed(context, Routes.tripExecution,
                arguments: TripExecutionArguments(widget.trip))
            .then((value) => BlocProvider.of<MyTripsBloc>(context)
                .add(GetTripsTripModuleId(widget.currentTripModelId)));
        // Navigator.pushNamed(context, Routes.tripDetails,
        //     arguments: TripDetailsArguments(tripModel: trip));
      },
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
                  child: Padding(
                    padding: const EdgeInsets.all(AppPadding.p4),
                    child: Row(
                      children: [
                        Image.asset(
                          widget.trip.tripDetails.date != null &&
                                  widget.trip.tripDetails.date != ""
                              ? ImageAssets.scheduledTripIc
                              : ImageAssets.asSoonAsPossibleTripIc,
                          width: AppSize.s14,
                        ),
                        SizedBox(
                          width: AppSize.s4,
                        ),
                        Text(
                          widget.date != null && widget.date != ""
                              ? AppStrings.scheduled.tr() + " : ${widget.date}"
                              : AppStrings.asSoonAsPossible.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: ColorManager.headersTextColor,
                                  fontSize: FontSize.s12,
                                  fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                // SvgPicture.asset(ImageAssets.truckIc,),
                Image.asset(
                  getIconName(widget.trip.tripDetails.tripType!),
                  width: AppSize.s40,
                ),
              ],
            ),
            SizedBox(
              height: AppSize.s4,
            ),
            Text(
              getTitle(widget.trip.tripDetails.tripType!),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorManager.headersTextColor,
                  fontSize: FontSize.s14,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: AppSize.s4,
            ),
            Text(
              "${widget.trip.tripDetails.pickupLocation.locationName} - ${widget.trip.tripDetails.destinationLocation.locationName}",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorManager.headersTextColor,
                  fontSize: FontSize.s14,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: AppSize.s4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      ImageAssets.tripDetailsProfileIc,
                      width: 18,
                      height: 19,
                    ),
                    SizedBox(
                      width: 9,
                    ),
                    Text(
                      "${widget.trip.tripDetails.passenger!.firstName} ${widget.trip.tripDetails.passenger!.lastName}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ColorManager.headersTextColor,
                            fontSize: FontSize.s14,
                          ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Image.asset(
                      ImageAssets.tripDetailsVisaIcon,
                      width: 18,
                      height: 19,
                    ),
                    SizedBox(
                      width: 9,
                    ),
                    Text(
                      "${widget.trip.tripDetails.paymentValue} ${AppStrings.ryalSuadi.tr()} ",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ColorManager.headersTextColor,
                            fontSize: FontSize.s14,
                          ),
                    ),
                  ],
                )
              ],
            ),
            Divider(
              color: ColorManager.dividerColor,
              thickness: 1,
            ),
            SizedBox(
              height: AppSize.s4,
            ),
            Text(
              widget.trip.tripDetails.completionDate != null
                  ? "${AppStrings.tripCompletedInDay.tr()}"
                      "${widget.trip.tripDetails.completionDate ?? "-"}"
                  : '${AppStrings.tripCompletedInDay.tr()} -',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorManager.headersTextColor,
                  fontSize: FontSize.s14,
                  fontWeight: FontWeight.bold),
            ),
            widget.trip.tripDetails.passengerRating != null
                ? Row(
                    children: [
                      Text(
                        "${AppStrings.passengerWasRatedBy.tr()}: ${widget.trip.tripDetails.passengerRating}",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ColorManager.headersTextColor,
                            fontSize: FontSize.s14,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.star_rate,
                        color: ColorManager.supportTextColor,
                      )
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      CustomTextButton(
                        text: AppStrings.ratePassenger.tr(),
                        isWaitToEnable: false,
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.ratePassenger,
                              arguments: RatePassengerArguments(widget.trip));
                        },
                        margin: 2,
                        backgroundColor: ColorManager.secondaryColor,
                        textColor: ColorManager.white,
                        icon: Icon(
                          Icons.star_border_purple500_sharp,
                          color: ColorManager.white,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
