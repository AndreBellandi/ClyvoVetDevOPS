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
23.97.96.150

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