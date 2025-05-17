import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/quote_model.dart';

class QuoteApiService {
  static const String _apiKey = 'J9Op5bkpZdtrQ2eFmusYMQ==DKX7xePpClrwQ3wk';
  static const String _baseUrl = 'https://api.api-ninjas.com/v1/quotes';

  Future<List<Quote>> fetchQuotes() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'X-Api-Key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Quote.fromJson(json)).toList();
      }
      throw Exception('Failed to load quotes');
    } catch (e) {
      throw Exception('Failed to load quotes: $e');
    }
  }
} 