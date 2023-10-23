import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:taxi_for_you/domain/model/current_location_model.dart';
import 'package:taxi_for_you/presentation/google_maps/model/maps_repo.dart';

import '../../../../app/constants.dart';
import '../../../../domain/model/location_filter_model.dart';
import '../../../../utils/dialogs/toast_handler.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/font_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../../utils/resources/values_manager.dart';
import '../../../common/widgets/custom_text_button.dart';
import '../../../google_maps/model/location_model.dart';
import '../../../google_maps/view/google_places_field.dart';
import '../../../trip_execution/helper/location_helper.dart';

class CityFilterWidget extends StatefulWidget {
  final Function(Destination pickup, Destination destination,
      CurrentLocationFilter currentLocation) onSelectLocationFilter;

  CityFilterWidget({required this.onSelectLocationFilter});

  @override
  State<CityFilterWidget> createState() => _CityFilterWidgetState();
}

class _CityFilterWidgetState extends State<CityFilterWidget> {
  bool isCitySelected = false;
  bool isCurrentCitySelected = false;

  Prediction? pPickup;
  Prediction? pDestination;

  Destination? pickup;
  Destination? destination;
  CurrentLocationFilter? currentLocationFilter;

  LocationModel? currentLocation;
  MapsRepo mapsRepo = MapsRepo();
  String currentCityName = '';

  final TextEditingController _searchFromController = TextEditingController();
  final TextEditingController _searchToController = TextEditingController();

  setFilterData(Destination pickup, Destination destination) {
    pickup = pickup;
    destination = destination;
  }

  getCurrentLocation() async {
    currentLocation = await mapsRepo.getUserCurrentLocation();
    currentLocationFilter = CurrentLocationFilter(
        currentLocation: CurrentLocation(
            latitude: currentLocation!.latitude,
            longitude: currentLocation!.longitude,
            cityName: ''));
    currentCityName = await LocationHelper().getCityNameByCoordinates(
        currentLocation!.latitude, currentLocation!.longitude);
    currentLocationFilter!.currentLocation.cityName = currentCityName;
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppPadding.p12),
      child: isCitySelected
          ? GestureDetector(
              onTap: () {
                _showSelectCitiesDialog();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.city.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColorManager.titlesTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.s18),
                  ),
                  SizedBox(
                    height: AppSize.s6,
                  ),
                  Container(
                    padding: EdgeInsets.all(AppPadding.p12),
                    decoration: BoxDecoration(
                        border: Border.all(color: ColorManager.grey),
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                      child: Text(
                        '${AppStrings.from.tr()} ${pickup!.cityName} - '
                        '${AppStrings.to.tr()} ${destination!.cityName}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: ColorManager.titlesTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: FontSize.s16),
                      ),
                    ),
                  )
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.city.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ColorManager.titlesTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.s16),
                ),
                Center(
                  child: CustomTextButton(
                    onPressed: () {
                      _showSelectCitiesDialog();
                    },
                    text: AppStrings.selectFromHereHint.tr(),
                    isWaitToEnable: false,
                    backgroundColor: ColorManager.secondaryColor,
                    fontSize: FontSize.s10,
                    width: 250,
                    height: 40,
                  ),
                )
              ],
            ),
    );
  }

  void _showSelectCitiesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            // You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
              return _dialogContentWidget(setState);
            },
          ),
        );
      },
    ).then((value) => (setState(() {})));
  }

  Widget _dialogContentWidget(StateSetter setState) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 1.7,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${AppStrings.from.tr()}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ColorManager.titlesTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.s16),
              ),
              SizedBox(
                height: 10,
              ),
              GoogleMapsPlacesField(
                enabled: !isCurrentCitySelected,
                controller: _searchFromController,
                focusNode: FocusNode(debugLabel: 'source_node'),
                hintText: "${AppStrings.pleaseEnterCity.tr()}",
                predictionCallback: (prediction) {
                  if (prediction != null) {
                    _searchFromController.text =
                        LocationHelper().getCityName(prediction);
                    pPickup = prediction;
                    pickup = Destination(
                        latitude: double.parse(prediction.lat!),
                        longitude: double.parse(prediction.lng!),
                        cityName: _searchFromController.text);
                  } else {}
                },
              ),
              Text(
                '${AppStrings.to.tr()}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ColorManager.titlesTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.s16),
              ),
              SizedBox(
                height: 10,
              ),
              GoogleMapsPlacesField(
                enabled: !isCurrentCitySelected,
                controller: _searchToController,
                focusNode: FocusNode(debugLabel: 'source_node'),
                hintText: "${AppStrings.pleaseEnterCity.tr()}",
                predictionCallback: (prediction) {
                  if (prediction != null) {
                    _searchToController.text =
                        LocationHelper().getCityName(prediction);
                    pDestination = prediction;
                    destination = Destination(
                        latitude: double.parse(prediction.lat!),
                        longitude: double.parse(prediction.lng!),
                        cityName: _searchToController.text);
                  } else {}
                },
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Checkbox(
                    side: BorderSide(
                        color: ColorManager.secondaryColor,
                        width: AppSize.s1_5),
                    activeColor: ColorManager.secondaryColor,
                    focusColor: ColorManager.primary,
                    checkColor: ColorManager.white,
                    value: isCurrentCitySelected,
                    onChanged: (value) {
                      setState(() {
                        isCurrentCitySelected = value!;
                        if (isCurrentCitySelected) {
                          pickup = Destination(
                              latitude: currentLocation!.latitude,
                              longitude: currentLocation!.longitude,
                              cityName: currentCityName);
                          destination = Destination(
                              latitude: currentLocation!.latitude,
                              longitude: currentLocation!.longitude,
                              cityName: currentCityName);
                        } else if (_searchFromController.text.isNotEmpty &&
                            _searchToController.text.isNotEmpty &&
                            pPickup != null &&
                            pDestination != null) {
                          pickup = Destination(
                              latitude: double.parse(pPickup!.lat!),
                              longitude: double.parse(pPickup!.lng!),
                              cityName: _searchFromController.text);
                          destination = Destination(
                              latitude: double.parse(pDestination!.lat!),
                              longitude: double.parse(pDestination!.lng!),
                              cityName: _searchToController.text);
                        }
                      });
                    },
                  ),
                  Text(
                    AppStrings.currentCity.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ColorManager.titlesTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.s16),
                  ),
                ],
              ),
              CustomTextButton(
                text: AppStrings.confirm.tr(),
                isWaitToEnable: false,
                backgroundColor: ColorManager.secondaryColor,
                textColor: ColorManager.white,
                onPressed: () {
                  if (pickup != null &&
                      destination != null &&
                      currentLocationFilter != null) {
                    widget.onSelectLocationFilter(
                        pickup!, destination!, currentLocationFilter!);
                    isCitySelected = true;
                    Navigator.pop(context);
                  } else {
                    ToastHandler(context)
                        .showToast(AppStrings.pleaseEnterCity.tr(), null);
                  }
                },
              ),
              CustomTextButton(
                text: AppStrings.back.tr(),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
