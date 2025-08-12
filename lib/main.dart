import 'dart:async';

import 'package:bott/provider/home_provider.dart';
import 'package:bott/provider/login_provider.dart';
import 'package:bott/provider/sign_up_provider.dart';
import 'package:bott/screens/home_screen.dart';
import 'package:bott/themes/theme_class.dart';
import 'package:bott/screens/login_screen.dart';
import 'package:bott/utils/image_paths.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bott/utils/helper_save_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
    getFirebaseToken();
  }

  Future<void> getFirebaseToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission for iOS
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await messaging.getToken();
      print("FCM Token: $token");
    } else {
      print("User declined or has not accepted permission");
    }
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
