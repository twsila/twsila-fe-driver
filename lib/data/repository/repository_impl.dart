import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taxi_for_you/data/mapper/driver.dart';
import 'package:taxi_for_you/data/mapper/mapper.dart';
import 'package:taxi_for_you/data/response/responses.dart';
import 'package:taxi_for_you/domain/model/ServiceTypeModel.dart';
import 'package:taxi_for_you/domain/model/car_brand_models_model.dart';
import 'package:taxi_for_you/domain/model/generate_otp_model.dart';
import 'package:taxi_for_you/domain/model/vehicleModel.dart';
import 'package:taxi_for_you/utils/helpers/cast_helpers.dart';

import '../../domain/model/driver_model.dart';
import '../../domain/model/models.dart';
import '../../domain/model/verify_otp_model.dart';
import '../../domain/repository/repository.dart';
import '../data_source/local_data_source.dart';
import '../data_source/remote_data_source.dart';
import '../network/error_handler.dart';
import '../network/failure.dart';
import '../network/network_info.dart';
import '../network/requests.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final FirebaseAuth auth = FirebaseAuth.instance;

  RepositoryImpl(
      this._remoteDataSource, this._networkInfo, this._localDataSource);

  @override
  Future<Either<Failure, Driver>> login(LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        var response = await _remoteDataSource.login(loginRequest);

        if (response.success == ApiInternalStatus.SUCCESS) {
          // success
          // return either right
          // return data
          //save driver data
          await _localDataSource
              .saveDriverToCache(Driver.fromJson(response.result!));
          return Right(LoginResponse.fromJson(response.result!).toDomain());
        } else {
          // failure --return business error
          // return either left
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, Authentication>> register(
      RegisterRequest registerRequest) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.register(registerRequest);

        if (response.success == ApiInternalStatus.SUCCESS) {
          // success
          // return either right
          // return data
          return Right(response.toDomain());
        } else {
          // failure --return business error
          // return either left
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, HomeObject>> getHomeData() async {
    try {
      // get response from cache
      final response = await _localDataSource.getHomeData();
      return Right(response.toDomain());
    } catch (cacheError) {
      // cache is not existing or cache is not valid

      // its the time to get from API side
      if (await _networkInfo.isConnected) {
        // its connected to internet, its safe to call API
        try {
          final response = await _remoteDataSource.getHomeData();

          if (response.success == ApiInternalStatus.SUCCESS) {
            // success
            // return either right
            // return data
            // save home response to cache

            // save response in cache (local data source)
            _localDataSource.saveHomeToCache(response);

            return Right(response.toDomain());
          } else {
            // failure --return business error
            // return either left
            return Left(Failure(ApiInternalStatus.FAILURE,
                response.message ?? ResponseMessage.DEFAULT));
          }
        } catch (error) {
          return Left(ErrorHandler.handle(error).failure);
        }
      } else {
        // return internet connection error
        // return either left
        return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
      }
    }
  }

  @override
  Future<Either<Failure, FirebaseCodeSent>> verifyFirebaseOtp(
      VerifyOTPRequest firebaseOTPRequest) async {
    // Create a PhoneAuthCredential with the code

    if (await _networkInfo.isConnected) {
      try {
        // PhoneAuthCredential credential = PhoneAuthProvider.credential(
        //     verificationId: VerifyOTPViewModel.firebaseCodeSent.verificationId,
        //     smsCode: firebaseOTPRequest.code);
        // Sign the user in (or link) with the credential
        // await auth.signInWithCredential(credential);

        return Right(FirebaseCodeSent("", 0));
      } catch (error) {
        return Left(DataSource.WRON_OTP.getFailure());
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) {
    // TODO: implement forgotPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, StoreDetails>> getStoreDetails() {
    // TODO: implement getStoreDetails
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, GenerateOtpModel>> generateOtp(
      GenerateOTPRequest otpRequest) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.generateOtp(otpRequest);

        if (response.success == ApiInternalStatus.SUCCESS) {
          // success
          // return either right
          // return data
          return Right(response);
        } else {
          // failure --return business error
          // return either left
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, VerifyOtpModel>> verifyOtp(
      VerifyOTPRequest verifyOTPRequest) async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.verifyOtp(verifyOTPRequest);

        if (response.success == ApiInternalStatus.SUCCESS) {
          // success
          // return either right
          // return data
          return Right(response);
        } else {
          // failure --return business error
          // return either left
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, List<ServiceTypeModel>>>
      registrationServiceTypes() async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.registrationServicesType();

        if (response.success == ApiInternalStatus.SUCCESS) {
          List<ServiceTypeModel> servicesList = [];

          response.result.forEach((key, value) {
            List<VehicleModel> x = List<VehicleModel>.from(
                value.map((x) => VehicleModel.fromJson(x)));

            servicesList.add(ServiceTypeModel(key, x));
          });

          return Right(servicesList);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, List<CarModel>>> carBrandsAndModels() async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.carBrandAndModel();

        if (response.success == ApiInternalStatus.SUCCESS) {


          return Right(response.result);
        } else {
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
