import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:taxi_for_you/utils/ext/screen_size_ext.dart';

import '../../../../domain/model/goods_service_type_model.dart';
import '../../../../domain/model/vehicle_model.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/langauge_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../../utils/resources/values_manager.dart';

class VehicleShapeWidget extends StatefulWidget {
  final String lang;
  final VehicleShape? preselectedVehicle;
  final List<VehicleShape> vehicleShapesList;
  final Function(VehicleShape vehicleShape) selectedVehicle;

  VehicleShapeWidget(
      {required this.lang,
      this.preselectedVehicle,
      required this.vehicleShapesList,
      required this.selectedVehicle});

  @override
  State<VehicleShapeWidget> createState() => _VehicleShapeWidgetState();
}

class _VehicleShapeWidgetState extends State<VehicleShapeWidget> {
  int current = -1;
  VehicleShape? selectedVehicle;

  @override
  void didUpdateWidget(VehicleShapeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedVehicle != oldWidget.selectedVehicle) {
      checkPreSelectedValues();
    }
  }

  checkPreSelectedValues() {
    try {
      if (widget.preselectedVehicle != null &&  widget.vehicleShapesList.isNotEmpty && mounted) {
        selectedVehicle = widget.vehicleShapesList
            .firstWhere((element) => element == widget.preselectedVehicle);
        if (selectedVehicle != null) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            setState(() {
              current = widget.vehicleShapesList.indexOf(selectedVehicle!);
              widget.selectedVehicle(selectedVehicle!);
            });
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: AppSize.s14,
        ),
        Visibility(
          visible: widget.vehicleShapesList.isNotEmpty,
          child: Text(
            AppStrings.vehicleShape.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.normal,
                color: ColorManager.titlesTextColor),
          ),
        ),
        SizedBox(
          height: AppSize.s14,
        ),
        Wrap(
          direction: Axis.horizontal,
          spacing: context.getWidth() / AppSize.s32,
          runSpacing: 20,
          children: List.generate(
              widget.vehicleShapesList.length,
              (index) => GestureDetector(
                    onTap: () {
                      current = index;
                      setState(() {
                        widget.selectedVehicle(widget.vehicleShapesList[index]);
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.lang == ARABIC
                              ? widget.vehicleShapesList[index].shapeAr
                                  .toString()
                              : widget.vehicleShapesList[index].shape
                                  .toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: ColorManager.headersTextColor),
                        ),
                        SizedBox(
                          width: AppSize.s30,
                        ),
                        Visibility(
                          visible: current == index,
                          child: Icon(
                            Icons.check,
                            color: ColorManager.purpleMainTextColor,
                          ),
                        )
                      ],
                    ),
                  )),
        ),
      ],
    );
  }
}
