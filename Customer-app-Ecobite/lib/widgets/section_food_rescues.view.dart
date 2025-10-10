import 'package:flutter/material.dart';
import 'package:fuodz/models/vendor_type.dart';
import 'package:fuodz/view_models/food_rescues.vm.dart';
import 'package:fuodz/widgets/cards/custom.visibility.dart';
import 'package:fuodz/widgets/custom_list_view.dart';
import 'package:fuodz/widgets/list_items/food_rescue.list_item.dart';
import 'package:fuodz/widgets/section.title.dart';
import 'package:fuodz/widgets/states/vendor.empty.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class SectionFoodRescuesView extends StatelessWidget {
  const SectionFoodRescuesView(
    this.vendorType, {
    this.title = "",
    this.scrollDirection = Axis.vertical,
    this.itemWidth,
    this.itemHeight = 200,
    this.separator,
    this.byLocation = false,
    this.hideEmpty = false,
    this.itemsPadding,
    this.titlePadding,
    this.spacer,
    this.params,
    Key? key,
  }) : super(key: key);

  final VendorType? vendorType;
  final Axis scrollDirection;
  final String title;
  final double? itemWidth;
  final double? itemHeight;
  final Widget? separator;
  final bool byLocation;
  final EdgeInsets? itemsPadding;
  final EdgeInsets? titlePadding;
  final double? spacer;
  final bool hideEmpty;
  final Map<String, dynamic>? params;

  @override
  Widget build(BuildContext context) {
    return CustomVisibilty(
      child: ViewModelBuilder<FoodRescuesViewModel>.reactive(
        viewModelBuilder: () => FoodRescuesViewModel(
          context,
          vendorType: vendorType,
          byLocation: byLocation,
          params: params,
        ),
        onViewModelReady: (model) => model.initialise(),
        builder: (context, model, child) {
          //DEBUG: Print status
          print('🍔 RESCUE OFFERS - Loading: ${model.isBusy}, Count: ${model.foodRescues.length}, Error: ${model.hasError}');
          
          //if not busy and list is empty && hideEmpty == true
          if (!model.isBusy && model.foodRescues.isEmpty && hideEmpty) {
            print('🍔 RESCUE OFFERS - Section hidden (no data)');
            return 0.widthBox;
          }

          //listview
          Widget listView = CustomListView(
            scrollDirection: scrollDirection,
            padding: itemsPadding ?? EdgeInsets.symmetric(horizontal: 10),
            dataSet: model.foodRescues,
            isLoading: model.isBusy,
            noScrollPhysics: scrollDirection != Axis.horizontal,
            itemBuilder: (context, index) {
              final foodRescue = model.foodRescues[index];
              final itemView = FoodRescueListItem(
                foodRescue,
                onPressed: model.foodRescueSelected,
                height: itemHeight,
              );

              //
              if (itemWidth != null) {
                return itemView.w(itemWidth!);
              }
              return itemView;
            },
            emptyWidget: EmptyVendor(),
            separatorBuilder:
                separator != null ? (ctx, index) => separator! : null,
          );

          //
          return CustomVisibilty(
            visible: !model.isBusy && !model.foodRescues.isEmpty,
            child: VStack(
              [
                //title
                Padding(
                  padding: titlePadding ?? EdgeInsets.symmetric(horizontal: 12),
                  child: SectionTitle("$title"),
                ),
                //list
                if (model.foodRescues.isEmpty)
                  listView.h(240)
                else if (scrollDirection == Axis.horizontal)
                  listView.h(280)
                else
                  listView
              ],
              spacing: spacer ?? 5,
            ),
          );
        },
      ),
    );
  }
}

