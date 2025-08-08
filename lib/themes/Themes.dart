import 'package:flutter/material.dart';

import '../utils/AppColors.dart';

//LightTheme
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  scaffoldBackgroundColor: AppColors.colorB3FFFFFF,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.colorE8A818,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.transparent),
      side: WidgetStatePropertyAll(
        BorderSide(
          color: Color(0xFFE8A818),
          width: 3,
        ),
      ),
      shadowColor:  WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll(Color(0xFFE8A818)),
    ),
  ),
  colorScheme: ColorScheme.light(
    surface: AppColors.colorE8A818,
    primary: AppColors.colorFF9700,
    secondary: AppColors.colorFF8049,
  ),
);

//DarkTheme
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  scaffoldBackgroundColor: AppColors.color96A4C3,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.color0E1526,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Color(0xFF96A4C3)),
      side: WidgetStatePropertyAll(
        BorderSide(
          color: Color(0xFF0E1526),
          width: 2,
        ),
      ),
      foregroundColor: WidgetStatePropertyAll(Color(0xFF0E1526)),
    ),
  ),
  colorScheme: ColorScheme.dark(
    surface: AppColors.color0E1526,
    primary: AppColors.color0F172D,
    secondary: AppColors.color0F172D,
  ),
);
