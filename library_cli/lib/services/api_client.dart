//Useless file, but I will keep it for now in case I need to use it later. I will use the services instead of this file.

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../models/book.dart';
import '../models/book_copy.dart';
import '../models/loan.dart';

class ApiClient {
  static const String baseUrl = 'http://localhost:8081/api';
  final Map<String, String> headers = {'Content-Type': 'application/json'};

  // User Endpoints
  Future<User?> getUserById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$id'));
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    }
    throw Exception('Failed to fetch user');
  }

  Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: headers,
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create user');
  }

  // Book Endpoints
  Future<List<Book>> getAllBooks() async {
    final response = await http.get(Uri.parse('$baseUrl/books'));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      return List<Book>.from(l.map((model) => Book.fromJson(model)));
    }
    throw Exception('Failed to fetch books');
  }

  Future<Book> createBook(Book book) async {
    final response = await http.post(
      Uri.parse('$baseUrl/books'),
      headers: headers,
      body: jsonEncode(book.toJson()),
    );
    if (response.statusCode == 201) {
      return Book.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create book');
  }

  // Book Copy Endpoints
  Future<BookCopy> createBookCopy(int bookId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/copies'),
      headers: headers,
      body: jsonEncode({'bookId': bookId}),
    );
    if (response.statusCode == 201) {
      return BookCopy.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create book copy');
  }

  // Loan Endpoints
  Future<Loan> borrowBook(int userId, int bookId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/loans/borrow'),
      headers: headers,
      body: jsonEncode({'userId': userId, 'bookId': bookId}),
    );
    if (response.statusCode == 201) {
      return Loan.fromJson(jsonDecode(response.body));
    }
    throw Exception(response.body); // Returns the business rule error from Spring Boot
  }

  Future<Loan> returnBook(int loanId, String condition) async {
    final response = await http.post(
      Uri.parse('$baseUrl/loans/return'),
      headers: headers,
      body: jsonEncode({'loanId': loanId, 'condition': condition}),
    );
    if (response.statusCode == 200) {
      return Loan.fromJson(jsonDecode(response.body));
    }
    throw Exception(response.body);
  }
}