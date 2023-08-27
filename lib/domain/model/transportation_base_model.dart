import 'dart:convert';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:taxi_for_you/domain/model/trip_model.dart';

import '../../utils/helpers/double_prase.dart';

class TransportationBaseModel {
  int? tripId;
  String? tripEndPoint;
  String? tripType;
  String? tripNumber;
  String? tripStatus;
  TransportationLocation pickupLocation = TransportationLocation();
  TransportationLocation destinationLocation = TransportationLocation();
  String? creationDate;
  String? date;
  String? stringDate;
  String? notes;
  double? paymentValue;
  List<ImageModel>? images;
  AcceptedOffer? acceptedOffer;
  List<Offer>? offers;
  Passenger? passenger;
  double? clientOffer;
  String? completionDate;
  double? passengerRating;
  double? driverRating;

  TransportationBaseModel();

  fromJSON(Map<String, dynamic> json) {
    tripId = json['id'] is String ? int.parse(json['id']) : json['id'];
    tripEndPoint = json['tripEndPoint'];
    tripType = json['tripType'];
    tripNumber = json['tripNumber'];
    passenger = Passenger.fromJson(json['passenger']);
    tripStatus = json['tripStatus'];
    creationDate = json['creationDate'];
    stringDate = json['stringDate'];
    date = json['date'];
    notes = json['notes'];
    completionDate = json['completionDate'];
    passengerRating = json['passengerRating'];
    driverRating = json['driverRating'];
    images = json['images'] != null
        ? List<ImageModel>.from(json['images'].map((x) => ImageModel.fromJson(x)))
        : null;
    clientOffer =
        json["clientOffer"] != null ? json["clientOffer"]?.toDouble() : null;
    paymentValue = (json['clientOffer'] != null)
        ? dynamicToDouble(json['clientOffer'])
        : null;
    pickupLocation = json['pickupLocation'] == null
        ? TransportationLocation()
        : TransportationLocation.fromJson(json['pickupLocation'] is String
            ? jsonDecode(json['pickupLocation'])
            : json['pickupLocation']);
    destinationLocation = json['destination'] == null
        ? TransportationLocation()
        : TransportationLocation.fromJson(json['destination'] is String
            ? jsonDecode(json['destination'])
            : json['destination']);
    offers = json["offers"] != null
        ? List<Offer>.from(json["offers"].map((x) => Offer.fromJson(x)))
        : [];
    if (json['acceptedOffer'] != null) {
      acceptedOffer = AcceptedOffer.fromJson(json['acceptedOffer']);
    }
    return this;
  }

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> data = <String, dynamic>{};
    if (tripId != null) data['id'] = tripId.toString();
    if (creationDate != null) data['creationDate'] = creationDate;
    if (stringDate != null) data['stringDate'] = stringDate;
    if (date != null) data['date'] = date;
    if (notes != null) data['notes'] = notes;
    if (completionDate != null) data['completionDate'] = notes;
    if (passengerRating != null) data['passengerRating'] = notes;
    if (driverRating != null) data['driverRating'] = notes;
    if (passenger != null) data['passenger'] = notes;
    if (images != null) data['images'] = images;
    if (clientOffer != null) data['clientOffer'] = clientOffer;
    if (paymentValue != null) data['clientOffer'] = paymentValue.toString();
    if (pickupLocation.latitude != null && pickupLocation.longitude != null) {
      data['pickupLocation'] = json.encode(pickupLocation.toJson());
    }
    if (destinationLocation.latitude != null &&
        destinationLocation.longitude != null) {
      data['destination'] = json.encode(destinationLocation.toJson());
    }
    if (tripType != null) data['tripType'] = tripType;
    if (tripNumber != null) data['tripNumber'] = tripNumber;
    if (tripStatus != null) data['tripStatus'] = tripStatus;
    return data;
  }
}

class TransportationLocation {
  String? locationName;
  double? latitude;
  double? longitude;

  TransportationLocation();

  TransportationLocation.fromJson(Map<String, dynamic> json) {
    locationName = json['locationName'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};

    data['locationName'] = locationName;
    data['latitude'] = latitude;
    data['longitude'] = longitude;

    return data;
  }

  TransportationLocation copyWith(TransportationLocation location) {
    TransportationLocation transportationLocation = TransportationLocation();

    transportationLocation.locationName = location.locationName;
    transportationLocation.longitude = location.longitude;
    transportationLocation.latitude = location.latitude;

    return transportationLocation;
  }
}

class Passenger {
  int id;
  String firstName;
  String lastName;
  String mobile;
  String email;
  String gender;
  String dateOfBirth;
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
        id: json["id"] ?? -1,
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? " ",
        mobile: json["mobile"],
        email: json["email"] ?? "",
        gender: json["gender"] ?? "",
        dateOfBirth: json["dateOfBirth"] ?? "",
        rating: json["rating"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
        "email": email,
        "gender": gender,
        "dateOfBirth": dateOfBirth,
        "rating": rating,
      };
}

class ImageModel {
  int id;
  String imageName;
  String url;

  ImageModel({
    required this.id,
    required this.imageName,
    required this.url,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        id: json["id"],
        imageName: json["imageName"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "imageName": imageName,
        "url": url,
      };
}
