import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../../../../app/constants.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/font_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../../utils/resources/values_manager.dart';
import '../../../common/widgets/custom_text_button.dart';
import '../../../google_maps/view/google_places_field.dart';

class CityFilterWidget extends StatefulWidget {
  CityFilterWidget();

  @override
  State<CityFilterWidget> createState() => _CityFilterWidgetState();
}

class _CityFilterWidgetState extends State<CityFilterWidget> {
  bool isCitySelected = true;
  bool isCurrentCitySelected = false;

  final TextEditingController _searchFromController = TextEditingController();
  final TextEditingController _searchToController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppPadding.p12),
      child: isCitySelected
          ? Column(
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
                      _showSelectDateDialog();
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
            )
          : Container(),
    );
  }

  void _showSelectDateDialog() {
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
                controller: _searchFromController,
                focusNode: FocusNode(debugLabel: 'source_node'),
                hintText: "${AppStrings.pleaseEnterCity.tr()}",
                predictionCallback: (prediction) {
                  if (prediction != null) {
                    // widget.onSelectPlace(
                    //   prediction.lat!,
                    //   prediction.lng!,
                    //   prediction.description!,
                    // );
                    List<Terms> newTerms = prediction.terms!;
                    newTerms.removeLast();
                    _searchFromController.text = newTerms.last.value.toString();
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
                controller: _searchToController,
                focusNode: FocusNode(debugLabel: 'source_node'),
                hintText: "${AppStrings.pleaseEnterCity.tr()}",
                predictionCallback: (prediction) {
                  if (prediction != null) {
                    // widget.onSelectPlace(
                    //   prediction.lat!,
                    //   prediction.lng!,
                    //   prediction.description!,
                    // );
                    List<Terms> newTerms = prediction.terms!;
                    newTerms.removeLast();
                    _searchToController.text = newTerms.last.value.toString();
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
                      setState(() => isCurrentCitySelected = value!);
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
                  Navigator.pop(context);
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
