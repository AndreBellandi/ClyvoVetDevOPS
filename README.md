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
Scalar API Reference (UI): /scalar/v1

# 👤 Donos (Tutores) — /api/tutores
Tabela Oracle: DONOS

Método	Rota	Descrição	Status HTTP
GET	/api/tutores?page=1&pageSize=10	Lista todos os donos com paginação	200 OK
GET	/api/tutores/{id}	Busca dono por ID com lista de pets	200 OK, 404
GET	/api/tutores/email/{email}	Busca dono por e-mail	200 OK, 404
GET	/api/tutores/{id}/pets	Lista os pets do dono	200 OK, 404
POST	/api/tutores	Cadastra novo dono	201 Created, 400
PUT	/api/tutores/{id}	Atualiza dados do dono	200 OK, 400, 404
DELETE	/api/tutores/{id}	Remove dono	204 NoContent, 404
Body POST/PUT:

{ "nome": "João Silva", "email": "joao@email.com", "telefone": "11999999999" }
🐾 Pets — /api/pets
Tabela Oracle: PETS

Método	Rota	Descrição	Status HTTP
GET	/api/pets?page=1&pageSize=10	Lista todos os pets com paginação	200 OK
GET	/api/pets/{id}	Detalha pet com tutor, vacinas e consultas	200 OK, 404
GET	/api/pets/especie/{especie}	Filtra pets por espécie	200 OK
GET	/api/pets/raca/{raca}	Filtra pets por raça	200 OK
GET	/api/pets/{id}/vacinas	Histórico de vacinas do pet	200 OK, 404
GET	/api/pets/{id}/consultas	Histórico de consultas do pet	200 OK, 404
GET	/api/pets/{id}/inteligencia-preventiva	Score de saúde preventiva (0–100) e alertas dinâmicos	200 OK, 404
POST	/api/pets	Cadastra novo pet	201 Created, 400
PUT	/api/pets/{id}	Atualiza dados do pet	200 OK, 400, 404
DELETE	/api/pets/{id}	Remove pet	204 NoContent, 404
Body POST/PUT:

{
  "nome": "Rex", "especie": "Cachorro", "raca": "Labrador",
  "dataNascimento": "2020-01-15", "peso": 25.50, "tutorId": 1
}

# 🩺 Consultas — /api/consultas
Tabela Oracle: CONSULTAS — Status: A = Agendada | C = Cancelada | R = Realizada

Método	Rota	Descrição	Status HTTP
GET	/api/consultas?page=1&pageSize=10	Lista todas as consultas com paginação	200 OK
GET	/api/consultas/{id}	Busca consulta por ID	200 OK, 404
GET	/api/consultas/status/{status}	Filtra por status: A, C ou R	200 OK
GET	/api/consultas/periodo?inicio=&fim=	Filtra por intervalo de datas	200 OK, 400
POST	/api/consultas	Registra nova consulta	201 Created, 400
PUT	/api/consultas/{id}	Atualiza consulta	200 OK, 400, 404
DELETE	/api/consultas/{id}	Remove consulta	204 NoContent, 404
Body POST/PUT:

{
  "data": "2026-06-10T14:00:00", "tipo": "Consulta de Rotina",
  "descricao": "Checkup anual completo", "valor": 150.00,
  "status": "A", "petId": 1, "funcionarioId": 1
}

# 💉 Vacinas — /api/vacinas
Tabela Oracle: VACINAS — Status: P = Pendente | A = Aplicada

Método	Rota	Descrição	Status HTTP
GET	/api/vacinas?page=1&pageSize=10	Lista todas as vacinas com paginação	200 OK
GET	/api/vacinas/{id}	Busca vacina por ID	200 OK, 404
GET	/api/vacinas/pendentes	Lista vacinas com status P	200 OK
GET	/api/vacinas/nome/{nome}	Filtra vacinas por nome	200 OK
POST	/api/vacinas	Registra nova vacina	201 Created, 400
PUT	/api/vacinas/{id}	Atualiza vacina	200 OK, 400, 404
DELETE	/api/vacinas/{id}	Remove vacina	204 NoContent, 404
Body POST/PUT:

{ "nome": "Antirrábica", "dataAplicacao": "2026-06-01", "status": "A", "petId": 1 }

# 👷 Funcionários — /api/funcionarios
Tabela Oracle: FUNCIONARIOS

Método	Rota	Descrição	Status HTTP
GET	/api/funcionarios	Lista todos os funcionários	200 OK
GET	/api/funcionarios/{id}	Busca funcionário por ID	200 OK, 404
GET	/api/funcionarios/setor/{setor}	Filtra por setor	200 OK
POST	/api/funcionarios	Cadastra novo funcionário	201 Created, 400
PUT	/api/funcionarios/{id}	Atualiza funcionário	200 OK, 404
DELETE	/api/funcionarios/{id}	Remove funcionário	204 NoContent, 404
Body POST/PUT:

{
  "nome": "Dra. Ana Souza", "setor": "Clínica Geral",
  "cargo": "Veterinária", "email": "ana@clyvovet.com", "telefone": "11988888888"
}

