import 'package:flutter/material.dart';
import 'package:fuodz/models/address.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/requests/delivery_address.request.dart';
import 'package:fuodz/services/alert.service.dart';
import 'package:fuodz/view_models/delivery_address/base_delivery_addresses.vm.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:fuodz/extensions/context.dart';

class NewDeliveryAddressesViewModel extends BaseDeliveryAddressesViewModel {
  //
  DeliveryAddressRequest deliveryAddressRequest = DeliveryAddressRequest();
  TextEditingController nameTEC = TextEditingController();
  TextEditingController addressTEC = TextEditingController();
  TextEditingController descriptionTEC = TextEditingController();
  TextEditingController what3wordsTEC = TextEditingController();
  bool isDefault = false;
  DeliveryAddress? deliveryAddress = new DeliveryAddress();

  //
  NewDeliveryAddressesViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  showAddressLocationPicker() async {
    final Address? locationResult = await newPlacePicker();
    if (locationResult == null) {
      return;
    }
    addressTEC.text = locationResult.addressLine ?? "";
    deliveryAddress!.address = locationResult.addressLine;
    deliveryAddress!.latitude = locationResult.coordinates?.latitude;
    deliveryAddress!.longitude = locationResult.coordinates?.longitude;
    deliveryAddress!.city = locationResult.locality;
    deliveryAddress!.state = locationResult.adminArea;
    deliveryAddress!.country = locationResult.countryName;

    final needsDetails = (deliveryAddress!.city ?? "").isEmpty ||
        (deliveryAddress!.state ?? "").isEmpty ||
        (deliveryAddress!.country ?? "").isEmpty;
    if (needsDetails) {
      setBusy(true);
      deliveryAddress = await getLocationCityName(deliveryAddress!);
      setBusy(false);
    }
    notifyListeners();
  }

  //

  void toggleDefault(bool? value) {
    isDefault = value ?? false;
    deliveryAddress!.isDefault = isDefault ? 1 : 0;
    notifyListeners();
  }

  //
  saveNewDeliveryAddress() async {
    if (formKey.currentState!.validate()) {
      //
      deliveryAddress!.name = nameTEC.text;
      deliveryAddress!.description = descriptionTEC.text;
      //
      setBusy(true);
      //
      final apiRespose = await deliveryAddressRequest.saveDeliveryAddress(
        deliveryAddress!,
      );

      //
      AlertService.dynamic(
        type: apiRespose.allGood ? AlertType.success : AlertType.error,
        title: "New Delivery Address".tr(),
        text: apiRespose.message,
        onConfirm: () {
          viewContext.pop(true);
        },
      );
      //
      setBusy(false);
    }
  }

  //
}
