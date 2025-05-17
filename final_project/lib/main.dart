// Import necessary Flutter and third-party packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/theme/app_theme.dart';
import 'package:myapp/viewmodels/auth_viewmodel.dart';
import 'package:myapp/viewmodels/theme_viewmodel.dart';
import 'package:myapp/viewmodels/items_viewmodel.dart';
import 'package:myapp/viewmodels/quote_viewmodel.dart';
import 'package:myapp/screens/splash_screen/splash_screen.dart';
import 'package:myapp/services/api/api_service.dart';
import 'package:myapp/services/api/auth_api_service.dart';
import 'package:myapp/services/api/items_api_service.dart';
import 'package:myapp/services/api/quote_api_service.dart';

// Main function - Entry point of the application
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SharedPreferences for local storage
  final prefs = await SharedPreferences.getInstance();
  
  // Initialize API services
  // Note: Using empty base URL since we're using local storage
  final apiService = ApiService(baseUrl: '');
  final authApiService = AuthApiService(apiService);
  final itemsApiService = ItemsApiService(apiService);
  final quoteApiService = QuoteApiService();
  
  // Run the app with initialized services
  runApp(MyApp(
    prefs: prefs,
    authApiService: authApiService,
    itemsApiService: itemsApiService,
    quoteApiService: quoteApiService,
  ));
}

// Root widget of the application
class MyApp extends StatelessWidget {
  // Required services and preferences
  final SharedPreferences prefs;
  final AuthApiService authApiService;
  final ItemsApiService itemsApiService;
  final QuoteApiService quoteApiService;

  const MyApp({
    super.key,
    required this.prefs,
    required this.authApiService,
    required this.itemsApiService,
    required this.quoteApiService,
  });

  @override
  Widget build(BuildContext context) {
    // Set up providers for state management
    return MultiProvider(
      providers: [
        // Theme provider for light/dark mode
        ChangeNotifierProvider(create: (_) => ThemeViewModel(prefs)),
        // Auth provider for user authentication
        ChangeNotifierProvider(create: (_) => AuthViewModel(prefs, authApiService)),
        // Items provider for managing items
        ChangeNotifierProvider(create: (_) => ItemsViewModel(prefs, itemsApiService)),
        // Quote provider for daily quotes
        ChangeNotifierProvider(create: (_) => QuoteViewModel(quoteApiService)),
      ],
      // Consumer for theme changes
      child: Consumer<ThemeViewModel>(
        builder: (context, themeViewModel, child) {
          return MaterialApp(
            title: 'My App',
            debugShowCheckedModeBanner: false,
            // Set up light and dark themes
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeViewModel.themeMode,
            // Start with splash screen
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
