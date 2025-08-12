import 'package:flutter/material.dart';

class InputValidator {
  static bool validateLogin({
    required BuildContext context,
    required String email,
    required String password,
  }) {
    if (email.isEmpty) {
      _showSnack(context, "Please enter email");
      return false;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _showSnack(context, "Please enter valid email");
      return false;
    }

    if (password.isEmpty) {
      _showSnack(context, "Please enter password");
      return false;
    }

    return true;
  }

  static bool validateSignUp({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    if (name.isEmpty) {
      _showSnack(context, "Please enter name");
      return false;
    }

    if (email.isEmpty) {
      _showSnack(context, "Please enter email");
      return false;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _showSnack(context, "Please enter valid email");
      return false;
    }

    if (password.isEmpty) {
      _showSnack(context, "Please enter password");
      return false;
    }

    if (confirmPassword.isEmpty) {
      _showSnack(context, "Please enter confirm password");
      return false;
    }

    if (password != confirmPassword) {
      _showSnack(context, "Passwords do not match");
      return false;
    }

    return true;
  }

  static void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}