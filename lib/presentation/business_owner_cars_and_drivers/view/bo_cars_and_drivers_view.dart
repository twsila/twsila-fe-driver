import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_card.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/strings_manager.dart';

import '../../../domain/model/driver_model.dart';
import '../../../utils/resources/font_manager.dart';
import '../../../utils/resources/routes_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../business_owner_add_driver/view/add_driver_sheet.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/page_builder.dart';
import '../bloc/bo_drivers_cars_bloc.dart';

class BOCarsAndDriversView extends StatefulWidget {
  const BOCarsAndDriversView();

  @override
  State<BOCarsAndDriversView> createState() => _BOCarsAndDriversViewState();
}

class _BOCarsAndDriversViewState extends State<BOCarsAndDriversView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _displayLoadingIndicator = false;
  List<Driver> driversList = [];

  @override
  void initState() {
    BlocProvider.of<BoDriversCarsBloc>(context).add(GetDriversAndCars());
    super.initState();
  }

  void startLoading() {
    setState(() {
      _displayLoadingIndicator = true;
    });
  }

  void stopLoading() {
    setState(() {
      _displayLoadingIndicator = false;
    });
  }

  bottomSheetForAddDriver(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return AddDriverBottomSheetView();
        });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
          appbar: true,
          context: context,
          body: _getContentWidget(context),
          scaffoldKey: _key,
          displayLoadingIndicator: _displayLoadingIndicator,
          allowBackButtonInAppBar: true,
          appBarTitle: AppStrings.DriversAndCars.tr(),
          centerTitle: true,
          appBarActions: [
            GestureDetector(
              onTap: () {
                bottomSheetForAddDriver(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.add,
                  color: ColorManager.primary,
                ),
              ),
            )
          ]),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return BlocConsumer<BoDriversCarsBloc, BoDriversCarsState>(
      listener: (context, state) {
        if (state is BoDriversCarsLoading) {
          startLoading();
        } else {
          stopLoading();
        }
        if (state is BoDriversCarsSuccess) {
          driversList = List<Driver>.from(
              state.baseResponse.result!.map((x) => Driver.fromJson(x)));
          if (driversList.isEmpty) {
            Navigator.pushNamed(context, Routes.BOaddDriver);
          }
        }

        if (state is BoDriversCarsFail) {
          CustomDialog(context).showErrorDialog('', '', state.message);
        }
      },
      builder: (context, state) {
        return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: driversList.length,
            itemBuilder: (context, i) {
              return Container(
                  margin: EdgeInsets.all(AppMargin.m8),
                  child: CustomCard(
                    onClick: () {},
                    bodyWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${driversList[i].carModel.carManufacturerId.carManufacturer} / ${driversList[i].carModel.modelName}",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: FontSize.s18,
                                      color: ColorManager.secondaryColor),
                            ),
                            Text(
                              "${driversList[i].firstName} ${driversList[i].lastName}",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: FontSize.s18,
                                      color: ColorManager.secondaryColor),
                            ),
                            Text(
                              "${driversList[i].mobile}",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.normal,
                                      fontSize: FontSize.s16,
                                      color: ColorManager.primaryPurple),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(AppPadding.p8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: ColorManager.lightGrey)),
                          height: AppSize.s120,
                          width: AppSize.s90,
                          child: driversList[i].images[0].imageUrl == null
                              ? Image.asset(ImageAssets.appBarLogo)
                              : FadeInImage.assetNetwork(
                                  placeholder: ImageAssets.appBarLogo,
                                  image: driversList[i].images[0].imageUrl!),
                        )
                      ],
                    ),
                  ));
            });
      },
    );
  }
}
