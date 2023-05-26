import '../../app/constants.dart';
import '../../domain/model/driver_model.dart';
import '../response/responses.dart';

import '../../app/constants.dart';
import '../../domain/model/models.dart';
import '../response/responses.dart';
import '../../app/extensions.dart';

extension LoginResponseMapper on LoginResponse? {
  Driver toDomain() {
    return Driver(
      firstName: this?.firstName.orEmpty() ?? Constants.empty,
      lastName: this?.lastName.orEmpty() ?? Constants.empty,
      mobile: this?.mobile.orEmpty() ?? Constants.empty,
      email: this?.email.orEmpty() ?? Constants.empty,
      gender: this?.gender.orEmpty() ?? Constants.empty,
      dateOfBirth: this?.dateOfBirth.orEmpty() ?? Constants.empty,
      token: this?.token.orEmpty() ?? Constants.empty,
      userDevice: this!.userDevice!,
      tokenExpirationTime:
          this?.tokenExpirationTime.orEmpty() ?? Constants.empty,
    );
  }
}
