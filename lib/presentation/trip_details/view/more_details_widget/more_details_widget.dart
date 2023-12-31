import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:taxi_for_you/domain/model/furniture_model.dart';
import 'package:taxi_for_you/presentation/trip_details/view/more_details_widget/widgets/cisterns_details_widget.dart';
import 'package:taxi_for_you/presentation/trip_details/view/more_details_widget/widgets/frozen_details_widget.dart';
import 'package:taxi_for_you/presentation/trip_details/view/more_details_widget/widgets/furniture_details_widget/furniture_details_widget.dart';
import 'package:taxi_for_you/presentation/trip_details/view/more_details_widget/widgets/goods_details_widget/goods_details_widget.dart';
import 'package:taxi_for_you/presentation/trip_details/view/more_details_widget/widgets/item_widget.dart';
import 'package:taxi_for_you/presentation/trip_details/view/more_details_widget/widgets/person_details_widget.dart';
import 'package:taxi_for_you/presentation/trip_details/view/more_details_widget/widgets/water_details_widget.dart';
import 'package:taxi_for_you/utils/ext/date_ext.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../../domain/model/cisterns_model.dart';
import '../../../../domain/model/freezers-model.dart';
import '../../../../domain/model/goods_model.dart';
import '../../../../domain/model/persons_model.dart';
import '../../../../domain/model/transportation_base_model.dart';
import '../../../../domain/model/water_model.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../../utils/resources/styles_manager.dart';

class MoreDetailsWidget extends StatefulWidget {
  final TransportationBaseModel transportationBaseModel;

  const MoreDetailsWidget({
    Key? key,
    required this.transportationBaseModel,
  }) : super(key: key);

  @override
  State<MoreDetailsWidget> createState() => _MoreDetailsWidgetState();
}

class _MoreDetailsWidgetState extends State<MoreDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: AppSize.s14,
        ),
        Visibility(
            visible: widget.transportationBaseModel.images != null,
            child: tripImages(widget.transportationBaseModel.images ?? [])),
        SizedBox(
          height: AppSize.s14,
        ),
        if (widget.transportationBaseModel is FurnitureModel)
          FurnitureDetailsWidget(
            furnitureModel: widget.transportationBaseModel as FurnitureModel,
          ),
        if (widget.transportationBaseModel is GoodsModel)
          GoodsDetailsWidget(
            goodsModel: widget.transportationBaseModel as GoodsModel,
          ),
        if (widget.transportationBaseModel is FreezersModel)
          FrozenDetailsWidget(
            freezersModel: widget.transportationBaseModel as FreezersModel,
          ),
        if (widget.transportationBaseModel is WaterModel)
          WaterDetailsWidget(
            waterModel: widget.transportationBaseModel as WaterModel,
          ),
        if (widget.transportationBaseModel is CisternsModel)
          CisternsDetailsWidget(
            cisternsModel: widget.transportationBaseModel as CisternsModel,
          ),
        if (widget.transportationBaseModel is PersonsModel)
          PersonDetailsWidget(
            personsModel: widget.transportationBaseModel as PersonsModel,
          ),
        Visibility(
            visible: widget.transportationBaseModel.notes != null,
            child: clientNotes(widget.transportationBaseModel.notes ?? "-")),
        Divider(color: ColorManager.dividerColor),
      ],
    );
  }

  Widget clientNotes(String notes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ItemWidget(
                title: AppStrings.clientNotes.tr(),
                text: widget.transportationBaseModel.notes ?? "-",
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget tripImages(List<ImageModel> imageUrls) {
    return imageUrls.isNotEmpty
        ? Center(
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 5,
              children: List.generate(imageUrls.length,
                  (index) => TripImageItem(imageUrls[index].url)),
            ),
          )
        : Container();
  }

  Widget imageUrlWithHandle(String url) {
    try {
      return SizedBox(
          height: 100,
          width: 100,
          child: Image.network(
            url,
            height: 70.0,
            width: 70.0,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Image.asset(
                ImageAssets.newAppBarLogo,
                color: ColorManager.splashBGColor,
              );
            },
          ));
    } catch (e) {
      return Image.asset(ImageAssets.newAppBarLogo,
        color: ColorManager.splashBGColor,);
    }
  }

  Widget TripImageItem(String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageUrlWithHandle(imageUrl),
        ],
      ),
    );
  }
}
