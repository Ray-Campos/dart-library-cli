import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/api_config.dart';
import '../models/user.dart';

class UserService {
  final String _usersUrl = '${ApiConfig.baseUrl}/users';

  Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse(_usersUrl),
      headers: ApiConfig.defaultHeaders,
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create user: ${response.body}');
  }

  Future<List<User>> getAllUsers() async {
    final response = await http.get(Uri.parse(_usersUrl));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      return List<User>.from(l.map((model) => User.fromJson(model)));
    }
    throw Exception('Failed to fetch users');
  }

  Future<User?> getUserById(int id) async {
    final response = await http.get(Uri.parse('$_usersUrl/$id'));
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    }
    throw Exception('Failed to fetch user details');
  }

  Future<User> updateUser(int id, User userDetails) async {
    final response = await http.put(
      Uri.parse('$_usersUrl/$id'),
      headers: ApiConfig.defaultHeaders,
      body: jsonEncode(userDetails.toJson()),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to update user: ${response.body}');
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$_usersUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }
}