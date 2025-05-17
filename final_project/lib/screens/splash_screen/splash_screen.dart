// Import necessary Flutter and third-party packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/viewmodels/auth_viewmodel.dart';
import 'package:myapp/screens/login_screen/login_screen.dart';
import 'package:myapp/screens/dashboard_screen/dashboard_screen.dart';
import 'package:myapp/screens/home_screen/home_screen.dart';

// SplashScreen widget - First screen shown when app starts
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Check login status when screen initializes
    _checkLoginStatus();
  }

  // Checks if user is logged in and navigates accordingly
  Future<void> _checkLoginStatus() async {
    // Simulate loading time (2 seconds)
    await Future.delayed(const Duration(seconds: 2));
    
    // Check if widget is still mounted before proceeding
    if (!mounted) return;

    // Get auth view model to check login status
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    
    // Navigate based on login status
    if (authViewModel.isLoggedIn) {
      // If logged in, go to dashboard
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      // If not logged in, go to login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build splash screen UI
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Add your app logo here
            const FlutterLogo(size: 100),
            const SizedBox(height: 24),
            // App name
            Text(
              'My App',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            // Loading indicator
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
} 