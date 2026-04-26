# SaaS Cobrança - Multi-tenant Billing API

## Visão Geral

Sistema de back-end construído para suportar operações de faturamento e pagamentos no modelo SaaS (Software as a Service). A aplicação permite que múltiplas empresas (inquilinos/tenants) gerenciem seus próprios clientes, boletos e recebimentos de forma totalmente isolada em uma única instância de banco de dados.

O projeto foi desenhado com foco em isolamento absoluto de dados, segurança financeira e arquitetura corporativa, obedecendo aos mais rigorosos padrões de mercado para escalabilidade técnica em sistemas B2B.

## Arquitetura e Tecnologias

A API foi construída sob a arquitetura RESTful, organizada pelo padrão **Package by Feature** (módulos isolados por domínio de negócio), utilizando as seguintes tecnologias:

* **Linguagem:** Java 17 (LTS)
* **Framework Core:** Spring Boot 3.x
* **Acesso a Dados:** Spring Data JPA / Hibernate
* **Banco de Dados:** PostgreSQL 15
* **Versionamento de Banco:** Flyway (Migrations)
* **Segurança e Isolamento:** Filtros HTTP Customizados e Contexto de Thread (ThreadLocal)
* **Infraestrutura:** Docker e Docker Compose
* **Build Tool:** Maven

## Estrutura do Banco de Dados (Multi-tenant)

Diferente de abordagens mais simples, a modelagem de dados deste projeto adota a estratégia **Multi-tenant por Schema (Schema per Tenant)**. Isso garante o isolamento físico/lógico da informação. O banco é dividido em duas áreas de contexto:

* **Núcleo Administrativo (Schema Public):** `tenant` (Gerencia as empresas clientes e roteamento de banco).
* **Domínio do Inquilino (Schemas Privados dinâmicos):** * **Gestão de Entidades:** `cliente`
    * **Transações Financeiras:** `cobranca`, `pagamento`

A modelagem conta com travas de integridade (CHECK constraints), uso de `UUID` nativo e `Soft Delete` para auditoria financeira impecável.

## Pré-requisitos de Ambiente

Para executar o projeto localmente, certifique-se de ter as seguintes ferramentas instaladas:

* Java Development Kit (JDK) 17
* Docker Desktop (com a engine em execução)
* Git

## Como Executar o Projeto

Existem duas abordagens para rodar a aplicação: o modo de desenvolvimento (para alterar o código e testar em tempo real) e o modo de produção (totalmente conteinerizado).

### Modo 1: Desenvolvimento Local (API nativa + DB no Docker)

Neste formato, o banco de dados roda em um container isolado e a aplicação Spring Boot roda diretamente na máquina host.

1.  **Clone o repositório:**
    ```bash
    git clone [https://github.com/seu-usuario/saas-cobranca.git](https://github.com/seu-usuario/saas-cobranca.git)
    cd saas-cobranca
    ```

2.  **Suba o container do banco de dados (PostgreSQL):**
    ```bash
    docker-compose up -d
    ```
    *Nota técnica:* O Flyway está configurado para assumir o controle do DDL. As migrations localizadas em `src/main/resources/db/migration` serão executadas automaticamente assim que a API se conectar ao banco.

