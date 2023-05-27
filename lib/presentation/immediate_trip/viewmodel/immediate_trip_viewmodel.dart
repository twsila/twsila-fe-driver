import 'dart:async';

import '../../base/baseviewmodel.dart';
import '../../common/state_renderer/state_renderer_impl.dart';

class ImmediateTripViewModel extends BaseViewModel
    with ImmediateTripViewModelInput, ImmediateTripViewModelOutput {
  StreamController immediateTripStreamController =
      StreamController<String>.broadcast();

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    immediateTripStreamController.close();
    super.dispose();
  }

  @override
  // TODO: implement inputServiceType
  Sink get inputServiceType => immediateTripStreamController.sink;

  @override
  setServiceType(String serviceType) {
    immediateTripStreamController.add(serviceType);
  }
}

abstract class ImmediateTripViewModelInput {
  Sink get inputServiceType;

  setServiceType(String serviceType);
}

abstract class ImmediateTripViewModelOutput {}
