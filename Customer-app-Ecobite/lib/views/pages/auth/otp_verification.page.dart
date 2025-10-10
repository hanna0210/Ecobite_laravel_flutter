import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/utils/utils.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/buttons/arrow_indicator.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/buttons/custom_outline_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:velocity_x/velocity_x.dart';

class OTPVerificationPage extends StatefulWidget {
  const OTPVerificationPage({
    required this.onSubmit,
    this.onResendCode,
    this.vm,
    Key? key,
    this.phone = "",
  }) : super(key: key);

  final Function(String) onSubmit;
  final Function? onResendCode;
  final dynamic vm;
  final String phone;

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  TextEditingController pinTEC = new TextEditingController();
  String? smsCode;
  int resendSecs = 30;
  int resendSecsIncreamental = 5;
  int maxResendSeconds = 30;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    startCountDown();
  }

  @override
  Widget build(BuildContext context) {
    final pinWidth = context.percentWidth * 85;

    return BasePage(
      showAppBar: true,
      showLeadingAction: true,
      appBarColor: AppColor.faintBgColor,
      elevation: 0,
      leading: IconButton(
        icon: ArrowIndicator(leading: true),
        onPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: VStack(
          [
            // Header Image
            Image.asset(
              AppImages.otpImage,
              width: 200,
              height: 200,
            ).centered().pOnly(top: 20, bottom: 20),

            // Title and Description
            VStack(
              [
                "Verify Your Phone".tr().text.xl2.semiBold.make(),
                UiSpacer.verticalSpace(space: 8),
                ("We sent a verification code to".tr() + "\n${widget.phone}")
                    .text
                    .gray600
                    .center
                    .make(),
              ],
              crossAlignment: CrossAxisAlignment.center,
            ).py12(),

            // Pin Code Field
            VStack(
              [
                "Enter Code".tr().text.semiBold.lg.make().pOnly(bottom: 12),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  textStyle: context.textTheme.bodyLarge!.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  controller: pinTEC,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 55,
                    fieldWidth: pinWidth / 7,
                    activeFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    activeColor: AppColor.primaryColor,
                    selectedColor: AppColor.primaryColor,
                    inactiveColor: Colors.grey.shade300,
                    borderWidth: 2,
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  onCompleted: (pin) {
                    smsCode = pin;
                  },
                  onChanged: (value) {
                    smsCode = value;
                  },
                ).w(pinWidth).centered(),
              ],
            ).py20(),

            // Resend Code Section
            HStack(
              [
                "Didn't receive the code?".tr().text.gray600.make(),
                UiSpacer.horizontalSpace(space: 4),
                Visibility(
                  visible: resendSecs > 0,
                  child: "($resendSecs)"
                      .text
                      .semiBold
                      .color(AppColor.primaryColor)
                      .make(),
                ),
                Visibility(
                  visible: resendSecs == 0,
                  child: "Resend"
                      .tr()
                      .text
                      .semiBold
                      .color(AppColor.primaryColor)
                      .make()
                      .onInkTap(
                        loading
                            ? null
                            : () async {
                                setState(() {
                                  loading = true;
                                });

                                if (widget.onResendCode != null) {
                                  await widget.onResendCode!();
                                } else {
                                  await widget.vm
                                      .processFirebaseOTPVerification(
                                          initial: false);
                                }

                                setState(() {
                                  loading = false;
                                  resendSecs = maxResendSeconds;
                                  maxResendSeconds += resendSecsIncreamental;
                                });
                                startCountDown();
                              },
                      ),
                ),
              ],
              crossAlignment: CrossAxisAlignment.center,
              alignment: MainAxisAlignment.center,
            ).py12(),

            // Action Buttons
            VStack(
              [
                // Verify Button
                CustomButton(
                  title: "Verify".tr(),
                  loading: loading ||
                      (widget.vm != null &&
                          (widget.vm.busy(widget.vm.otpLogin) ||
                              widget.vm.isBusy)),
                  onPressed: () async {
                    if (smsCode == null || smsCode!.length != 6) {
                      widget.vm.toastError("Verification code required".tr());
                    } else {
                      setState(() {
                        loading = true;
                      });
                      await widget.onSubmit(smsCode!);
                      setState(() {
                        loading = false;
                      });
                    }
                  },
                ).h(50).wFull(context),

                UiSpacer.verticalSpace(space: 12),

                // Edit Phone Number Button
                CustomOutlineButton(
                  title: "Edit Phone Number".tr(),
                  titleStyle: context.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Utils.textColorByTheme(),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ).h(50).wFull(context),
              ],
            ).py20(),

            // Additional Info
            VStack(
              [
                Icon(
                  Icons.security_outlined,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
                UiSpacer.verticalSpace(space: 8),
                "Your information is protected with industry-standard encryption"
                    .tr()
                    .text
                    .xs
                    .gray500
                    .center
                    .make(),
              ],
              crossAlignment: CrossAxisAlignment.center,
            ).py20(),
          ],
        ).p20().scrollVertical(),
      ),
    );
  }

  void startCountDown() async {
    if (resendSecs > 0) {
      setState(() {
        resendSecs -= 1;
      });

      await Future.delayed(1.seconds);
      startCountDown();
    }
  }

  @override
  void dispose() {
    pinTEC.dispose();
    super.dispose();
  }
}

