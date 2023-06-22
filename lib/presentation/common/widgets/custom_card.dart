import 'package:flutter/material.dart';

import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/values_manager.dart';

class CustomCard extends StatelessWidget {
  Widget bodyWidget;
  Function() onClick;

  CustomCard({Key? key, required this.bodyWidget, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Card(
          elevation: AppSize.s1_5,
          color: ColorManager.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.s4),
              side: BorderSide(color: ColorManager.white, width: AppSize.s1)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: bodyWidget,
          )),
    );
  }
}
