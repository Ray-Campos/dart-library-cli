# CLI de Gestão de Biblioteca

Um aplicativo de interface de linha de comando (CLI) construído com Dart para gerenciar um sistema de biblioteca. Este projeto atua como o consumidor (client-side) para uma API REST centralizada, substituindo a persistência tradicional baseada em arquivos por uma arquitetura moderna cliente-servidor.

> **Backend API:** [springboot-library-api](https://github.com/Ray-Campos/springboot-library-api)

## Funcionalidades

 **Fluxos Baseados em Papéis:** Interfaces distintas para administradores e usuários comuns.


 **Painel do Administrador:**
* Gerenciamento completo (CRUD) de Usuários com papéis específicos (STUDENT, PROFESSOR, EXTERNAL).


* Gerenciamento completo (CRUD) do Catálogo de Livros.


* Gerenciamento completo (CRUD) do Acervo Físico (Cópias).


* Relatórios de Empréstimos (histórico global, empréstimos ativos, consultas por ID de usuário e por ID de livro).


 **Painel do Usuário:**
* Meu Perfil (consulta de status e verificação de bloqueios ativos).
* Consultar o acervo disponível.


* Pegar livros emprestados (valida automaticamente limites de empréstimo do usuário, bloqueios e calcula datas de devolução).


* Devolver livros (processa automaticamente a avaliação da condição do livro e multas por atraso).


* Meus Empréstimos (acompanhamento de devoluções pendentes e histórico completo do usuário).



## Pré-requisitos

* [Dart SDK](https://dart.dev/get-dart) instalado em sua máquina local.


* API REST de Gestão de Biblioteca (Spring Boot/PostgreSQL) rodando localmente em `http://localhost:8081` (A porta foi configurada para 8081 visando evitar conflitos com instalações locais do PostgreSQL).

## Instalação

1. Clone este repositório.
```bash
git clone https://github.com/Ray-Campos/dart-library-cli
cd library-cli

```


2. Instale as dependências necessárias:



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



*Nota: A interface do terminal está localizada em Português (PT-BR), enquanto a arquitetura interna e os modelos são construídos em Inglês*.

## Estrutura do Projeto

* `bin/library_cli.dart`: Ponto de entrada da aplicação e laço de inicialização.


* `lib/core/api_config.dart`: Configurações de rede centralizadas (URL base e headers HTTP padronizados).
* `lib/models/`: Representações de dados (`user.dart`, `book.dart`, `book_copy.dart`, `loan.dart`) para serialização JSON.


* `lib/services/`: Camada de serviços HTTP segregada por domínio (`user_service.dart`, `book_service.dart`, `copy_service.dart`, `loan_service.dart`).
* `lib/views/`: Lógica e roteamento da interface de terminal (`login_view.dart`, `admin_view.dart`, `user_view.dart`).