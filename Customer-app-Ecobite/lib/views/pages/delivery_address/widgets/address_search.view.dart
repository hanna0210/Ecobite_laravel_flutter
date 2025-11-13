import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/input.styles.dart';
import 'package:fuodz/models/address.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/filters/ops_autocomplete.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/extensions/context.dart';

class AddressSearchView extends StatefulWidget {
  const AddressSearchView(
    this.vm, {
    Key? key,
    this.addressSelected,
    this.selectOnMap,
  }) : super(key: key);

  //
  final dynamic vm;
  final Function(dynamic)? addressSelected;
  final Function? selectOnMap;

  @override
  _AddressSearchViewState createState() => _AddressSearchViewState();
}

class _AddressSearchViewState extends State<AddressSearchView> {
  //
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        OPSAutocompleteTextField(
          textEditingController: widget.vm.placeSearchTEC,
          inputDecoration: InputDecoration(
            hintText: "Enter your address...".tr(),
            enabledBorder: InputStyles.inputUnderlineEnabledBorder(),
            errorBorder: InputStyles.inputUnderlineEnabledBorder(),
            focusedErrorBorder: InputStyles.inputUnderlineFocusBorder(),
            focusedBorder: InputStyles.inputUnderlineFocusBorder(),
            prefixIcon: Icon(
              FlutterIcons.search_fea,
              size: 18,
            ),
            labelStyle: Theme.of(context).textTheme.bodyLarge,
            contentPadding: EdgeInsets.all(10),
          ),
          debounceTime: 800,
          onselected: (Address prediction) {
            if (widget.addressSelected != null) {
              widget.addressSelected!(prediction);
            }
            context.pop();
          },
        ),
        //
        UiSpacer.expandedSpace(),
        //
        CustomButton(
          title: "Pick On Map".tr(),
          onPressed: () {
            print("done");
            context.pop();
            if (widget.selectOnMap != null) {
              widget.selectOnMap!();
            }
          },
        ),
      ],
    ).p20().h(context.percentHeight * 90).scrollVertical();
  }
}
