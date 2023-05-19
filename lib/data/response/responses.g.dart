// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse _$BaseResponseFromJson(Map<String, dynamic> json) => BaseResponse()
  ..success = json['success'] as bool?
  ..message = json['message'] as String?
  ..dateTime = json['dateTime'] as String?
  ..result = json['result'] as Map<String, dynamic>?
  ..errorCode = json['errorCode'] as String?;

Map<String, dynamic> _$BaseResponseToJson(BaseResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'dateTime': instance.dateTime,
      'result': instance.result,
      'errorCode': instance.errorCode,
    };

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['mobile'] as String?,
      json['email'] as String?,
      json['gender'] as String?,
      json['dateOfBirth'] as String?,
      json['token'] as String?,
      json['tokenExpirationTime'] as String?,
      json['userDevice'] == null
          ? null
          : UserDeviceResponse.fromJson(
              json['userDevice'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..message = json['message'] as String?
      ..dateTime = json['dateTime'] as String?
      ..result = json['result'] as Map<String, dynamic>?
      ..errorCode = json['errorCode'] as String?;

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'dateTime': instance.dateTime,
      'result': instance.result,
      'errorCode': instance.errorCode,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'mobile': instance.mobile,
      'email': instance.email,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth,
      'token': instance.token,
      'tokenExpirationTime': instance.tokenExpirationTime,
      'userDevice': instance.userDevice,
    };

UserDeviceResponse _$UserDeviceResponseFromJson(Map<String, dynamic> json) =>
    UserDeviceResponse(
      json['id'] as int?,
      json['registrationId'] as String?,
      json['deviceOs'] as String?,
      json['appVersion'] as String?,
      json['userId'] as int?,
    );

Map<String, dynamic> _$UserDeviceResponseToJson(UserDeviceResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'registrationId': instance.registrationId,
      'deviceOs': instance.deviceOs,
      'appVersion': instance.appVersion,
      'userId': instance.userId,
    };

CustomerResponse _$CustomerResponseFromJson(Map<String, dynamic> json) =>
    CustomerResponse(
      json['id'] as String?,
      json['name'] as String?,
      json['numOfNotifications'] as int?,
    );

Map<String, dynamic> _$CustomerResponseToJson(CustomerResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'numOfNotifications': instance.numOfNotifications,
    };

ContactsResponse _$ContactsResponseFromJson(Map<String, dynamic> json) =>
    ContactsResponse(
      json['phone'] as String?,
      json['email'] as String?,
      json['link'] as String?,
    );

Map<String, dynamic> _$ContactsResponseToJson(ContactsResponse instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'email': instance.email,
      'link': instance.link,
    };

AuthenticationResponse _$AuthenticationResponseFromJson(
        Map<String, dynamic> json) =>
    AuthenticationResponse(
      json['customer'] == null
          ? null
          : CustomerResponse.fromJson(json['customer'] as Map<String, dynamic>),
      json['contacts'] == null
          ? null
          : ContactsResponse.fromJson(json['contacts'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..message = json['message'] as String?
      ..dateTime = json['dateTime'] as String?
      ..result = json['result'] as Map<String, dynamic>?
      ..errorCode = json['errorCode'] as String?;

Map<String, dynamic> _$AuthenticationResponseToJson(
        AuthenticationResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'dateTime': instance.dateTime,
      'result': instance.result,
      'errorCode': instance.errorCode,
      'customer': instance.customer,
      'contacts': instance.contacts,
    };

ForgotPasswordResponse _$ForgotPasswordResponseFromJson(
        Map<String, dynamic> json) =>
    ForgotPasswordResponse(
      json['support'] as String?,
    )
      ..success = json['success'] as bool?
      ..message = json['message'] as String?
      ..dateTime = json['dateTime'] as String?
      ..result = json['result'] as Map<String, dynamic>?
      ..errorCode = json['errorCode'] as String?;

Map<String, dynamic> _$ForgotPasswordResponseToJson(
        ForgotPasswordResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'dateTime': instance.dateTime,
      'result': instance.result,
      'errorCode': instance.errorCode,
      'support': instance.support,
    };

ServiceResponse _$ServiceResponseFromJson(Map<String, dynamic> json) =>
    ServiceResponse(
      json['id'] as int?,
      json['title'] as String?,
      json['image'] as String?,
    );

Map<String, dynamic> _$ServiceResponseToJson(ServiceResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image': instance.image,
    };

BannersResponse _$BannersResponseFromJson(Map<String, dynamic> json) =>
    BannersResponse(
      json['id'] as int?,
      json['title'] as String?,
      json['image'] as String?,
      json['link'] as String?,
    );

Map<String, dynamic> _$BannersResponseToJson(BannersResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image': instance.image,
      'link': instance.link,
    };

StoreResponse _$StoreResponseFromJson(Map<String, dynamic> json) =>
    StoreResponse(
      json['id'] as int?,
      json['title'] as String?,
      json['image'] as String?,
    );

Map<String, dynamic> _$StoreResponseToJson(StoreResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image': instance.image,
    };

HomeDataResponse _$HomeDataResponseFromJson(Map<String, dynamic> json) =>
    HomeDataResponse(
      (json['services'] as List<dynamic>?)
          ?.map((e) => ServiceResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['banners'] as List<dynamic>?)
          ?.map((e) => BannersResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['stores'] as List<dynamic>?)
          ?.map((e) => StoreResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeDataResponseToJson(HomeDataResponse instance) =>
    <String, dynamic>{
      'services': instance.services,
      'banners': instance.banners,
      'stores': instance.stores,
    };

HomeResponse _$HomeResponseFromJson(Map<String, dynamic> json) => HomeResponse(
      json['data'] == null
          ? null
          : HomeDataResponse.fromJson(json['data'] as Map<String, dynamic>),
    )
      ..success = json['success'] as bool?
      ..message = json['message'] as String?
      ..dateTime = json['dateTime'] as String?
      ..result = json['result'] as Map<String, dynamic>?
      ..errorCode = json['errorCode'] as String?;

Map<String, dynamic> _$HomeResponseToJson(HomeResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'dateTime': instance.dateTime,
      'result': instance.result,
      'errorCode': instance.errorCode,
      'data': instance.data,
    };

StoreDetailsResponse _$StoreDetailsResponseFromJson(
        Map<String, dynamic> json) =>
    StoreDetailsResponse(
      json['id'] as int?,
      json['title'] as String?,
      json['image'] as String?,
      json['details'] as String?,
      json['services'] as String?,
      json['about'] as String?,
    )
      ..success = json['success'] as bool?
      ..message = json['message'] as String?
      ..dateTime = json['dateTime'] as String?
      ..result = json['result'] as Map<String, dynamic>?
      ..errorCode = json['errorCode'] as String?;

Map<String, dynamic> _$StoreDetailsResponseToJson(
        StoreDetailsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'dateTime': instance.dateTime,
      'result': instance.result,
      'errorCode': instance.errorCode,
      'id': instance.id,
      'title': instance.title,
      'image': instance.image,
      'details': instance.details,
      'services': instance.services,
      'about': instance.about,
    };
