import 'dart:io';
import '../services/user_service.dart';
import '../models/user.dart';
import 'admin_view.dart';
import 'user_view.dart';

class LoginView {
  final UserService userService = UserService();

  Future<void> start() async {
    while (true) {
      print('\n--- SISTEMA DE BIBLIOTECA ---');
      stdout.write('Digite seu ID de acesso ("admin" para painel, "sair" para encerrar): ');
      String? input = stdin.readLineSync()?.trim();

      if (input == null || input.isEmpty) {
        continue;
      }

      // Check if user wants to quit
      if (input.toLowerCase() == 'sair' || input.toLowerCase() == 'quit') {
        print('Encerrando o sistema. Até logo!');
        break; // Exits the while loop
      }

      if (input.toLowerCase() == 'admin') {
        AdminView adminView = AdminView();
        await adminView.showMenu();
      } else {
        int? userId = int.tryParse(input);
        if (userId != null) {
          try {
            // Using the UserService to fetch the user by ID
            User? user = await userService.getUserById(userId);
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
          print('Entrada invalida. Digite um ID numerico, "admin" ou "sair".');
        }
      }
    }
  }
}