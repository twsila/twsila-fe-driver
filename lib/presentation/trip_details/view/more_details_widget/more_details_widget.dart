import 'package:flutter/material.dart';
import 'package:taxi_for_you/domain/model/furniture_model.dart';
import 'package:taxi_for_you/presentation/trip_details/view/more_details_widget/widgets/furniture_details_widget/furniture_details_widget.dart';
import 'package:taxi_for_you/presentation/trip_details/view/more_details_widget/widgets/goods_details_widget/goods_details_widget.dart';

import '../../../../domain/model/goods_model.dart';
import '../../../../domain/model/transportation_base_model.dart';
import '../../../../utils/resources/color_manager.dart';

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
        if (widget.transportationBaseModel is FurnitureModel)
          FurnitureDetailsWidget(
            furnitureModel: widget.transportationBaseModel as FurnitureModel,
          ),
        if (widget.transportationBaseModel is GoodsModel)
          GoodsDetailsWidget(
            goodsModel: widget.transportationBaseModel as GoodsModel,
          ),
        Divider(color: ColorManager.lineColor),
      ],
    );
  }
}
