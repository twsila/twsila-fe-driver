import 'dart:async';

import '../../base/baseviewmodel.dart';
import '../../common/state_renderer/state_renderer_impl.dart';

class TripDetailsViewModel extends BaseViewModel
    with TripDetailsViewModelInput, TripDetailsViewModelOutput {
  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    super.dispose();
  }
}

abstract class TripDetailsViewModelInput {}

abstract class TripDetailsViewModelOutput {}
