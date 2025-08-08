import 'dart:async';

import 'package:bott/provider/HomeProvider.dart';
import 'package:bott/provider/LoginProvider.dart';
import 'package:bott/provider/SignUpProvider.dart';
import 'package:bott/screens/HomeScreen.dart';
import 'package:bott/themes/Themes.dart';
import 'package:bott/screens/LoginScreen.dart';
import 'package:bott/utils/ImagePaths.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bott/utils/HelperSaveData.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/ThemeNotifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HelperSaveData.helperSaveData.initSharedPreferences();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences pref;

  void checkLogin() async {
    pref = await SharedPreferences.getInstance();
    bool? checkLogin = pref.getBool("isLoginUser");
    print("login user======== $checkLogin");
    bool isGuest = await HelperSaveData.helperSaveData.getBoolValue("isGuest") ?? false;
    if (isGuest) {
      // Navigate to Home directly
      print("login user isGuest ======== $isGuest");
    }

    if(checkLogin == true){
      Timer(
          Duration(seconds: 3),
              () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen())));
    }else{
      Timer(
          Duration(seconds: 3),
              () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginScreen())));
    }
  }


  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? ImagePaths.appLogoDark
                    : ImagePaths.appLogo,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
