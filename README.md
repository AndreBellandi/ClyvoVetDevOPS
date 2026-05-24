# PetSense

## Descrição do Projeto

A Petsense é uma solução desenvolvida para auxiliar a Clyvo Vet no gerenciamento de informações relacionadas aos pets, consultas e acompanhamento veterinário.

A aplicação foi desenvolvida utilizando ASP.NET Core e Oracle Database, com deploy em uma máquina virtual Linux na Microsoft Azure utilizando Docker.

---

## Benefícios para o Negócio

- Centralização das informações veterinárias
- Melhor organização das consultas e atendimentos
- Facilidade no gerenciamento de dados dos pets
- Escalabilidade da aplicação utilizando containers Docker
- Persistência e segurança dos dados utilizando Oracle Database
- Facilidade de deploy em ambiente cloud utilizando Azure

---

## Tecnologias Utilizadas

- ASP.NET Core (.NET 10)
- Oracle XE
- Docker
- Docker Compose
- Microsoft Azure
- Ubuntu Server 22.04

---

## Desenho Macro da Arquitetura

A aplicação foi implantada na Microsoft Azure utilizando uma máquina virtual Linux Ubuntu 22.04 com Docker para orquestração dos containers da API e do banco de dados Oracle.

Usuário
   ↓
Internet
   ↓
Azure (Brazil South)
   ↓
Resource Group: rg-sprint
   ↓
VM Linux Ubuntu 22.04
   ↓
Docker
 ├── Container App
 │     └── Porta 8080
 │
 └── Container DB (Oracle XE)
       └── Porta 1521
              ↓
        Volume Persistente
           oracle_data

## Rotas da API e Documentação
---

### 🗑️ Excluir Resource Group (obrigatório ao final)

```bash
# Sair da VM
exit

# Deletar todos os recursos
az group delete --name rg-sprint --yes --no-wait
```

---

## 📡 Rotas da API

> Base URL: `http://SEU_IP_PUBLICO:8080`
> Documentação interativa: `/scalar/v1`

---

### 👤 Tutores — `/api/tutores`
> Tabela Oracle: `DONOS`

| Método | Rota | Descrição | Status |
|--------|------|-----------|--------|
| `GET` | `/api/tutores?page=1&pageSize=10` | Lista todos os tutores com paginação | `200` |
| `GET` | `/api/tutores/{id}` | Busca tutor por ID com lista de pets | `200` `404` |
| `GET` | `/api/tutores/email/{email}` | Busca tutor por e-mail | `200` `404` |
| `GET` | `/api/tutores/{id}/pets` | Lista os pets do tutor | `200` `404` |
| `POST` | `/api/tutores` | Cadastra novo tutor | `201` `400` |
| `PUT` | `/api/tutores/{id}` | Atualiza dados do tutor | `200` `400` `404` |
| `DELETE` | `/api/tutores/{id}` | Remove tutor | `204` `404` |

<details>
<summary>📄 Body POST/PUT</summary>

```json
{
  "nome": "João Silva",
  "email": "joao@email.com",
  "telefone": "11999999999"
}
```
</details>

---

### 🐾 Pets — `/api/pets`
> Tabela Oracle: `PETS`

| Método | Rota | Descrição | Status |
|--------|------|-----------|--------|
| `GET` | `/api/pets?page=1&pageSize=10` | Lista todos os pets com paginação | `200` |
| `GET` | `/api/pets/{id}` | Detalha pet com tutor, vacinas e consultas | `200` `404` |
| `GET` | `/api/pets/especie/{especie}` | Filtra pets por espécie | `200` |
| `GET` | `/api/pets/raca/{raca}` | Filtra pets por raça | `200` |
| `GET` | `/api/pets/{id}/vacinas` | Histórico de vacinas do pet | `200` `404` |
| `GET` | `/api/pets/{id}/consultas` | Histórico de consultas do pet | `200` `404` |
| `GET` | `/api/pets/{id}/inteligencia-preventiva` | Score de saúde preventiva (0–100) e alertas | `200` `404` |
| `POST` | `/api/pets` | Cadastra novo pet | `201` `400` |
| `PUT` | `/api/pets/{id}` | Atualiza dados do pet | `200` `400` `404` |
| `DELETE` | `/api/pets/{id}` | Remove pet | `204` `404` |

