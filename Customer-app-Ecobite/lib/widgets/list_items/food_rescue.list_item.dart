import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/extensions/context.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/food_rescue.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/currency_hstack.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class FoodRescueListItem extends StatelessWidget {
  const FoodRescueListItem(
    this.foodRescue, {
    required this.onPressed,
    this.height = 180,
    Key? key,
  }) : super(key: key);

  final FoodRescue foodRescue;
  final Function(FoodRescue) onPressed;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //image and discount badge
        Stack(
          children: [
            //rescue offer image
            CustomImage(
              imageUrl: foodRescue.photo,
              width: double.infinity,
              height: height,
              boxFit: BoxFit.cover,
            ).box.slate100.withRounded(value: 8).clip(Clip.antiAlias).make(),

            //discount badge
            CustomVisibilty(
              visible: foodRescue.hasDiscount,
              child: Positioned(
                top: 8,
                right: 8,
                child: VStack(
                  [
                    "${foodRescue.discountPercentage}%"
                        .text
                        .white
                        .bold
                        .size(16)
                        .make(),
                    "OFF".tr().text.white.xs.make(),
                  ],
                  crossAlignment: CrossAxisAlignment.center,
                )
                    .p8()
                    .box
                    .green600
                    .roundedLg
                    .shadowSm
                    .make(),
              ),
            ),

            //time remaining badge
            CustomVisibilty(
              visible: foodRescue.isExpiring && !foodRescue.isExpired,
              child: Positioned(
                bottom: 8,
                left: 8,
                child: HStack(
                  [
                    Icon(
                      FlutterIcons.clock_fea,
                      color: Colors.white,
                      size: 14,
                    ),
                    4.widthBox,
                    "${foodRescue.timeRemaining}"
                        .text
                        .white
                        .semiBold
                        .xs
                        .make(),
                  ],
                )
                    .px8()
                    .py4()
                    .box
                    .orange600
                    .withRounded(value: 12)
                    .make(),
              ),
            ),

            //favourite icon (future implementation)
            Positioned(
              top: 8,
              left: 8,
              child: Icon(
                foodRescue.isFavourite
                    ? FlutterIcons.heart_ant
                    : FlutterIcons.heart_o_faw,
                color: foodRescue.isFavourite ? Colors.red : Colors.white,
                size: 20,
              )
                  .p4()
                  .box
                  .color(Colors.black.withOpacity(0.3))
                  .roundedFull
                  .make(),
            ),
          ],
        ),

        //details
        8.heightBox,
        VStack(
          [
            //title
            foodRescue.title.text.medium.size(15).maxLines(2).ellipsis.make(),

            //vendor name
            6.heightBox,
            HStack(
              [
                Icon(
                  FlutterIcons.shopping_bag_fea,
                  size: 14,
                  color: context.theme.colorScheme.secondary,
                ),
                4.widthBox,
                foodRescue.vendor.name.text.sm.gray600.make().expand(),
              ],
            ),

            // pricing
            8.heightBox,
            HStack(
              [
                //rescue price
                CurrencyHStack(
                  [
                    AppStrings.currencySymbol.text.lg.semiBold.green600.make(),
                    foodRescue.rescuePrice
                        .currencyValueFormat()
                        .text
                        .lg
                        .bold
                        .green600
                        .make(),
                  ],
                  crossAlignment: CrossAxisAlignment.end,
                ),
                //original price
                8.widthBox,
                CustomVisibilty(
                  visible: foodRescue.hasDiscount,
                  child: CurrencyHStack(
                    [
                      AppStrings.currencySymbol.text.lineThrough.sm.gray500.make(),
                      foodRescue.originalPrice
                          .currencyValueFormat()
                          .text
                          .lineThrough
                          .sm
                          .gray500
                          .make(),
                    ],
                  ),
                ),
              ],
            ),

            //quantity available
            6.heightBox,
            HStack(
              [
                Icon(
                  FlutterIcons.package_fea,
                  size: 12,
                  color: Colors.orange,
                ),
                4.widthBox,
                "${foodRescue.availableQuantity} ${"available".tr()}"
                    .text
                    .xs
                    .orange600
                    .semiBold
                    .make(),
              ],
            ),
          ],
        ).px8(),

        6.heightBox,
      ],
    )
        .onInkTap(() => onPressed(foodRescue))
        .material(color: context.theme.colorScheme.surface)
        .box
        .clip(Clip.antiAlias)
        .color(context.theme.colorScheme.surface)
        .withRounded(value: 8)
        .outerShadow
        .make();
  }
}

