import 'dart:async';

import '../../base/baseviewmodel.dart';
import '../../common/state_renderer/state_renderer_impl.dart';

class ScheduledTripViewModel extends BaseViewModel
    with ScheduledTripViewModelInput, ScheduledTripViewModelOutput {
  StreamController scheduledTripStreamController =
      StreamController<String>.broadcast();

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    scheduledTripStreamController.close();
    super.dispose();
  }

  @override
  // TODO: implement inputServiceType
  Sink get inputServiceType => scheduledTripStreamController.sink;

  @override
  setServiceType(String serviceType) {
    scheduledTripStreamController.add(serviceType);
  }
}

abstract class ScheduledTripViewModelInput {
  Sink get inputServiceType;

  setServiceType(String serviceType);
}

abstract class ScheduledTripViewModelOutput {}
