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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  // Initialize services with local storage
  final apiService = ApiService(baseUrl: ''); // Empty base URL since we're using local storage
  final authApiService = AuthApiService(apiService);
  final itemsApiService = ItemsApiService(apiService);
  final quoteApiService = QuoteApiService();
  
  runApp(MyApp(
    prefs: prefs,
    authApiService: authApiService,
    itemsApiService: itemsApiService,
    quoteApiService: quoteApiService,
  ));
}

class MyApp extends StatelessWidget {
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeViewModel(prefs)),
        ChangeNotifierProvider(create: (_) => AuthViewModel(prefs, authApiService)),
        ChangeNotifierProvider(create: (_) => ItemsViewModel(prefs, itemsApiService)),
        ChangeNotifierProvider(create: (_) => QuoteViewModel(quoteApiService)),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeViewModel, child) {
          return MaterialApp(
            title: 'My App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeViewModel.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
