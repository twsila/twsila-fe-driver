import 'package:flutter/material.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/register_business_owner_viewmodel.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/widgets/header_widget.dart';
import 'package:taxi_for_you/presentation/business_owner/registration/view/widgets/input_fields.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_scaffold.dart';
import 'package:taxi_for_you/presentation/common/widgets/page_builder.dart';
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
    return CustomScaffold(
      pageBuilder: PageBuilder(
        scaffoldKey: businessOwnerViewModel.scaffoldKey,
        context: context,
        resizeToAvoidBottomInsets: true,
        displayLoadingIndicator: businessOwnerViewModel.displayLoadingIndicator,
        body: Container(
          margin: const EdgeInsets.all(AppMargin.m28),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RegistrationBOHeaderWidget(),
                const SizedBox(height: AppSize.s20),
                RegistartionBOInputFields(viewModel: businessOwnerViewModel),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
