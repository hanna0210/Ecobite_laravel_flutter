import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/view_models/taxi/taxi.vm.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supercharged/supercharged.dart';
import 'package:fuodz/services/taxi/mapbox_directions.service.dart';

class TaxiPolylinesService {
  TaxiViewModel taxiViewModel;
  TaxiPolylinesService(this.taxiViewModel);
  //
  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
  StreamSubscription? tripUpdateStream;
  StreamSubscription? locationStreamSubscription;

  //
  DeliveryAddress? pickupLocation;
  DeliveryAddress? dropoffLocation;
  LatLng? driverPosition;
  final pickupMarkerId = MarkerId('sourcePin');
  final dropoffMarkerId = MarkerId('destPin');

  //plylines
  drawTripPolyLines() async {
    //setting up latlng
    pickupLocation = DeliveryAddress(
      latitude:
          taxiViewModel.onGoingOrderTrip!.taxiOrder!.pickupLatitude.toDouble(),
      longitude:
          taxiViewModel.onGoingOrderTrip!.taxiOrder!.pickupLongitude.toDouble(),
      address: taxiViewModel.onGoingOrderTrip!.taxiOrder!.pickupAddress,
    );
    //
    dropoffLocation = DeliveryAddress(
      latitude:
          taxiViewModel.onGoingOrderTrip!.taxiOrder!.dropoffLatitude.toDouble(),
      longitude: taxiViewModel.onGoingOrderTrip!.taxiOrder!.dropoffLongitude
          .toDouble(),
      address: taxiViewModel.onGoingOrderTrip!.taxiOrder!.dropoffAddress,
    );

    // source pin
    taxiViewModel.taxiGoogleMapManagerService.clearMapMarkers();
    taxiViewModel.taxiGoogleMapManagerService.gMapMarkers.add(
      Marker(
        markerId: pickupMarkerId,
        position: LatLng(
          pickupLocation?.latitude ?? 0.00,
          pickupLocation?.longitude ?? 0.00,
        ),
        icon: taxiViewModel.taxiGoogleMapManagerService.sourceIcon!,
        anchor: Offset(0.5, 0.5),
      ),
    );
    // destination pin

    taxiViewModel.taxiGoogleMapManagerService.gMapMarkers.add(
      Marker(
        markerId: dropoffMarkerId,
        position: LatLng(
          dropoffLocation!.latitude!,
          dropoffLocation!.longitude!,
        ),
        icon: taxiViewModel.taxiGoogleMapManagerService.destinationIcon!,
        anchor: Offset(0.5, 0.5),
      ),
    );
    //load the polylines
    final routePoints = await MapboxDirectionsService.getRoute(
      origin: LatLng(
        pickupLocation!.latitude!,
        pickupLocation!.longitude!,
      ),
      destination: LatLng(
        dropoffLocation!.latitude!,
        dropoffLocation!.longitude!,
      ),
    );
    taxiViewModel.taxiGoogleMapManagerService.polylineCoordinates.clear();
    if (routePoints.isNotEmpty) {
      taxiViewModel.taxiGoogleMapManagerService.polylineCoordinates
          .addAll(routePoints);
    } else {
      taxiViewModel.taxiGoogleMapManagerService.polylineCoordinates.addAll([
        LatLng(pickupLocation!.latitude!, pickupLocation!.longitude!),
        LatLng(dropoffLocation!.latitude!, dropoffLocation!.longitude!),
      ]);
    }

    // with an id, an RGB color and the list of LatLng pairs
    Polyline polyline = Polyline(
      polylineId: PolylineId("poly"),
      color: AppColor.primaryColor,
      points: taxiViewModel.taxiGoogleMapManagerService.polylineCoordinates,
      width: 5,
    );
//
    taxiViewModel.taxiGoogleMapManagerService.gMapPolylines = {};
    taxiViewModel.taxiGoogleMapManagerService.gMapPolylines.add(polyline);
    taxiViewModel.notifyListeners();
  }