<details>
<summary>📄 Body POST/PUT</summary>

```json
{
  "nome": "Rex",
  "especie": "Cachorro",
  "raca": "Labrador",
  "dataNascimento": "2020-01-15",
  "peso": 25.50,
  "tutorId": 1
}
```
</details>

---

### 🩺 Consultas — `/api/consultas`
> Tabela Oracle: `CONSULTAS` — Status: `A` = Agendada | `C` = Cancelada | `R` = Realizada

| Método | Rota | Descrição | Status |
|--------|------|-----------|--------|
| `GET` | `/api/consultas?page=1&pageSize=10` | Lista todas as consultas com paginação | `200` |
| `GET` | `/api/consultas/{id}` | Busca consulta por ID | `200` `404` |
| `GET` | `/api/consultas/status/{status}` | Filtra por status: `A`, `C` ou `R` | `200` |
| `GET` | `/api/consultas/periodo?inicio=&fim=` | Filtra por intervalo de datas | `200` `400` |
| `POST` | `/api/consultas` | Registra nova consulta | `201` `400` |
| `PUT` | `/api/consultas/{id}` | Atualiza consulta | `200` `400` `404` |
| `DELETE` | `/api/consultas/{id}` | Remove consulta | `204` `404` |

<details>
<summary>📄 Body POST/PUT</summary>

```json
{
  "data": "2026-06-10T14:00:00",
  "tipo": "Consulta de Rotina",
  "descricao": "Checkup anual completo",
  "valor": 150.00,
  "status": "A",
  "petId": 1,
  "funcionarioId": 1
}
```
</details>

---

### 💉 Vacinas — `/api/vacinas`
> Tabela Oracle: `VACINAS` — Status: `P` = Pendente | `A` = Aplicada

| Método | Rota | Descrição | Status |
|--------|------|-----------|--------|
| `GET` | `/api/vacinas?page=1&pageSize=10` | Lista todas as vacinas com paginação | `200` |
| `GET` | `/api/vacinas/{id}` | Busca vacina por ID | `200` `404` |
| `GET` | `/api/vacinas/pendentes` | Lista vacinas com status `P` | `200` |
| `GET` | `/api/vacinas/nome/{nome}` | Filtra vacinas por nome | `200` |
| `GET` | `/api/vacinas/proximas?dias=30` | Lista vacinas agendadas para os próximos dias | `200` `400` |
| `POST` | `/api/vacinas` | Registra nova vacina | `201` `400` |
| `PUT` | `/api/vacinas/{id}` | Atualiza vacina | `200` `400` `404` |
| `DELETE` | `/api/vacinas/{id}` | Remove vacina | `204` `404` |

<details>
<summary>📄 Body POST/PUT</summary>

```json
{
  "nome": "Antirrábica",
  "dataAplicacao": "2026-06-01",
  "status": "A",
  "petId": 1
}
```
</details>

---

### 👷 Funcionários — `/api/funcionarios`
> Tabela Oracle: `FUNCIONARIOS`

| Método | Rota | Descrição | Status |
|--------|------|-----------|--------|
| `GET` | `/api/funcionarios` | Lista todos os funcionários | `200` |
| `GET` | `/api/funcionarios/{id}` | Busca funcionário por ID | `200` `404` |
| `GET` | `/api/funcionarios/setor/{setor}` | Filtra por setor | `200` |
| `POST` | `/api/funcionarios` | Cadastra novo funcionário | `201` `400` |
| `PUT` | `/api/funcionarios/{id}` | Atualiza funcionário | `200` `404` |
| `DELETE` | `/api/funcionarios/{id}` | Remove funcionário | `204` `404` |

<details>
<summary>📄 Body POST/PUT</summary>

```json
{
  "nome": "Dra. Ana Souza",
  "setor": "Clínica Geral",
  "cargo": "Veterinária",
  "email": "ana@clyvovet.com",
  "telefone": "11988888888"
}
```
</details>

---

### 💊 Medicamentos — `/api/medicamentos`
> Tabela Oracle: `MEDICAMENTOS`

| Método | Rota | Descrição | Status |
|--------|------|-----------|--------|
| `GET` | `/api/medicamentos` | Lista todos os medicamentos | `200` |
| `GET` | `/api/medicamentos/{id}` | Busca medicamento por ID | `200` `404` |
| `POST` | `/api/medicamentos` | Cadastra novo medicamento | `201` `400` |
| `PUT` | `/api/medicamentos/{id}` | Atualiza medicamento | `200` `404` |
| `DELETE` | `/api/medicamentos/{id}` | Remove medicamento | `204` `404` |

