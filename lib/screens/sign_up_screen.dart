import 'package:bott/screens/login_screen.dart';
import 'package:bott/utils/image_paths.dart';
import 'package:bott/utils/input_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/sign_up_provider.dart';
import '../utils/app_colors.dart';
import '../utils/fonts_class.dart';
import '../utils/google_auth_service.dart';
import '../utils/input_text_field_with_text.dart';
import '../utils/text_view.dart';
import '../utils/user_data_save.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  bool passwordVisible = false;
  bool passwordVisibleConfirm = false;
  TextEditingController emailText = TextEditingController();
  TextEditingController nameText = TextEditingController();
  TextEditingController passwordText = TextEditingController();
  TextEditingController confirmPasswordText = TextEditingController();

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    passwordVisibleConfirm = true;
  }

  @override
  Widget build(BuildContext context) {
    final signupProvider = Provider.of<SignUpProvider>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Form Container
            Positioned.fill(
              top: 200,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      InputTextFieldWithText(
                          label: "Username",
                          hintText: "Enter your username",
                          textController: nameText,
                          icon: ImagePaths.user1,
                          whiteIcon: ImagePaths.userWhite,
                          readOnly: false),
                      InputTextFieldWithText(
                          label: "Email",
                          hintText: "Enter email",
                          textController: emailText,
                          icon: ImagePaths.email,
                          whiteIcon: "assets/image/ic_email_white.png",
                          keyboardType: TextInputType.emailAddress,
                          readOnly: false),
                      SizedBox(
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
                              child: Image.asset(
                                Theme.of(context).brightness == Brightness.dark
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
                              child: Image.asset(
                                Theme.of(context).brightness == Brightness.dark
                                    ? ImagePaths.passwordWhite
                                    : ImagePaths.password,
                                height: 20,
                                width: 20,
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
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 15),
                        width: MediaQuery.of(context).size.width,
                        child: signupProvider.isLoading
                            ? Center(
                                child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator()))
                            : ElevatedButton(
                                onPressed: () async {
                                  if (InputValidator.validateSignUp(
                                      context: context,
                                      name: nameText.text,
                                      email: emailText.text,
                                      password: passwordText.text,
                                      confirmPassword:
                                          confirmPasswordText.text)) {
                                    final signUpProvider =
                                        Provider.of<SignUpProvider>(context,
                                            listen: false);

                                    bool success = await signUpProvider.signUp(
                                      nameText.text,
                                      emailText.text,
                                      passwordText.text,
                                    );
                                    if (!context.mounted) return;
                                    if (success) {
                                      Fluttertoast.showToast(
                                        msg: signUpProvider.message ??
                                            "Signup successful",
                                        toastLength: Toast.LENGTH_SHORT,
                                      );
                                      if (!context.mounted) return;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => LoginScreen()));
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: signUpProvider.message ??
                                            "Signup failed",
                                        toastLength: Toast.LENGTH_SHORT,
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 13, horizontal: 10),
                                  child: Text(
                                    "Sign Up",
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
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 15),
                        width: MediaQuery.of(context).size.width,
                        child: signupProvider.isLoadingGuest
                            ? Center(
                                child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator()))
                            : ElevatedButton(
                                onPressed: () async {
                                  final signUpProvider =
                                      Provider.of<SignUpProvider>(context,
                                          listen: false);

                                  bool success =
                                      await signUpProvider.guestLogin();
                                  if (!context.mounted) return;
                                  if (success) {
                                    SharedPreferences pref =
                                        await SharedPreferences.getInstance();
                                    pref.setString(
                                        UserDataSave.token,
                                        signUpProvider.guestUserModel?.data
                                                ?.accessToken?.token ??
                                            "");
                                    if (!context.mounted) return;
                                    // Navigate to home or another screen
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => HomeScreen()));
                                  } else {
                                    // Optionally show error if not already shown via toast
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              signUpProvider.message ??
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
                        margin: EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final googleAuthService = GoogleAuthService();
                                  await googleAuthService
                                      .signInWithGoogle(context);
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(ImagePaths.circleApple),
                                    Image.asset(ImagePaths.google),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Create Account Label
            Positioned(
              top: 170,
              left: 40,
              right: 40,
              child: Container(
                // height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                      color: Theme.of(context).colorScheme.primary, width: 2),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
                child: TextView(label: "Create Account"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
