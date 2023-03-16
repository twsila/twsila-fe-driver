import 'dart:async';

import '../../base/baseviewmodel.dart';
import '../../common/state_renderer/state_renderer_impl.dart';

class TripsViewModel extends BaseViewModel
    with TripsViewModelInput, TripsViewModelOutput {
  StreamController tripsTypeStreamController =
      StreamController<String>.broadcast();

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    tripsTypeStreamController.close();
    super.dispose();
  }

  @override
  // TODO: implement inputServiceType
  Sink get inputServiceType => tripsTypeStreamController.sink;

  @override
  setServiceType(String serviceType) {
    tripsTypeStreamController.add(serviceType);
  }
}

abstract class TripsViewModelInput {
  Sink get inputServiceType;

  setServiceType(String serviceType);
}

abstract class TripsViewModelOutput {}
