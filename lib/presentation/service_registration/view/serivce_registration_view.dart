import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../common/widgets/custom_scaffold.dart';
import '../../common/widgets/page_builder.dart';
import '../bloc/serivce_registration_bloc.dart';

class ServiceRegistrationView extends StatefulWidget {
  const ServiceRegistrationView({Key? key}) : super(key: key);

  @override
  State<ServiceRegistrationView> createState() =>
      _ServiceRegistrationViewState();
}

class _ServiceRegistrationViewState extends State<ServiceRegistrationView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  bool _displayLoadingIndicator = false;

  @override
  void initState() {
    // BlocProvider.of<ServiceRegistrationBloc>(context).add(GetServiceTypes());
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
        appbar: true,
        context: context,
        body: _getContentWidget(context),
        scaffoldKey: _key,
        displayLoadingIndicator: _displayLoadingIndicator,
        allowBackButtonInAppBar: true,
      ),
    );
  }

  Widget _getContentWidget(BuildContext context) {
    return BlocProvider<ServiceRegistrationBloc>(
      create: (BuildContext context) =>
          ServiceRegistrationBloc(registrationServiceUseCase: instance()),
      child: BlocConsumer<ServiceRegistrationBloc, ServiceRegistrationState>(
        listener: (context, state) {
          if (state is ServiceRegistrationLoading) {
            startLoading();
          } else {
            stopLoading();
          }
          if (state is ServicesTypesSuccess) {
            print(state.serviceTypeModel);
          }
        },
        builder: (context, state) {
          return Container();
        },
      ),
    );
  }
}
