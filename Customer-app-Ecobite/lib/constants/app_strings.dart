import 'dart:convert';

import 'package:fuodz/services/local_storage.service.dart';
import 'package:supercharged/supercharged.dart';

class AppStrings {
  //
  static String get appName => env('app_name') ?? "";
  static String get companyName => env('company_name') ?? "";
  static String get googleMapApiKey => env('google_maps_key') ?? "";
  static String get mapboxAccessToken =>
      env('mapboxApiKey') ?? env('mapbox_api_key') ?? "";
  static String get fcmApiKey => env('fcm_key') ?? "";
  static String get currencySymbol => env('currency') ?? "";
  static String get countryCode => env('country_code') ?? "";
  static bool get enableOtp => env('enble_otp') == "1";
  static bool get enableOTPLogin => env('enableOTPLogin') == "1";

  //
  static bool get enableEmailLogin => env('enableEmailLogin') ?? false;
  static bool get enableProfileUpdate => env('enableProfileUpdate') ?? false;

  static bool get enableGoogleDistance => env('enableGoogleDistance') == "1";
  static bool get enableSingleVendor => env('enableSingleVendor') == "1";
  static bool get enableMultipleVendorOrder =>
      env('enableMultipleVendorOrder') ?? false;
  static bool get enableReferSystem => env('enableReferSystem') == "1";
  static String get referAmount => env('referAmount') ?? "0";
  static bool get enableChat => env('enableChat') == "1";
  static bool get enableOrderTracking => env('enableOrderTracking') == "1";
  static bool get enableFatchByLocation => env('enableFatchByLocation') ?? true;
  static bool get showVendorTypeImageOnly =>
      env('showVendorTypeImageOnly') == "1";
  static bool get enableUploadPrescription =>
      env('enableUploadPrescription') == "1";
  static bool get enableParcelVendorByLocation =>
      env('enableParcelVendorByLocation') == "1";
  static bool get enableParcelMultipleStops =>
      env('enableParcelMultipleStops') == "1";
  static int get maxParcelStops =>
      (env('maxParcelStops') ?? 1).toString().toInt() ?? 1;
  static String get what3wordsApiKey => env('what3wordsApiKey') ?? "";
  static bool get isWhat3wordsApiKey => what3wordsApiKey.isNotEmpty;
  //App download links
  static String get androidDownloadLink => env('androidDownloadLink') ?? "";
  static String get iOSDownloadLink => env('iosDownloadLink') ?? "";
  //
  static bool get isSingleVendorMode => env('isSingleVendorMode') == "1";
  static bool get canScheduleTaxiOrder {
    try {
      final taxi = env('taxi');
      if (taxi == null || taxi is! Map) return false;
      return taxi['canScheduleTaxiOrder'] == "1";
    } catch (e) {
      return false;
    }
  }
  static int get taxiMaxScheduleDays {
    try {
      final taxi = env('taxi');
      if (taxi == null || taxi is! Map) return 2;
      return taxi['taxiMaxScheduleDays']?.toString().toInt() ?? 2;
    } catch (e) {
      return 2;
    }
  }

  static Map<String, dynamic> get enabledVendorType =>
      env('enabledVendorType') ?? {};
  static double get bannerHeight =>
      double.parse("${env('bannerHeight') ?? 150.00}");

  //
  static String get otpGateway => env('otpGateway') ?? "none";
  static bool get isFirebaseOtp => otpGateway.toLowerCase() == "firebase";
  static bool get isCustomOtp =>
      !["none", "firebase"].contains(otpGateway.toLowerCase());

  static String get emergencyContact => env('emergencyContact') ?? "911";

  //Social media logins
  static bool get googleLogin {
    try {
      final auth = env('auth');
      if (auth == null || auth is! Map) return false;
      return auth['googleLogin'] ?? false;
    } catch (e) {
      return false;
    }
  }
  static bool get appleLogin {
    try {
      final auth = env('auth');
      if (auth == null || auth is! Map) return false;
      return auth['appleLogin'] ?? false;
    } catch (e) {
      return false;
    }
  }
  static bool get facebbokLogin {
    try {
      final auth = env('auth');
      if (auth == null || auth is! Map) return false;
      return auth['facebbokLogin'] ?? false;
    } catch (e) {
      return false;
    }
  }
  static bool get qrcodeLogin {
    try {
      final auth = env('auth');
      if (auth == null || auth is! Map) return false;
      return auth['qrcodeLogin'] ?? false;
    } catch (e) {
      return false;
    }
  }
  
