# CLI de Gestão de Biblioteca

Um aplicativo de interface de linha de comando (CLI) construído com Dart para gerenciar um sistema de biblioteca. Este projeto atua como o consumidor (client-side) para uma API REST centralizada, substituindo a persistência tradicional baseada em arquivos por uma arquitetura moderna cliente-servidor.

## Funcionalidades

* **Fluxos Baseados em Papéis:** Interfaces distintas para administradores e usuários comuns.
* **Painel do Administrador:**
* Cadastrar novos usuários com papéis específicos (STUDENT, PROFESSOR, EXTERNAL).
* Gerenciar o catálogo da biblioteca (adicionar e listar títulos de livros).
* Gerenciar o estoque físico (adicionar cópias dos livros).


* **Painel do Usuário:**
* Consultar o acervo disponível.
* Pegar livros emprestados (valida automaticamente limites de empréstimo do usuário, bloqueios e calcula datas de devolução).
* Devolver livros (processa automaticamente a avaliação da condição do livro e multas por atraso).



## Pré-requisitos

* [Dart SDK](https://dart.dev/get-dart?utm_source=gemini) instalado em sua máquina local.
* API REST de Gestão de Biblioteca (Spring Boot/PostgreSQL) rodando localmente em `http://localhost:8080`.

## Instalação

1. Clone este repositório.
2. Navegue até o diretório raiz do projeto.
3. Instale as dependências necessárias:

```bash
dart pub get

```

## Como Usar

Inicie a aplicação CLI executando o seguinte comando a partir do diretório raiz:

```bash
dart run

```

### Fluxo de Autenticação

Quando a aplicação iniciar, você será solicitado a fazer login:

* **Acesso de Administrador:** Digite `admin` para entrar no painel de gerenciamento e preencher o banco de dados.
* **Acesso de Usuário:** Digite seu ID numérico de Usuário (gerado através do painel do Administrador) para acessar o fluxo de empréstimos e devoluções.

*Nota: A interface do terminal está localizada em Português (PT-BR), enquanto a arquitetura interna e os modelos são construídos em Inglês.*

## Estrutura do Projeto

* `bin/main.dart`: Ponto de entrada da aplicação e laço de inicialização.
* `lib/models/`: Representações de dados (`user.dart`, `book.dart`, `book_copy.dart`, `loan.dart`) para serialização JSON.
* `lib/services/api_client.dart`: Camada de serviço HTTP que gerencia as requisições GET, POST, PUT e DELETE para o backend.
* `lib/views/`: Lógica e roteamento da interface de terminal (`login_view.dart`, `admin_view.dart`, `user_view.dart`).