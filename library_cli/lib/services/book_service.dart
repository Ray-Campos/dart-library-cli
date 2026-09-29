import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/api_config.dart';
import '../models/book.dart';

class BookService {
  final String _booksUrl = '${ApiConfig.baseUrl}/books';

  Future<Book> createBook(Book book) async {
    final response = await http.post(
      Uri.parse(_booksUrl),
      headers: ApiConfig.defaultHeaders,
      body: jsonEncode(book.toJson()),
    );
    if (response.statusCode == 201) {
      return Book.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create book: ${response.body}');
  }

  Future<List<Book>> getAllBooks() async {
    final response = await http.get(Uri.parse(_booksUrl));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      return List<Book>.from(l.map((model) => Book.fromJson(model)));
    }
    throw Exception('Failed to fetch books');
  }

  Future<Book?> getBookById(int id) async {
    final response = await http.get(Uri.parse('$_booksUrl/$id'));
    if (response.statusCode == 200) {
      return Book.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    }
    throw Exception('Failed to fetch book details');
  }

  Future<Book> updateBook(int id, Book bookDetails) async {
    final response = await http.put(
      Uri.parse('$_booksUrl/$id'),
      headers: ApiConfig.defaultHeaders,
      body: jsonEncode(bookDetails.toJson()),
    );
    if (response.statusCode == 200) {
      return Book.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to update book: ${response.body}');
  }

  Future<void> deleteBook(int id) async {
    final response = await http.delete(Uri.parse('$_booksUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete book');
    }
  }
}