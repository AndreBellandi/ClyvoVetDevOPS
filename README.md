# ClyvoVetDevOPS — Opção 2: Serviço de Aplicativo (App Service)

README com o **passo a passo (how-to)** para a entrega da disciplina **DevOps Tools & Cloud Computing** usando a **Opção 2: Serviço de Aplicativo (App Service)** — API **.NET** publicada em Azure App Service, com banco de dados **também na nuvem**, porém **nada containerizado** (nem app, nem banco).

> Repositório do projeto: [AndreBellandi/ClyvoVetDevOPS](https://github.com/AndreBellandi/ClyvoVetDevOPS)
> Ajuste nomes de recursos, região, credenciais e caminhos conforme o ambiente real antes de executar os comandos.

---

## Índice

1. [Descrição da solução](#1-descrição-da-solução)
2. [Benefícios para o negócio](#2-benefícios-para-o-negócio)
3. [Arquitetura da solução](#3-arquitetura-da-solução)
4. [Pré-requisitos](#4-pré-requisitos)
5. [Criação dos recursos via Azure CLI](#5-criação-dos-recursos-via-azure-cli)
6. [Banco de dados em nuvem (PaaS)](#6-banco-de-dados-em-nuvem-paas)
7. [Deploy da aplicação no App Service](#7-deploy-da-aplicação-no-app-service)
8. [CRUD e evidências de persistência](#8-crud-e-evidências-de-persistência)
9. [Entrega (PDF e vídeo)](#9-entrega-pdf-e-vídeo)
10. [Checklist final (penalidades a evitar)](#10-checklist-final-penalidades-a-evitar)

---

## 1. Descrição da solução

A **CLYVO VET** é uma aplicação para clínicas veterinárias que permite gerenciar o cuidado contínuo do pet: cadastro de tutores e pets, histórico clínico, consultas e serviços. O backend é uma API **ASP.NET Core**, publicada em um **Azure App Service**, conectada a um banco de dados relacional **PaaS** na nuvem.

## 2. Benefícios para o negócio

**Atendimento preventivo em vez de reativo.** O score de saúde e a varredura de vacinas pendentes permitem que a clínica identifique animais em risco antes da queixa clínica, transformando consulta de emergência em acompanhamento programado.

**Histórico unificado.** Cada atendimento passa a compor um prontuário contínuo. O veterinário recebe consultas anteriores, vacinas aplicadas e medicações prescritas em uma requisição, sem depender da memória do tutor.

**Redução de faltas e de vacinas vencidas.** A rotina de alertas identifica vencimentos, viabilizando contato ativo com o tutor — receita recorrente que hoje se perde por esquecimento.

**Base para integração.** Sendo REST com contrato OpenAPI, o mesmo backend atende aplicativo do tutor, sistema da clínica e futuros parceiros sem reescrita.

**Operação observável.** Health checks, log estruturado com correlação e métricas de latência e erro permitem detectar degradação antes que o usuário reclame, requisito para operar em nuvem com SLA.

## 3. Arquitetura da solução

```
┌────────────┐        HTTPS        ┌──────────────────────────┐        SQL        ┌───────────────────────────┐
│  Usuário   │ ─────────────────▶  │  Azure App Service         │ ────────────────▶ │  Banco PaaS (Azure SQL /    │
│ (Tutor/Vet)│                     │  (clyvovet-api)             │                    │  PostgreSQL / MySQL / Oracle)│
└────────────┘                     └──────────────────────────┘                    └───────────────────────────┘
        ▲                                    │
        │                                    ▼
        │                          ┌──────────────────────────┐
        └───────────────────────── │   App Service Plan          │
             deploy via CLI/Git    │   (compute do App Service)  │
                                    └──────────────────────────┘
```

- **Persona Desenvolvedor**: publica o código da API diretamente no App Service (sem build de imagem Docker).
- **Persona Usuário final**: consome a API publicada, que se conecta ao banco PaaS.
- **Fluxo**: `az webapp up` / deploy via zip → App Service inicia a aplicação → API conecta ao banco PaaS via connection string.

> Desenhe este diagrama em uma ferramenta simples (draw.io, Excalidraw) — **não** use notação de Fluxo/TOGAF/UML, pois não será aceito.

## 4. Pré-requisitos

- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) instalada e autenticada (`az login`)
- .NET SDK instalado localmente para build/publish
- Conta ativa no Azure (assinatura com permissão para criar recursos)
- **Nenhum Docker é necessário nesta opção** — nada pode ser containerizado

```bash
az login
az account set --subscription "<NOME_OU_ID_DA_ASSINATURA>"
```

## 5. Criação dos recursos via Azure CLI

Todos os recursos (App e Banco de Dados) devem ser criados via **Azure CLI** — não pelo Portal manualmente.

### 5.1 Resource Group

```bash
az group create \
  --name rg-clyvovet \
  --location canadacentral
```

### 5.2 App Service Plan

```bash
az appservice plan create \
  --name plan-clyvovet \
  --resource-group rg-clyvovet \
  --sku B1 \
  --is-linux
```

### 5.3 Web App (App Service)

```bash
az webapp create \
  --name clyvovet-api \
  --resource-group rg-clyvovet \
  --plan plan-clyvovet \
  --runtime "DOTNETCORE:8.0"
```

## 6. Banco de dados em nuvem (PaaS)

Bancos aceitos: **Azure SQL (PaaS)**, **MySQL**, **PostgreSQL**, ou **Oracle da FIAP**. Não é permitido H2 nem qualquer banco containerizado nesta opção.

Exemplo com **Azure SQL**:

```bash
az sql server create \
  --name sql-clyvovet \
  --resource-group rg-clyvovet \
  --location brazilsouth \
  --admin-user clyvoadmin \
  --admin-password "<SENHA_SEGURA>"

az sql db create \
  --resource-group rg-clyvovet \
  --server sql-clyvovet \
  --name clyvovetdb \
  --service-objective Basic

az sql server firewall-rule create \
  --resource-group rg-clyvovet \
  --server sql-clyvovet \
  --name AllowAzureServices \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 0.0.0.0
```

Aplicar o `script_bd.sql` (DDL + inserts) no banco criado:

```bash
sqlcmd -S sql-clyvovet.database.windows.net -U clyvoadmin -P "<SENHA_SEGURA>" -d clyvovetdb -i script_bd.sql
```

> Se optar por Oracle da FIAP, use a connection string fornecida pela instituição em vez de criar um servidor Oracle próprio.

## 7. Deploy da aplicação no App Service

### 7.1 Configurar a connection string (variável protegida)

```bash
az webapp config appsettings set \
  --name clyvovet-api \
  --resource-group rg-clyvovet \
  --settings ConnectionStrings__Default="<CONNECTION_STRING_SEGURA>"
```

> Nunca deixe usuário/senha/token no `appsettings.json` versionado — sempre via `az webapp config appsettings` ou Azure Key Vault.

### 7.2 Publish e deploy via zip

```bash
dotnet publish -c Release -o ./publish

cd publish
zip -r ../clyvovet-api.zip .
cd ..

az webapp deploy \
  --name clyvovet-api \
  --resource-group rg-clyvovet \
  --src-path clyvovet-api.zip \
  --type zip
```

### 7.3 Validar o deploy

```bash
az webapp show --name clyvovet-api --resource-group rg-clyvovet --query "defaultHostName" -o tsv
az webapp log tail --name clyvovet-api --resource-group rg-clyvovet
```

Acesse `https://clyvovet-api.azurewebsites.net` (ou `/swagger`) para validar que a API está de pé.

## 8. CRUD e evidências de persistência

O CRUD deve cobrir pelo menos **duas tabelas relacionadas entre si**, do CORE da aplicação (nada de cidade/estado/usuário genérico), com pelo menos 2 linhas significativas cada. Evidência sempre via `SELECT` direto no banco:

| Operação | Endpoint (exemplo) | Evidência exigida |
|---|---|---|
| Create | `POST /api/pets` | `SELECT * FROM PET WHERE ID = ...` após o insert |
| Read | `GET /api/pets/{id}` | Consulta retornando os dados persistidos |
| Update | `PUT /api/pets/{id}` | `SELECT` mostrando o valor alterado |
| Delete | `DELETE /api/pets/{id}` | `SELECT` mostrando a ausência do registro |

## 9. Entrega (PDF e vídeo)

**PDF de entrega deve conter apenas:**
- Nome completo e RM de todos os integrantes
- Link do repositório no GitHub
- Link do vídeo no YouTube
- Nada além disso — todo o resto (README, scripts) fica no GitHub.

**Vídeo demonstrativo (mínimo 720p, áudio claro, explicação por voz, sem legendas):**
1. Mostrar a criação dos recursos na Azure (App Service Plan, Web App, banco PaaS).
2. Clone do repositório no GitHub → obrigatório começar assim os testes da solução.
3. Deploy da aplicação seguindo exatamente os passos deste README.
4. Criação, configuração e testes do App e do Banco de Dados na nuvem, seguindo o README.
5. Demonstração individual de cada operação do CRUD **diretamente no banco por `SELECT`**: inserção, atualização, exclusão e consulta, evidenciando a integração total entre App e Banco.
6. Sem cortes no vídeo durante a evidência do CRUD.

## 10. Checklist final (penalidades a evitar)

- [ ] Nada rodando em `localhost` — tudo publicado na nuvem (senão: zero de nota)
- [ ] Entrega dentro da data/horário definidos (senão: zero de nota)
- [ ] Professor com acesso ao repositório e ao vídeo (senão: zero de nota)
- [ ] Descrição da solução e do benefício para o negócio no README (-10 pontos cada, se ausente)
- [ ] README com instruções de deploy/teste (How To) (-30 pontos se ausente)
- [ ] Evidência clara de cada operação CRUD no banco (-30 pontos se ausente)
- [ ] Vídeo com boa qualidade e explicação falada (-30 pontos se não)
- [ ] Código-fonte publicado no GitHub (-40 pontos se ausente)
- [ ] PDF com nome completo, RM e links (-30 pontos se ausente)
- [ ] `script_bd.sql` com DDL incluído (-10 pontos se ausente)
- [ ] Pelo menos 2 linhas significativas inseridas nas tabelas usadas (-20 pontos se não)
- [ ] CRUD em pelo menos duas tabelas (-20 pontos se usar só uma)
- [ ] Tabelas do CORE da solução, não genéricas (-30 pontos se não)
- [ ] **Não misturar as opções de entrega** — nada pode estar containerizado nesta opção (-40 pontos se o App estiver containerizado, -40 pontos se o Banco estiver containerizado)
- [ ] Sem dados sensíveis expostos no código-fonte (-20 pontos se houver)
- [ ] Diagrama de arquitetura sem estilo Fluxo/TOGAF/UML (-20 pontos se usar)
- [ ] Banco permitido (Azure SQL PaaS, MySQL, PostgreSQL, Oracle da FIAP — nunca H2) (-40 pontos se não)
- [ ] Recursos (App e Banco) criados via Azure CLI (-30 pontos se não)
- [ ] Scripts de recursos entregues no README (grupo de recurso, plano do serviço, serviço de aplicativo, banco de dados, configurações) (-10 pontos por script faltando)