3.  **Execute a aplicação utilizando o Maven Wrapper:**
    ```bash
    # Em terminais Linux/Mac ou Git Bash:
    ./mvnw spring-boot:run
    
    # No PowerShell do Windows:
    .\mvnw spring-boot:run
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

### [v0.0.1] - 23/04/2026
**Bootstrap, Modelagem Avançada e Isolamento de Contexto**

* **Fundação de Infraestrutura:** Inicialização do projeto base via Spring Initializr e configuração de containerização com Docker (PostgreSQL 15).
* **Modelagem de Banco de Dados Corporativa:** Desenho de arquitetura Multi-tenant (Schema per Tenant). Criação de tabelas com foco em segurança financeira (UUIDs para ofuscação de volume, tipo `NUMERIC(15,2)` para precisão monetária, campos de auditoria e *Soft Delete* via coluna `ativo`).
* **Controle de Versionamento DDL:** Implementação do Flyway com separação de pastas para o schema público (`V1`) e os moldes das tabelas dos inquilinos (`V2`).
* **Rich Domain Model (Entidades Ricas):** Mapeamento JPA da entidade `Tenant` fugindo do antipadrão de setters anêmicos. Implementação de construtores validados, métodos de regras de negócio (`suspenderAcesso()`, `alterarPlano()`) e uso de callbacks do Hibernate (`@PreUpdate`).
* **Segurança de Concorrência (ThreadLocal):** Construção da classe `TenantContext` utilizando `InheritableThreadLocal` para garantir que o acesso ao banco de dados não sofra vazamento de memória (Data Leakage) entre as requisições de diferentes empresas rodando nas threads do Tomcat.
* **Filtro HTTP (Fail-Fast):** Implementação da camada de interceptação de requisições `TenantFilter`. O filtro atua como um *Gateway de Segurança*, bloqueando imediatamente acessos sem identificação de inquilino (cabeçalho `X-Tenant-ID`), com exceção de rotas públicas definidas na "Whitelist".

## Diagrama de Entidade-Relacionamento (ERD)

Abaixo está a representação visual do banco de dados, separando o contexto administrativo do contexto isolado do inquilino.

```mermaid
erDiagram
    %% ==========================================
    %% SCHEMA PUBLIC (Administração do SaaS)
    %% ==========================================
    TENANT {
        VARCHAR id PK
        VARCHAR nome_empresa
        VARCHAR schema_name UK
        VARCHAR email_contato
        VARCHAR plano_assinatura
        BOOLEAN ativo
        TIMESTAMP data_criacao
        TIMESTAMP data_atualizacao
    }

    %% ==========================================
    %% SCHEMA PRIVADO (Domínio do Inquilino)
    %% ==========================================
    CLIENTE {
        UUID id PK
        VARCHAR nome
        VARCHAR documento UK
        VARCHAR email
        VARCHAR telefone
        VARCHAR cep
        VARCHAR logradouro
        VARCHAR numero
        VARCHAR complemento
        VARCHAR bairro
        VARCHAR cidade
        VARCHAR uf
        BOOLEAN ativo
        TIMESTAMP data_cadastro
        TIMESTAMP data_atualizacao
    }

    ASSINATURA {
        UUID id PK
        UUID cliente_id FK
        VARCHAR plano_nome
        NUMERIC valor
        VARCHAR ciclo
        INTEGER dia_vencimento
        DATE proximo_vencimento
        VARCHAR status
        TIMESTAMP data_criacao
        TIMESTAMP data_atualizacao
    }

    COBRANCA {
        UUID id PK
        UUID cliente_id FK
        UUID assinatura_id FK
        VARCHAR descricao
        NUMERIC valor_original
        NUMERIC valor_multa
        NUMERIC valor_juros
        NUMERIC valor_desconto
        DATE data_vencimento
        VARCHAR status
        VARCHAR gateway_id
        VARCHAR link_fatura
        VARCHAR linha_digitavel
        TEXT pix_copia_cola
        BOOLEAN ativo
        TIMESTAMP data_criacao
        TIMESTAMP data_atualizacao
    }

    PAGAMENTO {
        UUID id PK
        UUID cobranca_id FK
        NUMERIC valor_pago
        TIMESTAMP data_pagamento
        VARCHAR metodo
        VARCHAR gateway_transacao_id
        VARCHAR status
    }

    NOTIFICACAO_COBRANCA {
        UUID id PK
        UUID cobranca_id FK
        VARCHAR tipo_canal
        VARCHAR tipo_aviso
        VARCHAR status_envio
        TIMESTAMP data_envio
        TEXT mensagem_erro
    }

    WEBHOOK_LOG {
        UUID id PK
        VARCHAR gateway
        VARCHAR evento_tipo
        JSONB payload
        VARCHAR status_processamento
        INTEGER tentativas
        TEXT mensagem_erro
        TIMESTAMP data_recebimento
        TIMESTAMP data_processamento
    }

    %% Relacionamentos
    CLIENTE ||--o{ ASSINATURA : contrata
    CLIENTE ||--o{ COBRANCA : possui
    ASSINATURA ||--o{ COBRANCA : gera
    COBRANCA ||--o{ PAGAMENTO : recebe_tentativas
    COBRANCA ||--o{ NOTIFICACAO_COBRANCA : dispara


## Padrões de Projeto e Decisões Arquiteturais

Para manter a base de código escalável e segura, este projeto adota as seguintes práticas:

* **Package by Feature:** A estrutura de diretórios é organizada por módulo de negócio (ex: `cliente`, `cobranca`, `tenant`), facilitando a manutenção e a futura quebra em microsserviços, se necessário.
* **Rich Domain Model (Modelo de Domínio Rico):** Rejeição do antipadrão de modelo anêmico. O uso do Lombok é restrito (apenas `@Getter` e construtores `protected` nas entidades). O estado das entidades só é alterado através de métodos de negócio que garantem a integridade dos dados (ex: `inativar()`, em vez de `setAtivo(false)`).
* **Fail-Fast Validation:** Validações rigorosas ocorrem nos construtores das entidades e nos filtros HTTP, abortando requisições inválidas antes que consumam recursos do servidor ou alcancem o banco de dados.

## Estrutura de Diretórios Base

```text
src/main/java/br/com/paulovidal/saas_cobranca/
 ├── config/            # Filtros de Segurança, Contexto Tenant, Swagger
 ├── tenant/            # Entidade, Repositório e Serviço (Schema Public)
 ├── cliente/           # Domínio de Clientes (Schema Inquilino)
 ├── assinatura/        # Motor de Recorrência e Contratos
 ├── cobranca/          # Emissão de Faturas e Pagamentos
 └── webhook/           # Recepção de eventos do Gateway de Pagamento

 ## Roadmap e Próximos Passos

- [ ] **v0.0.2:** Mapeamento JPA das entidades de negócio (`Cliente`, `Assinatura`, `Cobranca`).
- [ ] **v0.0.3:** Implementação do motor de Provisionamento de Tenants (Criação de Schemas sob demanda via Flyway).
- [ ] **v0.1.0:** Autenticação e Autorização via JWT.
- [ ] **v0.2.0:** Integração com Gateway de Pagamento (Asaas/Mercado Pago) e recepção de Webhooks.

---

**Desenvolvido por Paulo Rogério Vidal**
