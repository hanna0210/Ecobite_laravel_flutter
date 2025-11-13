import 'package:flutter/material.dart';
import 'package:fuodz/models/address.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/requests/delivery_address.request.dart';
import 'package:fuodz/services/alert.service.dart';
import 'package:fuodz/view_models/delivery_address/base_delivery_addresses.vm.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:fuodz/extensions/context.dart';

class EditDeliveryAddressesViewModel extends BaseDeliveryAddressesViewModel {
  //
  DeliveryAddressRequest deliveryAddressRequest = DeliveryAddressRequest();
  TextEditingController nameTEC = TextEditingController();
  TextEditingController addressTEC = TextEditingController();
  TextEditingController descriptionTEC = TextEditingController();
  bool isDefault = false;
  DeliveryAddress? deliveryAddress;

  //
  EditDeliveryAddressesViewModel(BuildContext context, this.deliveryAddress) {
    this.viewContext = context;
  }

  //
  void initialise() {
    //
    nameTEC.text = deliveryAddress!.name!;
    addressTEC.text = deliveryAddress!.address!;
    descriptionTEC.text = deliveryAddress!.description!;
    isDefault = deliveryAddress!.isDefault == 1;
    notifyListeners();
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

  void toggleDefault(bool? value) {
    isDefault = value ?? false;
    deliveryAddress!.isDefault = isDefault ? 1 : 0;
    notifyListeners();
  }

  //
  updateDeliveryAddress() async {
    if (formKey.currentState!.validate()) {
      //
      deliveryAddress!.name = nameTEC.text;
      deliveryAddress!.description = descriptionTEC.text;
      //
      setBusy(true);
      //
      final apiRespose = await deliveryAddressRequest.updateDeliveryAddress(
        deliveryAddress!,
      );

      //
      AlertService.dynamic(
        type: apiRespose.allGood ? AlertType.success : AlertType.error,
        title: "Update Delivery Address".tr(),
        text: apiRespose.message,
        onConfirm: () {
          viewContext.pop(true);
        },
      );
      //
      setBusy(false);
    }
  }
}
