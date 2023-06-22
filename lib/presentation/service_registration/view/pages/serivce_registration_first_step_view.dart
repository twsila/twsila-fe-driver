import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_for_you/domain/model/ServiceTypeModel.dart';
import 'package:taxi_for_you/domain/model/vehicleModel.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/service_registration/view/widgets/services_card_widget.dart';
import 'package:taxi_for_you/utils/resources/color_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'package:taxi_for_you/utils/resources/routes_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

import '../../../../app/app_prefs.dart';
import '../../../../app/di.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../common/widgets/custom_scaffold.dart';
import '../../../common/widgets/page_builder.dart';
import '../../bloc/serivce_registration_bloc.dart';

class ServiceRegistrationFirstStepView extends StatefulWidget {
  const ServiceRegistrationFirstStepView({Key? key}) : super(key: key);

  @override
  State<ServiceRegistrationFirstStepView> createState() =>
      _ServiceRegistrationFirstStepViewState();
}

class _ServiceRegistrationFirstStepViewState
    extends State<ServiceRegistrationFirstStepView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  bool _displayLoadingIndicator = false;
  List<ServiceTypeModel>? serviceModelList;

  ServiceTypeModel? selectedService;
  VehicleModel? selectedVehicleType;

  @override
  void initState() {
    BlocProvider.of<ServiceRegistrationBloc>(context).add(GetServiceTypes());
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

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      pageBuilder: PageBuilder(
        appbar: false,
        context: context,
        body: _getContentWidget(context),
        scaffoldKey: _key,
        displayLoadingIndicator: _displayLoadingIndicator,
        allowBackButtonInAppBar: true,
      ),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return BlocConsumer<ServiceRegistrationBloc, ServiceRegistrationState>(
      listener: (context, state) {
        if (state is ServiceRegistrationLoading) {
          startLoading();
        } else {
          stopLoading();
        }
        if (state is ServicesTypesSuccess) {
          this.serviceModelList = state.serviceTypeModelList;
          print(state.serviceTypeModelList.length);
        }
        if (state is FirstStepDataAddedState) {
          Navigator.pushNamed(context, Routes.serviceRegistrationSecondStep);
        }
      },
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(
              left: AppMargin.m16, right: AppMargin.m16, top: AppMargin.m16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.close),
                ),
              ),
              SizedBox(
                height: AppSize.s10,
              ),
              Text(
                AppStrings.stepOne.tr(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorManager.headersTextColor),
              ),
              Text(
                AppStrings.serviceData.tr(),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.s30,
                    color: ColorManager.headersTextColor),
              ),
              SizedBox(
                height: AppSize.s20,
              ),
              serviceModelList != null
                  ? Container(
                      child: ServiceCard(
                        serviceTypeModelList: this.serviceModelList!,
                        showServiceCarTypes: false,
                        selectedService: (ServiceTypeModel service) {
                          setState(() {
                            selectedService = service;
                          });
                        },
                        selectedVehicleType: (VehicleModel? vehicleType) {
                          setState(() {
                            selectedVehicleType = vehicleType;
                          });
                        },
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: ColorManager.primary,
                      ),
                    ),
              Spacer(),
              CustomTextButton(
                text: AppStrings.continueStr.tr(),
                icon: Icon(
                  Icons.arrow_forward,
                  color: ColorManager.white,
                ),
                onPressed:
                    selectedVehicleType != null && selectedService != null
                        ? () {
                            BlocProvider.of<ServiceRegistrationBloc>(context)
                                .add(SetFirstStepData(
                                    selectedService!.serviceName.toString(),
                                    selectedVehicleType!.id.toString()));
                          }
                        : null,
              )
            ],
          ),
        );
      },
    );
  }
}
