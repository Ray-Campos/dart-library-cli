// lib/views/user_view.dart

import 'dart:io';
import '../services/user_service.dart';
import '../services/book_service.dart';
import '../services/loan_service.dart';
import '../models/user.dart';
import '../models/book.dart';
import '../models/loan.dart';

class UserView {
  final UserService userService = UserService();
  final BookService bookService = BookService();
  final LoanService loanService = LoanService();
  
  final User loggedInUser;

  UserView({required this.loggedInUser});

  Future<void> showMenu() async {
    while (true) {
      print('\n--- BEM-VINDO, ${loggedInUser.name.toUpperCase()} ---');
      print('1. Meu Perfil');
      print('2. Consultar Acervo');
      print('3. Pegar Livro Emprestado');
      print('4. Devolver Livro');
      print('5. Meus Emprestimos');
      print('0. Sair');
      stdout.write('Escolha uma opcao: ');

      String? choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          await _viewProfile();
          break;
        case '2':
          await _listBooks();
          break;
        case '3':
          await _borrowBook();
          break;
        case '4':
          await _returnBook();
          break;
        case '5':
          await _viewMyLoans();
          break;
        case '0':
          print('Encerrando sessao...');
          return;
        default:
          print('Opcao invalida.');
      }
    }
  }

  Future<void> _viewProfile() async {
    print('\n--- MEU PERFIL ---');
    if (loggedInUser.id == null) return;
    
    try {
      User? user = await userService.getUserById(loggedInUser.id!);
      if (user != null) {
        print('ID: ${user.id}');
        print('Nome: ${user.name}');
        print('Papel: ${user.role}');
        print('Status: ${user.isBlocked ? "BLOQUEADO (Procure a administracao para regularizar)" : "ATIVO"}');
      }
    } catch (e) {
      print('Erro ao carregar perfil: $e');
    }
  }

  Future<void> _listBooks() async {
    print('\n--- ACERVO DA BIBLIOTECA ---');
    try {
      List<Book> books = await bookService.getAllBooks();
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
        var loan = await loanService.borrowBook(loggedInUser.id!, bookId);
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
        var loan = await loanService.returnBook(loanId, condition);
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

  Future<void> _viewMyLoans() async {
    if (loggedInUser.id == null) return;
    
    print('\n--- MEUS EMPRESTIMOS ---');
    try {
      List<Loan> activeLoans = await loanService.getActiveLoansByUser(loggedInUser.id!);
      List<Loan> allLoans = await loanService.getLoansByUser(loggedInUser.id!);

      print('\n[ Emprestimos Ativos ]');
      if (activeLoans.isEmpty) {
        print('Voce nao possui livros pendentes de devolucao.');
      } else {
        for (var loan in activeLoans) {
          print('ID do Emprestimo: ${loan.id} | Vencimento: ${loan.dueDate}');
        }
      }

      print('\n[ Historico Completo ]');
      if (allLoans.isEmpty) {
        print('Nenhum registro encontrado.');
      } else {
        for (var loan in allLoans) {
          String status = loan.returnDate == null 
              ? 'PENDENTE (Vence em ${loan.dueDate})' 
              : 'DEVOLVIDO em ${loan.returnDate}';
          print('ID: ${loan.id} | Status: $status | Multa: R\$ ${loan.fineAmount?.toStringAsFixed(2) ?? "0.00"}');
        }
      }
    } catch (e) {
      print('Erro ao carregar relatorio de emprestimos: $e');
    }
  }
}