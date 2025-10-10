import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/view_models/register.view_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({
    required this.viewModel,
    this.bottomPadding = 0,
    Key? key,
  }) : super(key: key);

  final RegisterViewModel viewModel;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    // Check if any social login is enabled
    final bool hasSocialLogin = AppStrings.googleLogin || 
                                 AppStrings.facebbokLogin || 
                                 (Platform.isIOS && AppStrings.appleLogin);

    if (!hasSocialLogin) {
      return SizedBox.shrink();
    }

    return VStack(
      [
        //facebook
        Visibility(
          visible: AppStrings.facebbokLogin,
          child: SignInButton(
            Buttons.FacebookNew,
            text: "Sign up with Facebook".tr(),
            onPressed: () {
              viewModel.processFacebookLogin();
            },
          ).wFull(context).pOnly(bottom: Vx.dp8),
        ),
        //google
        Visibility(
          visible: AppStrings.googleLogin,
          child: SignInButton(
            Buttons.Google,
            text: "Sign up with Google".tr(),
            onPressed: () {
              viewModel.processGoogleLogin();
            },
          ).wFull(context).pOnly(bottom: Vx.dp8),
        ),

        //apple
        Visibility(
          visible: Platform.isIOS && AppStrings.appleLogin,
          child: SignInWithAppleButton(
            text: "Sign up with Apple".tr(),
            onPressed: () => viewModel.processAppleLogin(),
          ).pOnly(bottom: Vx.dp8),
        ),
      ],
    ).pOnly(bottom: bottomPadding);
  }
}

