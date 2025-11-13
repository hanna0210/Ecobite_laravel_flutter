import 'package:fuodz/constants/app_strings.dart';

class AppMapSettings extends AppStrings {
  static bool get useGoogleOnApp {
    final mapConfig = AppStrings.env('map');
    if (mapConfig is Map && mapConfig["provider"] != null) {
      return mapConfig["provider"].toString().toLowerCase() == "google";
    }
    return false;
  }
}
