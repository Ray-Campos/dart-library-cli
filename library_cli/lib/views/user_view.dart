import 'dart:io';
import '../services/api_client.dart';
import '../models/user.dart';
import '../models/book.dart';

class UserView {
  final ApiClient apiClient = ApiClient();
  final User loggedInUser;

  UserView({required this.loggedInUser});

  Future<void> showMenu() async {
    while (true) {
      print('\n--- BEM-VINDO, ${loggedInUser.name.toUpperCase()} ---');
      print('1. Consultar Acervo');
      print('2. Pegar Livro Emprestado');
      print('3. Devolver Livro');
      print('0. Sair');
      stdout.write('Escolha uma opcao: ');

      String? choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          await _listBooks();
          break;
        case '2':
          await _borrowBook();
          break;
        case '3':
          await _returnBook();
          break;
        case '0':
          print('Encerrando sessao...');
          return;
        default:
          print('Opcao invalida.');
      }
    }
  }

  Future<void> _listBooks() async {
    print('\n--- ACERVO DA BIBLIOTECA ---');
    try {
      List<Book> books = await apiClient.getAllBooks();
      if (books.isEmpty) {
        print('Nenhum livro disponivel no momento.');
      } else {
        for (var book in books) {
          print('ID: ${book.id} | Titulo: ${book.title} | Autor: ${book.author}');
        }
      }
    } catch (e) {
      print('Erro ao carregar o acervo: $e');
    }
  }

  Future<void> _borrowBook() async {
    print('\n--- PEGAR EMPRESTADO ---');
    stdout.write('Digite o ID do Livro: ');
    String? input = stdin.readLineSync();
    int? bookId = int.tryParse(input ?? '');

    if (bookId != null && loggedInUser.id != null) {
      try {
        var loan = await apiClient.borrowBook(loggedInUser.id!, bookId);
        print('Emprestimo realizado com sucesso!');
        print('ID do Emprestimo: ${loan.id}');
        print('Data de Devolucao: ${loan.dueDate}');
      } catch (e) {
        print('Falha ao realizar emprestimo: $e');
      }
    } else {
      print('ID de livro invalido.');
    }
  }

  Future<void> _returnBook() async {
    print('\n--- DEVOLVER LIVRO ---');
    stdout.write('Digite o ID do Emprestimo: ');
    String? loanInput = stdin.readLineSync();
    int? loanId = int.tryParse(loanInput ?? '');

    if (loanId != null) {
      print('Condicao do livro:');
      print('1. Em bom estado (AVAILABLE)');
      print('2. Danificado (DAMAGED)');
      print('3. Perdido (LOST)');
      stdout.write('Escolha a condicao: ');
      
      String? conditionChoice = stdin.readLineSync();
      String condition = 'AVAILABLE';
      
      if (conditionChoice == '2') condition = 'DAMAGED';
      if (conditionChoice == '3') condition = 'LOST';

      try {
        var loan = await apiClient.returnBook(loanId, condition);
        print('Devolucao registrada com sucesso!');
        if (loan.fineAmount != null && loan.fineAmount! > 0) {
          print('ATENCAO: Multa gerada no valor de R\$ ${loan.fineAmount!.toStringAsFixed(2)}');
        }
      } catch (e) {
        print('Falha ao registrar devolucao: $e');
      }
    } else {
      print('ID de emprestimo invalido.');
    }
  }
}