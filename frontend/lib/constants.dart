import 'package:flutter/material.dart';

// Base URL backend
const String baseUrl = 'http://10.0.2.2:3000/api';
// Ganti dengan IP komputer jika pakai device fisik, contoh: http://192.168.1.5:3000/api

// Google Client ID
const String googleClientId = 'YOUR_GOOGLE_CLIENT_ID_HERE';

// Warna tema Honkai Star Rail
const Color kPrimaryColor = Color(0xFF1A1A2E);      // dark navy
const Color kSecondaryColor = Color(0xFF16213E);     // navy gelap
const Color kAccentColor = Color(0xFF4FC3F7);        // biru langit / stellar blue
const Color kAccentDark = Color(0xFF0288D1);         // biru lebih gelap
const Color kCardColor = Color(0xFF1E2A3A);          // card background
const Color kTextLight = Color(0xFFE0E0E0);          // teks terang
const Color kTextMuted = Color(0xFF9E9E9E);          // teks abu
const Color kGoldColor = Color(0xFFFFD700);          // warna emas
const Color kErrorColor = Color(0xFFEF5350);         // merah error
const Color kSuccessColor = Color(0xFF66BB6A);       // hijau sukses

// Font yang digunakan
const String kFontFamily = 'Rajdhani';

// Theme data aplikasi
ThemeData appTheme() {
  return ThemeData(
    useMaterial3: false,
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kPrimaryColor,
    fontFamily: kFontFamily,
    colorScheme: ColorScheme.dark(
      primary: kAccentColor,
      secondary: kAccentDark,
      surface: kSecondaryColor,
      background: kPrimaryColor,
      error: kErrorColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: kSecondaryColor,
      foregroundColor: kTextLight,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: kFontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: kAccentColor,
        letterSpacing: 1.2,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kAccentColor,
        foregroundColor: kPrimaryColor,
        textStyle: const TextStyle(
          fontFamily: kFontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kCardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kAccentColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: kAccentColor.withOpacity(0.4), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kAccentColor, width: 2),
      ),
      labelStyle: const TextStyle(color: kTextMuted, fontFamily: kFontFamily),
      hintStyle: const TextStyle(color: kTextMuted, fontFamily: kFontFamily),
    ),
    cardTheme: CardTheme(
      color: kCardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: kAccentColor.withOpacity(0.2), width: 1),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: kSecondaryColor,
      selectedItemColor: kAccentColor,
      unselectedItemColor: kTextMuted,
      selectedLabelStyle: TextStyle(fontFamily: kFontFamily, fontSize: 12),
      unselectedLabelStyle: TextStyle(fontFamily: kFontFamily, fontSize: 12),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: kCardColor,
      contentTextStyle: TextStyle(color: kTextLight, fontFamily: kFontFamily),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: kTextLight, fontFamily: kFontFamily, fontSize: 28, fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(color: kTextLight, fontFamily: kFontFamily, fontSize: 22, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: kTextLight, fontFamily: kFontFamily, fontSize: 16),
      bodyMedium: TextStyle(color: kTextLight, fontFamily: kFontFamily, fontSize: 14),
      bodySmall: TextStyle(color: kTextMuted, fontFamily: kFontFamily, fontSize: 12),
    ),
  );
}
