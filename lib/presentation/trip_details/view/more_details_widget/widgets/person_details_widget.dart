import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/model/persons_model.dart';
import '../../../../../utils/resources/strings_manager.dart';
import 'item_widget.dart';

class PersonDetailsWidget extends StatelessWidget {
  final PersonsModel personsModel;

  const PersonDetailsWidget({Key? key, required this.personsModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ItemWidget(
                title: AppStrings.vehicleType.tr(),
                text: personsModel.vehicleType ?? "-",
              ),
            ),
            Expanded(
              child: ItemWidget(
                title: AppStrings.numOfPassengers.tr(),
                text: personsModel.numberOfPassengers?.toString() ?? "-",
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
