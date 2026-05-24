## 📜 Scripts

---

### 🔐 Login (se necessário)

```bash
az login
```

---

### 1️⃣ Criar Resource Group

```bash
az group create --name rg-sprint --location brazilsouth
```

---

### 2️⃣ Provisionar a VM Linux

```bash
az vm create --resource-group rg-sprint --name vm-sprint --image Ubuntu2204 --size Standard_E2s_v3 --admin-username adminfiap --admin-password SuaSenha@Forte123 --authentication-type password
```

> 💡 Exemplo de senha válida: `SuaSenha@Forte123`

---

### 3️⃣ Abrir as Portas Necessárias

```bash
# port 8080
az vm open-port --resource-group rg-sprint --name vm-sprint --port 8080 --priority 120

# port 22 (caso não tenha)
az vm open-port --resource-group rg-sprint --name vm-sprint --port 22 --priority 100

# port 1521
az vm open-port --resource-group rg-sprint --name vm-sprint --port 1521 --priority 130
```

---

### 4️⃣ Entrar na VM

```bash
# Mostra o IP público
az vm show --resource-group rg-sprint --name vm-sprint -d --query publicIps -o tsv

# Entra na VM
ssh adminfiap@SEU_IP_PUBLICO
```

---

### 5️⃣ Instalar Docker + Ferramentas na VM

```bash
# Atualizar pacotes
sudo apt update && sudo apt upgrade -y

# Instalar o Docker
sudo apt install docker.io -y

# Instalar o Docker Compose
sudo apt install docker-compose -y

# Instalar imagem do Oracle
sudo docker pull gvenzl/oracle-xe
```

---

### 6️⃣ Criar Rede e Volume Docker

```bash
# Tirar o sudo (reinicie a VM se precisar)
sudo usermod -aG docker $USER && newgrp docker

docker network create clyvo-network
docker volume create oracle_data
```

---

### 7️⃣ Container Oracle

```bash
docker run -d --name oracle-db -p 1521:1521 -e ORACLE_PASSWORD=<SENHA_ORACLE> -v oracle_data:/opt/oracle/oradata gvenzl/oracle-xe

# Testes
docker ps
docker logs -f oracle-db
```

---

### 8️⃣ Container .NET

```bash
# Clonar o repositório
git clone https://github.com/gabriel-g-dev/ClyvoVetApi.git

# Entrar na pasta
cd ClyvoVetApi/

# Build da imagem
docker build -t clyvovet-api .

# Rodar container
docker run -d --name clyvovet-api --network clyvo-network -p 8080:8080 clyvovet-api

# Testes
docker ps

# No navegador
http://IP_DA_VM:8080/scalar
```

---

### 9️⃣ Excluir o Resource Group

```bash
# Para sair da VM
exit

# Deletar resource group
az group delete --name rg-sprint --yes --no-wait

# Verificação
az group exists --name rg-sprint
```