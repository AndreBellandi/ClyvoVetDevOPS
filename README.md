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
IP Público: 191.239.253.180
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