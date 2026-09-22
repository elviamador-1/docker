#!/bin/bash

# ============================================
# SCRIPT DE LOGS - VER LOGS EN TIEMPO REAL
# ============================================
# Uso: bash logs.sh [servicio]
# Ejemplo: bash logs.sh mysql

set -e

YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}=== LOGS DE DOCKER COMPOSE ===${NC}"
echo ""

if [ -n "$1" ]; then
    echo -e "${YELLOW}Mostrando logs de: $1${NC}"
    docker compose logs -f "$1"
else
    echo -e "${YELLOW}Mostrando logs de todos los servicios${NC}"
    echo -e "Para ver logs de un servicio específico, ejecuta:"
    echo -e "  bash logs.sh mysql"
    echo -e "  bash logs.sh apache"
    echo -e "  bash logs.sh phpmyadmin"
    echo ""
    docker compose logs -f
fi
