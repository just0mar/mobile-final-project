import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/viewmodels/auth_viewmodel.dart';
import 'package:myapp/viewmodels/items_viewmodel.dart';
import 'package:myapp/screens/dashboard_screen/dashboard_screen.dart';
import 'package:myapp/screens/favorites_screen/favorites_screen.dart';
import 'package:myapp/screens/profile_screen/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const FavoritesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
    );
  }
} 