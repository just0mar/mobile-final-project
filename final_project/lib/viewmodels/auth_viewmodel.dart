import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/services/api/auth_api_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class AuthViewModel extends ChangeNotifier {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userProfilePicKey = 'user_profile_pic';

  final SharedPreferences _prefs;
  final AuthApiService _authApiService;
  bool _isLoggedIn;
  String? _userEmail;
  String? _userName;
  String? _profilePicPath;
  bool _isLoading = false;
  String? _error;

  AuthViewModel(this._prefs, this._authApiService)
      : _isLoggedIn = _prefs.getBool(_isLoggedInKey) ?? false,
        _userEmail = _prefs.getString(_userEmailKey),
        _userName = _prefs.getString(_userNameKey),
        _profilePicPath = _prefs.getString(_userProfilePicKey);

  bool get isLoggedIn => _isLoggedIn;
  String? get userEmail => _userEmail;
  String? get userName => _userName;
  String? get profilePicPath => _profilePicPath;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _loadUserData() {
    _userName = _prefs.getString(_userNameKey);
    _userEmail = _prefs.getString(_userEmailKey);
    _profilePicPath = _prefs.getString(_userProfilePicKey);
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authApiService.login(email, password);
      _isLoggedIn = true;
      _userEmail = email;
      _userName = response['name'] ?? email.split('@')[0];

      await _prefs.setBool(_isLoggedInKey, true);
      await _prefs.setString(_userEmailKey, email);
      await _prefs.setString(_userNameKey, _userName!);

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authApiService.register(name, email, password);
      _isLoggedIn = true;
      _userEmail = email;
      _userName = name;

      await _prefs.setBool(_isLoggedInKey, true);
      await _prefs.setString(_userEmailKey, email);
      await _prefs.setString(_userNameKey, name);

      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      if (_userEmail != null) {
        await _authApiService.logout(_userEmail!);
      }
      _isLoggedIn = false;
      _userEmail = null;
      _userName = null;
      _profilePicPath = null;

      await _prefs.setBool(_isLoggedInKey, false);
      await _prefs.remove(_userEmailKey);
      await _prefs.remove(_userNameKey);
      await _prefs.remove(_userProfilePicKey);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    String? newPassword,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (_userEmail != null) {
        await _authApiService.updateProfile(
          _userEmail!,
          name: name,
          email: email,
          newPassword: newPassword,
        );
        
        _userName = name;
        _userEmail = email;
        
        await _prefs.setString(_userNameKey, name);
        await _prefs.setString(_userEmailKey, email);
        
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      // Get the application documents directory
      final directory = await getApplicationDocumentsDirectory();
      final imageDir = Directory('${directory.path}/profile_images');
      
      // Create the images directory if it doesn't exist
      if (!await imageDir.exists()) {
        await imageDir.create(recursive: true);
      }

      // Generate a unique filename
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = File('${imageDir.path}/$fileName');

      // Copy the image to the app's documents directory
      await File(pickedFile.path).copy(savedImage.path);

      // Update profile picture in ViewModel
      await updateProfilePicture(savedImage.path);
    }
  }

  Future<void> updateProfilePicture(String path) async {
    _profilePicPath = path;
    await _prefs.setString(_userProfilePicKey, path);
    notifyListeners();
  }

  Future<void> removeProfilePicture() async {
    try {
      if (_profilePicPath != null) {
        // Delete the file from storage
        final file = File(_profilePicPath!);
        if (await file.exists()) {
          await file.delete();
        }
        
        // Clear the profile picture path
        _profilePicPath = null;
        await _prefs.remove(_userProfilePicKey);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
} 