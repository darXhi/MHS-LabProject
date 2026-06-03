import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'resource_list_page.dart';
import 'transaction_history_page.dart';
import 'profile_page.dart';
import 'admin/admin_resource_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  UserModel? _currentUser;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _authService.getCurrentUser();
    setState(() => _currentUser = user);
  }

  List<Widget> get _pages {
    if (_currentUser?.isAdmin == true) {
      return [
        const ResourceListPage(),
        const AdminResourcePage(),
        const ProfilePage(),
      ];
    }
    return [
      const ResourceListPage(),
      const TransactionHistoryPage(),
      const ProfilePage(),
    ];
  }

  List<BottomNavigationBarItem> get _navItems {
    if (_currentUser?.isAdmin == true) {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.store_outlined),
          activeIcon: Icon(Icons.store),
          label: 'Shop',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.admin_panel_settings_outlined),
          activeIcon: Icon(Icons.admin_panel_settings),
          label: 'Manage',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
    }
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.store_outlined),
        activeIcon: Icon(Icons.store),
        label: 'Shop',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.receipt_long_outlined),
        activeIcon: Icon(Icons.receipt_long),
        label: 'History',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: kAccentColor)),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        items: _navItems,
      ),
    );
  }
}
