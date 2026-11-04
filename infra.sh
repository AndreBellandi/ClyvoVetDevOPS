#!/bin/bash
RG=rg-clyvovet
LOCATION=canadacentral
PLAN=plan-clyvovet
APP=clyvovet-api
RUNTIME="DOTNETCORE:9.0"

az provider register --namespace Microsoft.Web

az group create --name $RG --location $LOCATION

az appservice plan create --name $PLAN --resource-group $RG --sku B1 --is-linux

az webapp create --name $APP --resource-group $RG --plan $PLAN --runtime "$RUNTIME"

az webapp config set --name $APP --resource-group $RG --always-on true --startup-file "sh startup.sh"

az webapp config appsettings set --name $APP --resource-group $RG --settings WEBSITES_PORT=8080 ASPNETCORE_URLS=http://+:8080
