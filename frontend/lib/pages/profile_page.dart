import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _authService.getCurrentUser();
    setState(() => _user = user);
  }

  Future<void> _doLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kCardColor,
        title: const Text('Logout', style: TextStyle(color: kTextLight, fontFamily: kFontFamily)),
        content: const Text(
          'Kamu yakin ingin keluar?',
          style: TextStyle(color: kTextMuted, fontFamily: kFontFamily),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal', style: TextStyle(color: kTextMuted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: kErrorColor),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authService.logout();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: _user == null
          ? const Center(child: CircularProgressIndicator(color: kAccentColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Avatar
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kCardColor,
                      border: Border.all(color: kAccentColor, width: 2),
                    ),
                    child: const Icon(Icons.person, color: kAccentColor, size: 48),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    _user!.username,
                    style: const TextStyle(
                      color: kTextLight,
                      fontFamily: kFontFamily,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Role badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _user!.isAdmin ? kGoldColor.withOpacity(0.15) : kAccentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _user!.isAdmin ? kGoldColor.withOpacity(0.5) : kAccentColor.withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      _user!.isAdmin ? '⭐ Admin' : '👤 User',
                      style: TextStyle(
                        color: _user!.isAdmin ? kGoldColor : kAccentColor,
                        fontFamily: kFontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Info card
                  Card(
                    child: Column(
                      children: [
                        _InfoTile(
                          icon: Icons.person_outline,
                          label: 'Username',
                          value: _user!.username,
                        ),
                        Divider(color: kAccentColor.withOpacity(0.1), height: 1),
                        _InfoTile(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: _user!.email,
                        ),
                        Divider(color: kAccentColor.withOpacity(0.1), height: 1),
                        _InfoTile(
                          icon: Icons.shield_outlined,
                          label: 'Role',
                          value: _user!.role.toUpperCase(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Info aplikasi
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tentang Aplikasi',
                            style: TextStyle(
                              color: kAccentColor,
                              fontFamily: kFontFamily,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Honkai Star Retail adalah aplikasi toko galaktik untuk membeli berbagai resource dan light cone dari dunia Honkai Star Rail.',
                            style: TextStyle(color: kTextLight, fontFamily: kFontFamily, fontSize: 13, height: 1.5),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Versi: 1.0.0',
                            style: TextStyle(color: kTextMuted, fontFamily: kFontFamily, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Tombol Logout
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _doLogout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kErrorColor,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: kAccentColor, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: kTextMuted, fontFamily: kFontFamily, fontSize: 11)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(color: kTextLight, fontFamily: kFontFamily, fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
