import 'package:bott/model/common_model.dart';
import 'package:bott/screens/set_password_screen.dart';
import 'package:bott/utils/helper_save_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/login_user_model.dart';
import '../utils/app_colors.dart';
import '../utils/fonts_class.dart';
import '../utils/image_paths.dart';
import '../utils/user_data_save.dart';
import '../utils/util_api.dart';

class OtpScreen extends StatefulWidget {
  final String emailGet;

  const OtpScreen(this.emailGet, {super.key});

  @override
  State<OtpScreen> createState() => _OtpScreen();
}

class _OtpScreen extends State<OtpScreen> {
  TextEditingController otp1 = TextEditingController();
  TextEditingController otp2 = TextEditingController();
  TextEditingController otp3 = TextEditingController();
  TextEditingController otp4 = TextEditingController();

  @override
  void initState() {
    super.initState();
    saveData();
  }

  String? tokenUserGet;

  void saveData() async {
    tokenUserGet = await HelperSaveData.helperSaveData.getStringValue(UserDataSave.token);
    if (kDebugMode) {
      print("data login =======  ${tokenUserGet!}");
    }
  }

  late SharedPreferences pref;
  late String fcmToken;
  bool clickLoad = false;
  LoginUserModel? loginUserModel;
  CommonModel? commonModel;

  void forgetPasswordApi() async {
    String otptext = otp1.text + otp2.text + otp3.text + otp4.text;

    if (otptext.length != 4) {
      Fluttertoast.showToast(msg: "Please enter the complete OTP.");
      return;
    }

    pref = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      clickLoad = true;
    });
    loginUserModel = await UtilApi.getVerifyOtpMethod(
        widget.emailGet, otptext, tokenUserGet!);
    if (!mounted) return;
    if (loginUserModel!.status == 200) {
      Fluttertoast.showToast(
          msg: loginUserModel!.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      if (!mounted) return;
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => SetPasswordScreen()));
    } else {
      Fluttertoast.showToast(
          msg: loginUserModel!.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
    }
    if (!mounted) {
      setState(() {
      clickLoad = false;
    });
    }
  }

  void verifyOtpApi() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      clickLoad = true;
    });
    commonModel = await UtilApi.getResendOtpMethod(widget.emailGet);

    if (commonModel!.status == 200) {
      Fluttertoast.showToast(
          msg: commonModel!.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
    } else {
      Fluttertoast.showToast(
          msg: commonModel!.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
    }
    setState(() {
      clickLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? ImagePaths.appLogoDark
                      : ImagePaths.appLogo,
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 35, horizontal: 50),
                  child: Column(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text(
                          "Please enter your OTP sent to the email ${widget.emailGet}",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: Fonts.interSemiBold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: OTPDigitTextFieldBox(
                                controller: otp1, first: true, last: false),
                          ),
                          Expanded(
                            child: OTPDigitTextFieldBox(
                                controller: otp2, first: false, last: false),
                          ),
                          Expanded(
                            child: OTPDigitTextFieldBox(
                                controller: otp3, first: false, last: false),
                          ),
                          Expanded(
                            child: OTPDigitTextFieldBox(
                                controller: otp4, first: false, last: true),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        width: MediaQuery.of(context).size.width,
                        child: clickLoad
                            ? Center(
                                child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator()))
                            : ElevatedButton(
                                onPressed: () {
                                  forgetPasswordApi();
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 13, horizontal: 10),
                                  child: Text(
                                    "Reset Password",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        fontFamily: Fonts.interBold),
                                  ),
                                ),
                              ),
                      ),
                      TextButton(
                        onPressed: () {
                          Fluttertoast.showToast(
                              msg: "verify otp api call",
                              toastLength: Toast.LENGTH_SHORT
                          );
                          verifyOtpApi();
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "haven’t got the otp yet? ",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: Fonts.interRegular),
                            children: [
                              TextSpan(
                                text: "Resend OTP",
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: Fonts.interRegular),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 310,
            left: 40,
            right: 40,
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                    style: BorderStyle.solid),
              ),
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                "Enter OTP",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: Fonts.interSemiBold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OTPDigitTextFieldBox extends StatelessWidget {
  final bool first;
  final bool last;
  final TextEditingController controller;

  const OTPDigitTextFieldBox(
      {super.key,
      required this.controller,
      required this.first,
      required this.last});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(30.0),
      ),
      height: 60,
      child: AspectRatio(
        aspectRatio: 1.4,
        child: TextField(
          controller: controller,
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.isEmpty && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          // style: MyStyles.inputTextStyle,
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            fillColor: AppColors.colorTransparent,
            filled: true,
            isDense: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
            // counter: Container(),
            counterText: '',
            hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w400,
                fontSize: 16,
                fontFamily: Fonts.interMedium),
            hintText: '*',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(30.0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(30.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
