# ============================================
# DOCKERFILE - APACHE + PHP PERSONALIZADO
# ============================================
# Imagen base: PHP 8.1 con Apache
FROM php:8.1-apache

# Cambiar usuario a root temporalmente para instalar
USER root

# Actualizar e instalar extensiones necesarias
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    libzip-dev \
    git \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Instalar extensiones PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    gd \
    pdo \
    pdo_mysql \
    mysqli \
    xml \
    zip \
    opcache

# Habilitar módulos de Apache
RUN a2enmod rewrite \
    && a2enmod headers \
    && a2enmod ssl

# Configurar PHP.ini para desarrollo
RUN echo "memory_limit=256M" >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini \
    && echo "upload_max_filesize=50M" >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini \
    && echo "post_max_size=50M" >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini \
    && echo "display_errors=On" >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini \
    && echo "error_reporting=E_ALL" >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini

# Habilitar OPCache (caché de operaciones)
RUN docker-php-ext-install opcache && \
    echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo "opcache.memory_consumption=128" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

# Configurar DocumentRoot
ENV APACHE_DOCUMENT_ROOT /var/www/html
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf

# Crear directorio si no existe
RUN mkdir -p ${APACHE_DOCUMENT_ROOT} \
    && chown -R www-data:www-data ${APACHE_DOCUMENT_ROOT} \
    && chmod -R 755 ${APACHE_DOCUMENT_ROOT}

# Copiar archivo .htaccess para rewrite rules (opcional)
COPY .htaccess ${APACHE_DOCUMENT_ROOT}/.htaccess 2>/dev/null || true

# Exponer puerto
EXPOSE 80

# Volver a apache (usuario no-root)
USER www-data

# Comando por defecto
CMD ["apache2-foreground"]
