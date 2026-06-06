import 'package:flutter/material.dart';

// Base URL backend
const String baseUrl = 'http://10.0.2.2:3000/api';
// Ganti dengan IP komputer jika pakai device fisik, contoh: http://192.168.1.5:3000/api

// Google Client ID
const String googleClientId = 'YOUR_GOOGLE_CLIENT_ID_HERE';

// Warna tema dengan palet yang baru
const Color kPrimaryColor = Color(0xFF111844); // dark blue navy
const Color kSecondaryColor = Color(0xFF5B69A7); // medium blue
const Color kAccentColor = Color(0xFF88AEEA); // light blue
const Color kAccentDark = Color(0xFF5B69A7); // medium blue (untuk kontras)
const Color kCardColor = Color(0xFF1A2654); // card background (dark blue blend)
const Color kTextLight = Color(0xFFDABECE); // teks terang (beige)
const Color kTextMuted = Color(0xFF8B9FBD); // teks abu (muted blue)
const Color kGoldColor = Color(0xFFDABECE); // warna accent (beige)
const Color kErrorColor = Color(0xFFEF5350); // merah error
const Color kSuccessColor = Color(0xFF66BB6A); // hijau sukses

// Sample Products Data
final List<Map<String, dynamic>> sampleProducts = [
  {
    "id": 1,
    "name": "Stellar Jade",
    "type": "Galactic Resource",
    "description": "Premium currency used for special purchases.",
    "stock": 499,
    "price": 15000,
    "image": "stellarjade.jpeg",
  },
  {
    "id": 2,
    "name": "Acheron Light Cone",
    "type": "Light Cone",
    "description": "A powerful light cone associated with Acheron.",
    "stock": 24,
    "price": 750000,
    "image": "archeronlightcone.jpeg",
  },
  {
    "id": 3,
    "name": "Robin Light Cone",
    "type": "Light Cone",
    "description": "A support-oriented light cone for Robin.",
    "stock": 20,
    "price": 750000,
    "image": "robinlightcone.jpeg",
  },
  {
    "id": 4,
    "name": "Firefly Light Cone",
    "type": "Light Cone",
    "description": "A rare light cone featuring Firefly.",
    "stock": 15,
    "price": 750000,
    "image": "fireflylightcone.jpeg",
  },
  {
    "id": 5,
    "name": "Planetary Rendezvous",
    "type": "Light Cone",
    "description": "A light cone that increases team synergy.",
    "stock": 100,
    "price": 150000,
    "image": "planetaryrendezvous.jpeg",
  },
  {
    "id": 6,
    "name": "Fermata",
    "type": "Light Cone",
    "description": "A light cone focused on damage over time.",
    "stock": 80,
    "price": 150000,
    "image": "fermata.jpeg",
  },
  {
    "id": 7,
    "name": "Sparkle Light Cone",
    "type": "Light Cone",
    "description": "A premium light cone used by Sparkle.",
    "stock": 30,
    "price": 750000,
    "image": "sparklelightcone.jpeg",
  },
  {
    "id": 8,
    "name": "Trailblaze Power",
    "type": "Galactic Resource",
    "description": "Energy resource used to claim rewards.",
    "stock": 200,
    "price": 5000,
    "image": "trailblazepower.jpeg",
  },
  {
    "id": 9,
    "name": "Credit",
    "type": "Galactic Resource",
    "description": "Main currency used throughout the galaxy.",
    "stock": 1000,
    "price": 1000,
    "image": "credit.jpeg",
  },
  {
    "id": 10,
    "name": "Oneiric Shard",
    "type": "Galactic Resource",
    "description": "Premium shard used for special exchanges.",
    "stock": 150,
    "price": 25000,
    "image": "oneiricshard.jpeg",
  },
  {
    "id": 11,
    "name": "Lost Crystal",
    "type": "Galactic Resource",
    "description": "A rare crystal with mysterious power.",
    "stock": 100,
    "price": 35000,
    "image": "lostcrystal.jpeg",
  },
  {
    "id": 12,
    "name": "Memory of Chaos Pass",
    "type": "Galactic Resource",
    "description": "Pass required to access Memory of Chaos content.",
    "stock": 50,
    "price": 20000,
    "image": "memoryofchaospass.jpeg",
  },
];

// Gradient warna untuk background
LinearGradient kBackgroundGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF111844), // #111844
    Color(0xFF5B69A7), // #5B69A7
  ],
);

// Font yang digunakan
const String kFontFamily = 'Rajdhani';

// Image Mapping Helper - Menghubungkan nama product dengan file gambar
final Map<String, String> productImageMap = {
  'Stellar Jade': 'stellarjade.jpeg',
  'Acheron Light Cone': 'archeronlightcone.jpeg',
  'Robin Light Cone': 'robinlightcone.jpeg',
  'Firefly Light Cone': 'fireflylightcone.jpeg',
  'Planetary Rendezvous': 'planetaryrendezvous.jpeg',
  'Fermata': 'fermata.jpeg',
  'Sparkle Light Cone': 'sparklelightcone.jpeg',
  'Trailblaze Power': 'trailblazepower.jpeg',
  'Credit': 'credit.jpeg',
  'Oneiric Shard': 'oneiricshard.jpeg',
  'Lost Crystal': 'lostcrystal.jpeg',
  'Memory of Chaos Pass': 'memoryofchaospass.jpeg',
};

// Function helper untuk mendapatkan nama file gambar berdasarkan nama product
String getProductImage(String productName, String? imageFromDb) {
  // Jika dari database sudah ada, gunakan itu terlebih dahulu
  if (imageFromDb != null && imageFromDb.isNotEmpty) {
    return imageFromDb;
  }
  // Jika tidak ada, cari dari mapping
  return productImageMap[productName] ?? '';
}

// Widget helper untuk build product image dengan error handling
Widget buildProductImageWidget(
    String productName, String? imageFromDb, double iconSize) {
  final imagePath = getProductImage(productName, imageFromDb);

  if (imagePath.isNotEmpty) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        'assets/images/$imagePath',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.auto_awesome, color: kAccentColor, size: iconSize);
        },
      ),
    );
  } else {
    return Icon(Icons.auto_awesome, color: kAccentColor, size: iconSize);
  }
}

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
        borderSide:
            BorderSide(color: kAccentColor.withValues(alpha: 0.4), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kAccentColor, width: 2),
      ),
      labelStyle: const TextStyle(color: kTextMuted, fontFamily: kFontFamily),
      hintStyle: const TextStyle(color: kTextMuted, fontFamily: kFontFamily),
    ),
    cardTheme: CardThemeData(
      color: kCardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: kAccentColor.withValues(alpha: 0.2), width: 1),
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
      headlineLarge: TextStyle(
          color: kTextLight,
          fontFamily: kFontFamily,
          fontSize: 28,
          fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(
          color: kTextLight,
          fontFamily: kFontFamily,
          fontSize: 22,
          fontWeight: FontWeight.w600),
      bodyLarge:
          TextStyle(color: kTextLight, fontFamily: kFontFamily, fontSize: 16),
      bodyMedium:
          TextStyle(color: kTextLight, fontFamily: kFontFamily, fontSize: 14),
      bodySmall:
          TextStyle(color: kTextMuted, fontFamily: kFontFamily, fontSize: 12),
    ),
  );
}
