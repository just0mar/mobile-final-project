import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:myapp/services/api/auth_api_service.dart';
import 'package:myapp/services/api/items_api_service.dart';
import 'package:myapp/viewmodels/auth_viewmodel.dart';
import 'package:myapp/viewmodels/items_viewmodel.dart';
import 'package:myapp/main.dart';

// Create mock classes
@GenerateMocks([AuthApiService, ItemsApiService])
class MockAuthApiService extends Mock implements AuthApiService {}
class MockItemsApiService extends Mock implements ItemsApiService {}

class TestMyApp extends StatelessWidget {
  const TestMyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final prefs = snapshot.data!;
            final authApiService = MockAuthApiService();
            final itemsApiService = MockItemsApiService();

            // Set up mock responses
            when(authApiService.login(any, any)).thenAnswer((_) async => {'name': 'Test User'});
            when(authApiService.register(any, any, any)).thenAnswer((_) async => {'name': 'Test User'});
            when(itemsApiService.getItems()).thenAnswer((_) async => []);

            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => AuthViewModel(prefs, authApiService),
                ),
                ChangeNotifierProvider(
                  create: (_) => ItemsViewModel(prefs, itemsApiService),
                ),
              ],
              child: const MyApp(),
            );
          },
        ),
      ),
    );
  }
} 