/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-12.2.2-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: delgado_abogados
-- ------------------------------------------------------
-- Server version	12.2.2-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `abogados`
--

DROP TABLE IF EXISTS `abogados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `abogados` (
  `id_abogado` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(11) NOT NULL,
  `titulo` varchar(30) DEFAULT 'Lic.',
  `especialidad` varchar(150) DEFAULT NULL,
  `num_colegiado` varchar(50) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id_abogado`),
  UNIQUE KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `fk_abogados_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `abogados`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `abogados` WRITE;
/*!40000 ALTER TABLE `abogados` DISABLE KEYS */;
INSERT INTO `abogados` VALUES
(1,2,'Lic.','Tránsito y Seguros',NULL,1,'2026-04-08 19:00:34'),
(2,3,'Lic.','Derecho Penal',NULL,1,'2026-04-08 19:00:34'),
(3,4,'Lic.','Derecho Civil',NULL,1,'2026-04-08 19:00:34'),
(4,5,'Lic.','Derecho Corporativo',NULL,1,'2026-04-08 19:00:34'),
(5,6,'Lic.','Tránsito y Seguros',NULL,1,'2026-04-08 19:00:34'),
(6,7,'Lic.','Derecho Civil',NULL,1,'2026-04-08 19:00:34'),
(7,8,'Lic.','Derecho Penal',NULL,1,'2026-04-08 19:00:34'),
(8,9,'Lic.','Tránsito y Seguros',NULL,1,'2026-04-08 19:00:34');
/*!40000 ALTER TABLE `abogados` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `agenda`
--

DROP TABLE IF EXISTS `agenda`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `agenda` (
  `id_agenda` int(11) NOT NULL AUTO_INCREMENT,
  `id_expediente` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `hora` time DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `completado` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id_agenda`),
  KEY `fk_agenda_expediente` (`id_expediente`),
  CONSTRAINT `fk_agenda_expediente` FOREIGN KEY (`id_expediente`) REFERENCES `expedientes` (`id_expediente`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agenda`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `agenda` WRITE;
/*!40000 ALTER TABLE `agenda` DISABLE KEYS */;
INSERT INTO `agenda` VALUES
(1,1,'2019-01-07','09:00:00','Audiencia inicial - Juzgado 5to Pedregal',0,'2026-04-08 19:00:34'),
(2,2,'2019-01-07','10:30:00','Presentación de pruebas - Juzgado 4to',0,'2026-04-08 19:00:34'),
(3,3,'2019-01-07','14:00:00','Audiencia - Juzgado 5to Pedregal',0,'2026-04-08 19:00:34'),
(4,7,'2019-01-07','11:00:00','Diligencia - Alcaldía de Panamá',0,'2026-04-08 19:00:34'),
(5,8,'2019-01-07','15:00:00','Audiencia - Juzgado 1ro Pedregal',0,'2026-04-08 19:00:34');
/*!40000 ALTER TABLE `agenda` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `aseguradoras`
--

DROP TABLE IF EXISTS `aseguradoras`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `aseguradoras` (
  `id_aseguradora` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `codigo` varchar(30) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id_aseguradora`),
  UNIQUE KEY `nombre` (`nombre`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aseguradoras`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `aseguradoras` WRITE;
/*!40000 ALTER TABLE `aseguradoras` DISABLE KEYS */;
INSERT INTO `aseguradoras` VALUES
(1,'ASSA Compañía de Seguros','ASSA','507-300-0000','info@assa.com.pa',NULL,1,'2026-04-08 19:00:34'),
(2,'Ancón Seguros','ANCON','507-269-0000','info@ancon.com.pa',NULL,1,'2026-04-08 19:00:34'),
(3,'CONANCE','CONANCE','507-265-0000','info@conance.com.pa',NULL,1,'2026-04-08 19:00:34'),
(4,'Interoceanica','INTEROCEANICA','507-225-0000','info@interoceanica.com.pa',NULL,1,'2026-04-08 19:00:34'),
(5,'Particular (Sin Seguro)','PARTICULAR',NULL,NULL,NULL,1,'2026-04-08 19:00:34'),
(6,'ACONE Seguros','ACONE','507-227-0000','info@acone.com.pa',NULL,1,'2026-04-08 19:00:34');
/*!40000 ALTER TABLE `aseguradoras` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `ciudades`
--

DROP TABLE IF EXISTS `ciudades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ciudades` (
  `id_ciudad` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  PRIMARY KEY (`id_ciudad`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ciudades`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `ciudades` WRITE;
/*!40000 ALTER TABLE `ciudades` DISABLE KEYS */;
INSERT INTO `ciudades` VALUES
(2,'Chitré'),
(4,'Colón'),
(3,'David'),
(1,'Panamá'),
(5,'Santiago');
/*!40000 ALTER TABLE `ciudades` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `conductores`
--

DROP TABLE IF EXISTS `conductores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `conductores` (
  `id_conductor` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `cedula` varchar(20) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id_conductor`),
  UNIQUE KEY `cedula` (`cedula`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conductores`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `conductores` WRITE;
/*!40000 ALTER TABLE `conductores` DISABLE KEYS */;
INSERT INTO `conductores` VALUES
(1,'Anthony','Trejo','8-123-456','6600-1111',NULL,'2026-04-08 19:00:34'),
(2,'Angel','Delgado','8-234-567','6600-2222',NULL,'2026-04-08 19:00:34'),
(3,'Ricardo','De Alba','8-345-678','6600-3333',NULL,'2026-04-08 19:00:34'),
(4,'Martin Amado','Martinez','8-456-789','6600-4444',NULL,'2026-04-08 19:00:34'),
(5,'Erick','Vega','8-567-890','6600-5555',NULL,'2026-04-08 19:00:34'),
(6,'Melissa','Díaz','8-678-901','6600-6666',NULL,'2026-04-08 19:00:34'),
(7,'Guillermo','Ungo','8-789-012','6600-7777',NULL,'2026-04-08 19:00:34'),
(8,'Gilda','De Goldner','8-890-123','6600-8888',NULL,'2026-04-08 19:00:34'),
(9,'Yolanda','Mora De Valdés','8-901-234','6600-9999',NULL,'2026-04-08 19:00:34'),
(10,'Franco','Campbell','8-112-233','6601-0000',NULL,'2026-04-08 19:00:34');
/*!40000 ALTER TABLE `conductores` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `documentos_expediente`
--

DROP TABLE IF EXISTS `documentos_expediente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentos_expediente` (
  `id_documento` int(11) NOT NULL AUTO_INCREMENT,
  `id_expediente` int(11) NOT NULL,
  `nombre_archivo` varchar(255) NOT NULL,
  `tipo_archivo` varchar(50) DEFAULT NULL,
  `ruta_archivo` varchar(500) DEFAULT NULL,
  `uploaded_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id_documento`),
  KEY `fk_docs_expediente` (`id_expediente`),
  CONSTRAINT `fk_docs_expediente` FOREIGN KEY (`id_expediente`) REFERENCES `expedientes` (`id_expediente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documentos_expediente`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `documentos_expediente` WRITE;
/*!40000 ALTER TABLE `documentos_expediente` DISABLE KEYS */;
/*!40000 ALTER TABLE `documentos_expediente` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `estados_expediente`
--

DROP TABLE IF EXISTS `estados_expediente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_expediente` (
  `id_estado` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(60) NOT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  `color_hex` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id_estado`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_expediente`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `estados_expediente` WRITE;
/*!40000 ALTER TABLE `estados_expediente` DISABLE KEYS */;
INSERT INTO `estados_expediente` VALUES
(1,'Pendiente','Expediente registrado, en espera de inicio','#B8860B'),
(2,'En Curso','Expediente activo en proceso','#DAA520'),
(3,'Cerrado','Expediente finalizado','#808080');
/*!40000 ALTER TABLE `estados_expediente` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `expedientes`
--

DROP TABLE IF EXISTS `expedientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `expedientes` (
  `id_expediente` int(11) NOT NULL AUTO_INCREMENT,
  `codigo_expediente` varchar(30) NOT NULL,
  `id_conductor` int(11) NOT NULL,
  `id_aseguradora` int(11) NOT NULL,
  `numero_caso` varchar(80) DEFAULT NULL,
  `id_tipo_caso` int(11) NOT NULL,
  `id_abogado` int(11) NOT NULL,
  `id_juzgado` int(11) DEFAULT NULL,
  `id_estado` int(11) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_finalizacion` date DEFAULT NULL,
  `formato` varchar(80) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_expediente`),
  UNIQUE KEY `codigo_expediente` (`codigo_expediente`),
  KEY `fk_exp_conductor` (`id_conductor`),
  KEY `fk_exp_aseguradora` (`id_aseguradora`),
  KEY `fk_exp_tipo` (`id_tipo_caso`),
  KEY `fk_exp_abogado` (`id_abogado`),
  KEY `fk_exp_juzgado` (`id_juzgado`),
  KEY `fk_exp_estado` (`id_estado`),
  CONSTRAINT `fk_exp_abogado` FOREIGN KEY (`id_abogado`) REFERENCES `abogados` (`id_abogado`),
  CONSTRAINT `fk_exp_aseguradora` FOREIGN KEY (`id_aseguradora`) REFERENCES `aseguradoras` (`id_aseguradora`),
  CONSTRAINT `fk_exp_conductor` FOREIGN KEY (`id_conductor`) REFERENCES `conductores` (`id_conductor`),
  CONSTRAINT `fk_exp_estado` FOREIGN KEY (`id_estado`) REFERENCES `estados_expediente` (`id_estado`),
  CONSTRAINT `fk_exp_juzgado` FOREIGN KEY (`id_juzgado`) REFERENCES `juzgados` (`id_juzgado`),
  CONSTRAINT `fk_exp_tipo` FOREIGN KEY (`id_tipo_caso`) REFERENCES `tipos_caso` (`id_tipo_caso`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expedientes`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `expedientes` WRITE;
/*!40000 ALTER TABLE `expedientes` DISABLE KEYS */;
INSERT INTO `expedientes` VALUES
(1,'EXP-001',1,1,'CASO-2019-001',1,1,5,2,'2019-01-07',NULL,NULL,NULL,'2026-04-08 19:00:34','2026-04-08 19:00:34'),
(2,'EXP-002',2,2,'CASO-2019-002',1,2,4,2,'2019-01-07',NULL,NULL,NULL,'2026-04-08 19:00:34','2026-04-08 19:00:34'),
(3,'EXP-003',3,1,'CASO-2019-003',1,3,5,2,'2019-01-07',NULL,NULL,NULL,'2026-04-08 19:00:34','2026-04-08 19:00:34'),
(4,'EXP-004',4,1,'CASO-2017-001',1,4,1,3,'2017-03-09',NULL,NULL,NULL,'2026-04-08 19:00:34','2026-04-08 19:00:34'),
(5,'EXP-005',5,2,'CASO-2018-001',2,2,3,3,'2018-02-13',NULL,NULL,NULL,'2026-04-08 19:00:34','2026-04-08 19:00:34'),
(6,'EXP-006',6,6,'CASO-2018-002',1,1,2,3,'2018-11-02',NULL,NULL,NULL,'2026-04-08 19:00:34','2026-04-08 19:00:34'),
(7,'EXP-007',7,2,'CASO-2019-004',1,3,4,2,'2019-07-12',NULL,NULL,NULL,'2026-04-08 19:00:34','2026-04-08 19:00:34'),
(8,'EXP-008',8,1,'CASO-2019-005',1,1,2,2,'2019-01-07',NULL,NULL,NULL,'2026-04-08 19:00:34','2026-04-08 19:00:34'),
(9,'EXP-009',9,1,'CASO-2019-006',1,2,2,1,'2019-02-09',NULL,NULL,NULL,'2026-04-08 19:00:34','2026-04-08 19:00:34'),
(10,'EXP-010',10,1,'5435435',2,2,2,2,'2019-01-09',NULL,NULL,NULL,'2026-04-08 19:00:34','2026-04-08 19:00:34');
/*!40000 ALTER TABLE `expedientes` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `juzgados`
--

DROP TABLE IF EXISTS `juzgados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `juzgados` (
  `id_juzgado` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `numero` varchar(20) DEFAULT NULL,
  `id_ciudad` int(11) NOT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id_juzgado`),
  KEY `fk_juzgados_ciudad` (`id_ciudad`),
  CONSTRAINT `fk_juzgados_ciudad` FOREIGN KEY (`id_ciudad`) REFERENCES `ciudades` (`id_ciudad`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `juzgados`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `juzgados` WRITE;
/*!40000 ALTER TABLE `juzgados` DISABLE KEYS */;
INSERT INTO `juzgados` VALUES
(1,'Juzgado de Circuito de Tránsito','1ro (Pedregal)',1,NULL,1,'2026-04-08 19:00:34'),
(2,'Juzgado de Circuito de Tránsito','2do (Pedregal)',1,NULL,1,'2026-04-08 19:00:34'),
(3,'Juzgado de Circuito de Tránsito','3ro (Pedregal)',1,NULL,1,'2026-04-08 19:00:34'),
(4,'Juzgado de Circuito de Tránsito','4to (Pedregal)',1,NULL,1,'2026-04-08 19:00:34'),
(5,'Juzgado de Circuito de Tránsito','5to (Pedregal)',1,NULL,1,'2026-04-08 19:00:34'),
(6,'Alcaldía de Panamá','Alcaldía',1,NULL,1,'2026-04-08 19:00:34'),
(7,'Juzgado Municipal de Chitré','1ro',2,NULL,1,'2026-04-08 19:00:34');
/*!40000 ALTER TABLE `juzgados` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id_rol` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_rol` varchar(50) NOT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id_rol`),
  UNIQUE KEY `nombre_rol` (`nombre_rol`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES
(1,'Admin','Administrador del sistema con acceso total','2026-04-08 19:00:33'),
(2,'Abogado','Licenciado que gestiona expedientes','2026-04-08 19:00:33'),
(3,'Asistente','Asistente legal con acceso limitado','2026-04-08 19:00:33');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `tipos_caso`
--

DROP TABLE IF EXISTS `tipos_caso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos_caso` (
  `id_tipo_caso` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(80) NOT NULL,
  `descripcion` varchar(300) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id_tipo_caso`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_caso`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `tipos_caso` WRITE;
/*!40000 ALTER TABLE `tipos_caso` DISABLE KEYS */;
INSERT INTO `tipos_caso` VALUES
(1,'Tránsito','Casos de accidentes y tránsito vehicular',1),
(2,'Penal','Casos de naturaleza penal',1);
/*!40000 ALTER TABLE `tipos_caso` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `username` varchar(80) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `id_rol` int(11) NOT NULL,
  `activo` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `username` (`username`),
  KEY `fk_usuarios_rol` (`id_rol`),
  CONSTRAINT `fk_usuarios_rol` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES
(1,'Eli','Delgado','juan.perez@delgado.com','edelgado','$2b$12$1az9bqiFUPd1C4e1MFUHFO.Lp/EJA243lgtfXfY81hZHCh05T.DAe',1,1,'2026-04-08 19:00:34','2026-04-08 19:42:40'),
(2,'Ana','Martínez','diane.campbell@delgado.com','amartinez','$2b$12$1az9bqiFUPd1C4e1MFUHFO.Lp/EJA243lgtfXfY81hZHCh05T.DAe',2,1,'2026-04-08 19:00:34','2026-04-08 19:42:40'),
(3,'Carlos','Ramos','harold.gray@delgado.com','cramos','$2b$12$1az9bqiFUPd1C4e1MFUHFO.Lp/EJA243lgtfXfY81hZHCh05T.DAe',2,1,'2026-04-08 19:00:34','2026-04-08 19:42:40'),
(4,'Laura','Herrera','william.harris@delgado.com','lherrera','$2b$12$1az9bqiFUPd1C4e1MFUHFO.Lp/EJA243lgtfXfY81hZHCh05T.DAe',2,1,'2026-04-08 19:00:34','2026-04-08 19:42:42'),
(5,'Keith','Lee','keith.lee@delgado.com','klee','$2b$12$1az9bqiFUPd1C4e1MFUHFO.Lp/EJA243lgtfXfY81hZHCh05T.DAe',2,1,'2026-04-08 19:00:34','2026-04-08 19:25:48'),
(6,'Samuel','Jackson','samuel.jackson@delgado.com','sjackson','$2b$12$1az9bqiFUPd1C4e1MFUHFO.Lp/EJA243lgtfXfY81hZHCh05T.DAe',2,1,'2026-04-08 19:00:34','2026-04-08 19:25:48'),
(7,'Ryan','Berry','ryan.berry@delgado.com','rberry','$2b$12$1az9bqiFUPd1C4e1MFUHFO.Lp/EJA243lgtfXfY81hZHCh05T.DAe',2,1,'2026-04-08 19:00:34','2026-04-08 19:25:48'),
(8,'Katherine','Green','katherine.green@delgado.com','kgreen','$2b$12$1az9bqiFUPd1C4e1MFUHFO.Lp/EJA243lgtfXfY81hZHCh05T.DAe',2,1,'2026-04-08 19:00:34','2026-04-08 19:25:48'),
(9,'Tiffany','Hawkins','tiffany.hawkins@delgado.com','thawkins','$2b$12$1az9bqiFUPd1C4e1MFUHFO.Lp/EJA243lgtfXfY81hZHCh05T.DAe',2,1,'2026-04-08 19:00:34','2026-04-08 19:25:48');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Temporary table structure for view `vista_agenda_del_dia`
--

DROP TABLE IF EXISTS `vista_agenda_del_dia`;
/*!50001 DROP VIEW IF EXISTS `vista_agenda_del_dia`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `vista_agenda_del_dia` AS SELECT
 1 AS `id_agenda`,
  1 AS `fecha`,
  1 AS `hora`,
  1 AS `descripcion_cita`,
  1 AS `codigo_expediente`,
  1 AS `conductor`,
  1 AS `aseguradora`,
  1 AS `juzgado`,
  1 AS `abogado`,
  1 AS `completado` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vista_expedientes_completos`
--

DROP TABLE IF EXISTS `vista_expedientes_completos`;
/*!50001 DROP VIEW IF EXISTS `vista_expedientes_completos`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `vista_expedientes_completos` AS SELECT
 1 AS `id_expediente`,
  1 AS `codigo_expediente`,
  1 AS `conductor`,
  1 AS `cedula_conductor`,
  1 AS `telefono_conductor`,
  1 AS `aseguradora`,
  1 AS `numero_caso`,
  1 AS `tipo_caso`,
  1 AS `abogado`,
  1 AS `titulo_abogado`,
  1 AS `juzgado`,
  1 AS `ciudad_juzgado`,
  1 AS `estado`,
  1 AS `color_hex`,
  1 AS `fecha_inicio`,
  1 AS `fecha_finalizacion`,
  1 AS `formato`,
  1 AS `observaciones`,
  1 AS `created_at`,
  1 AS `updated_at` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vista_expedientes_por_abogado`
--

DROP TABLE IF EXISTS `vista_expedientes_por_abogado`;
/*!50001 DROP VIEW IF EXISTS `vista_expedientes_por_abogado`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `vista_expedientes_por_abogado` AS SELECT
 1 AS `id_abogado`,
  1 AS `abogado_completo`,
  1 AS `especialidad`,
  1 AS `total_expedientes`,
  1 AS `en_curso`,
  1 AS `pendientes`,
  1 AS `cerrados` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vista_expedientes_por_aseguradora`
--

DROP TABLE IF EXISTS `vista_expedientes_por_aseguradora`;
/*!50001 DROP VIEW IF EXISTS `vista_expedientes_por_aseguradora`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `vista_expedientes_por_aseguradora` AS SELECT
 1 AS `id_aseguradora`,
  1 AS `aseguradora`,
  1 AS `codigo`,
  1 AS `total_expedientes`,
  1 AS `en_curso`,
  1 AS `pendientes`,
  1 AS `cerrados` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vista_resumen_estados`
--

DROP TABLE IF EXISTS `vista_resumen_estados`;
/*!50001 DROP VIEW IF EXISTS `vista_resumen_estados`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `vista_resumen_estados` AS SELECT
 1 AS `estado`,
  1 AS `color_hex`,
  1 AS `total_expedientes` */;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `vista_agenda_del_dia`
--

/*!50001 DROP VIEW IF EXISTS `vista_agenda_del_dia`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_agenda_del_dia` AS select `ag`.`id_agenda` AS `id_agenda`,`ag`.`fecha` AS `fecha`,`ag`.`hora` AS `hora`,`ag`.`descripcion` AS `descripcion_cita`,`e`.`codigo_expediente` AS `codigo_expediente`,concat(`c`.`nombre`,' ',`c`.`apellido`) AS `conductor`,`a`.`nombre` AS `aseguradora`,concat(`j`.`nombre`,' ',`j`.`numero`) AS `juzgado`,concat(`u`.`nombre`,' ',`u`.`apellido`) AS `abogado`,`ag`.`completado` AS `completado` from ((((((`agenda` `ag` join `expedientes` `e` on(`ag`.`id_expediente` = `e`.`id_expediente`)) join `conductores` `c` on(`e`.`id_conductor` = `c`.`id_conductor`)) join `aseguradoras` `a` on(`e`.`id_aseguradora` = `a`.`id_aseguradora`)) left join `juzgados` `j` on(`e`.`id_juzgado` = `j`.`id_juzgado`)) join `abogados` `ab` on(`e`.`id_abogado` = `ab`.`id_abogado`)) join `usuarios` `u` on(`ab`.`id_usuario` = `u`.`id_usuario`)) order by `ag`.`hora` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_expedientes_completos`
--

/*!50001 DROP VIEW IF EXISTS `vista_expedientes_completos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_expedientes_completos` AS select `e`.`id_expediente` AS `id_expediente`,`e`.`codigo_expediente` AS `codigo_expediente`,concat(`c`.`nombre`,' ',`c`.`apellido`) AS `conductor`,`c`.`cedula` AS `cedula_conductor`,`c`.`telefono` AS `telefono_conductor`,`a`.`nombre` AS `aseguradora`,`e`.`numero_caso` AS `numero_caso`,`tc`.`nombre` AS `tipo_caso`,concat(`ab_u`.`nombre`,' ',`ab_u`.`apellido`) AS `abogado`,`ab`.`titulo` AS `titulo_abogado`,concat(`j`.`nombre`,' ',`j`.`numero`) AS `juzgado`,`ci`.`nombre` AS `ciudad_juzgado`,`est`.`nombre` AS `estado`,`est`.`color_hex` AS `color_hex`,`e`.`fecha_inicio` AS `fecha_inicio`,`e`.`fecha_finalizacion` AS `fecha_finalizacion`,`e`.`formato` AS `formato`,`e`.`observaciones` AS `observaciones`,`e`.`created_at` AS `created_at`,`e`.`updated_at` AS `updated_at` from ((((((((`expedientes` `e` join `conductores` `c` on(`e`.`id_conductor` = `c`.`id_conductor`)) join `aseguradoras` `a` on(`e`.`id_aseguradora` = `a`.`id_aseguradora`)) join `tipos_caso` `tc` on(`e`.`id_tipo_caso` = `tc`.`id_tipo_caso`)) join `abogados` `ab` on(`e`.`id_abogado` = `ab`.`id_abogado`)) join `usuarios` `ab_u` on(`ab`.`id_usuario` = `ab_u`.`id_usuario`)) left join `juzgados` `j` on(`e`.`id_juzgado` = `j`.`id_juzgado`)) left join `ciudades` `ci` on(`j`.`id_ciudad` = `ci`.`id_ciudad`)) join `estados_expediente` `est` on(`e`.`id_estado` = `est`.`id_estado`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_expedientes_por_abogado`
--

/*!50001 DROP VIEW IF EXISTS `vista_expedientes_por_abogado`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_expedientes_por_abogado` AS select `ab`.`id_abogado` AS `id_abogado`,concat(`ab`.`titulo`,' ',`u`.`nombre`,' ',`u`.`apellido`) AS `abogado_completo`,`ab`.`especialidad` AS `especialidad`,count(`e`.`id_expediente`) AS `total_expedientes`,sum(case when `est`.`nombre` = 'En Curso' then 1 else 0 end) AS `en_curso`,sum(case when `est`.`nombre` = 'Pendiente' then 1 else 0 end) AS `pendientes`,sum(case when `est`.`nombre` = 'Cerrado' then 1 else 0 end) AS `cerrados` from (((`abogados` `ab` join `usuarios` `u` on(`ab`.`id_usuario` = `u`.`id_usuario`)) left join `expedientes` `e` on(`ab`.`id_abogado` = `e`.`id_abogado`)) left join `estados_expediente` `est` on(`e`.`id_estado` = `est`.`id_estado`)) group by `ab`.`id_abogado`,`u`.`nombre`,`u`.`apellido`,`ab`.`titulo`,`ab`.`especialidad` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_expedientes_por_aseguradora`
--

/*!50001 DROP VIEW IF EXISTS `vista_expedientes_por_aseguradora`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_expedientes_por_aseguradora` AS select `a`.`id_aseguradora` AS `id_aseguradora`,`a`.`nombre` AS `aseguradora`,`a`.`codigo` AS `codigo`,count(`e`.`id_expediente`) AS `total_expedientes`,sum(case when `est`.`nombre` = 'En Curso' then 1 else 0 end) AS `en_curso`,sum(case when `est`.`nombre` = 'Pendiente' then 1 else 0 end) AS `pendientes`,sum(case when `est`.`nombre` = 'Cerrado' then 1 else 0 end) AS `cerrados` from ((`aseguradoras` `a` left join `expedientes` `e` on(`a`.`id_aseguradora` = `e`.`id_aseguradora`)) left join `estados_expediente` `est` on(`e`.`id_estado` = `est`.`id_estado`)) group by `a`.`id_aseguradora`,`a`.`nombre`,`a`.`codigo` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vista_resumen_estados`
--

/*!50001 DROP VIEW IF EXISTS `vista_resumen_estados`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_resumen_estados` AS select `est`.`nombre` AS `estado`,`est`.`color_hex` AS `color_hex`,count(`e`.`id_expediente`) AS `total_expedientes` from (`estados_expediente` `est` left join `expedientes` `e` on(`est`.`id_estado` = `e`.`id_estado`)) group by `est`.`id_estado`,`est`.`nombre`,`est`.`color_hex` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-04-09 19:50:37
