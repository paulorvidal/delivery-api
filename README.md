# Delivery API - White-Label System

![Java](https://img.shields.io/badge/Java-17-ED8B00?style=for-the-badge&logo=java&logoColor=white)
![Spring Boot](https://img.shields.io/badge/Spring_Boot-3.x-6DB33F?style=for-the-badge&logo=spring-boot&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-24.0-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Flyway](https://img.shields.io/badge/Flyway-Database_Migration-CC0200?style=for-the-badge&logo=flyway&logoColor=white)

## Visão Geral

Sistema de back-end construído para suportar operações de plataformas de delivery no modelo SaaS White-Label (Multi-tenant). A aplicação permite que múltiplos restaurantes gerenciem seus próprios catálogos, pedidos, clientes e regras de negócio (cupons, horários, taxas) de forma totalmente isolada em uma única instância de banco de dados.

O projeto foi desenhado com foco em integridade de dados (prevenção de concorrência e histórico imutável de transações financeiras) e obedece aos padrões de mercado para escalabilidade técnica.

## Arquitetura e Tecnologias

A API foi construída sob a arquitetura RESTful, organizada pelo padrão **Package by Feature** (módulos isolados por domínio de negócio), utilizando as seguintes tecnologias:

- **Linguagem:** Java 17 (LTS)
- **Framework Core:** Spring Boot 3.x
- **Acesso a Dados:** Spring Data JPA / Hibernate
- **Banco de Dados:** PostgreSQL 15
- **Versionamento de Banco:** Flyway (Migrations)
- **Segurança:** Spring Security
- **Infraestrutura:** Docker e Docker Compose
- **Build Tool:** Maven

## Estrutura do Banco de Dados (Multi-tenant)

A modelagem de dados adota a abordagem Multi-tenant por coluna, garantindo o isolamento da informação através da chave estrangeira `restaurante_id` presente na maioria das entidades. O schema atual contempla 11 tabelas distribuídas nos seguintes módulos de negócio:

1.  **Autenticação e Acesso:** `usuario`, `perfil`
2.  **Núcleo do Lojista:** `restaurante`, `horario_funcionamento`
3.  **Catálogo de Produtos:** `categoria`, `produto`, `grupo_complemento`, `complemento`
4.  **Vendas e Transações:** `pedido`, `item_pedido`, `endereco_usuario`
5.  **Marketing e Integrações:** `cupom_desconto`, `pagamento_pedido`

## Pré-requisitos de Ambiente

Para executar o projeto localmente, certifique-se de ter as seguintes ferramentas instaladas:

- Java Development Kit (JDK) 17
- Docker Desktop (com a engine em execução)
- Git

---

## Como Executar o Projeto

Existem duas abordagens para rodar a aplicação: o modo de desenvolvimento (para alterar o código e testar em tempo real) e o modo de produção (totalmente conteinerizado).

### Modo 1: Desenvolvimento Local (API nativa + DB no Docker)

Neste formato, o banco de dados roda em um container isolado e a aplicação Spring Boot roda diretamente na máquina host.

1.  **Clone o repositório:**

    ```bash
    git clone [https://github.com/seu-usuario/delivery-api.git](https://github.com/seu-usuario/delivery-api.git)
    cd delivery-api
    ```

2.  **Suba o container do banco de dados (PostgreSQL):**

    ```bash
    docker-compose up -d
    ```

    > **Nota técnica:** O Flyway está configurado para assumir o controle do DDL. As migrations localizadas em `src/main/resources/db/migration` serão executadas automaticamente assim que a API se conectar ao banco.

3.  **Execute a aplicação utilizando o Maven Wrapper:**

    ```bash
    # Em terminais Linux/Mac ou Git Bash:
    ./mvnw spring-boot:run

    # No PowerShell do Windows:
    .\mvnw spring-boot:run
    ```

4.  **Verifique o status da aplicação:**
    Acesse no navegador ou via terminal:
    ```http
    GET http://localhost:8080/api/status
    ```

### Modo 2: Execução 100% Conteinerizada (Docker Compose)

Para ambientes de homologação ou validação rápida sem dependência do ambiente Java local.

1.  **Gere o artefato executável:**

    ```bash
    ./mvnw clean package -DskipTests
    ```

2.  **Suba a infraestrutura completa:**

    ```bash
    docker-compose up --build -d
    ```

3.  **Encerrar a execução:**
    ```bash
    docker-compose down
    ```

---

## Registro de Desenvolvimento (Changelog)

### [v0.0.1] - 15/03/2026

**Bootstrap e Fundação de Dados**

- Inicialização do projeto base via Spring Initializr.
- Configuração de infraestrutura com Docker (PostgreSQL com volumes persistentes).
- Modelagem do banco de dados relacional com 11 tabelas.
- Implementação do Flyway para controle de versionamento de schema.
- Estruturação base de pacotes (Package by Feature).
- Endpoint de Health Check genérico e configuração base do Spring Security.

### [v0.0.2] - 24/03/2026

**Mapeamento de Domínio e Persistência Dinâmica**

- Implementação do Modelo de Dados (JPA): Tradução completa do schema SQL para entidades Java, utilizando UUIDs para chaves primárias e BigDecimal para precisão financeira.

- Arquitetura Multi-tenant: Configuração de relacionamentos @ManyToOne e @OneToMany garantindo o isolamento de dados por restaurante através da coluna restaurante_id.

**Módulos Implementados:**

- Usuario & Perfil: Sistema de acesso com suporte a diferentes tipos de usuários (Lojista, Cliente, Entregador).

- Catalogo: Estrutura hierárquica de Categorias, Produtos e Complementos (Adicionais).

- Pedido: Lógica de transação com "fotografia" de preços e estados do pedido (Pendente, Preparando, etc.).

- Restaurante: Configurações de loja, regras de frete e horários de funcionamento.

- Camada de Dados: Criação de JPA Repositories com suporte a buscas customizadas por Slug e CNPJ.

- Configuração de Segurança: Inicialização do SecurityFilterChain para gestão de rotas e proteção de endpoints.

### [v0.0.3] - 22/04/2026

**Refatoração de Banco de Dados e Segurança no Cadastro de Usuários**

- **Otimização do Schema Base (Flyway):** Consolidação de múltiplos scripts de migração em um único arquivo robusto (`V1__create_initial_schema.sql`), implementando travas de segurança (`CHECK constraints`) para status e índices (`INDEX`) para garantir performance em consultas de chaves estrangeiras.
- **Prevenção contra Mass Assignment:** Implementação do padrão DTO (Data Transfer Object) com as classes `UsuarioCadastroRequestDTO` e `UsuarioResponseDTO`, blindando a API contra escalonamento de privilégios (Privilege Escalation) pelo front-end.
- **Regras de Negócio de Identidade:** Criação do `UsuarioService` aplicando a lógica de segurança fundamental: criptografia de senha via `PasswordEncoder` e atribuição forçada (backend-driven) do perfil padrão `ROLE_CLIENTE` para novos cadastros públicos.
- **Repositórios de Acesso:** Construção das interfaces `UsuarioRepository` e `PerfilRepository` (Spring Data JPA) com métodos customizados para validação de e-mail e CPF únicos no momento do cadastro.
- **Validação de Entrada:** Integração do Spring Boot Validation (`@NotBlank`, `@Email`) na camada de DTO para garantir a consistência e integridade dos dados da requisição antes do processamento.
