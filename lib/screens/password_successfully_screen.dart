import 'package:bott/screens/login_screen.dart';
import 'package:bott/utils/image_paths.dart';
import 'package:flutter/material.dart';

class PasswordSuccessfullyScreen extends StatefulWidget {
  const PasswordSuccessfullyScreen({super.key});

  @override
  State<PasswordSuccessfullyScreen> createState() =>
      _PasswordSuccessfullyScreen();
}

class _PasswordSuccessfullyScreen extends State<PasswordSuccessfullyScreen> {
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
                      ? ImagePaths.rightCheckDark
                      : ImagePaths.rightCheck,
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
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 40),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text(
                          "Congratulations! Your password has been reset successfully. Click continue to login",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => LoginScreen()));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 10),
                            child: Text(
                              "Continue",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 215,
            left: 45,
            right: 45,
            child: Container(
              alignment: Alignment.topCenter,
              // child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                    style: BorderStyle.solid),
              ),
              padding: EdgeInsets.symmetric(vertical: 13),
              child: Text(
                "Password Reset Successfully",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
