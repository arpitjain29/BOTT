import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/sign_up_provider.dart';
import '../screens/home_screen.dart';
import 'user_data_save.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      await _googleSignIn.disconnect();
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      // Step 4: Call your existing signup API
      if (user != null) {
        final name = user.displayName ?? "";
        final email = user.email ?? "";
        final password = user.uid;
        final imageUrl = user.photoURL ?? "";

        final signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
        bool success = await signUpProvider.signUp(name, email, password);

        if (success) {
          SharedPreferences pref =
          await SharedPreferences
              .getInstance();
          pref.setString(
              UserDataSave.token,
              signUpProvider.signUpUserModel?.data
                  ?.accessToken?.token ??
                  "");
          pref.setBool("isLoginUser", true);
          pref.setString("profileImage", imageUrl);
          pref.setString("userName", name);
          pref.setString("userEmail", email);
          // Step 5: Navigate to home screen
          Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(signUpProvider.message ?? "Signup failed")),
          );
        }
      }

      return user;
    } catch (e) {
      print("Sign-in error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}