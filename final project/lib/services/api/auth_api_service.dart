import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:myapp/services/api/api_service.dart';
import 'package:http/http.dart' as http;

class AuthApiService {
  static const String _usersFileName = 'users.json';
  List<Map<String, dynamic>> _users = [];
  final ApiService _apiService;

  AuthApiService(this._apiService) {
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_usersFileName');
      
      if (await file.exists()) {
        final contents = await file.readAsString();
        _users = List<Map<String, dynamic>>.from(json.decode(contents));
      }
    } catch (e) {
      _users = [];
    }
  }

  Future<void> _saveUsers() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_usersFileName');
      await file.writeAsString(json.encode(_users));
    } catch (e) {
      print('Error saving users: $e');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    await _loadUsers();
    final user = _users.firstWhere(
      (user) => user['email'] == email && user['password'] == password,
      orElse: () => throw Exception('Invalid email or password'),
    );
    return {'name': user['name']};
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    await _loadUsers();
    
    // Check if email already exists
    if (_users.any((user) => user['email'] == email)) {
      throw Exception('Email already registered');
    }

    // Add new user
    _users.add({
      'name': name,
      'email': email,
      'password': password,
    });

    await _saveUsers();
    return {'name': name};
  }

  Future<void> logout(String email) async {
    // No need to do anything for local storage
  }

  Future<Map<String, dynamic>> getUserProfile(String email) async {
    await _loadUsers();
    final user = _users.firstWhere(
      (user) => user['email'] == email,
      orElse: () => throw Exception('User not found'),
    );
    return {
      'name': user['name'],
      'email': user['email'],
    };
  }

  Future<void> updateProfile(
    String currentEmail, {
    required String name,
    required String email,
    String? newPassword,
  }) async {
    await _loadUsers();
    
    // Find the user index
    final userIndex = _users.indexWhere((user) => user['email'] == currentEmail);
    if (userIndex == -1) {
      throw Exception('User not found');
    }

    // Check if new email is already taken by another user
    if (email != currentEmail && _users.any((user) => user['email'] == email)) {
      throw Exception('Email already taken');
    }

    // Update user data
    _users[userIndex] = {
      ..._users[userIndex],
      'name': name,
      'email': email,
      if (newPassword != null && newPassword.isNotEmpty)
        'password': newPassword,
    };

    await _saveUsers();
  }
} 