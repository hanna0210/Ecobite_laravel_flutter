import 'package:flutter/material.dart';
import 'package:fuodz/models/dynamic_pricing.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class DynamicPricingBadge extends StatelessWidget {
  const DynamicPricingBadge({
    Key? key,
    required this.dynamicPricing,
    this.compact = false,
  }) : super(key: key);

  final DynamicPricing dynamicPricing;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    // Don't show if dynamic pricing is not active or no increase
    if (!dynamicPricing.isDynamic || !dynamicPricing.hasIncrease) {
      return UiSpacer.emptySpace();
    }

    if (compact) {
      return HStack(
        [
          Icon(
            dynamicPricing.icon,
            size: 12,
            color: dynamicPricing.color,
          ),
          UiSpacer.horizontalSpace(space: 4),
          "+${dynamicPricing.priceIncreasePercentage.toStringAsFixed(0)}%"
              .text
              .white
              .xs
              .semiBold
              .make(),
        ],
      )
          .p4()
          .px8()
          .box
          .color(dynamicPricing.color)
          .roundedLg
          .make();
    }

    return HStack(
      [
        Icon(
          dynamicPricing.icon,
          size: 14,
          color: dynamicPricing.color,
        ),
        UiSpacer.horizontalSpace(space: 4),
        VStack(
          [
            dynamicPricing.demandDescription.tr()
                .text
                .xs
                .semiBold
                .color(dynamicPricing.color)
                .make(),
            "+${dynamicPricing.priceIncreasePercentage.toStringAsFixed(0)}%"
                .text
                .xs
                .color(dynamicPricing.color)
                .make(),
          ],
          crossAlignment: CrossAxisAlignment.start,
        ),
      ],
    )
        .p(6)
        .px8()
        .box
        .border(color: dynamicPricing.color.withOpacity(0.3), width: 1)
        .roundedSM
        .color(dynamicPricing.color.withOpacity(0.1))
        .make();
  }
}

