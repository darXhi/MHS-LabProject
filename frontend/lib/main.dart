import 'package:flutter/material.dart';
import 'constants.dart';
import 'services/auth_service.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Honkai Star Retail',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      home: const SplashChecker(),
    );
  }
}

// Cek apakah user sudah login atau belum
class SplashChecker extends StatefulWidget {
  const SplashChecker({super.key});

  @override
  State<SplashChecker> createState() => _SplashCheckerState();
}

class _SplashCheckerState extends State<SplashChecker> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    final loggedIn = await _authService.isLoggedIn();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => loggedIn ? const HomePage() : const LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo / judul
            Text(
              '✦ HONKAI STAR',
              style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: kAccentColor,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'RETAIL',
              style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: kGoldColor,
                letterSpacing: 6,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              color: kAccentColor,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
