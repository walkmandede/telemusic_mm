import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryBlack = Color(0xFF191414);
  static const Color primaryYellow = Color(0xFFfee400);
  // static const Color spotifyGreen = Color(0xFF1DB954);
  static const Color lightGray = Color(0xFFB3B3B3);
  static const Color darkGray = Color(0xFF535353);
  static const Color white = Colors.white;

  //baseTextStyle
  static TextStyle appTextStyle1 = GoogleFonts.nunito();
  // static TextStyle appTextStyle1 = GoogleFonts.arima();

  // Global Theme Data
  static ThemeData theme = ThemeData(
    // Define the default brightness and colors.
    primarySwatch: MaterialColor(primaryYellow.value, const <int, Color>{
      50: Color(0xFFfee400),
      100: Color(0xFFfee400),
      200: Color(0xFFfee400),
      300: Color(0xFFfee400),
      400: Color(0xFFfee400),
      500: Color(0xFFfee400),
      600: Color(0xFFfee400),
      700: Color(0xFFfee400),
      800: Color(0xFFfee400),
      900: Color(0xFFfee400),
    }),
    brightness: Brightness.dark,
    useMaterial3: false,
    primaryColor: primaryYellow,
    scaffoldBackgroundColor: primaryBlack,
    // Define AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: primaryBlack,
      foregroundColor: white,
      elevation: 0,
      titleTextStyle: appTextStyle1.copyWith(
        color: white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Define Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: primaryBlack,
        backgroundColor: primaryYellow, // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),

    // Floating Action Button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryYellow,
      foregroundColor: primaryBlack,
    ),

    // Text Theme
    textTheme: TextTheme(
      displayLarge: appTextStyle1.copyWith(
        color: white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: appTextStyle1.copyWith(
        color: white,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: appTextStyle1.copyWith(
        color: lightGray,
        fontSize: 16,
      ),
      bodyMedium: appTextStyle1.copyWith(
        color: lightGray,
        fontSize: 14,
      ),
      labelLarge: appTextStyle1.copyWith(
        color: primaryBlack,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: white,
    ),

    // Input Decoration (e.g., TextFields)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkGray,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      hintStyle: appTextStyle1.copyWith(
        color: lightGray,
      ),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: primaryBlack,
      selectedItemColor: primaryYellow,
      unselectedItemColor: lightGray,
      selectedLabelStyle: appTextStyle1.copyWith(fontWeight: FontWeight.bold),
    ),
  );
}
