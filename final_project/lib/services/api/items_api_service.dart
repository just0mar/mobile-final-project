import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:myapp/services/api/api_service.dart';

class ItemsApiService {
  static const String _itemsFileName = 'items.json';
  List<Map<String, dynamic>> _items = [];

  ItemsApiService(ApiService _) {
    _loadItems();
  }

  Future<void> _loadItems() async {
    print('ItemsApiService: _loadItems started');
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_itemsFileName');
      
      if (await file.exists()) {
        final contents = await file.readAsString();
        print('ItemsApiService: Read from file: $contents');
        _items = List<Map<String, dynamic>>.from(json.decode(contents));
        // Ensure imageUrls is a List<String>
        for (var item in _items) {
          if (item.containsKey('imageUrls') && item['imageUrls'] is! List<String>?) {
             if (item['imageUrls'] is List) {
                item['imageUrls'] = List<String>.from(item['imageUrls']);
             } else {
                item['imageUrls'] = null; // Or an empty list [] depending on desired behavior for invalid data
             }
          }
        }
         print('ItemsApiService: _loadItems successfully loaded ${_items.length} items');
      }
       print('ItemsApiService: _loadItems finished');
    } catch (e) {
      _items = [];
       print('ItemsApiService: Error loading items: $e');
    }
  }

  Future<void> _saveItems() async {
    print('ItemsApiService: _saveItems started');
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_itemsFileName');
      final String encoded = json.encode(_items);
      print('ItemsApiService: Writing to file: $encoded');
      await file.writeAsString(encoded);
      print('ItemsApiService: _saveItems finished successfully');
    } catch (e) {
      print('ItemsApiService: Error saving items: $e');
    }
  }

  Future<List<dynamic>> getItems() async {
    await _loadItems();
    return _items;
  }

  Future<Map<String, dynamic>> getItemDetails(String itemId) async {
    await _loadItems();
    final item = _items.firstWhere(
      (item) => item['id'] == itemId,
      orElse: () => throw Exception('Item not found'),
    );
    return item;
  }

  Future<Map<String, dynamic>> createItem(Map<String, dynamic> itemData) async {
    await _loadItems(); // Load existing items before adding
    final newItem = {
      ...itemData,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'createdAt': DateTime.now().toIso8601String(),
      'isFavorite': false,
      // Ensure imageUrls is handled as a list
      'imageUrls': itemData.containsKey('imageUrls') && itemData['imageUrls'] is List ? List<String>.from(itemData['imageUrls']) : null, // Or []
    };
    _items.add(newItem);
    await _saveItems(); // Save after adding
    return newItem;
  }

  Future<Map<String, dynamic>> updateItem(String itemId, Map<String, dynamic> itemData) async {
    await _loadItems();
    final index = _items.indexWhere((item) => item['id'] == itemId);
    if (index == -1) {
      throw Exception('Item not found');
    }
    _items[index] = {
      ..._items[index],
      ...itemData,
      // Ensure imageUrls is handled as a list during update
      'imageUrls': itemData.containsKey('imageUrls') && itemData['imageUrls'] is List ? List<String>.from(itemData['imageUrls']) : _items[index]['imageUrls'],
    };
    await _saveItems();
    return _items[index];
  }

  Future<void> deleteItem(String itemId) async {
    await _loadItems();
    _items.removeWhere((item) => item['id'] == itemId);
    await _saveItems();
  }

  Future<List<dynamic>> getFavorites() async {
    await _loadItems();
    return _items.where((item) => item['isFavorite'] == true).toList();
  }

  Future<void> toggleFavorite(String itemId) async {
    await _loadItems();
    final index = _items.indexWhere((item) => item['id'] == itemId);
    if (index == -1) {
      throw Exception('Item not found');
    }
    _items[index]['isFavorite'] = !(_items[index]['isFavorite'] ?? false);
    await _saveItems();
  }
} 