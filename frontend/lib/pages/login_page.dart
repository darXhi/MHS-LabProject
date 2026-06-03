import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/auth_service.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _doLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _authService.login(
      _usernameController.text.trim(),
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (result['success']) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } else {
      setState(() {
        _errorMessage = result['message'];
      });
    }
  }

  Future<void> _doGoogleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _authService.loginWithGoogle();

    setState(() => _isLoading = false);

    if (result['success']) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } else {
      setState(() {
        _errorMessage = result['message'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Header
                Center(
                  child: Column(
                    children: [
                      Text(
                        '✦ HONKAI STAR',
                        style: TextStyle(
                          fontFamily: kFontFamily,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: kAccentColor,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        'RETAIL',
                        style: TextStyle(
                          fontFamily: kFontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kGoldColor,
                          letterSpacing: 5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                Text(
                  'Login',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Masuk untuk melanjutkan perjalanan galaktikmu',
                  style: Theme.of(context).textTheme.bodySmall,
                ),

                const SizedBox(height: 24),

                // Error message
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: kErrorColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kErrorColor.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: kErrorColor, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: kErrorColor, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Username field
                TextFormField(
                  controller: _usernameController,
                  style: const TextStyle(color: kTextLight),
                  decoration: const InputDecoration(
                    labelText: 'Username atau Email',
                    prefixIcon: Icon(Icons.person_outline, color: kAccentColor),
                  ),
                  validator: (value) {
                    // Validasi 1: field tidak boleh kosong
                    if (value == null || value.trim().isEmpty) {
                      return 'Username tidak boleh kosong';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: kTextLight),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline, color: kAccentColor),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: kTextMuted,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  validator: (value) {
                    // Validasi 2: password minimal 6 karakter
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 28),

                // Tombol Login
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _doLogin,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: kPrimaryColor,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Login'),
                  ),
                ),

                const SizedBox(height: 16),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: kTextMuted.withOpacity(0.4))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('atau', style: Theme.of(context).textTheme.bodySmall),
                    ),
                    Expanded(child: Divider(color: kTextMuted.withOpacity(0.4))),
                  ],
                ),

                const SizedBox(height: 16),

                // Tombol Google Login
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _doGoogleLogin,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kTextLight,
                      side: BorderSide(color: kAccentColor.withOpacity(0.5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.g_mobiledata, size: 24, color: kAccentColor),
                    label: const Text(
                      'Lanjutkan dengan Google',
                      style: TextStyle(fontFamily: kFontFamily, fontSize: 15),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Info akun demo
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kCardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kAccentColor.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Akun Demo:',
                        style: TextStyle(
                          color: kAccentColor,
                          fontFamily: kFontFamily,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('Admin: admin / password123', style: Theme.of(context).textTheme.bodySmall),
                      Text('User: user1 / password123', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
