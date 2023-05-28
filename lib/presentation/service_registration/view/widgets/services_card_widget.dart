import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:taxi_for_you/domain/model/ServiceTypeModel.dart';
import 'package:taxi_for_you/domain/model/vehicleModel.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../../utils/helpers/cast_helpers.dart';

class ServiceCard extends StatefulWidget {
  final List<ServiceTypeModel> serviceTypeModelList;
  final bool showServiceCarTypes;
  Function(ServiceTypeModel service) selectedService;
  Function(VehicleModel vehcileType) selectedVehicleType;

  ServiceCard(
      {Key? key,
      required this.serviceTypeModelList,
      required this.showServiceCarTypes,
      required this.selectedService,
      required this.selectedVehicleType})
      : super(key: key);

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  ServiceTypeModel? selectedService;
  VehicleModel? selectedVehicleModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.selectServiceType.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.normal,
              color: ColorManager.titlesTextColor),
        ),
        SizedBox(
          height: AppSize.s8,
        ),
        MasonryGridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 5,
          crossAxisSpacing: AppSize.s20,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: widget.serviceTypeModelList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedService != null &&
                      selectedService != widget.serviceTypeModelList[index]) {
                    selectedService!.isSelected = false;
                    selectedService = widget.serviceTypeModelList[index];
                    selectedService!.isSelected = true;
                  } else {
                    selectedService = widget.serviceTypeModelList[index];
                    selectedService!.isSelected = true;
                  }
                  widget.selectedService(selectedService!);
                });
              },
              child: Container(
                padding: EdgeInsets.only(
                  top: AppPadding.p8,
                  bottom: AppPadding.p8,
                ),
                decoration: BoxDecoration(
                  color: widget.serviceTypeModelList[index].isSelected
                      ? ColorManager.primaryBlueBackgroundColor
                      : ColorManager.white,
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: ColorManager.borderColor),
                ),
                child: Center(
                  child: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FadeInImage(
                          height: AppSize.s30,
                          width: AppSize.s30,
                          image: NetworkImage(
                              'https://icons-for-free.com/iconfiles/png/512/mountains+photo+photos+placeholder+sun+icon-1320165661388177228.png'),
                          placeholder: AssetImage(ImageAssets.appBarLogo),
                        ),
                        SizedBox(
                          width: AppSize.s8,
                        ),
                        Text(
                          widget.serviceTypeModelList[index].serviceName,
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
              ),
            );
          },
        ),
        SizedBox(
          height: AppSize.s30,
        ),
        Text(
          AppStrings.selectServiceVehicleType.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.normal,
              color: ColorManager.titlesTextColor),
        ),
        SizedBox(
          height: AppSize.s8,
        ),
        selectedService != null
            ? MasonryGridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: AppSize.s12,
                crossAxisSpacing: AppSize.s20,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: selectedService?.VehicleModels.length ?? 0,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedVehicleModel != null &&
                            selectedVehicleModel !=
                                selectedService!.VehicleModels[index]) {
                          selectedVehicleModel!.isSelected = false;
                          selectedVehicleModel =
                              selectedService!.VehicleModels[index];
                          selectedVehicleModel!.isSelected = true;
                        } else {
                          selectedVehicleModel =
                              selectedService!.VehicleModels[index];
                          selectedVehicleModel!.isSelected = true;
                        }
                        widget.selectedVehicleType(selectedVehicleModel!);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        top: AppPadding.p8,
                        bottom: AppPadding.p8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            selectedService?.VehicleModels[index].isSelected ??
                                    false
                                ? ColorManager.primaryBlueBackgroundColor
                                : ColorManager.white,
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(color: ColorManager.borderColor),
                      ),
                      child: Center(
                        child: Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FadeInImage(
                                height: AppSize.s33,
                                width: AppSize.s33,
                                image: NetworkImage(
                                    'https://icons-for-free.com/iconfiles/png/512/mountains+photo+photos+placeholder+sun+icon-1320165661388177228.png'),
                                placeholder: AssetImage(ImageAssets.appBarLogo),
                              ),
                              SizedBox(
                                width: AppSize.s8,
                              ),
                              Text(
                                selectedService
                                        ?.VehicleModels[index].vehicleType ??
                                    "",
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
                    ),
                  );
                },
              )
            : Container(),
      ],
    );
  }
}

class Service {
  String name;
  List<VehicleModel> vehicleModels;

  Service(this.name, this.vehicleModels);
}

class Vehicle {
  int id;
  String vehicleType;
  String driverServiceType;

  Vehicle(this.id, this.vehicleType, this.driverServiceType);
}
