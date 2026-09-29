import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/api_config.dart';
import '../models/loan.dart';

class LoanService {
  final String _loansUrl = '${ApiConfig.baseUrl}/loans';

  // Transactional methods
  Future<Loan> borrowBook(int userId, int bookId) async {
    final response = await http.post(
      Uri.parse('$_loansUrl/borrow'),
      headers: ApiConfig.defaultHeaders,
      body: jsonEncode({'userId': userId, 'bookId': bookId}),
    );
    if (response.statusCode == 201) {
      return Loan.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to borrow book: ${response.body}');
  }

  Future<Loan> returnBook(int loanId, String condition) async {
    final response = await http.post(
      Uri.parse('$_loansUrl/return'),
      headers: ApiConfig.defaultHeaders,
      body: jsonEncode({'loanId': loanId, 'condition': condition}),
    );
    if (response.statusCode == 200) {
      return Loan.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to return book: ${response.body}');
  }

  // Query methods
  Future<List<Loan>> getAllLoans() async {
    final response = await http.get(Uri.parse(_loansUrl));
    return _parseLoanList(response);
  }

  Future<List<Loan>> getAllActiveLoans() async {
    final response = await http.get(Uri.parse('$_loansUrl/active'));
    return _parseLoanList(response);
  }

  Future<List<Loan>> getLoansByUser(int userId) async {
    final response = await http.get(Uri.parse('$_loansUrl/user/$userId'));
    return _parseLoanList(response);
  }

  Future<List<Loan>> getActiveLoansByUser(int userId) async {
    final response = await http.get(Uri.parse('$_loansUrl/user/$userId/active'));
    return _parseLoanList(response);
  }

  Future<List<Loan>> getLoansByBook(int bookId) async {
    final response = await http.get(Uri.parse('$_loansUrl/book/$bookId'));
    return _parseLoanList(response);
  }

  Future<List<Loan>> getActiveLoansByBook(int bookId) async {
    final response = await http.get(Uri.parse('$_loansUrl/book/$bookId/active'));
    return _parseLoanList(response);
  }

  //Helper, could be on a new layer
  List<Loan> _parseLoanList(http.Response response) {
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      return List<Loan>.from(l.map((model) => Loan.fromJson(model)));
    }
    throw Exception('Failed to fetch loans: ${response.statusCode}');
  }

}