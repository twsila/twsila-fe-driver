import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:taxi_for_you/presentation/google_maps/model/location_model.dart';
import 'package:taxi_for_you/presentation/trip_execution/helper/location_helper.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'dart:ui' as ui;

import '../../../../app/constants.dart';
import '../../../../domain/model/trip_model.dart';
import '../../../../utils/resources/color_manager.dart';
import '../../../../utils/resources/font_manager.dart';
import '../../../../utils/resources/strings_manager.dart';
import '../../../google_maps/model/maps_repo.dart';

class MapWidget extends StatefulWidget {
  TripModel tripModel;
  MapWidget({required this.tripModel});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {


  int _index = 0;
  GoogleMapController? mapController;
  static const LatLng sourceLocation = LatLng(30.037628, 31.355374);
  static const LatLng destination = LatLng(30.044796, 31.340440);
  MapsRepo mapsRepo = MapsRepo();
  Duration oneSec = Duration(seconds: 2);
  late Timer _timer;
  late double distanceBetweenCurrentAndSource;
  late CompassEvent _driverDirection;

  List<LatLng> polylineCoordinates = [];

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> setCustomMarkerIcon() async {
    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2, size: Size(10, 10)),
        ImageAssets.locationPin)
        .then(
          (icon) {
        sourceIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, ImageAssets.locationPin)
        .then(
          (icon) {
        destinationIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2, size: Size(10, 10)),
        ImageAssets.driverCar)
        .then(
          (icon) {
        currentLocationIcon = icon;
      },
    );
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Constants.GOOGLE_API_KEY, // Your Google Map Key
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
            (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  LocationModel? currentLocation;

  void getCurrentLocation() async {
    currentLocation = await mapsRepo.getUserCurrentLocation();
    distanceBetweenCurrentAndSource = LocationHelper()
        .distanceBetweenTwoLocationInMeters(
        lat1: currentLocation!.latitude,
        long1: currentLocation!.longitude,
        lat2: sourceLocation.latitude,
        long2: sourceLocation.longitude);
    LocationHelper().getArrivalTimeFromCurrentToLocation(
        currentLocation: currentLocation!,
        destinationLocation: LocationModel(
            locationName: '',
            latitude: sourceLocation.latitude,
            longitude: sourceLocation.longitude));
    print(
        "distance between current and source ${distanceBetweenCurrentAndSource}");
    setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> animateCameraToLatLong(double latitude, double longitude) async {
    mapController?.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(currentLocation!.latitude, currentLocation!.longitude), 17));
    setState(() {});
  }


  @override
  void initState() {
    setCustomMarkerIcon();
    _timer = Timer.periodic(oneSec, (Timer t) async {
      getCurrentLocation();
    });
    getPolyPoints();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  currentLocation == null
        ? Center(
        child: Text(
          AppStrings.loadingMaps.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: ColorManager.headersTextColor,
              fontSize: FontSize.s14,
              fontWeight: FontWeight.bold),
        ))
        : Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(currentLocation!.latitude, currentLocation!.longitude),
          zoom: 13.5,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("currentLocation"),
            icon: currentLocationIcon,
            // rotation: _driverDirection.heading!,
            position:
            LatLng(currentLocation!.latitude, currentLocation!.longitude!),
          ),
          Marker(
            markerId: MarkerId("source"),
            icon: sourceIcon,
            position: sourceLocation,
          ),
          Marker(
            markerId: MarkerId("destination"),
            icon: destinationIcon,
            position: destination,
          ),
        },
        onMapCreated: _onMapCreated,
        polylines: {
          Polyline(
            polylineId: const PolylineId("route"),
            points: polylineCoordinates,
            color: ColorManager.headersTextColor,
            width: 6,
          ),
        },
      ),
    );
  }
}
