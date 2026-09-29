import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/api_config.dart';
import '../models/book_copy.dart';

class CopyService {
  final String _copiesUrl = '${ApiConfig.baseUrl}/copies';

  Future<BookCopy> createBookCopy(int bookId) async {
    final response = await http.post(
      Uri.parse(_copiesUrl),
      headers: ApiConfig.defaultHeaders,
      body: jsonEncode({'bookId': bookId}),
    );
    if (response.statusCode == 201) {
      return BookCopy.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create book copy: ${response.body}');
  }

  Future<List<BookCopy>> getAllCopies() async {
    final response = await http.get(Uri.parse(_copiesUrl));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      return List<BookCopy>.from(l.map((model) => BookCopy.fromJson(model)));
    }
    throw Exception('Failed to fetch copies');
  }

  Future<BookCopy?> getCopyById(int id) async {
    final response = await http.get(Uri.parse('$_copiesUrl/$id'));
    if (response.statusCode == 200) {
      return BookCopy.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    }
    throw Exception('Failed to fetch copy details');
  }

  Future<BookCopy> updateCopyStatus(int id, String status) async {
    final response = await http.put(
      Uri.parse('$_copiesUrl/$id'),
      headers: ApiConfig.defaultHeaders,
      body: jsonEncode({'status': status}),
    );
    if (response.statusCode == 200) {
      return BookCopy.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to update copy status: ${response.body}');
  }

  Future<void> deleteCopy(int id) async {
    final response = await http.delete(Uri.parse('$_copiesUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete copy');
    }
  }
}