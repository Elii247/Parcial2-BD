
USE delgado_abogados;

-- ============================================================
-- VISTA 1: vista_expedientes_completos
-- Muestra toda la información consolidada de expedientes
-- ============================================================
CREATE OR REPLACE VIEW vista_expedientes_completos AS
SELECT
    e.id_expediente,
    e.codigo_expediente,
    CONCAT(c.nombre, ' ', c.apellido)                   AS conductor,
    c.cedula                                             AS cedula_conductor,
    c.telefono                                           AS telefono_conductor,
    a.nombre                                             AS aseguradora,
    e.numero_caso,
    tc.nombre                                            AS tipo_caso,
    CONCAT(ab_u.nombre, ' ', ab_u.apellido)             AS abogado,
    ab.titulo                                            AS titulo_abogado,
    CONCAT(j.nombre, ' ', j.numero)                     AS juzgado,
    ci.nombre                                            AS ciudad_juzgado,
    est.nombre                                           AS estado,
    est.color_hex,
    e.fecha_inicio,
    e.fecha_finalizacion,
    e.formato,
    e.observaciones,
    e.created_at,
    e.updated_at
FROM expedientes e
    JOIN conductores     c   ON e.id_conductor   = c.id_conductor
    JOIN aseguradoras    a   ON e.id_aseguradora  = a.id_aseguradora
    JOIN tipos_caso      tc  ON e.id_tipo_caso    = tc.id_tipo_caso
    JOIN abogados        ab  ON e.id_abogado      = ab.id_abogado
    JOIN usuarios        ab_u ON ab.id_usuario    = ab_u.id_usuario
    LEFT JOIN juzgados   j   ON e.id_juzgado      = j.id_juzgado
    LEFT JOIN ciudades   ci  ON j.id_ciudad       = ci.id_ciudad
    JOIN estados_expediente est ON e.id_estado    = est.id_estado;

-- ============================================================
-- VISTA 2: vista_agenda_del_dia
-- Muestra las citas programadas para hoy con info completa
-- ============================================================
CREATE OR REPLACE VIEW vista_agenda_del_dia AS
SELECT
    ag.id_agenda,
    ag.fecha,
    ag.hora,
    ag.descripcion                                       AS descripcion_cita,
    e.codigo_expediente,
    CONCAT(c.nombre, ' ', c.apellido)                   AS conductor,
    a.nombre                                             AS aseguradora,
    CONCAT(j.nombre, ' ', j.numero)                     AS juzgado,
    CONCAT(u.nombre, ' ', u.apellido)                   AS abogado,
    ag.completado
FROM agenda ag
    JOIN expedientes     e   ON ag.id_expediente = e.id_expediente
    JOIN conductores     c   ON e.id_conductor   = c.id_conductor
    JOIN aseguradoras    a   ON e.id_aseguradora  = a.id_aseguradora
    LEFT JOIN juzgados   j   ON e.id_juzgado     = j.id_juzgado
    JOIN abogados        ab  ON e.id_abogado     = ab.id_abogado
    JOIN usuarios        u   ON ab.id_usuario    = u.id_usuario
ORDER BY ag.hora;

-- ============================================================
-- VISTA 3: vista_resumen_estados
-- Dashboard: conteo de expedientes por estado
-- ============================================================
CREATE OR REPLACE VIEW vista_resumen_estados AS
SELECT
    est.nombre                                           AS estado,
    est.color_hex,
    COUNT(e.id_expediente)                              AS total_expedientes
FROM estados_expediente est
    LEFT JOIN expedientes e ON est.id_estado = e.id_estado
GROUP BY est.id_estado, est.nombre, est.color_hex;

-- ============================================================
-- VISTA 4: vista_expedientes_por_abogado
-- Carga de trabajo por abogado
-- ============================================================
CREATE OR REPLACE VIEW vista_expedientes_por_abogado AS
SELECT
    ab.id_abogado,
    CONCAT(ab.titulo, ' ', u.nombre, ' ', u.apellido)  AS abogado_completo,
    ab.especialidad,
    COUNT(e.id_expediente)                              AS total_expedientes,
    SUM(CASE WHEN est.nombre = 'En Curso'  THEN 1 ELSE 0 END) AS en_curso,
    SUM(CASE WHEN est.nombre = 'Pendiente' THEN 1 ELSE 0 END) AS pendientes,
    SUM(CASE WHEN est.nombre = 'Cerrado'   THEN 1 ELSE 0 END) AS cerrados
FROM abogados ab
    JOIN usuarios        u   ON ab.id_usuario  = u.id_usuario
    LEFT JOIN expedientes e  ON ab.id_abogado  = e.id_abogado
    LEFT JOIN estados_expediente est ON e.id_estado = est.id_estado
GROUP BY ab.id_abogado, u.nombre, u.apellido, ab.titulo, ab.especialidad;

-- ============================================================
-- VISTA 5: vista_expedientes_por_aseguradora
-- Expedientes agrupados por aseguradora con totales
-- ============================================================
CREATE OR REPLACE VIEW vista_expedientes_por_aseguradora AS
SELECT
    a.id_aseguradora,
    a.nombre                                            AS aseguradora,
    a.codigo,
    COUNT(e.id_expediente)                             AS total_expedientes,
    SUM(CASE WHEN est.nombre = 'En Curso'  THEN 1 ELSE 0 END) AS en_curso,
    SUM(CASE WHEN est.nombre = 'Pendiente' THEN 1 ELSE 0 END) AS pendientes,
    SUM(CASE WHEN est.nombre = 'Cerrado'   THEN 1 ELSE 0 END) AS cerrados
FROM aseguradoras a
    LEFT JOIN expedientes e ON a.id_aseguradora = e.id_aseguradora
    LEFT JOIN estados_expediente est ON e.id_estado = est.id_estado
GROUP BY a.id_aseguradora, a.nombre, a.codigo;
