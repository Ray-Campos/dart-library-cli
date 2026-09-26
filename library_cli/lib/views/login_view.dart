import 'dart:io';
import '../services/api_client.dart';
import '../models/user.dart';
import 'admin_view.dart';
import 'user_view.dart';

class LoginView {
  final ApiClient apiClient = ApiClient();

  Future<void> start() async {
    while (true) {
      print('\n--- SISTEMA DE BIBLIOTECA ---');
      stdout.write('Digite seu ID de acesso (ou "admin" para painel de controle): ');
      String? input = stdin.readLineSync()?.trim();

      if (input == null || input.isEmpty) {
        continue;
      }

      if (input.toLowerCase() == 'admin') {
        AdminView adminView = AdminView();
        await adminView.showMenu();
      } else {
        int? userId = int.tryParse(input);
        if (userId != null) {
          try {
            User? user = await apiClient.getUserById(userId);
            if (user != null) {
              UserView userView = UserView(loggedInUser: user);
              await userView.showMenu();
            } else {
              print('Usuario nao encontrado.');
            }
          } catch (e) {
            print('Erro ao conectar com o servidor: $e');
          }
        } else {
          print('Entrada invalida. Digite um ID numerico ou "admin".');
        }
      }
    }
  }
}