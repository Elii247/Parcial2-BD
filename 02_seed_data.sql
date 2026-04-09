-- ============================================================
-- DELGADO & DELGADO - DATOS INICIALES (SEED)
-- ============================================================

USE delgado_abogados;

-- Roles
INSERT INTO roles (nombre_rol, descripcion) VALUES
('Admin', 'Administrador del sistema con acceso total'),
('Abogado', 'Licenciado que gestiona expedientes'),
('Asistente', 'Asistente legal con acceso limitado');

-- Ciudades
INSERT INTO ciudades (nombre) VALUES
('Panamá'),
('Chitré'),
('David'),
('Colón'),
('Santiago');

-- Aseguradoras
INSERT INTO aseguradoras (nombre, codigo, telefono, email) VALUES
('ASSA Compañía de Seguros', 'ASSA', '507-300-0000', 'info@assa.com.pa'),
('Ancón Seguros', 'ANCON', '507-269-0000', 'info@ancon.com.pa'),
('CONANCE', 'CONANCE', '507-265-0000', 'info@conance.com.pa'),
('Interoceanica', 'INTEROCEANICA', '507-225-0000', 'info@interoceanica.com.pa'),
('Particular (Sin Seguro)', 'PARTICULAR', NULL, NULL),
('ACONE Seguros', 'ACONE', '507-227-0000', 'info@acone.com.pa');

-- Juzgados
INSERT INTO juzgados (nombre, numero, id_ciudad) VALUES
('Juzgado de Circuito de Tránsito', '1ro (Pedregal)', 1),
('Juzgado de Circuito de Tránsito', '2do (Pedregal)', 1),
('Juzgado de Circuito de Tránsito', '3ro (Pedregal)', 1),
('Juzgado de Circuito de Tránsito', '4to (Pedregal)', 1),
('Juzgado de Circuito de Tránsito', '5to (Pedregal)', 1),
('Alcaldía de Panamá', 'Alcaldía', 1),
('Juzgado Municipal de Chitré', '1ro', 2);

-- Tipos de caso
INSERT INTO tipos_caso (nombre, descripcion) VALUES
('Tránsito', 'Casos de accidentes y tránsito vehicular'),
('Penal', 'Casos de naturaleza penal');

-- Estados del expediente
INSERT INTO estados_expediente (nombre, descripcion, color_hex) VALUES
('Pendiente', 'Expediente registrado, en espera de inicio', '#B8860B'),
('En Curso', 'Expediente activo en proceso', '#DAA520'),
('Cerrado', 'Expediente finalizado', '#808080');

-- Usuarios (password_hash = hash de 'password123' para demo)
INSERT INTO usuarios (nombre, apellido, email, username, password_hash, id_rol) VALUES
('Juan', 'Pérez', 'juan.perez@delgado.com', 'jperez', '$2b$12$demo_hash_juan', 1),
('Diane', 'Campbell', 'diane.campbell@delgado.com', 'dcampbell', '$2b$12$demo_hash_diane', 2),
('Harold', 'Gray', 'harold.gray@delgado.com', 'hgray', '$2b$12$demo_hash_harold', 2),
('William', 'Harris', 'william.harris@delgado.com', 'wharris', '$2b$12$demo_hash_william', 2),
('Keith', 'Lee', 'keith.lee@delgado.com', 'klee', '$2b$12$demo_hash_keith', 2),
('Samuel', 'Jackson', 'samuel.jackson@delgado.com', 'sjackson', '$2b$12$demo_hash_samuel', 2),
('Ryan', 'Berry', 'ryan.berry@delgado.com', 'rberry', '$2b$12$demo_hash_ryan', 2),
('Katherine', 'Green', 'katherine.green@delgado.com', 'kgreen', '$2b$12$demo_hash_kgreen', 2),
('Tiffany', 'Hawkins', 'tiffany.hawkins@delgado.com', 'thawkins', '$2b$12$demo_hash_tiffany', 2);

-- Abogados
INSERT INTO abogados (id_usuario, titulo, especialidad) VALUES
(2, 'Lic.', 'Tránsito y Seguros'),
(3, 'Lic.', 'Derecho Penal'),
(4, 'Lic.', 'Derecho Civil'),
(5, 'Lic.', 'Derecho Corporativo'),
(6, 'Lic.', 'Tránsito y Seguros'),
(7, 'Lic.', 'Derecho Civil'),
(8, 'Lic.', 'Derecho Penal'),
(9, 'Lic.', 'Tránsito y Seguros');

-- Conductores
INSERT INTO conductores (nombre, apellido, cedula, telefono) VALUES
('Anthony', 'Trejo', '8-123-456', '6600-1111'),
('Angel', 'Delgado', '8-234-567', '6600-2222'),
('Ricardo', 'De Alba', '8-345-678', '6600-3333'),
('Martin Amado', 'Martinez', '8-456-789', '6600-4444'),
('Erick', 'Vega', '8-567-890', '6600-5555'),
('Melissa', 'Díaz', '8-678-901', '6600-6666'),
('Guillermo', 'Ungo', '8-789-012', '6600-7777'),
('Gilda', 'De Goldner', '8-890-123', '6600-8888'),
('Yolanda', 'Mora De Valdés', '8-901-234', '6600-9999'),
('Franco', 'Campbell', '8-112-233', '6601-0000');

-- Expedientes
INSERT INTO expedientes (codigo_expediente, id_conductor, id_aseguradora, numero_caso, id_tipo_caso, id_abogado, id_juzgado, id_estado, fecha_inicio) VALUES
('EXP-001', 1, 1, 'CASO-2019-001', 1, 1, 5, 2, '2019-01-07'),
('EXP-002', 2, 2, 'CASO-2019-002', 1, 2, 4, 2, '2019-01-07'),
('EXP-003', 3, 1, 'CASO-2019-003', 1, 3, 5, 2, '2019-01-07'),
('EXP-004', 4, 1, 'CASO-2017-001', 1, 4, 1, 3, '2017-03-09'),
('EXP-005', 5, 2, 'CASO-2018-001', 2, 2, 3, 3, '2018-02-13'),
('EXP-006', 6, 6, 'CASO-2018-002', 1, 1, 2, 3, '2018-11-02'),
('EXP-007', 7, 2, 'CASO-2019-004', 1, 3, 4, 2, '2019-07-12'),
('EXP-008', 8, 1, 'CASO-2019-005', 1, 1, 2, 2, '2019-01-07'),
('EXP-009', 9, 1, 'CASO-2019-006', 1, 2, 2, 1, '2019-02-09'),
('EXP-010', 10, 1, '5435435', 2, 2, 2, 2, '2019-01-09');

-- Agenda del día (ejemplo)
INSERT INTO agenda (id_expediente, fecha, hora, descripcion) VALUES
(1, '2019-01-07', '09:00:00', 'Audiencia inicial - Juzgado 5to Pedregal'),
(2, '2019-01-07', '10:30:00', 'Presentación de pruebas - Juzgado 4to'),
(3, '2019-01-07', '14:00:00', 'Audiencia - Juzgado 5to Pedregal'),
(7, '2019-01-07', '11:00:00', 'Diligencia - Alcaldía de Panamá'),
(8, '2019-01-07', '15:00:00', 'Audiencia - Juzgado 1ro Pedregal');
