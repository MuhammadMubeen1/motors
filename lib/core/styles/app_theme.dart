import 'package:flutter/material.dart';
import 'package:motors_app/core/styles/app_color.dart';

/// All custom application theme
class AppTheme {
  /// Default application theme
  final ThemeData _themeLight = ThemeData(fontFamily: 'SFProDisplay');

  ThemeData get themeLight => _themeLight.copyWith(
        scaffoldBackgroundColor: ColorApp.white,
        useMaterial3: false,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 3.0,
          backgroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: ColorApp.white,
          elevation: 7.0,
          type: BottomNavigationBarType.fixed,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
      );
}