<details>
<summary>📄 Body POST/PUT</summary>

```json
{
  "nome": "Amoxicilina"
}
```
</details>

---

---

## 🐳 Dockerfile

```dockerfile
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copia o .csproj e restaura dependências (otimiza cache do Docker)
COPY ["ClyvoVetApi.csproj", "./"]
RUN dotnet restore "ClyvoVetApi.csproj"

# Copia os arquivos restantes e faz o build
COPY . .
RUN dotnet build "ClyvoVetApi.csproj" -c Release -o /app/build
RUN dotnet publish "ClyvoVetApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Usa a imagem segura do ASP.NET
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Porta HTTP não privilegiada
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

# Execução com usuário não-root (DevOps Compliance ✅)
USER app

ENTRYPOINT ["dotnet", "ClyvoVetApi.dll"]
```

## Instalação da Solução (How To)

1. Provisionar a VM Linux Ubuntu na Microsoft Azure.
2. Abrir as portas 22, 8080 e 1521.
3. Instalar Docker e Docker Compose.
4. Clonar o repositório da aplicação.
5. Realizar o build da imagem Docker.
6. Executar os containers da API e do Oracle XE.
7. Validar os containers utilizando `docker ps`.
8. Acessar a documentação Swagger da API.

##  Scripts

# LOGIN (SE PRECISAR)
az login

# 1. CRIAR RESOURCE GROUP
</>bash

az group create --name rg-sprint --location brazilsouth

# 2. PROVISIONAR A VM LINUX
</>bash
 
az vm create --resource-group rg-sprint --name vm-sprint --image Ubuntu2204 --size Standard_E2s_v3 --admin-username adminfiap --admin-password SuaSenha@Forte123 --authentication-type password

# EXEMPLO DE SENHA
SuaSenha@Forte123

# 3. ABRIR AS PORTAS NECESSÁRIAS
</>bash

# port 8080
az vm open-port --resource-group rg-sprint --name vm-sprint --port 8080 --priority 120

# port 22 (caso não tenha)
az vm open-port --resource-group rg-sprint --name vm-sprint --port 22 --priority 100
 
# port 1521
az vm open-port --resource-group rg-sprint --name vm-sprint --port 1521 --priority 130

# 4. ENTRANDO NA VM
</>bash

# mostra o ip
az vm show --resource-group rg-sprint --name vm-sprint -d --query publicIps -o tsv
20.206.88.59

# Entra na vm
ssh adminfiap@SEU_IP_PUBLICO

# 5. INSTALAR DOCKER + FERRAMENTAS NA VM
</>bash

#Atualizar pacotes
sudo apt update && sudo apt upgrade -y

#instalar o docker
sudo apt install docker.io -y

#instalar o docker compose
sudo apt install docker-compose -y

#instalar imagem do docker
sudo docker pull gvenzl/oracle-xe
 
# 6. CRIAR REDE E VOLUME DOCKER
</>bash
# Tirar o sudo (reinicie a vm se precisar)
sudo usermod -aG docker $USER && newgrp docker

docker network create clyvo-network
docker volume create oracle_data
 
# 7. CONTAINER ORACLE
 </>bash

docker run -d --name oracle-db -p 1521:1521 -e ORACLE_PASSWORD=<SENHA_ORACLE> -v oracle_data:/opt/oracle/oradata gvenzl/oracle-xe

# testes
docker ps
 
docker logs -f oracle-db
 
# 8. CONTAINER DOTNET
 </>bash

#Clonar o repositório
git clone https://github.com/gabriel-g-dev/ClyvoVetApi.git
 
#Entrar na pasta
cd ClyvoVetApi/
 
#instalação
docker build -t clyvovet-api .
 
#rodar container
docker run -d --name clyvovet-api --network clyvo-network -p 8080:8080 clyvovet-api
 
#testes
docker ps
 
#no navegador
http://IP_DA_VM:8080/scalar

# 9. EXCLUIR O RESOURCE GROUP
#para sair da vm
exit

az group delete --name rg-sprint --yes --no-wait

# verificação

az group exists --name rg-sprint