  drawPolyLinesToPickup() async {
    //setting up latlng
    pickupLocation = DeliveryAddress(
      latitude:
          taxiViewModel.taxiLocationService.driverMarker!.position.latitude,
      longitude:
          taxiViewModel.taxiLocationService.driverMarker!.position.longitude,
      address: taxiViewModel.onGoingOrderTrip!.taxiOrder!.pickupAddress,
    );
    //
    dropoffLocation = DeliveryAddress(
      latitude:
          taxiViewModel.onGoingOrderTrip!.taxiOrder!.pickupLatitude.toDouble(),
      longitude:
          taxiViewModel.onGoingOrderTrip!.taxiOrder!.pickupLongitude.toDouble(),
      address: taxiViewModel.onGoingOrderTrip!.taxiOrder!.pickupAddress,
    );

    // source pin
    taxiViewModel.taxiGoogleMapManagerService.clearMapMarkers();
    taxiViewModel.taxiGoogleMapManagerService.gMapMarkers.add(
      Marker(
        markerId: pickupMarkerId,
        position: LatLng(
          pickupLocation!.latitude!,
          pickupLocation!.longitude!,
        ),
        icon: taxiViewModel.taxiGoogleMapManagerService.sourceIcon!,
        anchor: Offset(0.5, 0.5),
      ),
    );
    // destination pin

    taxiViewModel.taxiGoogleMapManagerService.gMapMarkers.add(
      Marker(
        markerId: dropoffMarkerId,
        position: LatLng(
          dropoffLocation!.latitude!,
          dropoffLocation!.longitude!,
        ),
        icon: taxiViewModel.taxiGoogleMapManagerService.destinationIcon!,
        anchor: Offset(0.5, 0.5),
      ),
    );
    final routePoints = await MapboxDirectionsService.getRoute(
      origin: LatLng(
        pickupLocation!.latitude!,
        pickupLocation!.longitude!,
      ),
      destination: LatLng(
        dropoffLocation!.latitude!,
        dropoffLocation!.longitude!,
      ),
    );
    taxiViewModel.taxiGoogleMapManagerService.polylineCoordinates.clear();
    if (routePoints.isNotEmpty) {
      taxiViewModel.taxiGoogleMapManagerService.polylineCoordinates
          .addAll(routePoints);
    } else {
      taxiViewModel.taxiGoogleMapManagerService.polylineCoordinates.addAll([
        LatLng(pickupLocation!.latitude!, pickupLocation!.longitude!),
        LatLng(dropoffLocation!.latitude!, dropoffLocation!.longitude!),
      ]);
    }

    // with an id, an RGB color and the list of LatLng pairs
    Polyline polyline = Polyline(
      polylineId: PolylineId("poly"),
      color: AppColor.primaryColor,
      points: taxiViewModel.taxiGoogleMapManagerService.polylineCoordinates,
      width: 5,
    );
//
    taxiViewModel.taxiGoogleMapManagerService.gMapPolylines = {};
    taxiViewModel.taxiGoogleMapManagerService.gMapPolylines.add(polyline);
    taxiViewModel.notifyListeners();
  }

  //
  Future<void> updateCameraLocation(
    LatLng source,
    LatLng destination,
    GoogleMapController? mapController,
  ) async {
    if (mapController == null) return;

    LatLngBounds bounds;

    if (source.latitude > destination.latitude &&
        source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(source.latitude, destination.longitude),
          northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destination.latitude, source.longitude),
          northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 70);

    return checkCameraLocation(cameraUpdate, mapController);
  }

  Future<void> checkCameraLocation(
    CameraUpdate cameraUpdate,
    GoogleMapController mapController,
  ) async {
    mapController.animateCamera(cameraUpdate);
    final l1 = await mapController.getVisibleRegion();
    final l2 = await mapController.getVisibleRegion();

    if (l1 == null || l2 == null) {
      return checkCameraLocation(cameraUpdate, mapController);
    }

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController);
    }
  }
}
