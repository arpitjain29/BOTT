import 'package:bott/screens/password_successfully_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/common_model.dart';
import '../utils/app_colors.dart';
import '../utils/fonts_class.dart';
import '../utils/helper_save_data.dart';
import '../utils/image_paths.dart';
import '../utils/user_data_save.dart';
import '../utils/util_api.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreen();
}

class _SetPasswordScreen extends State<SetPasswordScreen> {
  bool passwordVisible = false;
  bool passwordVisibleConfirm = false;
  TextEditingController passwordText = TextEditingController();
  TextEditingController confirmPasswordText = TextEditingController();

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    passwordVisibleConfirm = true;
    saveData();
  }

  String? tokenUserGet;

  void saveData() async {
    tokenUserGet =
        await HelperSaveData.helperSaveData.getStringValue(UserDataSave.token);
    if (kDebugMode) {
      print("set password screen token =======  $tokenUserGet");
    }
  }

  bool validateInputs(BuildContext context) {
    if (passwordText.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please enter password.")));
      return false;
    }

    if (confirmPasswordText.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter confirm password.")));
      return false;
    }

    if (passwordText.text != confirmPasswordText.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Passwords do not match.")));
      return false;
    }
    return true;
  }

  late SharedPreferences pref;
  late String fcmToken;
  bool clickLoad = false;
  CommonModel? commonModel;

  void resetPasswordApi() async {
    pref = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      clickLoad = true;
    });
    commonModel =
        await UtilApi.getResetPasswordMethod(passwordText.text, tokenUserGet!);
    if (!mounted) return;
    if (commonModel!.status == 200) {
      Fluttertoast.showToast(
          msg: commonModel!.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      if (!mounted) return;
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => PasswordSuccessfullyScreen()));
    } else {
      Fluttertoast.showToast(
          msg: commonModel!.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
    }
    if (!mounted) {
      setState(() {
      clickLoad = false;
    });
    }
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
            // child: ,
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
                  padding: EdgeInsets.symmetric(vertical: 35, horizontal: 45),
                  child: Column(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text(
                          "Create a new password. Ensure it differs from previous ones for security",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              fontFamily: Fonts.interSemiBold),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Password",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: Fonts.interSemiBold),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.surface,
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ], // Example gradient colors
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: TextField(
                          controller: passwordText,
                          obscureText: passwordVisible,
                          decoration: InputDecoration(
                            fillColor: AppColors.colorTransparent,
                            filled: true,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 13.0, horizontal: 20.0),
                            // counter: Container(),
                            counterText: '',
                            hintStyle: TextStyle(
                                color: AppColors.color4D4D4D,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                fontFamily: Fonts.interMedium),
                            hintText: 'Enter Password',
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.colorTransparent),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.colorTransparent),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                            ),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.colorWhite
                                      : AppColors.colorGreyDark,
                                  BlendMode.srcIn,
                                ),
                                child: Image.asset(
                                  "assets/image/ic_password.png",
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                              icon: Icon(
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.colorGrey.shade600,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Confirm Password",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: Fonts.interSemiBold),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.surface,
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ], // Example gradient colors
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: TextField(
                          controller: confirmPasswordText,
                          obscureText: passwordVisibleConfirm,
                          decoration: InputDecoration(
                            fillColor: AppColors.colorTransparent,
                            filled: true,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 13.0, horizontal: 20.0),
                            // counter: Container(),
                            counterText: '',
                            hintStyle: TextStyle(
                                color: AppColors.color4D4D4D,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                fontFamily: Fonts.interMedium),
                            hintText: 'Re-Enter Password',
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.colorTransparent),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.colorTransparent),
                              borderRadius: BorderRadius.all(
                                Radius.circular(30.0),
                              ),
                            ),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.colorWhite
                                      : AppColors.colorGreyDark,
                                  BlendMode.srcIn,
                                ),
                                child: Image.asset(
                                  "assets/image/ic_password.png",
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordVisibleConfirm =
                                      !passwordVisibleConfirm;
                                });
                              },
                              icon: Icon(
                                passwordVisibleConfirm
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.colorGrey.shade600,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 30),
                        width: MediaQuery.of(context).size.width,
                        child: clickLoad
                            ? Center(
                                child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator()))
                            : ElevatedButton(
                                onPressed: () {
                                  resetPasswordApi();
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 13, horizontal: 10),
                                  child: Text(
                                    "Update password",
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
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 420,
            left: 45,
            right: 45,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                    style: BorderStyle.solid),
              ),
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                "Set a new password",
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
