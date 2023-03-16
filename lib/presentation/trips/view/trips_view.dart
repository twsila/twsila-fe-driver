import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:flutter/material.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import 'package:taxi_for_you/utils/resources/styles_manager.dart';

import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/routes_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../common/widgets/custom_dropdown.dart';

class TripsView extends StatefulWidget {
  const TripsView({Key? key}) : super(key: key);

  @override
  State<TripsView> createState() => _TripsViewState();
}

class _TripsViewState extends State<TripsView> {
  List<String> list1 = [
    AppStrings.ongoingTrips.tr(),
    AppStrings.scheduledTrips.tr(),
    AppStrings.fromToTrips.tr(),
    AppStrings.nearFromMeTrips.tr(),
    AppStrings.animalsTrips.tr(),
    AppStrings.boxTrips.tr(),
    AppStrings.viewAllTrips.tr(),
  ];
  bool _isTripTypeSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        elevation: AppSize.s0,
        backgroundColor: ColorManager.white,
        iconTheme: IconThemeData(color: ColorManager.primary),
      ),
      body: _getContentWidget(),
    );
  }

  Widget _getContentWidget() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.searchForTrips.tr(),
            style: getRegularStyle(
                color: ColorManager.primary, fontSize: FontSize.s16),
          ),
          CustomDropDown(
            backgroundColor: ColorManager.white,
            isTitleBold: false,
            stringsArr: list1,
            isValid: true,
            hintTextColor: ColorManager.grey,
            hintText: AppStrings.selectFromHereHint.tr(),
            textColor: ColorManager.primary,
            borderColor: ColorManager.grey,
            onChanged: (selectedValue) {
              // _viewModel.setServiceType(selectedValue!);
              setState(() {
                _isTripTypeSelected = true;
              });
            },
          ),
          Visibility(
            visible: _isTripTypeSelected,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(Routes.tripDetailsRoute);
              },
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorManager.primary),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.clientName.tr(),
                          style: getRegularStyle(
                              color: ColorManager.black,
                              fontSize: FontSize.s12),
                        ),
                        Text(
                          AppStrings.ahmedMohamedClient.tr(),
                          style: getRegularStyle(
                              color: ColorManager.black,
                              fontSize: FontSize.s12),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.tripInformation.tr(),
                          style: getRegularStyle(
                              color: ColorManager.black,
                              fontSize: FontSize.s12),
                        ),
                        Text(
                          AppStrings.fromKhobarToElDmam.tr(),
                          style: getRegularStyle(
                              color: ColorManager.black,
                              fontSize: FontSize.s12),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.clientOfferLabel.tr(),
                          style: getRegularStyle(
                              color: ColorManager.black,
                              fontSize: FontSize.s12),
                        ),
                        Text(
                          "10000",
                          style: getRegularStyle(
                              color: ColorManager.black,
                              fontSize: FontSize.s12),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.rating.tr(),
                          style: getRegularStyle(
                              color: ColorManager.black,
                              fontSize: FontSize.s12),
                        ),
                        Text(
                          "4.3",
                          style: getRegularStyle(
                              color: ColorManager.black,
                              fontSize: FontSize.s12),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          // const Spacer(),
          // // ElevatedButton(
          // //     onPressed: () {
          // //       Navigator.pushNamed(context, Routes.tripDetailsRoute);
          // //     },
          // //     child: const Text("Next"))
        ],
      ),
    );
  }
}
