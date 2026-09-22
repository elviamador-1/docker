#!/bin/bash

# ============================================
# SCRIPT DE PARADA - DOCKER COMPOSE
# ============================================
# Uso: bash stop.sh

set -e

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${YELLOW}=== DETENIENDO CONTENEDORES ===${NC}"
echo ""

# Opción de eliminar volúmenes
if [ "$1" = "-v" ] || [ "$1" = "--volumes" ]; then
    echo -e "${RED}⚠ Se eliminarán los volúmenes (datos de BD)${NC}"
    read -p "¿Estás seguro? (s/n): " confirm
    
    if [ "$confirm" = "s" ] || [ "$confirm" = "S" ]; then
        docker compose down -v
        echo -e "${GREEN}✓ Contenedores y volúmenes eliminados${NC}"
    else
        echo -e "${YELLOW}Cancelado${NC}"
        exit 0
    fi
else
    docker compose down
    echo -e "${GREEN}✓ Contenedores detenidos${NC}"
    echo -e "  ${YELLOW}Nota: Los datos de BD se mantienen en mysql_data${NC}"
fi

echo ""
echo -e "${YELLOW}=== ESTADO ACTUAL ===${NC}"
docker compose ps

echo ""
