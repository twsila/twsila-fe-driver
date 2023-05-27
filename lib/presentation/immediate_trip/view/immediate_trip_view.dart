import 'package:flutter/material.dart';
import 'package:taxi_for_you/presentation/immediate_trip/viewmodel/immediate_trip_viewmodel.dart';

import '../../../app/app_prefs.dart';
import '../../../app/di.dart';
import '../../../utils/resources/color_manager.dart';
import '../../common/state_renderer/state_renderer_impl.dart';

class ImmediateTripView extends StatefulWidget {
  const ImmediateTripView({Key? key}) : super(key: key);

  @override
  State<ImmediateTripView> createState() => _ImmediateTripViewState();
}

class _ImmediateTripViewState extends State<ImmediateTripView> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final ImmediateTripViewModel _viewModel = instance<ImmediateTripViewModel>();

  _bind() {
    _viewModel.start();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          // _getContentWidget();
          return snapshot.data
                  ?.getScreenWidget(context, _getContentWidget(), () {}) ??
              _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container();
  }
}
