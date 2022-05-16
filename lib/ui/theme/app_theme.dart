import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xff6200ee);
const kPrimaryVariantColor = Color(0xff3700b3);
const kSecondaryColor = Color(0xff03dac6);
const kSecondaryVariantColor = Color(0xff018786);
const kBackgroundColor = Color(0xFFF7F7F7);

TextStyle get kFirstTitleTextStyle => const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    );

TextStyle get kSecondaryTitleTextStyle => const TextStyle(
      color: Color(0xD9000000),
      fontSize: 14,
    );

TextStyle get kTipTextStyle => const TextStyle(
      color: Colors.white,
      fontSize: 12,
    );

ButtonStyle get textButtonStyle => ButtonStyle(
      padding: MaterialStateProperty.all(EdgeInsets.zero),
      overlayColor: MaterialStateColor.resolveWith(
        (states) => Colors.white.withAlpha(50),
      ),
      backgroundColor: MaterialStateColor.resolveWith(
        (states) => kPrimaryColor,
      ),
      textStyle: MaterialStateProperty.all(
        const TextStyle(fontSize: 15),
      ),
      foregroundColor: MaterialStateProperty.all(Colors.white),
    );

ThemeData get appThemeData => ThemeData(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: kPrimaryColor,
        primaryVariant: kPrimaryVariantColor,
        secondary: kSecondaryColor,
        secondaryVariant: kSecondaryVariantColor,
        background: kBackgroundColor,
      ),
      appBarTheme: appBarTheme,
      textButtonTheme: TextButtonThemeData(style: textButtonStyle),
      tabBarTheme: const TabBarTheme(
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(
          fontSize: 15,
          color: Color(0xD9000000),
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 15,
          color: Color(0xA6000000),
        ),
      ),
      indicatorColor: kPrimaryColor,
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

ThemeData? get appDarkThemeData => null;

AppBarTheme get appBarTheme => const AppBarTheme();
