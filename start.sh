#!/bin/bash

# ============================================
# SCRIPT DE INICIO - DOCKER COMPOSE
# ============================================
# Uso: bash start.sh

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}=== INICIANDO CONTENEDORES ===${NC}"
echo ""

# Descargar imágenes más recientes
echo -e "${YELLOW}Descargando imágenes...${NC}"
docker compose pull

echo ""
echo -e "${YELLOW}Iniciando servicios...${NC}"
docker compose up --pull always -d

echo ""
echo -e "${YELLOW}Esperando a que MySQL esté listo...${NC}"
sleep 5

# Verificar estado
echo ""
echo -e "${YELLOW}=== ESTADO DE LOS SERVICIOS ===${NC}"
docker compose ps

echo ""
echo -e "${GREEN}✓ CONTENEDORES INICIADOS${NC}"
echo ""
echo -e "Acceso a servicios:"
echo -e "  ${GREEN}Apache/PHP:${NC}     http://localhost"
echo -e "  ${GREEN}phpMyAdmin:${NC}     http://localhost:8080"
echo -e "  ${GREEN}MySQL:${NC}          localhost:3306"
echo ""
echo -e "Credenciales por defecto:"
echo -e "  ${GREEN}MySQL Usuario:${NC}   root"
echo -e "  ${GREEN}MySQL Contraseña:${NC} rootpass123"
echo ""
