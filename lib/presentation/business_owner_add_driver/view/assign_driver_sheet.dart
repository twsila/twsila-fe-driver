import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_for_you/app/app_prefs.dart';
import 'package:taxi_for_you/domain/model/requested_drivers_response.dart';
import 'package:taxi_for_you/presentation/business_owner_cars_and_drivers/bloc/bo_drivers_cars_bloc.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_input_field.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../app/di.dart';
import '../../../domain/model/driver_model.dart';
import '../../../utils/dialogs/custom_dialog.dart';
import '../../../utils/resources/assets_manager.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../common/widgets/custom_card.dart';
import '../../common/widgets/custom_text_button.dart';

class AssignDriverBottomSheetView extends StatefulWidget {
  int tripId;

  AssignDriverBottomSheetView({required this.tripId});

  @override
  State<AssignDriverBottomSheetView> createState() =>
      _AssignDriverBottomSheetViewState();
}

class _AssignDriverBottomSheetViewState
    extends State<AssignDriverBottomSheetView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _displayLoadingIndicator = false;
  List<RequestedDriversResponse> driversList = [];
  Driver? selectedDriver;
  AppPreferences appPreferences = instance();

  @override
  void initState() {
    BlocProvider.of<BoDriversCarsBloc>(context).add(GetDriversAndCars());
    super.initState();
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
    return BlocConsumer<BoDriversCarsBloc, BoDriversCarsState>(
      listener: (context, state) {
        if (state is BoDriversCarsLoading) {
          startLoading();
        } else {
          stopLoading();
        }
        if (state is BoDriversCarsSuccess) {
          driversList = state.driversList;
        }

        if (state is AssignDriversSuccess) {
          CustomDialog(context).showSuccessDialog(
              '', '', AppStrings.sendingRequestDone.tr(), onBtnPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          });
        }

        if (state is AssignDriverFail) {
          CustomDialog(context).showErrorDialog('', '', state.message);
        }
      },
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.p8),
          height: MediaQuery.of(context).size.height *
              0.7, //to control height of bottom sheet
          child: Stack(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: AppSize.s14,
                ),
                Text(
                  AppStrings.assignDriver.tr(),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: FontSize.s16,
                      color: ColorManager.secondaryColor),
                ),
                SizedBox(
                  height: AppSize.s25,
                ),
                Expanded(
                    child: _displayLoadingIndicator
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : driversList.isNotEmpty
                            ? ListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount: driversList.length,
                                itemBuilder: (context, i) {
                                  return CustomCard(
                                    onClick: () {
                                      BlocProvider.of<BoDriversCarsBloc>(
                                              context)
                                          .add(assignDriverForTrip(
                                              appPreferences
                                                  .getCachedDriver()!
                                                  .id!,
                                              driversList[i].id!,
                                              widget.tripId));
                                    },
                                    bodyWidget: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${driversList[i].driver.carModel.carManufacturerId.carManufacturer} / ${driversList[i].driver.carModel.modelName}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: FontSize.s18,
                                                      color: ColorManager
                                                          .secondaryColor),
                                            ),
                                            Text(
                                              "${driversList[i].driver.firstName} ${driversList[i].driver.lastName}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: FontSize.s18,
                                                      color: ColorManager
                                                          .secondaryColor),
                                            ),
                                            Text(
                                              "${driversList[i].driver.mobile}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: FontSize.s16,
                                                      color: ColorManager
                                                          .primaryPurple),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.all(AppPadding.p8),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color:
                                                      ColorManager.lightGrey)),
                                          height: AppSize.s120,
                                          width: AppSize.s90,
                                          child: driversList[i]
                                                      .driver
                                                      .images[0]
                                                      .imageUrl ==
                                                  null
                                              ? Image.asset(
                                                  ImageAssets.appBarLogo)
                                              : FadeInImage.assetNetwork(
                                                  placeholder:
                                                      ImageAssets.appBarLogo,
                                                  image: driversList[i]
                                                      .driver
                                                      .images[0]
                                                      .imageUrl!),
                                        )
                                      ],
                                    ),
                                  );
                                })
                            : Center(
                                child: Text(
                                AppStrings.noAddedDrivers.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                        fontWeight: FontWeight.normal,
                                        fontSize: FontSize.s16,
                                        color: ColorManager.error),
                              ))),
              ],
            ),
          ]),
        );
      },
    );
  }
}
