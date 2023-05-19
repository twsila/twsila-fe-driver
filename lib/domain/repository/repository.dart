import 'package:dartz/dartz.dart';
import 'package:taxi_for_you/domain/model/driver_model.dart';

import '../../data/network/failure.dart';
import '../../data/network/requests.dart';
import '../model/models.dart';

abstract class Repository {
  Future<Either<Failure, Driver>> login(LoginRequest loginRequest);

  Future<Either<Failure, String>> forgotPassword(String email);

  Future<Either<Failure, Authentication>> register(
      RegisterRequest registerRequest);

  Future<Either<Failure, HomeObject>> getHomeData();

  Future<Either<Failure, StoreDetails>> getStoreDetails();


  Future<Either<Failure, FirebaseCodeSent>> generateFirebaseOtp(GenerateFirebaseOTPRequest firebaseOTPRequest);

  Future<Either<Failure, FirebaseCodeSent>> verifyFirebaseOtp(VerifyFirebaseOTPRequest verifyFirebaseOTPRequest);


}
