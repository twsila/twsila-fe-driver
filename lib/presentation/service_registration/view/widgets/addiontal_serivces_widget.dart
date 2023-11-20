import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/presentation/service_registration/view/helpers/registration_request.dart';
import '../../../../domain/model/goods_model.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../../utils/resources/styles_manager.dart';
import '../../../common/widgets/custom_checkbox.dart';

class AdditionalServicesWidget extends StatefulWidget {
  final AdditionalServicesModel additionalServicesModel;

  const AdditionalServicesWidget(
      {Key? key, required this.additionalServicesModel})
      : super(key: key);

  @override
  _AdditionalServicesWidgetState createState() =>
      _AdditionalServicesWidgetState();
}

class _AdditionalServicesWidgetState extends State<AdditionalServicesWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.extraServices.tr(),
          textAlign: TextAlign.start,
          style: getMediumStyle(
            color: ColorManager.titlesTextColor,
            fontSize: 16,
          ),
        ),
        Row(
          children: [
            CustomCheckBox(
                checked: widget.additionalServicesModel.canTransportFurniture!,
                fieldName: AppStrings.canTransportFurniture.tr(),
                onChange: (checked) {
                  widget.additionalServicesModel.canTransportFurniture =
                      checked;
                }),
            Spacer(),
            CustomCheckBox(
                checked: widget.additionalServicesModel.canTransportGoods!,
                fieldName: AppStrings.canTransportGoods.tr(),
                onChange: (checked) {
                  widget.additionalServicesModel.canTransportGoods = checked;
                }),
          ],
        ),
        Row(
          children: [
            CustomCheckBox(
                checked: widget.additionalServicesModel.canTransportFrozen!,
                fieldName: AppStrings.canTransportFrozen.tr(),
                onChange: (checked) {
                  widget.additionalServicesModel.canTransportFrozen = checked;
                }),
            Spacer(),
            CustomCheckBox(
                checked: widget.additionalServicesModel.hasWaterTank!,
                fieldName: AppStrings.hasWaterTank.tr(),
                onChange: (checked) {
                  widget.additionalServicesModel.hasWaterTank = checked;
                }),
          ],
        ),
        Row(
          children: [
            CustomCheckBox(
                checked: widget.additionalServicesModel.hasOtherTanks!,
                fieldName: AppStrings.hasOtherTanks.tr(),
                onChange: (checked) {
                  widget.additionalServicesModel.hasOtherTanks = checked;
                }),
            Spacer(),
            CustomCheckBox(
                checked: widget.additionalServicesModel.hasPacking!,
                fieldName: AppStrings.hasPacking.tr(),
                onChange: (checked) {
                  widget.additionalServicesModel.hasPacking = checked;
                }),
          ],
        ),
        Row(
          children: [
            CustomCheckBox(
                checked: widget.additionalServicesModel.hasLoading!,
                fieldName: AppStrings.hasLoading.tr(),
                onChange: (checked) {
                  widget.additionalServicesModel.hasLoading = checked;
                }),
            Spacer(),
            CustomCheckBox(
                checked: widget.additionalServicesModel.hasAssembly!,
                fieldName: AppStrings.hasAssembly.tr(),
                onChange: (checked) {
                  widget.additionalServicesModel.hasAssembly = checked;
                }),
          ],
        ),
        CustomCheckBox(
            checked: widget.additionalServicesModel.hasLifting!,
            fieldName: AppStrings.hasLifting.tr(),
            onChange: (checked) {
              widget.additionalServicesModel.hasLifting = checked;
            }),
      ],
    );
  }
}

class AdditionalServicesModel {
  bool? canTransportFurniture;
  bool? canTransportGoods;
  bool? canTransportFrozen;
  bool? hasWaterTank;
  bool? hasOtherTanks;
  bool? hasPacking;
  bool? hasLoading;
  bool? hasAssembly;
  bool? hasLifting;

  AdditionalServicesModel({
    this.canTransportFurniture = false,
    this.canTransportGoods = false,
    this.canTransportFrozen = false,
    this.hasWaterTank = false,
    this.hasOtherTanks = false,
    this.hasPacking = false,
    this.hasLoading = false,
    this.hasAssembly = false,
    this.hasLifting = false,
  });
}
