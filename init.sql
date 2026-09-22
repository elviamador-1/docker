-- ============================================
-- SCRIPT DE INICIALIZACIÓN - MYSQL
-- ============================================
-- Este script crea tablas y datos de ejemplo
-- Se ejecuta automáticamente al crear el contenedor

USE myapp;

-- Crear tabla de usuarios
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    contraseña VARCHAR(255) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Crear tabla de productos
CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT DEFAULT 0,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Crear tabla de pedidos
CREATE TABLE IF NOT EXISTS pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10, 2) NOT NULL,
    estado VARCHAR(50) DEFAULT 'pendiente',
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertar datos de ejemplo - Usuarios
INSERT INTO usuarios (nombre, email, contraseña, activo) VALUES
('Juan Pérez', 'juan@example.com', SHA2('pass123', 256), TRUE),
('María García', 'maria@example.com', SHA2('pass456', 256), TRUE),
('Carlos López', 'carlos@example.com', SHA2('pass789', 256), TRUE);

-- Insertar datos de ejemplo - Productos
INSERT INTO productos (nombre, descripcion, precio, stock, activo) VALUES
('Laptop Dell', 'Laptop XPS 13 con procesador Intel i7', 1299.99, 10, TRUE),
('Mouse Logitech', 'Mouse inalámbrico con batería de larga duración', 29.99, 50, TRUE),
('Teclado Mecánico', 'Teclado RGB mecánico para gaming', 149.99, 25, TRUE),
('Monitor LG 27"', 'Monitor 4K con panel IPS', 399.99, 8, TRUE),
('Webcam HD', 'Webcam 1080p con micrófono integrado', 79.99, 15, TRUE);

-- Insertar datos de ejemplo - Pedidos
INSERT INTO pedidos (usuario_id, total, estado) VALUES
(1, 1329.98, 'completado'),
(2, 449.98, 'pendiente'),
(3, 229.98, 'completado');

-- Crear índices para mejor rendimiento
CREATE INDEX idx_usuarios_email ON usuarios(email);
CREATE INDEX idx_productos_nombre ON productos(nombre);
CREATE INDEX idx_pedidos_usuario ON pedidos(usuario_id);

-- Mostrar resumen
SELECT 'Base de datos inicializada correctamente' AS status;
SELECT COUNT(*) AS total_usuarios FROM usuarios;
SELECT COUNT(*) AS total_productos FROM productos;
SELECT COUNT(*) AS total_pedidos FROM pedidos;
