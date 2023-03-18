import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_language_widget.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_square_button.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/utils/ext/screen_size_ext.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/routes_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../utils/resources/assets_manager.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.white,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Container(
                width: 100, height: 100, child: const LanguageWidget()),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: SizedBox(
              height: context.getHeight() / 3,
              child: Image.asset(ImageAssets.car),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 32,
            child: SizedBox(
              width: 120,
              child: Image.asset(ImageAssets.logoImg),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSize.s32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.goodAfternoon.tr(),
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text(
                        AppStrings.thinkingOfTravel.tr(),
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                )),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: CustomSquareButton(
                            onPressed: () {
                              Navigator.pushNamed(context, Routes.tripsRoute);
                            },
                            text: AppStrings.trips.tr(),
                            iconData: Icons.car_rental),
                      ),
                      Flexible(
                        child: CustomSquareButton(
                            onPressed: () {
                              // Navigator.pushNamed(context, Routes.goodsRoute);
                            },
                            text: AppStrings.goods.tr(),
                            iconData: Icons.chair),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: CustomSquareButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, Routes.registerRoute);
                              },
                              text: AppStrings.register.tr(),
                              iconData: Icons.car_rental),
                        ),
                        Flexible(
                          child: CustomSquareButton(
                              onPressed: () {
                                // Navigator.pushNamed(context, Routes.goodsRoute);
                              },
                              text: AppStrings.goods.tr(),
                              iconData: Icons.chair),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
