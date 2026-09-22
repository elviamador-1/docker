# docker
explicación instalación docker

# Docker Compose: phpMyAdmin + Apache + MySQL

Documentación completa del entorno de desarrollo con tres contenedores separados: MySQL, Apache con PHP y phpMyAdmin.

---

## 📋 Contenido

1. [Estructura del proyecto](#estructura-del-proyecto)
2. [Servicios configurados](#servicios-configurados)
3. [Requisitos previos](#requisitos-previos)
4. [Instalación y arranque](#instalación-y-arranque)
5. [Acceso a los servicios](#acceso-a-los-servicios)
6. [Configuración detallada](#configuración-detallada)
7. [Comandos útiles](#comandos-útiles)
8. [Solución de problemas](#solución-de-problemas)

---

## 📁 Estructura del proyecto

```
docker/
├── docker-compose.yaml     # Configuración de los 3 servicios
├── html/                   # Carpeta compartida con Apache
│   └── index.php          # Archivo PHP de prueba (phpinfo)
└── README.md              # Este archivo
```

### Volúmenes persistentes

- **mysql_data**: Almacena la base de datos MySQL entre reinicios

---

## 🐳 Servicios configurados

### 1. **MySQL 8.0**
Base de datos relacional que sirve como backend de la aplicación.

| Propiedad | Valor |
|-----------|-------|
| **Imagen** | `mysql:8.0` |
| **Contenedor** | `mysql_container` |
| **Puerto** | `3306:3306` |
| **Usuario root** | `root` |
| **Contraseña root** | `rootpass123` |
| **Base de datos** | `myapp` |
| **Usuario BD** | `appuser` |
| **Contraseña usuario** | `apppass123` |
| **Volumen** | `mysql_data:/var/lib/mysql` |
| **Healthcheck** | Activo (ping cada 20s) |

### 2. **Apache + PHP 8.1**
Servidor web con soporte para scripts PHP.

| Propiedad | Valor |
|-----------|-------|
| **Imagen** | `php:8.1-apache` |
| **Contenedor** | `apache_container` |
| **Puerto** | `80:80` |
| **Carpeta raíz** | `/var/www/html` (montada desde `./html`) |
| **Dependencia** | MySQL (espera a que esté healthy) |
| **Red** | `app_network` |

### 3. **phpMyAdmin**
Interfaz web para gestionar MySQL.

| Propiedad | Valor |
|-----------|-------|
| **Imagen** | `phpmyadmin:latest` |
| **Contenedor** | `phpmyadmin_container` |
| **Puerto** | `8080:80` |
| **Host MySQL** | `mysql` (resuelto por la red) |
| **Usuario** | `root` |
| **Contraseña** | `rootpass123` |
| **Dependencia** | MySQL (espera a que esté healthy) |
| **Red** | `app_network` |

---

## ✅ Requisitos previos

- **Docker Desktop** instalado y ejecutándose
- **Git Bash** o terminal PowerShell en Windows
- Acceso a la carpeta `C:\Users\Usuario1\Desktop\docker`
- Puertos `80`, `3306` y `8080` disponibles en tu máquina

---

## 🚀 Instalación y arranque

### Paso 1: Clonar o descargar el proyecto

```bash
cd C:\Users\Usuario1\Desktop\docker
```

### Paso 2: Verificar que los archivos existen

```bash
# Windows PowerShell
ls -la

# Deberías ver:
# docker-compose.yaml
# html/
# README.md
```

### Paso 3: Descargar las imágenes y arrancar los contenedores

```bash
docker compose up --pull always -d
```

**Opciones:**
- `--pull always`: Descarga la última versión de las imágenes
- `-d`: Ejecuta en segundo plano (detached mode)

### Paso 4: Verificar que todo está corriendo

```bash
docker compose ps
```

**Salida esperada:**
```
NAME                   IMAGE               STATUS
apache_container       php:8.1-apache      Up (healthy)
mysql_container        mysql:8.0           Up (healthy)
phpmyadmin_container   phpmyadmin:latest   Up
```

---

## 🌐 Acceso a los servicios

### Apache / PHP
- **URL**: http://localhost/
- **Carpeta raíz**: `./html` (local) → `/var/www/html` (contenedor)
- **Prueba**: Abre http://localhost/ en tu navegador (deberías ver `phpinfo()`)

### phpMyAdmin
- **URL**: http://localhost:8080
- **Usuario**: `root`
- **Contraseña**: `rootpass123`
- **Puerto MySQL**: `3306`

### MySQL (acceso directo)
- **Host**: `localhost` o `127.0.0.1`
- **Puerto**: `3306`
- **Usuario root**: `root`
- **Contraseña**: `rootpass123`
- **Base de datos por defecto**: `myapp`

**Conexión desde un cliente MySQL:**
```bash
mysql -h localhost -u root -p
# Contraseña: rootpass123
```

---

## ⚙️ Configuración detallada

### docker-compose.yaml - Secciones clave

#### Variables de entorno (MySQL)
```yaml
environment:
  MYSQL_ROOT_PASSWORD: rootpass123      # Contraseña del usuario root
  MYSQL_DATABASE: myapp                 # Base de datos inicial
  MYSQL_USER: appuser                   # Usuario adicional
  MYSQL_PASSWORD: apppass123            # Contraseña del usuario adicional
```

#### Healthcheck (MySQL)
```yaml
healthcheck:
  test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
  timeout: 20s          # Timeout de cada intento
  retries: 10           # Reintentos antes de marcar como unhealthy
```

#### Dependencias (Apache y phpMyAdmin)
```yaml
depends_on:
  mysql:
    condition: service_healthy  # Espera a que MySQL esté healthy
```

#### Red interna (app_network)
Todos los servicios están conectados a una red bridge personalizada (`app_network`), lo que permite que se comuniquen entre sí usando los nombres de servicio:
- Apache se comunica con MySQL como: `mysql:3306`
- phpMyAdmin se comunica con MySQL como: `mysql:3306`

#### Volúmenes

**Volumen nombrado (mysql_data):**
```yaml
volumes:
  mysql_data:/var/lib/mysql
```
Persiste la base de datos entre reinicios del contenedor. Se almacena en:
- Linux/Mac: `~/.docker/volumes/mysql_data/_data`
- Windows: `\\.\pipe\docker_engine` (gestionado por Docker Desktop)

**Bind mount (html):**
```yaml
volumes:
  - ./html:/var/www/html
```
Sincroniza cambios en `./html` en tiempo real con el contenedor.

---

## 🛠️ Comandos útiles

### Estado y logs

```bash
# Ver estado de los contenedores
docker compose ps

# Ver logs de todos los servicios
docker compose logs

# Ver logs de un servicio específico
docker compose logs mysql
docker compose logs apache
docker compose logs phpmyadmin

# Ver últimas 50 líneas de logs
docker compose logs --tail=50

# Seguir logs en tiempo real
docker compose logs -f
```

### Control de contenedores

```bash
# Detener contenedores
docker compose stop

# Reiniciar contenedores
docker compose restart

# Eliminar contenedores (pero no volúmenes)
docker compose down

# Eliminar contenedores Y volúmenes
docker compose down -v

# Ejecutar comando dentro de un contenedor
docker compose exec mysql bash
docker compose exec apache bash
docker compose exec phpmyadmin bash

# Acceder a MySQL desde el contenedor
docker compose exec mysql mysql -u root -p
# Contraseña: rootpass123
```

### Inspección

```bash
# Ver detalles de red
docker network ls
docker network inspect docker_app_network

# Ver detalles del volumen
docker volume ls
docker volume inspect docker_mysql_data

# Estadísticas de uso
docker stats
```

### Reconstruir

```bash
# Reconstruir sin caché (descargar imágenes nuevas)
docker compose up --build --pull always

# Forzar recreación de contenedores
docker compose up --force-recreate -d
```

---

## 🔧 Solución de problemas

### Problema: Los contenedores no arrancarn

**Solución:**
```bash
# Revisar logs detallados
docker compose logs

# Detener todo y limpiar
docker compose down -v

# Reintentar
docker compose up --pull always -d
```

### Problema: No puedo acceder a http://localhost:8080

**Causas posibles:**
1. Los contenedores no están running
2. El puerto 8080 está ocupado
3. Docker Desktop no está ejecutándose

**Solución:**
```bash
# Verificar que todo está corriendo
docker compose ps

# Verificar qué está usando el puerto 8080 (Windows)
netstat -ano | findstr :8080

# Detener Docker Desktop y reiniciar
```

### Problema: phpMyAdmin muestra error de conexión

**Causa:** MySQL no está listo cuando phpMyAdmin intenta conectar

**Solución:**
```bash
# Reiniciar phpMyAdmin
docker compose restart phpmyadmin

# Esperar 10 segundos y reintentarr
```

### Problema: Error de permisos en ./html

**Solución (Windows):**
Asegúrate que la carpeta `html` existe y tiene permisos de lectura.

```bash
# Crear la carpeta si no existe
mkdir html

# Verificar permisos
icacls html /grant:r "%USERNAME%:F"
```

### Problema: MySQL usa mucha memoria

**Solución:** Limitar memoria en docker-compose.yaml
```yaml
services:
  mysql:
    deploy:
      resources:
        limits:
          memory: 512M
```

Luego:
```bash
docker compose up --build -d
```

---

## 📝 Ejemplos de uso

### Crear una tabla desde phpMyAdmin

1. Abre http://localhost:8080
2. Inicia sesión: `root` / `rootpass123`
3. Selecciona la base de datos `myapp`
4. Crea una tabla nueva

### Conectar una aplicación PHP a MySQL

En `./html/connect.php`:
```php
<?php
$conn = new mysqli("mysql", "appuser", "apppass123", "myapp");

if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}

echo "Conectado a MySQL exitosamente!";
$conn->close();
?>
```

Accede a http://localhost/connect.php

### Acceder a MySQL desde línea de comandos

```bash
docker compose exec mysql mysql -u appuser -p -D myapp
# Contraseña: apppass123
```

---

## 🔐 Seguridad

⚠️ **Advertencia:** Esta configuración es SOLO para desarrollo local.

**Para producción:**
- Cambia todas las contraseñas en el archivo `.env`
- No expongas MySQL públicamente
- Usa variables de entorno en lugar de valores hardcodeados
- Implementa SSL/TLS
- Configura firewalls y límites de recursos

---

## 📦 Mantenimiento

### Actualizar imágenes

```bash
docker compose pull
docker compose up -d
```

### Limpiar espacio en disco

```bash
# Eliminar volúmenes no usados
docker volume prune

# Eliminar imágenes no usadas
docker image prune

# Limpieza completa (⚠️ será destructiva)
docker system prune -a --volumes
```

---

## 📚 Recursos útiles

- [Documentación Docker Compose](https://docs.docker.com/compose/)
- [Documentación imagen MySQL](https://hub.docker.com/_/mysql)
- [Documentación imagen PHP](https://hub.docker.com/_/php)
- [Documentación phpMyAdmin](https://hub.docker.com/r/phpmyadmin/phpmyadmin)

---

## ✨ Resumen

| Servicio | URL | Usuario | Contraseña |
|----------|-----|---------|-----------|
| Apache | http://localhost | - | - |
| phpMyAdmin | http://localhost:8080 | root | rootpass123 |
| MySQL | localhost:3306 | root | rootpass123 |
| MySQL (app) | localhost:3306 | appuser | apppass123 |

---

**Versión del documento:** 1.0  
**Fecha:** 2026-09-22  
**Autor:** Docker Setup Guide