# 💊 Medicamentos — /api/medicamentos
Tabela Oracle: MEDICAMENTOS

Método	Rota	Descrição	Status HTTP
GET	/api/medicamentos	Lista todos os medicamentos	200 OK
GET	/api/medicamentos/{id}	Busca medicamento por ID	200 OK, 404
POST	/api/medicamentos	Cadastra novo medicamento	201 Created, 400
PUT	/api/medicamentos/{id}	Atualiza medicamento	200 OK, 404
DELETE	/api/medicamentos/{id}	Remove medicamento	204 NoContent, 404
Body POST/PUT:

{ "nome": "Amoxicilina" }
Método	Rota	Descrição	Status de Resposta (HTTP)
GET	/api/tutores	Lista todos os tutores com paginação.	200 OK (PagedResponse)
GET	/api/tutores/{id}	Busca os detalhes completos de um tutor e sua lista de pets.	200 OK, 404 Not Found
GET	/api/tutores/email/{email}	Busca detalhes completos do tutor pelo endereço de e-mail.	200 OK, 404 Not Found
GET	/api/tutores/{id}/pets	Lista todos os pets pertencentes a um tutor específico.	200 OK, 404 Not Found
POST	/api/tutores	Cadastra um novo tutor. Valida unicidade de e-mail e formato.	201 Created, 400 Bad Request
PUT	/api/tutores/{id}	Atualiza dados cadastrais de um tutor.	200 OK, 400 Bad Request, 404 Not Found
DELETE	/api/tutores/{id}	Remove um tutor e seus respectivos dados do sistema.	204 NoContent, 404 Not Found
Pets (/api/pets)
Método	Rota	Descrição	Status de Resposta (HTTP)
GET	/api/pets	Lista todos os pets cadastrados com paginação.	200 OK (PagedResponse)
GET	/api/pets/{id}	Retorna detalhes do pet, dados do tutor e histórico completo de vacinas/consultas.	200 OK, 404 Not Found
GET	/api/pets/especie/{especie}	Lista pets pertencentes à espécie especificada.	200 OK
GET	/api/pets/raca/{raca}	Lista pets pertencentes à raça especificada.	200 OK
GET	/api/pets/{id}/vacinas	Retorna o calendário e histórico vacinal detalhado do pet.	200 OK, 404 Not Found
GET	/api/pets/{id}/consultas	Retorna o histórico de consultas e agendamentos do pet.	200 OK, 404 Not Found
GET	/api/pets/{id}/inteligencia-preventiva	Retorna a análise preditiva, score de saúde preventiva (0 a 100) e alertas dinâmicos do pet (Intelligence Engine).	200 OK, 404 Not Found
POST	/api/pets	Cadastra um novo pet associando a um tutor válido.	201 Created, 400 Bad Request
PUT	/api/pets/{id}	Atualiza informações detalhadas de um pet.	200 OK, 400 Bad Request, 404 Not Found
DELETE	/api/pets/{id}	Remove o registro de um pet.	204 NoContent, 404 Not Found

# Consultas (/api/consultas)
Método	Rota	Descrição	Status de Resposta (HTTP)
GET	/api/consultas	Lista todas as consultas cadastradas com paginação.	200 OK (PagedResponse)
GET	/api/consultas/{id}	Busca uma consulta individual por ID.	200 OK, 404 Not Found
GET	/api/consultas/veterinario/{nome}	Busca consultas associadas a um veterinário por aproximação de nome.	200 OK
GET	/api/consultas/periodo	Busca consultas dentro de um intervalo de datas (Query inicio e fim).	200 OK, 400 Bad Request
POST	/api/consultas	Registra uma nova consulta clínica para um pet válido.	201 Created, 400 Bad Request
PUT	/api/consultas/{id}	Atualiza informações de uma consulta agendada.	200 OK, 400 Bad Request, 404 Not Found
DELETE	/api/consultas/{id}	Exclui o registro de uma consulta.	204 NoContent, 404 Not Found

# Vacinas (/api/vacinas)
Método	Rota	Descrição	Status de Resposta (HTTP)
GET	/api/vacinas	Lista todas as vacinas aplicadas ou agendadas com paginação.	200 OK (PagedResponse)
GET	/api/vacinas/{id}	Detalha uma vacina específica por ID.	200 OK, 404 Not Found
GET	/api/vacinas/pendentes	Lista todas as vacinas pendentes de aplicação no sistema.	200 OK
GET	/api/vacinas/nome/{nome}	Busca vacinas pelo nome comercial ou tipo de imunizante.	200 OK
GET	/api/vacinas/proximas	Lista vacinas agendadas para os próximos dias (Query dias, padrão 30).	200 OK, 400 Bad Request
POST	/api/vacinas	Registra uma nova aplicação ou agendamento de vacina para um pet.	201 Created, 400 Bad Request
PUT	/api/vacinas/{id}	Atualiza registros ou status de uma vacina.	200 OK, 400 Bad Request, 404 Not Found
DELETE	/api/vacinas/{id}	Exclui um registro de vacinação.	204 NoContent, 404 Not Found

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