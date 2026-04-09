-- ============================================================
-- DELGADO & DELGADO - FIRMA DE ABOGADOS
-- Script de Base de Datos - Sistema de Gestión de Expedientes
-- Versión: 1.0
-- Fecha: 2024
-- Normalización: 1FN, 2FN, 3FN aplicada
-- ============================================================

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS delgado_abogados
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE delgado_abogados;

-- ============================================================
-- TABLA: roles
-- Catálogo de roles del sistema (1FN: atómicos, sin duplicados)
-- ============================================================
CREATE TABLE roles (
    id_rol       INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol   VARCHAR(50) NOT NULL UNIQUE,
    descripcion  VARCHAR(200),
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLA: usuarios
-- Almacena los usuarios del sistema
-- 3FN: sin dependencias transitivas (rol separado en catálogo)
-- ============================================================
CREATE TABLE usuarios (
    id_usuario   INT AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR(100) NOT NULL,
    apellido     VARCHAR(100) NOT NULL,
    email        VARCHAR(150) NOT NULL UNIQUE,
    username     VARCHAR(80)  NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    id_rol       INT NOT NULL,
    activo       TINYINT(1) DEFAULT 1,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuarios_rol FOREIGN KEY (id_rol) REFERENCES roles(id_rol)
);

-- ============================================================
-- TABLA: aseguradoras
-- Catálogo de compañías aseguradoras
-- 1FN: cada campo atómico; 3FN: sin dependencias transitivas
-- ============================================================
CREATE TABLE aseguradoras (
    id_aseguradora   INT AUTO_INCREMENT PRIMARY KEY,
    nombre           VARCHAR(100) NOT NULL UNIQUE,
    codigo           VARCHAR(30)  NOT NULL UNIQUE,
    telefono         VARCHAR(20),
    email            VARCHAR(150),
    direccion        VARCHAR(255),
    activo           TINYINT(1) DEFAULT 1,
    created_at       DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLA: juzgados
-- Catálogo de juzgados donde se tramitan los casos
-- 3FN: ciudad separable → tabla ciudades (aplicado)
-- ============================================================
CREATE TABLE ciudades (
    id_ciudad    INT AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE juzgados (
    id_juzgado   INT AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR(150) NOT NULL,
    numero       VARCHAR(20),
    id_ciudad    INT NOT NULL,
    direccion    VARCHAR(255),
    activo       TINYINT(1) DEFAULT 1,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_juzgados_ciudad FOREIGN KEY (id_ciudad) REFERENCES ciudades(id_ciudad)
);

-- ============================================================
-- TABLA: tipos_caso
-- Catálogo de tipos de proceso (TRÁNSITO, PENAL, etc.)
-- ============================================================
CREATE TABLE tipos_caso (
    id_tipo_caso  INT AUTO_INCREMENT PRIMARY KEY,
    nombre        VARCHAR(80) NOT NULL UNIQUE,
    descripcion   VARCHAR(300),
    activo        TINYINT(1) DEFAULT 1
);

-- ============================================================
-- TABLA: abogados
-- Licenciados que llevan los expedientes
-- 3FN: datos del usuario separados en tabla usuarios
-- ============================================================
CREATE TABLE abogados (
    id_abogado   INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario   INT NOT NULL UNIQUE,
    titulo       VARCHAR(30) DEFAULT 'Lic.',
    especialidad VARCHAR(150),
    num_colegiado VARCHAR(50),
    activo       TINYINT(1) DEFAULT 1,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_abogados_usuario FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- ============================================================
-- TABLA: conductores
-- Personas involucradas en los casos (demandantes/demandados)
-- 1FN: datos atómicos separados
-- ============================================================
CREATE TABLE conductores (
    id_conductor  INT AUTO_INCREMENT PRIMARY KEY,
    nombre        VARCHAR(100) NOT NULL,
    apellido      VARCHAR(100) NOT NULL,
    cedula        VARCHAR(20)  UNIQUE,
    telefono      VARCHAR(20),
    email         VARCHAR(150),
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLA: estados_expediente
-- Catálogo de estados posibles de un expediente
-- ============================================================
CREATE TABLE estados_expediente (
    id_estado    INT AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR(60) NOT NULL UNIQUE,
    descripcion  VARCHAR(200),
    color_hex    VARCHAR(10)  -- para la UI (#gold, #gray, etc.)
);

-- ============================================================
-- TABLA: expedientes
-- Entidad central del sistema
-- 2FN: todos los atributos dependen completamente de id_expediente
-- 3FN: sin dependencias transitivas (aseguradora, juzgado, tipo → catálogos)
-- ============================================================
CREATE TABLE expedientes (
    id_expediente      INT AUTO_INCREMENT PRIMARY KEY,
    codigo_expediente  VARCHAR(30) NOT NULL UNIQUE,
    id_conductor       INT NOT NULL,
    id_aseguradora     INT NOT NULL,
    numero_caso        VARCHAR(80),
    id_tipo_caso       INT NOT NULL,
    id_abogado         INT NOT NULL,
    id_juzgado         INT,
    id_estado          INT NOT NULL,
    fecha_inicio       DATE NOT NULL,
    fecha_finalizacion DATE,
    formato            VARCHAR(80),
    observaciones      TEXT,
    created_at         DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at         DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_exp_conductor   FOREIGN KEY (id_conductor)   REFERENCES conductores(id_conductor),
    CONSTRAINT fk_exp_aseguradora FOREIGN KEY (id_aseguradora) REFERENCES aseguradoras(id_aseguradora),
    CONSTRAINT fk_exp_tipo        FOREIGN KEY (id_tipo_caso)   REFERENCES tipos_caso(id_tipo_caso),
    CONSTRAINT fk_exp_abogado     FOREIGN KEY (id_abogado)     REFERENCES abogados(id_abogado),
    CONSTRAINT fk_exp_juzgado     FOREIGN KEY (id_juzgado)     REFERENCES juzgados(id_juzgado),
    CONSTRAINT fk_exp_estado      FOREIGN KEY (id_estado)      REFERENCES estados_expediente(id_estado)
);

-- ============================================================
-- TABLA: agenda
-- Citas y audiencias del día por expediente
-- ============================================================
CREATE TABLE agenda (
    id_agenda       INT AUTO_INCREMENT PRIMARY KEY,
    id_expediente   INT NOT NULL,
    fecha           DATE NOT NULL,
    hora            TIME,
    descripcion     VARCHAR(255),
    completado      TINYINT(1) DEFAULT 0,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_agenda_expediente FOREIGN KEY (id_expediente) REFERENCES expedientes(id_expediente)
);

-- ============================================================
-- TABLA: documentos_expediente
-- Archivos/anexos adjuntos a un expediente
-- ============================================================
CREATE TABLE documentos_expediente (
    id_documento    INT AUTO_INCREMENT PRIMARY KEY,
    id_expediente   INT NOT NULL,
    nombre_archivo  VARCHAR(255) NOT NULL,
    tipo_archivo    VARCHAR(50),
    ruta_archivo    VARCHAR(500),
    uploaded_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_docs_expediente FOREIGN KEY (id_expediente) REFERENCES expedientes(id_expediente)
);

-- ============================================================
-- FIN DEL SCHEMA
-- ============================================================
