#!/bin/bash

# ============================================
# SCRIPT DE REINICIO - DOCKER COMPOSE
# ============================================
# Uso: bash restart.sh [servicio]
# Ejemplo: bash restart.sh mysql

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}=== REINICIANDO CONTENEDORES ===${NC}"
echo ""

if [ -n "$1" ]; then
    echo -e "${YELLOW}Reiniciando: $1${NC}"
    docker compose restart "$1"
    echo -e "${GREEN}✓ $1 reiniciado${NC}"
else
    echo -e "${YELLOW}Reiniciando todos los servicios...${NC}"
    docker compose restart
    echo -e "${GREEN}✓ Todos los servicios reiniciados${NC}"
fi

echo ""
echo -e "${YELLOW}=== ESTADO ACTUAL ===${NC}"
docker compose ps

echo ""
