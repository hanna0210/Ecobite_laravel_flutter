import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/extensions/string.dart';
import 'package:fuodz/models/food_rescue.dart';
import 'package:fuodz/view_models/food_rescue_details.vm.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/currency_hstack.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class FoodRescueDetailsPage extends StatelessWidget {
  const FoodRescueDetailsPage({
    required this.foodRescue,
    Key? key,
  }) : super(key: key);

  final FoodRescue foodRescue;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FoodRescueDetailsViewModel>.reactive(
      viewModelBuilder: () =>
          FoodRescueDetailsViewModel(context, foodRescue),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          title: "Rescue Offer Details".tr(),
          showAppBar: true,
          showLeadingAction: true,
          showCart: true,
          isLoading: model.isBusy,
          body: model.hasError
              ? VStack(
                  [
                    Icon(FlutterIcons.alert_circle_fea,
                            size: 64, color: Colors.red)
                        .centered(),
                    20.heightBox,
                    "Failed to load offer details".tr().text.xl.makeCentered(),
                    10.heightBox,
                    CustomButton(
                      title: "Try Again".tr(),
                      onPressed: model.initialise,
                    ).w(200).centered(),
                  ],
                  crossAlignment: CrossAxisAlignment.center,
                ).centered().p20()
              : CustomScrollView(
                  slivers: [
                    // Image Gallery
                    SliverToBoxAdapter(
                      child: SafeArea(
                        bottom: false,
                        child: _buildImageGallery(context, model),
                      ),
                    ),

                    // Content
                    SliverToBoxAdapter(
                      child: VStack(
                        [
                          // Header Section
                          _buildHeader(context, model),
                          
                          20.heightBox,

                          // Pricing Section
                          _buildPricing(context, model),

                          20.heightBox,

                          // Vendor Section
                          _buildVendorInfo(context, model),

                          20.heightBox,

                          // Description
                          _buildDescription(context, model),

                          20.heightBox,

                          // Pickup Instructions
                          _buildPickupInstructions(context, model),

                          20.heightBox,

                          // Tags
                          _buildTags(context, model),

                          100.heightBox, // Space for bottom sheet
                        ],
                      ).p20(),
                    ),
                  ],
                ),
          bottomSheet: _buildBottomSheet(context, model),
        );
      },
    );
  }

  Widget _buildImageGallery(
      BuildContext context, FoodRescueDetailsViewModel model) {
    return Stack(
      children: [
        // Main Image
        CustomImage(
          imageUrl: model.foodRescue.photo,
          height: context.percentHeight * 40,
          width: double.infinity,
          boxFit: BoxFit.cover,
        ),

        // Discount Badge
        CustomVisibilty(
          visible: model.foodRescue.hasDiscount,
          child: Positioned(
            top: 20,
            right: 20,
            child: VStack(
              [
                "${model.foodRescue.discountPercentage}%"
                    .text
                    .white
                    .bold
                    .xl2
                    .make(),
                "OFF".tr().text.white.sm.make(),
              ],
              crossAlignment: CrossAxisAlignment.center,
            )
                .p12()
                .box
                .green600
                .roundedLg
                .shadowXl
                .make(),
          ),
        ),

        // Favorite Button
        Positioned(
          top: 20,
          left: 20,
          child: Icon(
            model.foodRescue.isFavourite
                ? FlutterIcons.heart_ant
                : FlutterIcons.heart_o_faw,
            color: model.foodRescue.isFavourite ? Colors.red : Colors.white,
            size: 28,
          )
              .p8()
              .box
              .color(Colors.black.withOpacity(0.5))
              .roundedFull
              .make()
              .onInkTap(model.toggleFavourite),
        ),

        // Time Remaining Badge
        CustomVisibilty(
          visible: model.foodRescue.isExpiring && !model.foodRescue.isExpired,
          child: Positioned(
            bottom: 20,
            left: 20,
            child: HStack(
              [
                Icon(FlutterIcons.clock_fea, color: Colors.white, size: 16),
                6.widthBox,
                "${model.foodRescue.timeRemaining}"
                    .text
                    .white
                    .semiBold
                    .make(),
              ],
            )
                .px12()
                .py8()
                .box
                .orange600
                .roundedLg
                .shadowLg
                .make(),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, FoodRescueDetailsViewModel model) {
    return VStack(
      [
        // Title
        model.foodRescue.title.text.xl2.bold.make(),
        
        10.heightBox,

        // Status indicators
        HStack(
          [
            // Available quantity
            Icon(FlutterIcons.package_fea, size: 16, color: Colors.green),
            4.widthBox,
            "${model.foodRescue.availableQuantity} ${"available".tr()}"
                .text
                .green600
                .semiBold
                .make(),
            
            20.widthBox,

            // Active status
            CustomVisibilty(
              visible: !model.foodRescue.canPurchase,
              child: HStack(
                [
                  Icon(FlutterIcons.alert_circle_fea,
                      size: 16, color: Colors.red),
                  4.widthBox,
                  "Not Available".tr().text.red600.semiBold.make(),
                ],
              ),
            ),
          ],
        ),
      ],
      crossAlignment: CrossAxisAlignment.start,
    );
  }

  Widget _buildPricing(BuildContext context, FoodRescueDetailsViewModel model) {
    return VStack(
      [
        "Pricing".tr().text.lg.semiBold.make(),
        12.heightBox,
        HStack(
          [
            // Rescue Price
            VStack(
              [
                "Rescue Price".tr().text.sm.gray600.make(),
                6.heightBox,
                CurrencyHStack(
                  [
                    AppStrings.currencySymbol.text.xl2.bold.green600.make(),
                    model.foodRescue.rescuePrice
                        .currencyValueFormat()
                        .text
                        .xl3
                        .bold
                        .green600
                        .make(),
                  ],
                ),
              ],
            ).expand(),

            // Original Price
            VStack(
              [
                "Original Price".tr().text.sm.gray600.make(),
                6.heightBox,
                CurrencyHStack(
                  [
                    AppStrings.currencySymbol.text.lg.lineThrough.gray500.make(),
                    model.foodRescue.originalPrice
                        .currencyValueFormat()
                        .text
                        .xl
                        .lineThrough
                        .gray500
                        .make(),
                  ],
                ),
              ],
            ).expand(),
          ],
        ),
        
        16.heightBox,

        // Savings
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: HStack(
            [
              Icon(FlutterIcons.trending_down_fea,
                  color: Colors.green, size: 20),
              10.widthBox,
              "You save ${AppStrings.currencySymbol}${model.foodRescue.savedAmount.currencyValueFormat()} (${model.foodRescue.discountPercentage}% off)"
                  .text
                  .green700
                  .semiBold
                  .make(),
            ],
          ),
        ),
      ],
      crossAlignment: CrossAxisAlignment.start,
    );
  }

  Widget _buildVendorInfo(
      BuildContext context, FoodRescueDetailsViewModel model) {
    return VStack(
      [
        "Vendor".tr().text.lg.semiBold.make(),
        12.heightBox,
        HStack(
          [
            // Vendor Logo
            CustomImage(
              imageUrl: model.foodRescue.vendor.logo,
              width: 50,
              height: 50,
            ).box.roundedSM.clip(Clip.antiAlias).make(),

            12.widthBox,

            // Vendor Details
            VStack(
              [
                model.foodRescue.vendor.name.text.lg.semiBold.make(),
                4.heightBox,
                model.foodRescue.vendor.address.text.sm.gray600.maxLines(2).make(),
              ],
              crossAlignment: CrossAxisAlignment.start,
            ).expand(),

            // View vendor button
            Icon(FlutterIcons.chevron_right_fea, color: Colors.grey),
          ],
        )
            .p12()
            .box
            .roundedSM
            .border(color: Colors.grey.withOpacity(0.3))
            .make()
            .onInkTap(model.openVendorDetails),
      ],
      crossAlignment: CrossAxisAlignment.start,
    );
  }

  Widget _buildDescription(
      BuildContext context, FoodRescueDetailsViewModel model) {
    return VStack(
      [
        "Description".tr().text.lg.semiBold.make(),
        12.heightBox,
        model.foodRescue.description.text.make(),
      ],
      crossAlignment: CrossAxisAlignment.start,
    );
  }

  Widget _buildPickupInstructions(
      BuildContext context, FoodRescueDetailsViewModel model) {
    if (model.foodRescue.pickupInstructions == null ||
        model.foodRescue.pickupInstructions!.isEmpty) {
      return SizedBox.shrink();
    }

    return VStack(
      [
        "Pickup Instructions".tr().text.lg.semiBold.make(),
        12.heightBox,
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),
          child: HStack(
            [
              Icon(FlutterIcons.info_fea, color: Colors.blue, size: 20),
              12.widthBox,
              model.foodRescue.pickupInstructions!.text.blue900.make().expand(),
            ],
            crossAlignment: CrossAxisAlignment.start,
          ),
        ),
      ],
      crossAlignment: CrossAxisAlignment.start,
    );
  }

  Widget _buildTags(BuildContext context, FoodRescueDetailsViewModel model) {
    if (model.foodRescue.tags == null || model.foodRescue.tags!.isEmpty) {
      return SizedBox.shrink();
    }

    return VStack(
      [
        "Categories".tr().text.lg.semiBold.make(),
        12.heightBox,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: model.foodRescue.tags!.map((tag) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColor.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColor.primaryColor.withOpacity(0.3),
                ),
              ),
              child: tag.text.color(AppColor.primaryColor).sm.make(),
            );
          }).toList(),
        ),
      ],
      crossAlignment: CrossAxisAlignment.start,
    );
  }

  Widget _buildBottomSheet(
      BuildContext context, FoodRescueDetailsViewModel model) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quantity Selector
            HStack(
              [
                "Quantity".tr().text.lg.semiBold.make().expand(),
                
                HStack(
                  [
                    // Decrease button
                    Icon(FlutterIcons.minus_fea, size: 20)
                        .p8()
                        .box
                        .color(Colors.grey.withOpacity(0.2))
                        .roundedSM
                        .make()
                        .onInkTap(model.decreaseQuantity),
                    
                    12.widthBox,
                    
                    // Quantity display
                    "${model.quantity}"
                        .text
                        .xl2
                        .bold
                        .make()
                        .px12(),
                    
                    12.widthBox,
                    
                    // Increase button
                    Icon(FlutterIcons.plus_fea, size: 20)
                        .p8()
                        .box
                        .color(AppColor.primaryColor.withOpacity(0.2))
                        .roundedSM
                        .make()
                        .onInkTap(model.increaseQuantity),
                  ],
                ),
              ],
            ),
            
            16.heightBox,

            // Total Price & Add to Cart
            HStack(
              [
                // Total Price
                VStack(
                  [
                    "Total".tr().text.sm.gray600.make(),
                    CurrencyHStack(
                      [
                        AppStrings.currencySymbol.text.lg.bold.make(),
                        model.totalPrice
                            .currencyValueFormat()
                            .text
                            .xl2
                            .bold
                            .make(),
                      ],
                    ),
                  ],
                  crossAlignment: CrossAxisAlignment.start,
                ),
                
                20.widthBox,
                
                // Add to Cart Button
                CustomButton(
                  title: "Add to Cart".tr(),
                  icon: FlutterIcons.shopping_cart_fea,
                  onPressed: model.addToCart,
                  loading: model.isBusy,
                  color: AppColor.primaryColor,
                ).expand(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