  //UI Configures
  static dynamic get uiConfig {
    return env('ui') ?? null;
  }

  static double get categoryImageWidth {
    try {
      final ui = env('ui');
      if (ui == null || ui is! Map || ui["categorySize"] == null) {
        return 40.00;
      }
      return double.parse((ui['categorySize']["w"] ?? 40.00).toString());
    } catch (e) {
      return 40.00;
    }
  }

  static double get categoryImageHeight {
    try {
      final ui = env('ui');
      if (ui == null || ui is! Map || ui["categorySize"] == null) {
        return 40.00;
      }
      return double.parse((ui['categorySize']["h"] ?? 40.00).toString());
    } catch (e) {
      return 40.00;
    }
  }

  static double get categoryTextSize {
    try {
      final ui = env('ui');
      if (ui == null || ui is! Map || ui["categorySize"] == null) {
        return 12.00;
      }
      return double.parse(
        (ui['categorySize']["text"]['size'] ?? 12.00).toString(),
      );
    } catch (e) {
      return 12.00;
    }
  }

  static int get categoryPerRow {
    try {
      final ui = env('ui');
      if (ui == null || ui is! Map || ui["categorySize"] == null) {
        return 4;
      }
      return int.parse((ui['categorySize']["row"] ?? 4).toString());
    } catch (e) {
      return 3;
    }
  }

  static bool get categoryStyleGrid {
    try {
      final ui = env('ui');
      if (ui == null || ui is! Map || ui["categoryStyle"] == null) {
        return true;
      }
      String style = ui['categoryStyle'].toString().toLowerCase();
      return style == "grid";
    } catch (e) {
      return true;
    }
  }

  static bool get searchGoogleMapByCountry {
    try {
      final ui = env('ui');
      if (ui == null || ui is! Map || ui["google"] == null) {
        return false;
      }
      return ui['google']["searchByCountry"] ?? false;
    } catch (e) {
      return false;
    }
  }

  static String get searchGoogleMapByCountries {
    try {
      final ui = env('ui');
      if (ui == null || ui is! Map || ui["google"] == null) {
        return "";
      }
      return ui['google']["searchByCountries"] ?? "";
    } catch (e) {
      return "";
    }
  }

  static bool get useWebsocketAssignment {
    return (env('useWebsocketAssignment') ?? false);
  }

  //DONT'T TOUCH
  static const String notificationChannel = "high_importance_channel";

  //START DON'T TOUNCH
  //for app usage
  static String firstTimeOnApp = "first_time";
  static String authenticated = "authenticated";
  static String userAuthToken = "auth_token";
  static String userKey = "user";
  static String appLocale = "locale";
  static String notificationsKey = "notifications";
  static String appCurrency = "currency";
  static String appColors = "colors";
  static String appRemoteSettings = "appRemoteSettings";
  //END DON'T TOUNCH

  //
  //Change to your app store id
  static String appStoreId = "";

  //
  //saving
  static Future<bool> saveAppSettingsToLocalStorage(String stringMap) async {
    return await LocalStorageService.prefs!.setString(
      AppStrings.appRemoteSettings,
      stringMap,
    );
  }

  static dynamic appSettingsObject;
  static Future<void> getAppSettingsFromLocalStorage() async {
    appSettingsObject = LocalStorageService.prefs?.getString(
      AppStrings.appRemoteSettings,
    );
    if (appSettingsObject != null) {
      appSettingsObject = jsonDecode(appSettingsObject);
    }
  }

  static dynamic env(String ref) {
    //
    getAppSettingsFromLocalStorage();
    //
    if (appSettingsObject == null) return null;
    return appSettingsObject[ref];
  }

  //
  static List<String> get orderCancellationReasons {
    return ["Long pickup time", "Vendor is too slow", "custom"];
  }

  //
  static List<String> get orderStatuses {
    return [
      'pending',
      'preparing',
      'ready',
      'enroute',
      'failed',
      'cancelled',
      'delivered',
    ];
  }
}
