import 'dart:convert';
import 'package:flutter/material.dart';

DynamicPricing dynamicPricingFromJson(String str) =>
    DynamicPricing.fromJson(json.decode(str));

String dynamicPricingToJson(DynamicPricing data) => json.encode(data.toJson());

class DynamicPricing {
  DynamicPricing({
    this.isDynamic = false,
    this.demandLevel = 0,
    this.demandDescription = "",
    this.demandColor = "",
    this.appliedRule,
    this.priceIncreasePercentage = 0.0,
    this.originalDeliveryFee,
    this.multiplier,
  });

  bool isDynamic;
  int demandLevel;
  String demandDescription;
  String demandColor;
  String? appliedRule;
  double priceIncreasePercentage;
  double? originalDeliveryFee;
  double? multiplier;

  factory DynamicPricing.fromJson(Map<String, dynamic> json) {
    return DynamicPricing(
      isDynamic: json["is_dynamic"] ?? false,
      demandLevel: json["demand_level"] != null
          ? int.tryParse(json["demand_level"].toString()) ?? 0
          : 0,
      demandDescription: json["demand_description"] ?? "",
      demandColor: json["demand_color"] ?? "",
      appliedRule: json["applied_rule"],
      priceIncreasePercentage: json["price_increase_percentage"] != null
          ? double.tryParse(json["price_increase_percentage"].toString()) ?? 0.0
          : 0.0,
      originalDeliveryFee: json["original_delivery_fee"] != null
          ? double.tryParse(json["original_delivery_fee"].toString())
          : null,
      multiplier: json["multiplier"] != null
          ? double.tryParse(json["multiplier"].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "is_dynamic": isDynamic,
        "demand_level": demandLevel,
        "demand_description": demandDescription,
        "demand_color": demandColor,
        "applied_rule": appliedRule,
        "price_increase_percentage": priceIncreasePercentage,
        "original_delivery_fee": originalDeliveryFee,
        "multiplier": multiplier,
      };

  // Helper methods
  Color get color {
    switch (demandColor.toLowerCase()) {
      case "red":
        return Colors.red;
      case "orange":
        return Colors.orange;
      case "yellow":
        return Colors.amber;
      case "green":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData get icon {
    if (demandLevel >= 3) {
      return Icons.local_fire_department; // Critical demand
    } else if (demandLevel >= 2) {
      return Icons.trending_up; // High demand
    } else if (demandLevel >= 1) {
      return Icons.arrow_upward; // Medium demand
    } else {
      return Icons.check_circle; // Low demand
    }
  }

  String get demandLevelText {
    if (demandLevel >= 3) {
      return "Critical Demand";
    } else if (demandLevel >= 2) {
      return "High Demand";
    } else if (demandLevel >= 1) {
      return "Medium Demand";
    } else {
      return "Normal";
    }
  }

  bool get hasIncrease {
    return priceIncreasePercentage > 0;
  }
}

