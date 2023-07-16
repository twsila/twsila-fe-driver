import 'dart:async';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:taxi_for_you/domain/model/trip_model.dart';
import 'package:taxi_for_you/presentation/common/widgets/custom_text_button.dart';
import 'package:taxi_for_you/presentation/google_maps/model/location_model.dart';
import 'package:taxi_for_you/presentation/trip_execution/helper/location_helper.dart';
import 'package:taxi_for_you/presentation/trip_execution/view/widgets/customer_info_draggable.dart';
import 'package:taxi_for_you/utils/resources/assets_manager.dart';
import 'package:taxi_for_you/utils/resources/font_manager.dart';
import 'dart:ui' as ui;
import '../../../app/app_prefs.dart';
import '../../../app/constants.dart';
import '../../../app/di.dart';
import '../../../utils/resources/color_manager.dart';
import '../../../utils/resources/langauge_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../../utils/resources/values_manager.dart';
import '../../common/widgets/custom_stepper.dart';
import '../../google_maps/model/maps_repo.dart';
import '../../trip_details/widgets/dotted_seperator.dart';

class TrackingPage extends StatefulWidget {
  TripModel tripModel;

  TrackingPage({Key? key, required this.tripModel}) : super(key: key);

  @override
  State<TrackingPage> createState() => TrackingPageState();
}

class TrackingPageState extends State<TrackingPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
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
    return Scaffold(
      body: currentLocation == null
          ? Center(
              child: Text(
              AppStrings.loadingMaps.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ColorManager.headersTextColor,
                  fontSize: FontSize.s14,
                  fontWeight: FontWeight.bold),
            ))
          : ExpandableBottomSheet(
              animationCurveExpand: Curves.easeInToLinear,
              enableToggle: true,
              background: _mapWidget(),
              persistentHeader: CustomerInfoHeader(
                tripModel: widget.tripModel,
              ),
              expandableContent: _bottomInfoWidget(),
            ),
    );
  }

  Widget _mapWidget() {
    return Container(
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

  Widget _bottomInfoWidget() {
    return Wrap(children: [
      Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          color: ColorManager.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_fromToWidget()],
          )),
    ]);
  }

  Widget _fromToWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: AppSize.s8,
                  ),
                  Icon(
                    Icons.check_circle_rounded,
                    color: ColorManager.primary,
                  ),
                  Container(
                    height: AppSize.s36,
                    child: DashLineView(
                      fillRate: .88,
                      direction: Axis.vertical,
                    ),
                  ),
                  SvgPicture.asset(ImageAssets.locationPinTripDetailsIc)
                ],
              ),
              SizedBox(
                width: AppSize.s10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${AppStrings.from.tr()} Giza ",
                          overflow: TextOverflow.clip,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: ColorManager.headersTextColor,
                                  fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "الوقت المتوقع 15 دقيقة",
                          overflow: TextOverflow.clip,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: ColorManager.headersTextColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSize.s18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${AppStrings.to.tr()} Haram",
                          overflow: TextOverflow.clip,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: ColorManager.headersTextColor,
                                  fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "الوقت المتوقع 5 دقيقة",
                          overflow: TextOverflow.clip,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: ColorManager.headersTextColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          CustomTextButton(
            text: 'الاتصال بالعميل',
            isWaitToEnable: false,
            icon: Icon(
              Icons.call,
              color: ColorManager.white,
            ),
          )
        ],
      ),
    );
  }
}

class NavigationTrackingArguments {
  TripModel tripModel;

  NavigationTrackingArguments(this.tripModel);
}
