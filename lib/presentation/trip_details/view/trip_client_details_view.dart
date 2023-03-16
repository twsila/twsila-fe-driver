import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taxi_for_you/presentation/google_maps/model/location_model.dart';
import 'package:taxi_for_you/presentation/google_maps/view/google_maps_widget.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/routes_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import 'package:taxi_for_you/utils/resources/styles_manager.dart';

import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../common/widgets/custom_dropdown.dart';
import '../../common/widgets/custom_text_input_field.dart';
import '../../google_maps/view/google_search.dart';

class TripClientDetailsView extends StatefulWidget {
  const TripClientDetailsView({Key? key}) : super(key: key);

  @override
  State<TripClientDetailsView> createState() => _TripClientDetailsViewState();
}

class _TripClientDetailsViewState extends State<TripClientDetailsView> {
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  bool _isAgreeChecked = false;

  @override
  void initState() {
    sourceController.text = "cairo";
    destinationController.text = "alex";
    super.initState();
  }

  @override
  void dispose() {
    sourceController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  Widget numberField(String text, Widget widget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: getRegularStyle(
              color: ColorManager.primary, fontSize: FontSize.s16),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 120,
          child: widget,
        ),
      ],
    );
  }

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
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                AppStrings.tripDetails.tr() +
                    " " +
                    AppStrings.captainOfferNewPrice.tr(),
                style: getSemiBoldStyle(
                    color: ColorManager.error, fontSize: FontSize.s16),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              AppStrings.offerFromClientNamed.tr() +
                  " " +
                  AppStrings.ahmedMohamedClient.tr() +
                  " " +
                  AppStrings.withPrice.tr() +
                  " 1000 " +
                  AppStrings.sarCurrency.tr(),
              style: getRegularStyle(
                  color: ColorManager.black, fontSize: FontSize.s14),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                AppStrings.tripDetailsChangeRegardingItsType.tr(),
                style: getSemiBoldStyle(
                    color: ColorManager.primary, fontSize: FontSize.s14),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            numberField(
                AppStrings.pickupPoint.tr(),
                Text(
                  "El Dammam , Suadi Arbia",
                  style: getSemiBoldStyle(color: ColorManager.black),
                )),
            const SizedBox(
              height: 20,
            ),
            numberField(
                AppStrings.destinationPoint.tr(),
                Text(
                  "El Khobar , Suadi Arbia",
                  style: getSemiBoldStyle(color: ColorManager.black),
                )),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 4.6,
              child: GoogleMapsWidget(
                sourceLocation: LocationModel(
                    locationName: "damam",
                    latitude: 26.399250,
                    longitude: 49.984360),
                destinationLocation: LocationModel(
                    locationName: "khobar",
                    latitude: 26.164598,
                    longitude: 50.122999),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Checkbox(
                    value: _isAgreeChecked,
                    onChanged: (isChecked) {
                      setState(() {
                        _isAgreeChecked = isChecked!;
                      });
                    }),
                Flexible(
                  child: Text(
                    AppStrings.wantToOfferPriceForTrip.tr(),
                    style: getRegularStyle(
                        color: ColorManager.black, fontSize: FontSize.s14),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: _isAgreeChecked,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    AppStrings.enterPriceThatYouWant.tr(),
                    style: getRegularStyle(
                        color: ColorManager.black, fontSize: FontSize.s14),
                  ),
                  SizedBox(
                    width: 80,
                    child: CustomTextInputField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {}),
                  ),
                  Text(
                    AppStrings.sarCurrency.tr(),
                    style: getRegularStyle(
                        color: ColorManager.black, fontSize: FontSize.s14),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Fluttertoast.showToast(
                      msg: AppStrings.offerAcceptedMessage.tr(),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.of(context).pushNamed(Routes.categoriesRoute);
                  });
                },
                child: Text(
                  AppStrings.sendSuggestedPrice.tr(),
                  style: getRegularStyle(color: ColorManager.white,fontSize: FontSize.s14),
                )),
          ],
        ),
      ),
    );
  }
}
