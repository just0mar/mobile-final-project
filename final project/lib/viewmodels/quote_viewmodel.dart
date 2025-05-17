import 'package:flutter/material.dart';
import 'package:myapp/models/quote_model.dart';
import 'package:myapp/services/api/quote_api_service.dart';

class QuoteViewModel extends ChangeNotifier {
  final QuoteApiService _quoteApiService;
  Quote? _currentQuote;
  bool _isLoading = false;
  String? _error;

  QuoteViewModel(this._quoteApiService);

  Quote? get currentQuote => _currentQuote;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchQuote() async {
    if (_currentQuote != null) return; // Don't fetch if we already have a quote

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final quotes = await _quoteApiService.fetchQuotes();
      if (quotes.isNotEmpty) {
        _currentQuote = quotes.first;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshQuote() async {
    _currentQuote = null; // Clear current quote
    await fetchQuote(); // Fetch a new quote
  }
} 