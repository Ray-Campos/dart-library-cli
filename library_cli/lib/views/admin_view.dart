import 'dart:io';
import '../services/api_client.dart';
import '../models/user.dart';
import '../models/book.dart';

class AdminView {
  final ApiClient apiClient = ApiClient();

  Future<void> showMenu() async {
    while (true) {
      print('\n--- PAINEL DE ADMINISTRACAO ---');
      print('1. Gerenciar Usuarios');
      print('2. Gerenciar Catalogo de Livros');
      print('3. Gerenciar Acervo Fisico (Copias)');
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
        case '0':
          print('Saindo do painel de administracao...');
          return;
        default:
          print('Opcao invalida. Tente novamente.');
      }
    }
  }

  Future<void> _manageUsers() async {
    print('\n--- GERENCIAR USUARIOS ---');
    print('1. Cadastrar Usuario');
    print('2. Sair');
    stdout.write('Escolha: ');

    String? choice = stdin.readLineSync();
    if (choice == '1') {
      stdout.write('Nome do usuario: ');
      String? name = stdin.readLineSync();
      
      stdout.write('Papel (STUDENT, PROFESSOR, EXTERNAL): ');
      String? role = stdin.readLineSync();

      if (name != null && role != null && name.isNotEmpty && role.isNotEmpty) {
        try {
          User newUser = User(name: name, role: role.toUpperCase());
          User created = await apiClient.createUser(newUser);
          print('Usuario cadastrado com sucesso! ID: ${created.id}');
        } catch (e) {
          print('Erro ao cadastrar usuario: $e');
        }
      } else {
        print('Dados invalidos.');
      }
    }
  }

  Future<void> _manageBooks() async {
    print('\n--- GERENCIAR LIVROS ---');
    print('1. Cadastrar Livro');
    print('2. Listar Livros');
    print('3. Sair');
    stdout.write('Escolha: ');

    String? choice = stdin.readLineSync();
    if (choice == '1') {
      stdout.write('Titulo: ');
      String? title = stdin.readLineSync();
      
      stdout.write('Autor: ');
      String? author = stdin.readLineSync();
      
      stdout.write('ISBN: ');
      String? isbn = stdin.readLineSync();

      if (title != null && author != null && isbn != null) {
        try {
          Book newBook = Book(title: title, author: author, isbn: isbn);
          Book created = await apiClient.createBook(newBook);
          print('Livro cadastrado com sucesso! ID: ${created.id}');
        } catch (e) {
          print('Erro ao cadastrar livro: $e');
        }
      }
    } else if (choice == '2') {
      try {
        List<Book> books = await apiClient.getAllBooks();
        if (books.isEmpty) {
          print('Nenhum livro cadastrado.');
        } else {
          for (var book in books) {
            print('ID: ${book.id} | Titulo: ${book.title} | Autor: ${book.author}');
          }
        }
      } catch (e) {
        print('Erro ao buscar livros: $e');
      }
    }
  }

  Future<void> _manageCopies() async {
    print('\n--- GERENCIAR COPIAS ---');
    print('1. Adicionar Copia a um Livro');
    print('2. Sair');
    stdout.write('Escolha: ');

    String? choice = stdin.readLineSync();
    if (choice == '1') {
      stdout.write('Digite o ID do Livro: ');
      String? input = stdin.readLineSync();
      int? bookId = int.tryParse(input ?? '');

      if (bookId != null) {
        try {
          var copy = await apiClient.createBookCopy(bookId);
          print('Copia criada com sucesso! ID da Copia: ${copy.id}');
        } catch (e) {
          print('Erro ao criar copia: $e');
        }
      } else {
        print('ID invalido.');
      }
    }
  }
}