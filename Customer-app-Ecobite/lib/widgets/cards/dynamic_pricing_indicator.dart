import 'package:flutter/material.dart';
import 'package:fuodz/models/dynamic_pricing.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class DynamicPricingIndicator extends StatelessWidget {
  const DynamicPricingIndicator({
    Key? key,
    required this.dynamicPricing,
    this.showDetails = true,
  }) : super(key: key);

  final DynamicPricing dynamicPricing;
  final bool showDetails;

  @override
  Widget build(BuildContext context) {
    // Don't show if dynamic pricing is not active
    if (!dynamicPricing.isDynamic) {
      return UiSpacer.emptySpace();
    }

    return VStack(
      [
        // Header with icon and demand level
        HStack(
          [
            Icon(
              dynamicPricing.icon,
              color: dynamicPricing.color,
              size: 20,
            ),
            UiSpacer.horizontalSpace(space: 8),
            dynamicPricing.demandDescription.tr()
                .text
                .semiBold
                .color(dynamicPricing.color)
                .make()
                .expand(),
            // Price increase percentage badge
            if (dynamicPricing.hasIncrease)
              "+${dynamicPricing.priceIncreasePercentage.toStringAsFixed(0)}%"
                  .text
                  .white
                  .xs
                  .semiBold
                  .make()
                  .p4()
                  .px8()
                  .box
                  .color(dynamicPricing.color)
                  .roundedLg
                  .make(),
          ],
        ).py8(),

        // Details section
        if (showDetails && dynamicPricing.appliedRule != null)
          HStack(
            [
              Icon(
                Icons.info_outline,
                size: 16,
                color: Colors.grey,
              ),
              UiSpacer.horizontalSpace(space: 4),
              VStack(
                [
                  "Pricing adjusted due to:"
                      .tr()
                      .text
                      .xs
                      .color(Colors.grey)
                      .make(),
                  "${dynamicPricing.appliedRule}"
                      .text
                      .xs
                      .semiBold
                      .color(context.textTheme.bodyLarge?.color)
                      .make(),
                ],
                crossAlignment: CrossAxisAlignment.start,
              ).expand(),
            ],
          ).py4(),

        // Explanation
        if (showDetails)
          "Delivery fees are adjusted based on real-time demand, time of day, and other factors to ensure service availability."
              .tr()
              .text
              .xs
              .color(Colors.grey.shade600)
              .make()
              .py4(),
      ],
    )
        .p12()
        .box
        .border(color: dynamicPricing.color.withOpacity(0.3), width: 1)
        .roundedSM
        .color(dynamicPricing.color.withOpacity(0.05))
        .make();
  }
}

