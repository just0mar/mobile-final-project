import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/models/item_model.dart';
import 'package:myapp/services/api/items_api_service.dart';
import 'package:image_picker/image_picker.dart';

// ItemsViewModel class - Manages the state and business logic for items
class ItemsViewModel extends ChangeNotifier {
  // Key for storing items in SharedPreferences
  static const String _itemsKey = 'items';
  
  // Dependencies
  final SharedPreferences _prefs;
  final ItemsApiService _itemsApiService;
  
  // State variables
  List<Item> _items = [];
  List<Item> _favorites = [];
  bool _isLoading = false;
  String? _error;
  List<File>? _selectedImages = [];

  // Constructor - Initializes the view model and loads items
  ItemsViewModel(this._prefs, this._itemsApiService) {
    _loadItems();
  }

  // Getters for state variables
  List<Item> get items => _items;
  List<Item> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<File>? get selectedImages => _selectedImages;

  // Load items from storage or API
  Future<void> _loadItems() async {
    _isLoading = true;
    _error = null;

    try {
      // Try to load from API first
      final items = await _itemsApiService.getItems();
      _items = items.map((item) => Item.fromJson(item)).toList();
      _updateFavorites();
      _error = null;
    } catch (e) {
      // Fallback to local storage if API fails
      final String? itemsJson = _prefs.getString(_itemsKey);
      if (itemsJson != null) {
        final List<dynamic> decoded = json.decode(itemsJson);
        _items = decoded.map((item) => Item.fromJson(item)).toList();
        _updateFavorites();
      }
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update the favorites list based on items' favorite status
  void _updateFavorites() {
    _favorites = _items.where((item) => item.isFavorite).toList();
  }

  // Save items to local storage
  Future<void> _saveItems() async {
    final String encoded = json.encode(_items.map((item) => item.toJson()).toList());
    await _prefs.setString(_itemsKey, encoded);
  }

  // Add a new item
  Future<void> addItem(Item item) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try to add through API first
      final response = await _itemsApiService.createItem(item.toJson());
      final newItem = Item.fromJson(response);
      _items.add(newItem);
      await _saveItems();
      _updateFavorites();
      _error = null;
    } catch (e) {
      // Fallback to local storage if API fails
      _items.add(item);
      await _saveItems();
      _updateFavorites();
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update an existing item
  Future<void> updateItem(Item item) async {
    try {
      // Try to update through API first
      final response = await _itemsApiService.updateItem(item.id, item.toJson());
      final updatedItem = Item.fromJson(response);
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _items[index] = updatedItem;
        await _saveItems();
        _updateFavorites();
        notifyListeners();
      }
    } catch (e) {
      // Fallback to local storage if API fails
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _items[index] = item;
        await _saveItems();
        _updateFavorites();
        notifyListeners();
      }
    }
  }

  // Delete an item
  Future<void> deleteItem(String id) async {
    try {
      // Try to delete through API first
      await _itemsApiService.deleteItem(id);
      _items.removeWhere((item) => item.id == id);
      await _saveItems();
      _updateFavorites();
      notifyListeners();
    } catch (e) {
      // Fallback to local storage if API fails
      _items.removeWhere((item) => item.id == id);
      await _saveItems();
      _updateFavorites();
      notifyListeners();
    }
  }

  // Toggle favorite status of an item
  Future<void> toggleFavorite(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try to update through API first
      await _itemsApiService.toggleFavorite(id);
      final index = _items.indexWhere((item) => item.id == id);
      if (index != -1) {
        final item = _items[index];
        _items[index] = item.copyWith(isFavorite: !item.isFavorite);
        await _saveItems();
        _updateFavorites();
      }
    } catch (e) {
      // Fallback to local storage if API fails
      final index = _items.indexWhere((item) => item.id == id);
      if (index != -1) {
        final item = _items[index];
        _items[index] = item.copyWith(isFavorite: !item.isFavorite);
        await _saveItems();
        _updateFavorites();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get items for a specific user
  List<Item> getItemsByUserId(String userId) {
    return _items.where((item) => item.userId == userId).toList();
  }

  // Get favorite items for a specific user
  List<Item> getFavoriteItems(String userId) {
    return _items.where((item) => item.userId == userId && item.isFavorite).toList();
  }

  // Pick multiple images from gallery
  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
      notifyListeners();
    }
  }

  // Remove an image from selected images
  void removeImage(int index) {
    if (_selectedImages != null && index >= 0 && index < _selectedImages!.length) {
      _selectedImages!.removeAt(index);
      notifyListeners();
    }
  }

  // Clear selected images
  void clearSelectedImages() {
    _selectedImages = [];
    notifyListeners();
  }
} 