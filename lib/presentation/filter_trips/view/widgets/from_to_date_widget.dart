import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_date_picker.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';

import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../../utils/resources/values_manager.dart';
import '../../../common/widgets/custom_bottom_sheet.dart';
import '../../../common/widgets/custom_text_button.dart';

class FromToDateWidget extends StatefulWidget {
  FromToDateWidget();

  @override
  State<FromToDateWidget> createState() => _FromToDateWidgetState();
}

class _FromToDateWidgetState extends State<FromToDateWidget> {
  bool isRangeOrDateSelected = true;
  bool todayDate = false;
  String? selectedFromDate;
  String? selectedToDate;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppPadding.p12),
        child: selectedFromDate == null && selectedToDate == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.tripDate.tr(),
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
            : GestureDetector(
                onTap: () {
                  _showSelectDateDialog();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.tripDate.tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: ColorManager.titlesTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: FontSize.s16),
                    ),
                    Center(
                      child: Text(
                        '${AppStrings.from.tr()} ${selectedFromDate} - ${AppStrings.to.tr()} ${selectedToDate}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: ColorManager.titlesTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: FontSize.s16),
                      ),
                    )
                  ],
                ),
              ));
  }

  Widget _dialogContentWidget(StateSetter setState) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 1.7,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            CustomDatePickerWidget(
              onSelectDate: (date) {
                selectedFromDate = date;
              },
              isDimmed: todayDate,
              pickTime: false,
              labelText: 'من',
            ),
            CustomDatePickerWidget(
              onSelectDate: (date) {
                selectedToDate = date;
              },
              isDimmed: todayDate,
              pickTime: false,
              labelText: 'الى',
            ),
            Row(
              children: [
                Checkbox(
                  side: BorderSide(
                      color: ColorManager.secondaryColor, width: AppSize.s1_5),
                  activeColor: ColorManager.secondaryColor,
                  focusColor: ColorManager.primary,
                  checkColor: ColorManager.white,
                  value: todayDate,
                  onChanged: (value) {
                    setState(() => todayDate = value!);
                  },
                ),
                Text(
                  'تاريخ اليوم',
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
}
