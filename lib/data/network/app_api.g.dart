// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_api.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _AppServiceClient implements AppServiceClient {
  _AppServiceClient(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://twsila-dev-service-f33wiujt7a-lm.a.run.app';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<LoginResponse> login(
    mobile,
    language,
    userDeviceDTO,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'mobile': mobile,
      'language': language,
      'userDeviceDTO': userDeviceDTO,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<LoginResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/drivers/login',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LoginResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GenerateOtpModel> generateOtp(mobile) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'mobile': mobile};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<GenerateOtpModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/otp/generate',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GenerateOtpModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<VerifyOtpModel> verifyOtp(
    mobile,
    userOtp,
    generatedOtp,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'mobile': mobile,
      'userOtp': userOtp,
      'generatedOtp': generatedOtp,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<VerifyOtpModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/otp/validate',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = VerifyOtpModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<RegistrationServicesTypesResponse> registrationServices() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<RegistrationServicesTypesResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/drivers/vehicle-types',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = RegistrationServicesTypesResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CarBrandAndModelsModel> carBrandsAndModels() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CarBrandAndModelsModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/drivers/car-model',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CarBrandAndModelsModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ForgotPasswordResponse> forgotPassword(email) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'email': email};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ForgotPasswordResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/customers/forgotPassword',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ForgotPasswordResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<RegistrationResponse> registerCaptainWithService(
    firstName,
    lastName,
    mobile,
    email,
    gender,
    dateOfBirth,
    driverServiceType,
    vehicleTypeId,
    carManufacturerTypeId,
    carModelId,
    canTransportFurniture,
    canTransportGoods,
    canTransportFrozen,
    hasWaterTank,
    hasPacking,
    hasLoading,
    hasAssembly,
    hasLifting,
    plateNumber,
    isAcknowledged,
    driverImages,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry(
      'firstName',
      firstName,
    ));
    _data.fields.add(MapEntry(
      'lastName',
      lastName,
    ));
    _data.fields.add(MapEntry(
      'mobile',
      mobile,
    ));
    _data.fields.add(MapEntry(
      'email',
      email,
    ));
    _data.fields.add(MapEntry(
      'gender',
      gender,
    ));
    _data.fields.add(MapEntry(
      'dateOfBirth',
      dateOfBirth,
    ));
    _data.fields.add(MapEntry(
      'driverServiceType',
      driverServiceType,
    ));
    _data.fields.add(MapEntry(
      'vehicleType.id',
      vehicleTypeId,
    ));
    _data.fields.add(MapEntry(
      'carManufacturerType.id',
      carManufacturerTypeId,
    ));
    _data.fields.add(MapEntry(
      'carModel.id',
      carModelId,
    ));
    _data.fields.add(MapEntry(
      'canTransportFurniture',
      canTransportFurniture.toString(),
    ));
    _data.fields.add(MapEntry(
      'canTransportGoods',
      canTransportGoods.toString(),
    ));
    _data.fields.add(MapEntry(
      'canTransportFrozen',
      canTransportFrozen.toString(),
    ));
    _data.fields.add(MapEntry(
      'hasWaterTank',
      hasWaterTank.toString(),
    ));
    _data.fields.add(MapEntry(
      'hasPacking',
      hasPacking.toString(),
    ));
    _data.fields.add(MapEntry(
      'hasLoading',
      hasLoading.toString(),
    ));
    _data.fields.add(MapEntry(
      'hasAssembly',
      hasAssembly.toString(),
    ));
    _data.fields.add(MapEntry(
      'hasLifting',
      hasLifting.toString(),
    ));
    _data.fields.add(MapEntry(
      'plateNumber',
      plateNumber,
    ));
    _data.fields.add(MapEntry(
      'isAcknowledged',
      isAcknowledged.toString(),
    ));
    _data.files.addAll(driverImages.map((i) => MapEntry(
        'driverImages',
        MultipartFile.fromFileSync(
          i.path,
          filename: i.path.split(Platform.pathSeparator).last,
        ))));
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<RegistrationResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
            .compose(
              _dio.options,
              '/drivers/register',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = RegistrationResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ServiceRegisterModel> serviceStatus(userId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'userId': userId};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ServiceRegisterModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/drivers/registration-status',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ServiceRegisterModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> getTripsByModuleId(
    tripModelType,
    userId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'tripModelType': tripModelType,
      'userId': userId,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/drivers/offers/select-trip',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> getMyTripsByModuleId(
    tripModelType,
    userId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'tripModelType': tripModelType,
      'userId': userId,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/drivers/offers/select-my-trip',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GeneralResponse> addOffer(
    userId,
    tripId,
    driverOffer,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'userId': userId,
      'tripId': tripId,
      'driverOffer': driverOffer,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<GeneralResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/drivers/offers/add',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GeneralResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GeneralResponse> acceptOffer(
    userId,
    tripId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'userId': userId,
      'tripId': tripId,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<GeneralResponse>(Options(
      method: 'PUT',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/drivers/offers/accept',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GeneralResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GeneralResponse> tripSummary(
    userId,
    tripId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'userId': userId,
      'tripId': tripId,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<GeneralResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/drivers/trip-summary',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GeneralResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LookupsModel> getLookups() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<LookupsModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/lookups',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LookupsModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LogoutModel> logout(
    userId,
    registrationId,
    language,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'userId': userId,
      'registrationId': registrationId,
      'language': language,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<LogoutModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/drivers/logout',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LogoutModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseResponse> changeTripStatus(
    userId,
    tripId,
    tripStatus,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'userId': userId,
      'tripId': tripId,
      'tripStatus': tripStatus,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/drivers/trips/change-status',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
