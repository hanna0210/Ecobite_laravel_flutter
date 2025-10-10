import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/food_rescue.dart';
import 'package:fuodz/models/user.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/requests/food_rescue.request.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:fuodz/view_models/base.view_model.dart';

class FoodRescuesViewModel extends MyBaseViewModel {
  //
  FoodRescuesViewModel(
    BuildContext context, {
    this.vendorType,
    this.byLocation,
    this.params,
  }) {
    this.viewContext = context;
    if (this.byLocation == null) {
      this.byLocation = AppStrings.enableFatchByLocation;
    }
  }

  //
  User? currentUser;

  //
  VendorType? vendorType;
  FoodRescueRequest foodRescueRequest = FoodRescueRequest();
  List<FoodRescue> foodRescues = [];
  late bool? byLocation;
  Map<String, dynamic>? params;

  void initialise() async {
    //
    if (AuthServices.authenticated()) {
      currentUser = await AuthServices.getCurrentUser(force: true);
      notifyListeners();
    }

    deliveryaddress?.address = LocationService.currenctAddress?.addressLine;
    deliveryaddress?.latitude =
        LocationService.currenctAddress?.coordinates?.latitude;
    deliveryaddress?.longitude =
        LocationService.currenctAddress?.coordinates?.longitude;

    //get food rescues
    fetchFoodRescues();
  }

  //
  fetchFoodRescues() async {
    //
    print('🍔 Starting to fetch food rescues...');
    setBusy(true);
    try {
      Map<String, dynamic> queryParams = {
        "vendor_type_id": vendorType?.id,
        ...(params ?? {}),
      };

      if ((byLocation != null && byLocation!) &&
          deliveryaddress?.latitude != null) {
        print('🍔 Fetching nearby food rescues (lat: ${deliveryaddress!.latitude}, lng: ${deliveryaddress!.longitude})');
        foodRescues = await foodRescueRequest.getNearbyFoodRescues(
          latitude: deliveryaddress!.latitude!,
          longitude: deliveryaddress!.longitude!,
        );
      } else {
        print('🍔 Fetching all food rescues with params: $queryParams');
        foodRescues = await foodRescueRequest.getFoodRescues(
          queryParams: queryParams,
        );
      }
      print('🍔 Successfully fetched ${foodRescues.length} food rescues');
    } catch (error) {
      print("🍔 fetchFoodRescues Error ==> $error");
    }
    setBusy(false);
  }

  //
  void foodRescueSelected(FoodRescue foodRescue) {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.foodRescueDetails,
      arguments: foodRescue,
    );
  }
}

