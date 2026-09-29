import 'dart:io';
import '../services/user_service.dart';
import '../services/book_service.dart';
import '../services/copy_service.dart';
import '../services/loan_service.dart';
import '../models/user.dart';
import '../models/book.dart';
import '../models/book_copy.dart';
import '../models/loan.dart';

class AdminView {
  final UserService userService = UserService();
  final BookService bookService = BookService();
  final CopyService copyService = CopyService();
  final LoanService loanService = LoanService();

  Future<void> showMenu() async {
    while (true) {
      print('\n--- PAINEL DE ADMINISTRACAO ---');
      print('1. Gerenciar Usuarios');
      print('2. Gerenciar Catalogo de Livros');
      print('3. Gerenciar Acervo Fisico (Copias)');
      print('4. Relatorios de Emprestimos');
      print('0. Sair');
      stdout.write('Escolha uma opcao: ');

      String? choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          await _manageUsers();
          break;
        case '2':
          await _manageBooks();
          break;
        case '3':
          await _manageCopies();
          break;
        case '4':
          await _manageLoans();
          break;
        case '0':
          print('Saindo do painel de administracao...');
          return;
        default:
          print('Opcao invalida. Tente novamente.');
      }
    }
  }

  // --- LOAN REPORTS ---
  Future<void> _manageLoans() async {
    while (true) {
      print('\n--- RELATORIOS DE EMPRESTIMOS ---');
      print('1. Listar Todos os Emprestimos (Historico Global)');
      print('2. Listar Emprestimos Ativos (Nao devolvidos)');
      print('3. Consultar Historico por ID do Usuario');
      print('4. Consultar Historico por ID do Livro');
      print('0. Voltar');
      stdout.write('Escolha: ');

      String? choice = stdin.readLineSync();
      if (choice == '0') return;

      try {
        switch (choice) {
          case '1':
            List<Loan> loans = await loanService.getAllLoans();
            _printLoans(loans);
            break;
          case '2':
            List<Loan> activeLoans = await loanService.getAllActiveLoans();
            _printLoans(activeLoans);
            break;
          case '3':
            stdout.write('ID do Usuario: ');
            int? userId = int.tryParse(stdin.readLineSync() ?? '');
            if (userId != null) {
              List<Loan> userLoans = await loanService.getLoansByUser(userId);
              _printLoans(userLoans);
            }
            break;
          case '4':
            stdout.write('ID do Livro: ');
            int? bookId = int.tryParse(stdin.readLineSync() ?? '');
            if (bookId != null) {
              List<Loan> bookLoans = await loanService.getLoansByBook(bookId);
              _printLoans(bookLoans);
            }
            break;
          default:
            print('Opcao invalida.');
        }
      } catch (e) {
        print('Erro ao buscar relatorios: $e');
      }
    }
  }

  void _printLoans(List<Loan> loans) {
    if (loans.isEmpty) {
      print('Nenhum registro de emprestimo encontrado.');
      return;
    }
    for (var loan in loans) {
      String status = loan.returnDate == null 
          ? 'ATIVO (Vence: ${loan.dueDate})' 
          : 'DEVOLVIDO (${loan.returnDate})';
      // Adjust the property access based on exactly how your Dart Loan model maps the JSON objects
      print('ID: ${loan.id} | Status: $status');
    }
  }

  // --- USER MANAGEMENT ---
  Future<void> _manageUsers() async {
    while (true) {
      print('\n--- GERENCIAR USUARIOS ---');
      print('1. Cadastrar Usuario');
      print('2. Listar Todos os Usuarios');
      print('3. Buscar Usuario por ID');
      print('4. Atualizar Usuario');
      print('5. Excluir Usuario');
      print('0. Voltar');
      stdout.write('Escolha: ');

      String? choice = stdin.readLineSync();
      if (choice == '0') return;

      try {
        switch (choice) {
          case '1': 
            stdout.write('Nome do usuario: ');
            String name = stdin.readLineSync() ?? '';
            stdout.write('Papel (STUDENT, PROFESSOR, EXTERNAL): ');
            String role = stdin.readLineSync() ?? '';
            if (name.isNotEmpty && role.isNotEmpty) {
              User created = await userService.createUser(User(name: name, role: role.toUpperCase()));
              print('Usuario cadastrado com sucesso! ID: ${created.id}');
            }
            break;
          case '2': 
            List<User> users = await userService.getAllUsers();
            users.isEmpty ? print('Nenhum usuario.') : users.forEach((u) => print('ID: ${u.id} | Nome: ${u.name} | Papel: ${u.role} | Bloqueado: ${u.isBlocked}'));
            break;
          case '3': 
            stdout.write('ID do usuario: ');
            int? id = int.tryParse(stdin.readLineSync() ?? '');
            if (id != null) {
              User? u = await userService.getUserById(id);
              u != null ? print('Encontrado -> Nome: ${u.name}, Papel: ${u.role}, Bloqueado: ${u.isBlocked}') : print('Usuario nao encontrado.');
            }
            break;
          case '4': 
            stdout.write('ID do usuario a atualizar: ');
            int? id = int.tryParse(stdin.readLineSync() ?? '');
            if (id != null) {
              stdout.write('Novo Nome: ');
              String name = stdin.readLineSync() ?? '';
              stdout.write('Novo Papel: ');
              String role = stdin.readLineSync() ?? '';
              stdout.write('Esta bloqueado? (s/n): ');
              bool isBlocked = (stdin.readLineSync()?.toLowerCase() == 's');
              User updated = await userService.updateUser(id, User(name: name, role: role.toUpperCase(), isBlocked: isBlocked));
              print('Usuario ${updated.id} atualizado.');
            }
            break;
          case '5': 
            stdout.write('ID do usuario a excluir: ');
            int? id = int.tryParse(stdin.readLineSync() ?? '');
            if (id != null) {
              await userService.deleteUser(id);
              print('Usuario excluido com sucesso.');
            }
            break;
          default:
            print('Opcao invalida.');
        }
      } catch (e) {
        print('Erro na operacao: $e');
      }
    }
  }

  // --- BOOK MANAGEMENT ---
  Future<void> _manageBooks() async {
    while (true) {
      print('\n--- GERENCIAR LIVROS ---');
      print('1. Cadastrar Livro');
      print('2. Listar Todos os Livros');
      print('3. Buscar Livro por ID');
      print('4. Atualizar Livro');
      print('5. Excluir Livro');
      print('0. Voltar');
      stdout.write('Escolha: ');

      String? choice = stdin.readLineSync();
      if (choice == '0') return;

      try {
        switch (choice) {
          case '1': 
            stdout.write('Titulo: ');
            String title = stdin.readLineSync() ?? '';
            stdout.write('Autor: ');
            String author = stdin.readLineSync() ?? '';
            stdout.write('ISBN: ');
            String isbn = stdin.readLineSync() ?? '';
            if (title.isNotEmpty && author.isNotEmpty && isbn.isNotEmpty) {
              Book created = await bookService.createBook(Book(title: title, author: author, isbn: isbn));
              print('Livro cadastrado com sucesso! ID: ${created.id}');
            }
            break;
          case '2': 
            List<Book> books = await bookService.getAllBooks();
            books.isEmpty ? print('Nenhum livro.') : books.forEach((b) => print('ID: ${b.id} | Titulo: ${b.title} | Autor: ${b.author}'));
            break;
          case '3': 
            stdout.write('ID do livro: ');
            int? id = int.tryParse(stdin.readLineSync() ?? '');
            if (id != null) {
              Book? b = await bookService.getBookById(id);
              b != null ? print('Encontrado -> Titulo: ${b.title}, Autor: ${b.author}, ISBN: ${b.isbn}') : print('Livro nao encontrado.');
            }
            break;
          case '4': 
            stdout.write('ID do livro a atualizar: ');
            int? id = int.tryParse(stdin.readLineSync() ?? '');
            if (id != null) {
              stdout.write('Novo Titulo: ');
              String title = stdin.readLineSync() ?? '';
              stdout.write('Novo Autor: ');
              String author = stdin.readLineSync() ?? '';
              stdout.write('Novo ISBN: ');
              String isbn = stdin.readLineSync() ?? '';
              Book updated = await bookService.updateBook(id, Book(title: title, author: author, isbn: isbn));
              print('Livro ${updated.id} atualizado.');
            }
            break;
          case '5': 
            stdout.write('ID do livro a excluir: ');
            int? id = int.tryParse(stdin.readLineSync() ?? '');
            if (id != null) {
              await bookService.deleteBook(id);
              print('Livro excluido com sucesso.');
            }
            break;
          default:
            print('Opcao invalida.');
        }
      } catch (e) {
        print('Erro na operacao: $e');
      }
    }
  }

  // --- COPIES MANAGEMENT ---
  Future<void> _manageCopies() async {
    while (true) {
      print('\n--- GERENCIAR COPIAS ---');
      print('1. Registrar Nova Copia');
      print('2. Listar Todas as Copias');
      print('3. Buscar Copia por ID');
      print('4. Atualizar Status da Copia');
      print('5. Excluir Copia');
      print('0. Voltar');
      stdout.write('Escolha: ');

      String? choice = stdin.readLineSync();
      if (choice == '0') return;

      try {
        switch (choice) {
          case '1': 
            stdout.write('ID do Livro base: ');
            int? bookId = int.tryParse(stdin.readLineSync() ?? '');
            if (bookId != null) {
              BookCopy created = await copyService.createBookCopy(bookId);
              print('Copia criada com sucesso! ID: ${created.id}');
            }
            break;
          case '2': 
            List<BookCopy> copies = await copyService.getAllCopies();
            copies.isEmpty ? print('Nenhuma copia.') : copies.forEach((c) => print('ID Copia: ${c.id} | ID Livro: ${c.book?.id} | Status: ${c.status}'));
            break;
          case '3': 
            stdout.write('ID da Copia: ');
            int? id = int.tryParse(stdin.readLineSync() ?? '');
            if (id != null) {
              BookCopy? c = await copyService.getCopyById(id);
              c != null ? print('Encontrada -> Livro: ${c.book?.title}, Status: ${c.status}') : print('Copia nao encontrada.');
            }
            break;
          case '4': 
            stdout.write('ID da Copia a atualizar: ');
            int? id = int.tryParse(stdin.readLineSync() ?? '');
            if (id != null) {
              stdout.write('Novo Status (AVAILABLE, BORROWED, LOST, DAMAGED): ');
              String status = stdin.readLineSync() ?? '';
              BookCopy updated = await copyService.updateCopyStatus(id, status.toUpperCase());
              print('Status da copia ${updated.id} atualizado.');
            }
            break;
          case '5': 
            stdout.write('ID da copia a excluir: ');
            int? id = int.tryParse(stdin.readLineSync() ?? '');
            if (id != null) {
              await copyService.deleteCopy(id);
              print('Copia excluida com sucesso.');
            }
            break;
          default:
            print('Opcao invalida.');
        }
      } catch (e) {
        print('Erro na operacao: $e');
      }
    }
  }
}