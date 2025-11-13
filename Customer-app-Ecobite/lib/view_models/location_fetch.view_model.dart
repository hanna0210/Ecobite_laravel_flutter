import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/services/geocoder.service.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:fuodz/services/permission.service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/extensions/context.dart';

class LocationFetchViewModel extends MyBaseViewModel {
  LocationFetchViewModel(BuildContext context, this.nextPage) {
    this.viewContext = context;
  }

  bool showManuallySelection = false;
  bool showRequestPermission = false;
  Widget nextPage;
  //
  void initialise() async {
    try {
      //check for previous set location
      LocationService.deliveryaddress =
          await LocationService.getLocallySaveAddress();
    } catch (error) {
      print(error);
    }
    if (LocationService.deliveryaddress != null) {
      loadNextPage();
    } else {
      handleFetchCurrentLocation();
    }
  }

  handleFetchCurrentLocation() async {
    final granted = await locationPermissionGetter();
    showManuallySelection = !granted;
    showRequestPermission = granted;
    notifyListeners();
    if (granted) {
      await fetchCurrentLocation();
      if (LocationService.deliveryaddress != null) {
        loadNextPage();
      }
    }
  }

  Future<bool> locationPermissionGetter() async {
    bool granted = false;
    try {
      granted = await PermissionService.isLocationGranted();
      if (!granted) {
        final permanentlyDenied =
            await PermissionService.isLocationPermanentlyDenied();
        if (permanentlyDenied && !Platform.isIOS) {
          //
          toastError(
            "Permission is denied permanently, please re-enable permission from app info on your device settings. Thank you"
                .tr(),
          );
          //
          granted = await LocationService.showRequestDialog();
          if (granted) {
            granted = await Geolocator.openLocationSettings();
          }
        } else if (permanentlyDenied && Platform.isIOS) {
          //
          toastError(
            "Permission is denied permanently. You can skip the use for location and use the app manually. Thank you"
                .tr(),
          );
        } else {
          granted = await LocationService.showRequestDialog();

          if (granted) {
            try {
              granted = await PermissionService.requestPermission();
            } catch (error) {
              granted = false;
            }
          }
        }
      }
    } catch (error) {
      granted = false;
    }

    return granted;
  }

  void pickFromMap() async {
    //
    await locationPermissionGetter();

    final Address? locationResult = await newPlacePicker();
    if (locationResult == null) {
      return;
    }
    DeliveryAddress deliveryAddress = DeliveryAddress();
    deliveryAddress.address = locationResult.addressLine;
    deliveryAddress.name =
        locationResult.featureName ?? locationResult.addressLine;
    deliveryAddress.latitude = locationResult.coordinates?.latitude;
    deliveryAddress.longitude = locationResult.coordinates?.longitude;
    deliveryAddress.city = locationResult.locality;
    deliveryAddress.state = locationResult.adminArea;
    deliveryAddress.country = locationResult.countryName;

    if (deliveryAddress.latitude != null && deliveryAddress.longitude != null) {
      final needsDetails = (deliveryAddress.city ?? "").isEmpty ||
          (deliveryAddress.state ?? "").isEmpty ||
          (deliveryAddress.country ?? "").isEmpty;
      if (needsDetails) {
        setBusy(true);
        deliveryAddress = await getLocationCityName(deliveryAddress);
        setBusy(false);
      }
    }

    LocationService.deliveryaddress = deliveryAddress;
    LocationService.currenctAddressSubject.add(locationResult);
    loadNextPage();
  }

  loadNextPage() async {
    try {
      await LocationService.saveSelectedAddressLocally(
        LocationService.deliveryaddress,
      );
      viewContext.pop();
      viewContext.nextAndRemoveUntilPage(nextPage);
    } catch (error) {
      print("error: $error");
    }
  }

  //
}
