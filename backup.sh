#!/bin/bash

# ============================================
# SCRIPT DE BACKUP - MYSQL Y ARCHIVOS
# ============================================
# Uso: bash backup.sh

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Variables
BACKUP_DIR="./backups"
DATE=$(date +"%Y%m%d_%H%M%S")
DB_NAME="myapp"
DB_USER="root"
DB_PASSWORD="rootpass123"
DB_HOST="mysql"

echo -e "${YELLOW}=== INICIANDO BACKUP ===${NC}"

# Crear carpeta de backups si no existe
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    echo -e "${GREEN}✓ Carpeta de backups creada${NC}"
fi

# ============================================
# BACKUP DE BASE DE DATOS
# ============================================
echo -e "${YELLOW}Haciendo backup de MySQL...${NC}"

BACKUP_FILE="$BACKUP_DIR/mysql_backup_${DATE}.sql"

docker compose exec -T mysql mysqldump \
    -h "$DB_HOST" \
    -u "$DB_USER" \
    -p"$DB_PASSWORD" \
    "$DB_NAME" > "$BACKUP_FILE"

if [ -f "$BACKUP_FILE" ]; then
    SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo -e "${GREEN}✓ Backup de BD completado${NC}"
    echo -e "  Archivo: ${BACKUP_FILE}"
    echo -e "  Tamaño: ${SIZE}"
else
    echo -e "${RED}✗ Error al hacer backup de BD${NC}"
    exit 1
fi

# ============================================
# BACKUP DE ARCHIVOS HTML
# ============================================
echo -e "${YELLOW}Haciendo backup de archivos...${NC}"

ARCHIVE_FILE="$BACKUP_DIR/html_backup_${DATE}.tar.gz"

tar -czf "$ARCHIVE_FILE" html/ 2>/dev/null || true

if [ -f "$ARCHIVE_FILE" ]; then
    SIZE=$(du -h "$ARCHIVE_FILE" | cut -f1)
    echo -e "${GREEN}✓ Backup de archivos completado${NC}"
    echo -e "  Archivo: ${ARCHIVE_FILE}"
    echo -e "  Tamaño: ${SIZE}"
else
    echo -e "${RED}✗ Error al hacer backup de archivos${NC}"
fi

# ============================================
# RESUMEN
# ============================================
echo -e ""
echo -e "${GREEN}=== BACKUP COMPLETADO ===${NC}"
echo -e "Backups guardados en: ${BACKUP_DIR}"
echo -e "Total de archivos:"
ls -lh "$BACKUP_DIR" | tail -n +2 | wc -l
echo -e ""
echo -e "${YELLOW}Tip: Para restaurar la BD, ejecuta:${NC}"
echo -e "  docker compose exec -T mysql mysql -u root -prootpass123 myapp < backups/mysql_backup_${DATE}.sql"
