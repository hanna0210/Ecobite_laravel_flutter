import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/requests/delivery_address.request.dart';
import 'package:fuodz/services/app.service.dart';
import 'package:fuodz/services/cart.service.dart';
import 'package:fuodz/services/geocoder.service.dart';
import 'package:fuodz/view_models/base.view_model.dart';

class DeliveryAddressPickerViewModel extends MyBaseViewModel {
  //
  DeliveryAddressRequest deliveryAddressRequest = DeliveryAddressRequest();
  List<DeliveryAddress> deliveryAddresses = [];
  List<DeliveryAddress> unFilterDeliveryAddresses = [];
  final Function(DeliveryAddress) onSelectDeliveryAddress;
  bool vendorCheckRequired;

  //
  DeliveryAddressPickerViewModel(
    BuildContext context,
    this.onSelectDeliveryAddress,
    this.vendorCheckRequired,
  ) {
    this.viewContext = context;
    if (vendorCheckRequired) {
      vendorCheckRequired = true;
    }
  }

  //
  void initialise() {
    //
    fetchDeliveryAddresses();
  }

  //
  fetchDeliveryAddresses() async {
    //
    int? vendorId =
        CartServices.productsInCart.isNotEmpty
            ? CartServices.productsInCart.first.product?.vendor.id
            : AppService().vendorId ?? null;

    List<int>? vendorIds =
        (CartServices.productsInCart.isNotEmpty &&
                AppStrings.enableMultipleVendorOrder)
            ? CartServices.productsInCart
                .map((e) => e.product!.vendorId)
                .toList()
                .toSet()
                .toList()
            : null;
    //send null value to api, so address will not be filtered
    if (!vendorCheckRequired) {
      vendorIds = null;
      vendorId = null;
    }

    setBusy(true);
    try {
      unFilterDeliveryAddresses =
          deliveryAddresses = await deliveryAddressRequest.getDeliveryAddresses(
            vendorId: vendorId,
            vendorIds: vendorIds,
          );
      clearErrors();
    } catch (error) {
      setError(error);
    }
    setBusy(false);
  }

  //
  newDeliveryAddressPressed() async {
    await Navigator.of(
      viewContext,
    ).pushNamed(AppRoutes.newDeliveryAddressesRoute);
    fetchDeliveryAddresses();
  }

  //
  void pickFromMap() async {
    //
    final Address? locationResult = await newPlacePicker();
    if (locationResult == null) {
      return;
    }
    DeliveryAddress deliveryAddress = DeliveryAddress();
    deliveryAddress.address = locationResult.addressLine;
    deliveryAddress.latitude = locationResult.coordinates?.latitude;
    deliveryAddress.longitude = locationResult.coordinates?.longitude;
    deliveryAddress.city = locationResult.locality;
    deliveryAddress.state = locationResult.adminArea;
    deliveryAddress.country = locationResult.countryName;

    final needsDetails = (deliveryAddress.city ?? "").isEmpty ||
        (deliveryAddress.state ?? "").isEmpty ||
        (deliveryAddress.country ?? "").isEmpty;
    if (needsDetails &&
        deliveryAddress.latitude != null &&
        deliveryAddress.longitude != null) {
      setBusy(true);
      final addresses = await GeocoderService().findAddressesFromCoordinates(
        Coordinates(
          deliveryAddress.latitude!,
          deliveryAddress.longitude!,
        ),
      );
      setBusy(false);
      if (addresses.isNotEmpty) {
        final resolved = addresses.first;
        deliveryAddress.city = deliveryAddress.city ?? resolved.locality;
        deliveryAddress.state = deliveryAddress.state ?? resolved.adminArea;
        deliveryAddress.country =
            deliveryAddress.country ?? resolved.countryName;
      }
    }
    onSelectDeliveryAddress(deliveryAddress);
  }

  filterResult(String keyword) {
    deliveryAddresses =
        unFilterDeliveryAddresses.where((e) {
          //
          String name = e.name ?? "";
          String address = e.address ?? "";
          //
          return name.toLowerCase().contains(keyword) ||
              address.toLowerCase().contains(keyword);
        }).toList();
    notifyListeners();
  }
}
