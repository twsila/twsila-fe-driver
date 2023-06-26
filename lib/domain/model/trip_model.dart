// To parse this JSON data, do
//
//     final tripModel = tripModelFromJson(jsonString);

import 'dart:convert';

TripModel tripModelFromJson(String str) => TripModel.fromJson(json.decode(str));

String tripModelToJson(TripModel data) => json.encode(data.toJson());

class TripModelResponse {
  bool success;
  dynamic message;
  String dateTime;
  List<TripModel> result;

  TripModelResponse({
    required this.success,
    this.message,
    required this.dateTime,
    required this.result,
  });

  factory TripModelResponse.fromJson(Map<String, dynamic> json) =>
      TripModelResponse(
        success: json["success"],
        message: json["message"],
        dateTime: json["dateTime"],
        result: List<TripModel>.from(
            json["result"].map((x) => TripModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "dateTime": dateTime,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

class TripModel {
  int id;
  Ation pickupLocation;
  Ation destination;
  TripStatus tripStatus;
  String tripType;
  String? date;
  dynamic tripNumber;
  Passenger passenger;
  String? notes;
  double clientOffer;
  List<TripImage> images;
  bool? containsPacking;
  bool? containsLoading;
  bool? containsLift;
  double? payloadWeight;
  FrozenMaterial? materialDetails;
  FrozenMaterial? packingDetails;
  bool? containsBoxes;
  String? shippingType;
  FrozenMaterial? frozenMaterial;
  TankDetails? tankDetails;
  String? tankType;
  bool? containsAssemble;
  String? furnitureItems;

  TripModel({
    required this.id,
    required this.pickupLocation,
    required this.destination,
    required this.tripStatus,
    required this.tripType,
    required this.date,
    this.tripNumber,
    required this.passenger,
    this.notes,
    required this.clientOffer,
    required this.images,
    this.containsPacking,
    this.containsLoading,
    this.containsLift,
    this.payloadWeight,
    this.materialDetails,
    this.packingDetails,
    this.containsBoxes,
    this.shippingType,
    this.frozenMaterial,
    this.tankDetails,
    this.tankType,
    this.containsAssemble,
    this.furnitureItems,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) => TripModel(
        id: json["id"],
        pickupLocation: Ation.fromJson(json["pickupLocation"]),
        destination: Ation.fromJson(json["destination"]),
        tripStatus: tripStatusValues.map[json["tripStatus"]]!,
        tripType: json["tripType"],
        date: json["date"] != null ? json["date"] : null,
        tripNumber: json["tripNumber"] ?? "",
        passenger: Passenger.fromJson(json["passenger"]),
        notes: json["notes"] != null ? json["notes"] : null,
        clientOffer: json["clientOffer"]?.toDouble(),
        images: List<TripImage>.from(json["images"].map((x) => TripImage.fromJson(x))),
        containsPacking: json["containsPacking"],
        containsLoading: json["containsLoading"],
        containsLift: json["containsLift"],
        payloadWeight: json["payloadWeight"]?.toDouble(),
        materialDetails: json["materialDetails"] == null
            ? null
            : FrozenMaterial.fromJson(json["materialDetails"]),
        packingDetails: json["packingDetails"] == null
            ? null
            : FrozenMaterial.fromJson(json["packingDetails"]),
        containsBoxes: json["containsBoxes"],
        shippingType: json["shippingType"],
        frozenMaterial: json["frozenMaterial"] == null
            ? null
            : FrozenMaterial.fromJson(json["frozenMaterial"]),
        tankDetails: json["tankDetails"] == null
            ? null
            : TankDetails.fromJson(json["tankDetails"]),
        tankType: json["tankType"],
        containsAssemble: json["containsAssemble"],
        furnitureItems: json["furnitureItems"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pickupLocation": pickupLocation.toJson(),
        "destination": destination.toJson(),
        "tripStatus": tripStatusValues.reverse[tripStatus],
        "tripType": tripType,
        "date": date,
        "tripNumber": tripNumber,
        "passenger": passenger.toJson(),
        "notes": notes,
        "clientOffer": clientOffer,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "containsPacking": containsPacking,
        "containsLoading": containsLoading,
        "containsLift": containsLift,
        "payloadWeight": payloadWeight,
        "materialDetails": materialDetails?.toJson(),
        "packingDetails": packingDetails?.toJson(),
        "containsBoxes": containsBoxes,
        "shippingType": shippingType,
        "frozenMaterial": frozenMaterial?.toJson(),
        "tankDetails": tankDetails?.toJson(),
        "tankType": tankType,
        "containsAssemble": containsAssemble,
        "furnitureItems": furnitureItems,
      };
}



class Ation {
  double latitude;
  double longitude;
  String locationName;

  Ation({
    required this.latitude,
    required this.longitude,
    required this.locationName,
  });

  factory Ation.fromJson(Map<String, dynamic> json) => Ation(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        locationName: json["locationName"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "locationName": locationName,
      };
}

class FrozenMaterial {
  int id;
  String description;

  FrozenMaterial({
    required this.id,
    required this.description,
  });

  factory FrozenMaterial.fromJson(Map<String, dynamic> json) => FrozenMaterial(
        id: json["id"],
        description: json["description"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description":description,
      };
}




class TripImage {
  int id;
  String imageName;

  TripImage({
    required this.id,
    required this.imageName,
  });

  factory TripImage.fromJson(Map<String, dynamic> json) => TripImage(
        id: json["id"],
        imageName: json["imageName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "imageName": imageName,
      };
}

class Passenger {
  int id;
  FirstName firstName;
  LastName lastName;
  String mobile;
  Email email;
  Gender gender;
  DateOfBirth dateOfBirth;
  double rating;

  Passenger({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.email,
    required this.gender,
    required this.dateOfBirth,
    required this.rating,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) => Passenger(
        id: json["id"],
        firstName: firstNameValues.map[json["firstName"]]!,
        lastName: lastNameValues.map[json["lastName"]]!,
        mobile: json["mobile"],
        email: emailValues.map[json["email"]]!,
        gender: genderValues.map[json["gender"]]!,
        dateOfBirth: dateOfBirthValues.map[json["dateOfBirth"]]!,
        rating: json["rating"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstNameValues.reverse[firstName],
        "lastName": lastNameValues.reverse[lastName],
        "mobile": mobile,
        "email": emailValues.reverse[email],
        "gender": genderValues.reverse[gender],
        "dateOfBirth": dateOfBirthValues.reverse[dateOfBirth],
        "rating": rating,
      };
}

enum DateOfBirth { THE_02011980, THE_26122022 }

final dateOfBirthValues = EnumValues({
  "02/01/1980": DateOfBirth.THE_02011980,
  "26/12/2022": DateOfBirth.THE_26122022
});

enum Email { GAMALELSAWY_GMAIL_COM, A_A_COM }

final emailValues = EnumValues({
  "a@a.com": Email.A_A_COM,
  "gamalelsawy@gmail.com": Email.GAMALELSAWY_GMAIL_COM
});

enum FirstName { AMIR }

final firstNameValues = EnumValues({"amir": FirstName.AMIR});

enum Gender { M }

final genderValues = EnumValues({"M": Gender.M});

enum LastName { SAMAIR, SAMIR }

final lastNameValues =
    EnumValues({"samair": LastName.SAMAIR, "samir": LastName.SAMIR});

class TankDetails {
  int id;
  int size;

  TankDetails({
    required this.id,
    required this.size,
  });

  factory TankDetails.fromJson(Map<String, dynamic> json) => TankDetails(
        id: json["id"],
        size: json["size"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "size": size,
      };
}

enum TripStatus { DRAFT, COMPLETED }

final tripStatusValues =
    EnumValues({"COMPLETED": TripStatus.COMPLETED, "DRAFT": TripStatus.DRAFT});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
