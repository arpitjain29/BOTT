import 'package:bott/screens/HomeScreen.dart';
import 'package:bott/screens/ResetPassword.dart';
import 'package:bott/screens/SignUpScreen.dart';
import 'package:bott/utils/Fonts.dart';
import 'package:bott/utils/ImagePaths.dart';
import 'package:bott/utils/InputValidator.dart';
import 'package:bott/utils/TextView.dart';
import 'package:bott/utils/UserDataSave.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/LoginProvider.dart';
import '../utils/AppColors.dart';
import '../utils/HelperSaveData.dart';
import '../utils/InputTextFieldWithText.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  bool passwordVisible = false;
  TextEditingController emailText = TextEditingController();
  TextEditingController passwordText = TextEditingController();

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
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
        child: Column(
          children: [
            SizedBox(height: 100),
            SizedBox(
              height: 160,
              width: 160,
              child: Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? ImagePaths.appLogoDark
                    : ImagePaths.appLogo,
                height: 160,
                width: 160,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    child: Column(
                      children: [
                        Container(
                          height: 10,
                        ),
                        InputTextFieldWithText(
                            label: "Email",
                            hintText: "Enter Your Email",
                            textController: emailText,
                            whiteIcon: "assets/image/ic_email_white.png",
                            icon: ImagePaths.email,
                            keyboardType: TextInputType.emailAddress),
                        Container(
                          height: 5,
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
                                borderSide: BorderSide(
                                    color: AppColors.colorTransparent),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30.0),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.colorTransparent),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30.0),
                                ),
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Image.asset(
                                  isDark
                                      ? ImagePaths.passwordWhite
                                      : ImagePaths.password,
                                  height: 20,
                                  width: 20,
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
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ResetPassword()));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 15),
                            alignment: Alignment.topRight,
                            child: TextView(
                              label: "Forgot Password?",
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          width: MediaQuery.of(context).size.width,
                          child: loginProvider.isLoading
                              ? Center(
                                  child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator()))
                              : ElevatedButton(
                                  onPressed: () async {
                                    if (InputValidator.validateLogin(
                                        context: context,
                                        email: emailText.text,
                                        password: passwordText.text)) {
                                      final success = await loginProvider.login(
                                          emailText.text, passwordText.text);

                                      if (success) {
                                        Fluttertoast.showToast(
                                          msg: loginProvider.message ??
                                              "Login successful",
                                          toastLength: Toast.LENGTH_SHORT,
                                        );

                                        SharedPreferences pref =
                                            await SharedPreferences
                                                .getInstance();
                                        await HelperSaveData.helperSaveData
                                            .initSharedPreferences();
                                        HelperSaveData.helperSaveData
                                            .saveLoginUsers(
                                                loginProvider.loginUserModel);
                                        pref.setBool("isLoginUser", true);

                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => HomeScreen()));
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: loginProvider.message ??
                                              "Login failed",
                                          toastLength: Toast.LENGTH_SHORT,
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 13, horizontal: 10),
                                    child: Text(
                                      "Sign In",
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
                        Container(height: 5),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          width: MediaQuery.of(context).size.width,
                          child: loginProvider.isLoadingGuest
                              ? Center(
                                  child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator()))
                              : ElevatedButton(
                                  onPressed: () async {
                                    final loginProvider =
                                        Provider.of<LoginProvider>(context,
                                            listen: false);

                                    bool success =
                                        await loginProvider.guestLogin();

                                    if (success) {
                                      SharedPreferences pref =
                                          await SharedPreferences.getInstance();
                                      pref.setString(
                                          UserDataSave.token,
                                          loginProvider.guestUserModel?.data
                                                  ?.accessToken?.token ??
                                              "");
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => HomeScreen()));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                loginProvider.message ??
                                                    'Guest login failed')),
                                      );
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 13, horizontal: 10),
                                    child: TextView(label: "Continue as Guest"),
                                  ),
                                ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                child: TextView(label: "Or"),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(ImagePaths.circleApple),
                                    Image.asset(ImagePaths.google),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SignUpScreen()));
                          },
                          child: TextView(
                              label: "Create an account?Sign up", fontSize: 14),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
