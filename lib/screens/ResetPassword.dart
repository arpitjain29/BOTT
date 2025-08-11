import 'package:bott/model/ForgetPasswordModel.dart';
import 'package:bott/screens/OtpScreen.dart';
import 'package:bott/utils/HelperSaveData.dart';
import 'package:bott/utils/UserDataSave.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/Fonts.dart';
import '../utils/ImagePaths.dart';
import '../utils/InputTextFieldWithText.dart';
import '../utils/UtilApi.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPassword();
}

class _ResetPassword extends State<ResetPassword> {
  TextEditingController emailText = TextEditingController();

  bool validateInputs(BuildContext context) {
    if (emailText.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please enter email.")));
      return false;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(emailText.text)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please enter valid email.")));
      return false;
    }
    return true;
  }

  late SharedPreferences pref;
  late String fcmToken;
  bool clickLoad = false;
  ForgetPasswordModel? forgetPasswordModel;

  void forgetPasswordApi() async {
    await HelperSaveData.helperSaveData.initSharedPreferences();
    pref = await SharedPreferences.getInstance();
    setState(() {
      clickLoad = true;
    });
    forgetPasswordModel = await UtilApi.getForgetPasswordMethod(emailText.text);

    if (forgetPasswordModel!.status == 200) {
      HelperSaveData.helperSaveData.setStringValue(UserDataSave.token,
          forgetPasswordModel?.data?.accessToken?.token.toString() ?? "");
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => OtpScreen(emailText.text)));
    } else {
      Fluttertoast.showToast(
          msg: forgetPasswordModel!.message!,
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
                child: Container(
                  child: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? ImagePaths.appLogoDark
                        : ImagePaths.appLogo,
                  ),
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
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: Column(
                    children: [
                      Container(
                        height: 30,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text(
                          "Please enter your email to reset the password",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: Fonts.interSemiBold),
                        ),
                      ),
                      InputTextFieldWithText(
                          label: "Email",
                          hintText: "Enter Your Email",
                          textController: emailText,
                          icon: ImagePaths.email,
                          whiteIcon: "assets/image/ic_email_white.png",
                          keyboardType: TextInputType.emailAddress),
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
                                  if (validateInputs(context)) {
                                    forgetPasswordApi();
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
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
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 285,
            left: 45,
            right: 45,
            child: Container(
              width: MediaQuery.of(context).size.width,
              // height: 50,
              padding: EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: Theme.of(context).colorScheme.primary, width: 2),
              ),
              child: Text(
                "Reset Password",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: Fonts.interSemiBold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
