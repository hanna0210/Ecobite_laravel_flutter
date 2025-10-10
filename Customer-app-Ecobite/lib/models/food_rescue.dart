import 'package:dartx/dartx.dart';
import 'package:fuodz/extensions/dynamic.dart';
import 'package:fuodz/models/vendor.dart';

class FoodRescue {
  FoodRescue({
    required this.id,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.rescuePrice,
    required this.availableQuantity,
    required this.totalQuantity,
    this.availableFrom,
    this.availableUntil,
    required this.vendorId,
    required this.isActive,
    this.pickupInstructions,
    this.tags,
    required this.vendor,
    required this.photo,
    required this.photos,
    required this.discountPercentage,
    required this.isAvailable,
    this.timeRemaining,
    required this.isFavourite,
    this.createdAt,
    this.updatedAt,
  }) {
    this.heroTag = dynamic.randomAlphaNumeric(15) + "$id";
  }

  int id;
  String? heroTag;
  String title;
  String description;
  double originalPrice;
  double rescuePrice;
  int availableQuantity;
  int totalQuantity;
  String? availableFrom;
  String? availableUntil;
  int vendorId;
  bool isActive;
  String? pickupInstructions;
  List<String>? tags;
  Vendor vendor;
  String photo;
  List<String> photos;
  int discountPercentage;
  bool isAvailable;
  String? timeRemaining;
  bool isFavourite;
  String? createdAt;
  String? updatedAt;

  factory FoodRescue.fromJson(Map<String, dynamic> json) {
    return FoodRescue(
      id: json["id"],
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      originalPrice: double.tryParse(json["original_price"].toString()) ?? 0.0,
      rescuePrice: double.tryParse(json["rescue_price"].toString()) ?? 0.0,
      availableQuantity: int.tryParse(json["available_quantity"].toString()) ?? 0,
      totalQuantity: int.tryParse(json["total_quantity"].toString()) ?? 0,
      availableFrom: json["available_from"],
      availableUntil: json["available_until"],
      vendorId: json["vendor_id"],
      isActive: json["is_active"] == 1 || json["is_active"] == true,
      pickupInstructions: json["pickup_instructions"],
      tags: json["tags"] != null
          ? List<String>.from(json["tags"].map((x) => x.toString()))
          : [],
      vendor: Vendor.fromJson(json["vendor"]),
      photo: json["photo"] ?? "",
      photos: json["photos"] != null
          ? List<String>.from(json["photos"].map((x) => x.toString()))
          : [],
      discountPercentage:
          int.tryParse(json["discount_percentage"]?.toString() ?? "0") ?? 0,
      isAvailable: json["is_available"] == 1 || json["is_available"] == true,
      timeRemaining: json["time_remaining"],
      isFavourite: json["is_favourite"] == 1 || json["is_favourite"] == true,
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "original_price": originalPrice,
      "rescue_price": rescuePrice,
      "available_quantity": availableQuantity,
      "total_quantity": totalQuantity,
      "available_from": availableFrom,
      "available_until": availableUntil,
      "vendor_id": vendorId,
      "is_active": isActive ? 1 : 0,
      "pickup_instructions": pickupInstructions,
      "tags": tags,
      "photo": photo,
      "photos": photos,
      "discount_percentage": discountPercentage,
      "is_available": isAvailable ? 1 : 0,
      "time_remaining": timeRemaining,
      "is_favourite": isFavourite ? 1 : 0,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }

  //getters
  bool get hasDiscount => discountPercentage > 0;
  double get savedAmount => originalPrice - rescuePrice;
  String get formattedDiscount => "$discountPercentage%";
  bool get isExpiring => timeRemaining != null && timeRemaining != 'expired';
  bool get isExpired => timeRemaining == 'expired';
  bool get canPurchase => isActive && isAvailable && availableQuantity > 0;
}

