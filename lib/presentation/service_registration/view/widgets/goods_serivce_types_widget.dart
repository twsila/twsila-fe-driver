import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_network_image_widget.dart';
import 'package:taxi_for_you/presentation/service_registration/view/helpers/registration_request.dart';
import 'package:taxi_for_you/presentation/service_registration/view/widgets/vehicle_shape_widget.dart';
import 'package:taxi_for_you/utils/dialogs/toast_handler.dart';
import 'package:taxi_for_you/utils/ext/screen_size_ext.dart';
import 'package:taxi_for_you/utils/resources/langauge_manager.dart';

import '../../../../domain/model/goods_service_type_model.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/font_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../../utils/resources/values_manager.dart';

class GoodsServiceTypesWidget extends StatefulWidget {
  final String lang;
  final RegistrationRequest registrationRequest;
  final List<GoodsServiceTypeModel> goodsServiceTypesList;
  final Function(GoodsServiceTypeModel selectedService) selectedService;
  final Function(VehicleShape vehicleShape) selectedVehicleShape;

  GoodsServiceTypesWidget(
      {required this.lang,
      required this.registrationRequest,
      required this.goodsServiceTypesList,
      required this.selectedService,
      required this.selectedVehicleShape});

  @override
  State<GoodsServiceTypesWidget> createState() =>
      _GoodsServiceTypesWidgetState();
}

class _GoodsServiceTypesWidgetState extends State<GoodsServiceTypesWidget> {
  int current = -1;
  GoodsServiceTypeModel? selectedGoodsServiceTypeModel;
  VehicleShape? vehicleShape;

  @override
  void didUpdateWidget(GoodsServiceTypesWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.goodsServiceTypesList != oldWidget.goodsServiceTypesList) {
      checkSelectedValues();
    }
  }

  checkSelectedValues() {
    try {
      if (widget.registrationRequest.serviceTypeParam != null && mounted) {
        int serviceIndex = widget.goodsServiceTypesList.indexWhere((element) =>
            element.serviceTypeParam ==
            widget.registrationRequest.serviceTypeParam);
        selectedGoodsServiceTypeModel =
            widget.goodsServiceTypesList[serviceIndex];

        if (widget.registrationRequest.vehicleTypeId != null &&
            selectedGoodsServiceTypeModel != null &&
            selectedGoodsServiceTypeModel!.vehicleShapes.isNotEmpty) {
          int vehicleIndex = selectedGoodsServiceTypeModel!.vehicleShapes
              .indexWhere((element) =>
                  element.id.toString() ==
                  widget.registrationRequest.vehicleTypeId);

          if (vehicleIndex <
              selectedGoodsServiceTypeModel!.vehicleShapes.length) {
            vehicleShape =
                selectedGoodsServiceTypeModel!.vehicleShapes[vehicleIndex];
          }
        }
        SchedulerBinding.instance.addPostFrameCallback((_) {
          setState(() {
            if (selectedGoodsServiceTypeModel != null && vehicleShape != null) {
              current = widget.goodsServiceTypesList
                  .indexOf(selectedGoodsServiceTypeModel!);
              widget.selectedService(selectedGoodsServiceTypeModel!);
              widget.selectedVehicleShape(vehicleShape!);
            }
          });
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.selectSubServiceType.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.normal,
              color: ColorManager.titlesTextColor),
        ),
        SizedBox(
          height: AppSize.s14,
        ),
        Wrap(
          direction: Axis.horizontal,
          spacing: context.getWidth() / AppSize.s32,
          runSpacing: 20,
          children: List.generate(
              widget.goodsServiceTypesList.length,
              (index) => GestureDetector(
                    onTap: () {
                      current = index;
                      if (widget
                              .goodsServiceTypesList[index].serviceTypeParam ==
                          "OTHER_TANK") {
                        ToastHandler(context).showToast(
                            widget
                                .goodsServiceTypesList[index].serviceTypeParam,
                            Toast.LENGTH_SHORT);
                      }
                      setState(() {
                        widget.selectedService(
                            widget.goodsServiceTypesList[index]);
                        selectedGoodsServiceTypeModel =
                            widget.goodsServiceTypesList[index];
                      });
                    },
                    child: FittedBox(
                      child: Container(
                        padding: EdgeInsets.all(AppPadding.p8),
                        decoration: BoxDecoration(
                          color: current == index
                              ? ColorManager.thirdAccentColor
                              : ColorManager.white,
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(
                              color: current == index
                                  ? ColorManager.thirdAccentColor
                                  : ColorManager.borderColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: AppSize.s28,
                              height: AppSize.s32,
                              child: CustomNetworkImageWidget(
                                imageUrl: widget
                                    .goodsServiceTypesList[index].icon.url,
                              ),
                            ),
                            SizedBox(
                              width: AppSize.s8,
                            ),
                            Text(
                              widget.lang == ARABIC
                                  ? widget.goodsServiceTypesList[index]
                                      .serviceTypeAr
                                  : widget
                                      .goodsServiceTypesList[index].serviceType,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: FontSize.s12,
                                      color: ColorManager.headersTextColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
        ),
        VehicleShapeWidget(
            lang: widget.lang,
            preselectedVehicle: this.vehicleShape,
            vehicleShapesList:
                selectedGoodsServiceTypeModel?.vehicleShapes ?? [],
            selectedVehicle: (vehicleShapes) {
              widget.selectedVehicleShape(vehicleShapes);
            })
      ],
    );
  }
}
