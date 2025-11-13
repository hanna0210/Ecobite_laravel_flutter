import 'dart:convert';

import 'package:fuodz/constants/app_strings.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapboxDirectionsService {
  static const String _baseUrl =
      "https://api.mapbox.com/directions/v5/mapbox/driving-traffic";

  static Future<List<LatLng>> getRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final token = AppStrings.mapboxAccessToken;
    if (token.isEmpty) {
      return [];
    }

    final queryParameters = <String, String>{
      "alternatives": "false",
      "geometries": "geojson",
      "overview": "full",
      "steps": "false",
      "access_token": token,
    };

    final uri = Uri.parse(
      '$_baseUrl/${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}',
    ).replace(queryParameters: queryParameters);

    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        return [];
      }
      final data = jsonDecode(response.body);
      final routes = data['routes'] as List<dynamic>?;
      if (routes == null || routes.isEmpty) {
        return [];
      }
      final geometry = routes.first['geometry'];
      final coordinates = geometry?['coordinates'] as List<dynamic>?;
      if (coordinates == null) {
        return [];
      }
      return coordinates
          .map(
            (coord) => LatLng(
              (coord[1] as num?)?.toDouble() ?? 0.0,
              (coord[0] as num?)?.toDouble() ?? 0.0,
            ),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }
}

