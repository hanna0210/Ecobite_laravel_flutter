import 'package:fuodz/constants/api.dart';
import 'package:fuodz/models/api_response.dart';
import 'package:fuodz/models/food_rescue.dart';
import 'package:fuodz/services/http.service.dart';

class FoodRescueRequest extends HttpService {
  //
  Future<List<FoodRescue>> getFoodRescues({
    Map<String, dynamic>? queryParams,
    int page = 1,
  }) async {
    Map<String, dynamic> params = {
      ...(queryParams != null ? queryParams : {}),
      "page": "$page",
    };

    //if params contains latitude and longitude, and if they are null, remove them
    if (params.containsKey("latitude") &&
        params.containsKey("longitude") &&
        (params["latitude"] == null || params["longitude"] == null)) {
      params.remove("latitude");
      params.remove("longitude");
    }

    final apiResult = await get(
      Api.foodRescues,
      queryParameters: params,
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      List<FoodRescue> foodRescues = [];
      apiResponse.data.forEach((element) {
        try {
          foodRescues.add(FoodRescue.fromJson(element));
        } catch (error) {
          print("===============================");
          print("Error Fetching Food Rescue ==> $error");
          print("Food Rescue ==> ${element['id']}");
          print("===============================");
        }
      });
      return foodRescues;
    }

    throw apiResponse.message!;
  }

  //
  Future<List<FoodRescue>> getNearbyFoodRescues({
    required double latitude,
    required double longitude,
    double radius = 10,
    int page = 1,
  }) async {
    final apiResult = await get(
      Api.nearbyFoodRescues,
      queryParameters: {
        "latitude": latitude,
        "longitude": longitude,
        "radius": radius,
        "page": "$page",
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      List<FoodRescue> foodRescues = [];
      apiResponse.data.forEach((element) {
        try {
          foodRescues.add(FoodRescue.fromJson(element));
        } catch (error) {
          print("===============================");
          print("Error Fetching Nearby Food Rescue ==> $error");
          print("Food Rescue ==> ${element['id']}");
          print("===============================");
        }
      });
      return foodRescues;
    }

    throw apiResponse.message!;
  }

  //
  Future<FoodRescue> foodRescueDetails(int id) async {
    final apiResult = await get("${Api.foodRescues}/$id");
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return FoodRescue.fromJson(apiResponse.body);
    }

    throw apiResponse.message!;
  }

  //
  Future<ApiResponse> toggleFavourite(int foodRescueId) async {
    final apiResult = await post(
      Api.favouriteFoodRescues,
      {"food_rescue_id": foodRescueId},
    );
    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> purchaseFoodRescue({
    required int foodRescueId,
    int quantity = 1,
  }) async {
    final apiResult = await post(
      "${Api.foodRescues}/$foodRescueId/purchase",
      {"quantity": quantity},
    );
    return ApiResponse.fromResponse(apiResult);
  }
}

