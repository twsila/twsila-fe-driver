import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/register_business_owner_viewmodel.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/widgets/header_widget.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/widgets/input_fields.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_scaffold.dart';
import 'package:taxi_for_you/presentation/common/widgets/page_builder.dart';
import 'package:taxi_for_you/presentation/login/bloc/login_bloc.dart';
import 'package:taxi_for_you/presentation/service_registration/bloc/serivce_registration_bloc.dart';
import 'package:taxi_for_you/utils/dialogs/custom_dialog.dart';
import 'package:taxi_for_you/utils/resources/constants_manager.dart';
import 'package:taxi_for_you/utils/resources/routes_manager.dart';
import 'package:taxi_for_you/utils/resources/values_manager.dart';

class RegisterBusinessOwnerScreen extends StatefulWidget {
  final String mobileNumber;

  RegisterBusinessOwnerScreen({Key? key, required this.mobileNumber})
      : super(key: key);

  @override
  State<RegisterBusinessOwnerScreen> createState() =>
      _RegisterBusinessOwnerScreenState();
}

class _RegisterBusinessOwnerScreenState
    extends State<RegisterBusinessOwnerScreen> {
  final RegisterBusinessOwnerViewModel businessOwnerViewModel =
      RegisterBusinessOwnerViewModel();

  @override
  void initState() {
    businessOwnerViewModel.bind(widget.mobileNumber);
    super.initState();
  }

  @override
  void dispose() {
    businessOwnerViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state is LoginLoadingState) {
              setState(() {
                businessOwnerViewModel.displayLoadingIndicator = true;
              });
            } else {
              setState(() {
                businessOwnerViewModel.displayLoadingIndicator = false;
              });
            }
            if (state is LoginSuccessState) {
              businessOwnerViewModel.appPreferences.setUserLoggedIn();
              DriverBaseModel cachedDriver = state.driver;
              cachedDriver.captainType = RegistrationConstants.businessOwner;
              await businessOwnerViewModel.appPreferences
                  .setDriver(cachedDriver);
              DriverBaseModel? driver =
                  businessOwnerViewModel.appPreferences.getCachedDriver();
              if (driver != null) {
                Navigator.pushReplacementNamed(
                    context, Routes.welcomeToTwsilaBO);
              }
            }
            if (state is LoginFailState) {
              CustomDialog(context).showErrorDialog('', '', state.message);
            }
          },
          child: const SizedBox(),
        ),
        BlocListener<ServiceRegistrationBloc, ServiceRegistrationState>(
            listener: (context, state) {
              if (state is ServiceRegistrationLoading) {
                setState(() {
                  businessOwnerViewModel.displayLoadingIndicator = true;
                });
              } else {
                setState(() {
                  businessOwnerViewModel.displayLoadingIndicator = false;
                });
                if (state is ServiceBORegistrationSuccess) {
                  BlocProvider.of<LoginBloc>(context).add(
                    MakeLoginBOEvent(
                      businessOwnerViewModel.mobileNumberController.text,
                      businessOwnerViewModel.appPreferences.getAppLanguage(),
                    ),
                  );
                }
                if (state is ServiceRegistrationFail) {
                  CustomDialog(context).showErrorDialog('', '', state.message);

                  // Navigator.pushReplacementNamed(context, Routes.welcomeToTwsilaBO);
                }
              }
            },
            child: CustomScaffold(
              pageBuilder: PageBuilder(
                scaffoldKey: businessOwnerViewModel.scaffoldKey,
                context: context,
                resizeToAvoidBottomInsets: true,
                displayLoadingIndicator:
                    businessOwnerViewModel.displayLoadingIndicator,
                body: Container(
                  margin: const EdgeInsets.all(AppMargin.m28),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RegistrationBOHeaderWidget(),
                        const SizedBox(height: AppSize.s20),
                        RegistartionBOInputFields(
                            viewModel: businessOwnerViewModel),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
