import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/models/cart.dart';
import 'package:fuodz/models/food_rescue.dart';
import 'package:fuodz/models/product.dart';
import 'package:fuodz/requests/food_rescue.request.dart';
import 'package:fuodz/services/alert.service.dart';
import 'package:fuodz/services/cart.service.dart';
import 'package:fuodz/services/cart_ui.service.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class FoodRescueDetailsViewModel extends MyBaseViewModel {
  FoodRescueDetailsViewModel(BuildContext context, this.foodRescue) {
    this.viewContext = context;
  }

  //
  FoodRescueRequest foodRescueRequest = FoodRescueRequest();
  FoodRescue foodRescue;
  int quantity = 1;
  
  //
  void initialise() async {
    //get full details
    setBusy(true);
    try {
      foodRescue = await foodRescueRequest.foodRescueDetails(foodRescue.id);
      clearErrors();
    } catch (error) {
      print("Food Rescue Details Error ==> $error");
      setError(error);
    }
    setBusy(false);
  }

  //
  void increaseQuantity() {
    if (quantity < foodRescue.availableQuantity) {
      quantity++;
      notifyListeners();
    } else {
      AlertService.warning(
        title: "Maximum Quantity".tr(),
        text: "Only ${foodRescue.availableQuantity} available".tr(),
      );
    }
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
      notifyListeners();
    }
  }

  //
  void toggleFavourite() async {
    setBusyForObject(foodRescue.id, true);
    
    try {
      final response = await foodRescueRequest.toggleFavourite(foodRescue.id);
      
      if (response.allGood) {
        foodRescue.isFavourite = !foodRescue.isFavourite;
        AlertService.success(
          text: foodRescue.isFavourite
              ? "Added to favourites".tr()
              : "Removed from favourites".tr(),
        );
      }
    } catch (error) {
      print("Toggle Favourite Error ==> $error");
    }
    
    setBusyForObject(foodRescue.id, false);
  }

  //
  void addToCart() async {
    if (!foodRescue.canPurchase) {
      AlertService.error(
        title: "Not Available".tr(),
        text: "This rescue offer is no longer available".tr(),
      );
      return;
    }

    if (quantity > foodRescue.availableQuantity) {
      AlertService.error(
        title: "Insufficient Quantity".tr(),
        text: "Only ${foodRescue.availableQuantity} available".tr(),
      );
      return;
    }

    setBusy(true);

    try {
      // Convert FoodRescue to Product-like cart item
      Product tempProduct = Product(
        id: foodRescue.id,
        name: foodRescue.title,
        description: foodRescue.description,
        price: foodRescue.rescuePrice,
        discountPrice: 0,
        photo: foodRescue.photo,
        vendor: foodRescue.vendor,
        optionGroups: [],
        photos: foodRescue.photos,
        featured: 0,
        plusOption: 0,
        isFavourite: foodRescue.isFavourite,
        deliverable: 1,
        digital: 0,
        digitalFiles: [],
        isActive: 1,
        vendorId: foodRescue.vendorId,
        availableQty: foodRescue.availableQuantity,
        rating: 0.0,
        reviewsCount: 0,
        description_url: "",
      );

      Cart cart = Cart(
        selectedQty: quantity,
        price: foodRescue.rescuePrice,
        product: tempProduct,
        productPrice: foodRescue.rescuePrice,
        optionsPrice: 0.0,
      );

      // Check if can add to cart
      bool canAddToCart = await CartUIServices.handleCartEntry(
        viewContext,
        cart,
        tempProduct,
      );

      if (canAddToCart) {
        await CartServices.addToCart(cart);
        
        AlertService.success(
          title: "Added to Cart".tr(),
          text: "${foodRescue.title} has been added to cart".tr(),
        );
      } else {
        AlertService.warning(
          title: "Cart Warning".tr(),
          text: "You have items from different vendor. Please clear cart first"
              .tr(),
        );
      }
    } catch (error) {
      print("Add to Cart Error ==> $error");
      AlertService.error(
        title: "Error".tr(),
        text: "Failed to add to cart. Please try again".tr(),
      );
    }

    setBusy(false);
  }

  //
  void goToCheckout() {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.checkoutRoute,
    );
  }

  //
  void openVendorDetails() {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.vendorDetails,
      arguments: foodRescue.vendor,
    );
  }

  //
  String getFormattedPrice(double price) {
    return price.toStringAsFixed(2);
  }

  double get totalPrice => foodRescue.rescuePrice * quantity;
  double get totalSavings =>
      (foodRescue.originalPrice - foodRescue.rescuePrice) * quantity;
}

