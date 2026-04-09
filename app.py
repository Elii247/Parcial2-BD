"""
============================================================
DELGADO & DELGADO - FIRMA DE ABOGADOS
API REST con Flask - Sistema de Gestión de Expedientes
Conector: PyMySQL (compatible con MariaDB)
============================================================
"""

from flask import Flask, request, jsonify
from functools import wraps
import pymysql
import pymysql.cursors
import bcrypt
import jwt
import datetime
import os
from dotenv import load_dotenv
from flask import Flask
from flask_cors import CORS

load_dotenv()

app = Flask(__name__)
CORS(app)

# ============================================================
# CONFIGURACIÓN — MariaDB con PyMySQL
# ============================================================
DB_CONFIG = {
    'host':     os.environ.get('DB_HOST', 'localhost'),
    'user':     os.environ.get('DB_USER', 'root'),
    'password': os.environ.get('DB_PASS', ''),
    'database': os.environ.get('DB_NAME', 'delgado_abogados'),
    'cursorclass': pymysql.cursors.DictCursor,
    'charset':  'utf8mb4',
    'port':     int(os.environ.get('DB_PORT', 3306)),
}

SECRET_KEY = os.environ.get('SECRET_KEY', 'delgado_secret_2024')


# ============================================================
# HELPER: Conexión a MariaDB
# ============================================================
def get_db():
    """Retorna una conexión nueva a MariaDB."""
    return pymysql.connect(**DB_CONFIG)


# ============================================================
# HELPER: Respuestas estándar
# ============================================================
def success(data=None, message="OK", code=200):
    return jsonify({"success": True, "message": message, "data": data}), code

def error(message="Error", code=400):
    return jsonify({"success": False, "message": message, "data": None}), code


# ============================================================
# MIDDLEWARE: Autenticación JWT
# ============================================================
def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get('Authorization', '').replace('Bearer ', '')
        if not token:
            return error("Token requerido", 401)
        try:
            data = jwt.decode(token, SECRET_KEY, algorithms=['HS256'])
            request.user = data
        except jwt.ExpiredSignatureError:
            return error("Token expirado", 401)
        except jwt.InvalidTokenError:
            return error("Token inválido", 401)
        return f(*args, **kwargs)
    return decorated


# ============================================================
# MÓDULO 1: AUTENTICACIÓN / LOGIN
# ============================================================

@app.route('/api/auth/login', methods=['POST'])
def login():
    """
    POST /api/auth/login
    Body: { "username": "jperez", "password": "password123" }
    """
    body = request.get_json()
    if not body or not body.get('username') or not body.get('password'):
        return error("Usuario y contraseña requeridos")

    conn = get_db()
    try:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT u.id_usuario, u.nombre, u.apellido, u.username,
                       u.password_hash, u.activo, r.nombre_rol
                FROM usuarios u
                JOIN roles r ON u.id_rol = r.id_rol
                WHERE u.username = %s
            """, (body['username'],))
            user = cur.fetchone()
    finally:
        conn.close()

    if not user or not user['activo']:
        return error("Credenciales inválidas", 401)

    if not bcrypt.checkpw(body['password'].encode(), user['password_hash'].encode()):
        return error("Credenciales inválidas", 401)

    token = jwt.encode({
        'id_usuario': user['id_usuario'],
        'username':   user['username'],
        'rol':        user['nombre_rol'],
        'exp':        datetime.datetime.utcnow() + datetime.timedelta(hours=8)
    }, SECRET_KEY, algorithm='HS256')

    return success({
        "token": token,
        "usuario": {
            "id":       user['id_usuario'],
            "nombre":   f"{user['nombre']} {user['apellido']}",
            "username": user['username'],
            "rol":      user['nombre_rol']
        }
    }, "Login exitoso")


@app.route('/api/auth/me', methods=['GET'])
@token_required
def me():
    return success(request.user)


# ============================================================
# MÓDULO 2: EXPEDIENTES
# ============================================================

@app.route('/api/expedientes', methods=['GET'])
@token_required
def get_expedientes():
    page     = int(request.args.get('page', 1))
    per_page = int(request.args.get('per_page', 9))
    buscar   = request.args.get('buscar', '')
    aseg     = request.args.get('aseguradora', '')
    tipo     = request.args.get('tipo_caso', '')
    estado   = request.args.get('estado', '')

    conditions, params = [], []

    if buscar:
        conditions.append("(conductor LIKE %s OR codigo_expediente LIKE %s)")
        params += [f'%{buscar}%', f'%{buscar}%']
    if aseg:
        conditions.append("aseguradora = %s")
        params.append(aseg)
    if tipo:
        conditions.append("tipo_caso = %s")
        params.append(tipo)
    if estado:
        conditions.append("estado = %s")
        params.append(estado)

    where  = "WHERE " + " AND ".join(conditions) if conditions else ""
    offset = (page - 1) * per_page

    conn = get_db()
    try:
        with conn.cursor() as cur:
            cur.execute(f"SELECT COUNT(*) as total FROM vista_expedientes_completos {where}", params)
            total = cur.fetchone()['total']
            cur.execute(
                f"SELECT * FROM vista_expedientes_completos {where} ORDER BY created_at DESC LIMIT %s OFFSET %s",
                params + [per_page, offset]
            )
            expedientes = cur.fetchall()
    finally:
        conn.close()

    return success({
        "expedientes": expedientes,
        "pagination": {
            "total":    total,
            "page":     page,
            "per_page": per_page,
            "pages":    (total + per_page - 1) // per_page
        }
    })


@app.route('/api/expedientes/<int:id_expediente>', methods=['GET'])
@token_required
def get_expediente(id_expediente):
    conn = get_db()
    try:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT * FROM vista_expedientes_completos WHERE id_expediente = %s",
                (id_expediente,)
            )
            exp = cur.fetchone()
    finally:
        conn.close()

    if not exp:
        return error("Expediente no encontrado", 404)
    return success(exp)


@app.route('/api/expedientes', methods=['POST'])
@token_required
def create_expediente():
    body = request.get_json()
    required = ['codigo_expediente', 'id_conductor', 'id_aseguradora',
                'id_tipo_caso', 'id_abogado', 'fecha_inicio']
    missing = [f for f in required if not body.get(f)]
    if missing:
        return error(f"Campos requeridos faltantes: {', '.join(missing)}")

    conn = get_db()
    try:
        with conn.cursor() as cur:
            cur.execute("""
                INSERT INTO expedientes
                    (codigo_expediente, id_conductor, id_aseguradora, numero_caso,
                     id_tipo_caso, id_abogado, id_juzgado, id_estado,
                     fecha_inicio, fecha_finalizacion, formato)
                VALUES (%s, %s, %s, %s, %s, %s, %s, 1, %s, %s, %s)
            """, (
                body['codigo_expediente'], body['id_conductor'],
                body['id_aseguradora'],    body.get('numero_caso'),
                body['id_tipo_caso'],      body['id_abogado'],
                body.get('id_juzgado'),    body['fecha_inicio'],
                body.get('fecha_finalizacion'), body.get('formato')
            ))
            conn.commit()
            new_id = cur.lastrowid
    except Exception as e:
        conn.rollback()
        return error(str(e))
    finally:
        conn.close()

    return success({"id_expediente": new_id}, "Expediente creado exitosamente", 201)


@app.route('/api/expedientes/<int:id_expediente>', methods=['PUT'])
@token_required
def update_expediente(id_expediente):
    body = request.get_json()
    updatable = ['id_conductor', 'id_aseguradora', 'numero_caso', 'id_tipo_caso',
                 'id_abogado', 'id_juzgado', 'id_estado', 'fecha_inicio',
                 'fecha_finalizacion', 'formato', 'observaciones']

    fields = {k: body[k] for k in updatable if k in body}
    if not fields:
        return error("No hay campos para actualizar")

    set_clause = ", ".join([f"{k} = %s" for k in fields])
    values = list(fields.values()) + [id_expediente]

    conn = get_db()
    try:
        with conn.cursor() as cur:
            cur.execute(f"UPDATE expedientes SET {set_clause} WHERE id_expediente = %s", values)
            conn.commit()
            if cur.rowcount == 0:
                return error("Expediente no encontrado", 404)
    except Exception as e:
        conn.rollback()
        return error(str(e))
    finally:
        conn.close()

    return success(None, "Expediente actualizado exitosamente")


# ============================================================
# MÓDULO 3: ASEGURADORAS
# ============================================================

@app.route('/api/aseguradoras', methods=['GET'])
@token_required
def get_aseguradoras():
    conn = get_db()
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM vista_expedientes_por_aseguradora ORDER BY total_expedientes DESC")
            data = cur.fetchall()
    finally:
        conn.close()
    return success(data)


@app.route('/api/aseguradoras', methods=['POST'])
@token_required
def create_aseguradora():
    body = request.get_json()
    if not body.get('nombre') or not body.get('codigo'):
        return error("Nombre y código son requeridos")

    conn = get_db()
    try:
        with conn.cursor() as cur:
            cur.execute("""
                INSERT INTO aseguradoras (nombre, codigo, telefono, email, direccion)
                VALUES (%s, %s, %s, %s, %s)
            """, (body['nombre'], body['codigo'],
                  body.get('telefono'), body.get('email'), body.get('direccion')))
            conn.commit()
            new_id = cur.lastrowid
    except Exception as e:
        conn.rollback()
        return error(str(e))
    finally:
        conn.close()

    return success({"id_aseguradora": new_id}, "Aseguradora creada", 201)


# ============================================================
# MÓDULO 4: TIPOS DE CASO
# ============================================================

@app.route('/api/tipos-caso', methods=['GET'])
@token_required
def get_tipos_caso():
    conn = get_db()
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM tipos_caso WHERE activo = 1 ORDER BY nombre")
            data = cur.fetchall()
    finally:
        conn.close()
    return success(data)


@app.route('/api/tipos-caso', methods=['POST'])
@token_required
def create_tipo_caso():
    body = request.get_json()
    if not body.get('nombre'):
        return error("El nombre del tipo de caso es requerido")

    conn = get_db()
    try:
        with conn.cursor() as cur:
            cur.execute(
                "INSERT INTO tipos_caso (nombre, descripcion) VALUES (%s, %s)",
                (body['nombre'], body.get('descripcion'))
            )
            conn.commit()
            new_id = cur.lastrowid
    except Exception as e:
        conn.rollback()
        return error(str(e))
    finally:
        conn.close()

    return success({"id_tipo_caso": new_id}, "Tipo de caso creado", 201)


# ============================================================
# MÓDULO 5: ABOGADOS (LICENCIADOS)
# ============================================================

@app.route('/api/abogados', methods=['GET'])
@token_required
def get_abogados():
    conn = get_db()
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM vista_expedientes_por_abogado ORDER BY total_expedientes DESC")
            data = cur.fetchall()
    finally:
        conn.close()
    return success(data)


@app.route('/api/abogados', methods=['POST'])
@token_required
def create_abogado():
    body = request.get_json()
    required = ['nombre', 'apellido', 'email', 'username', 'password']
    missing = [f for f in required if not body.get(f)]
    if missing:
        return error(f"Campos requeridos: {', '.join(missing)}")

    pw_hash = bcrypt.hashpw(body['password'].encode(), bcrypt.gensalt()).decode()

    conn = get_db()
    try:
        with conn.cursor() as cur:
            cur.execute("""
                INSERT INTO usuarios (nombre, apellido, email, username, password_hash, id_rol)
                VALUES (%s, %s, %s, %s, %s, 2)
            """, (body['nombre'], body['apellido'], body['email'],
                  body['username'], pw_hash))
            new_user_id = cur.lastrowid
            cur.execute("""
                INSERT INTO abogados (id_usuario, titulo, especialidad, num_colegiado)
                VALUES (%s, %s, %s, %s)
            """, (new_user_id, body.get('titulo', 'Lic.'),
                  body.get('especialidad'), body.get('num_colegiado')))
            conn.commit()
            new_id = cur.lastrowid
    except Exception as e:
        conn.rollback()
        return error(str(e))
    finally:
        conn.close()

    return success({"id_abogado": new_id}, "Abogado registrado exitosamente", 201)


# ============================================================
# MÓDULO 6: DASHBOARD / REPORTES
# ============================================================

@app.route('/api/dashboard', methods=['GET'])
@token_required
def get_dashboard():
    conn = get_db()
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM vista_resumen_estados")
            estados = cur.fetchall()
            cur.execute("SELECT * FROM vista_agenda_del_dia WHERE fecha = CURDATE() ORDER BY hora")
            agenda = cur.fetchall()
    finally:
        conn.close()

    return success({
        "estados":   estados,
        "agenda":    agenda,
        "fecha_hoy": datetime.date.today().isoformat()
    })


@app.route('/api/reportes/expedientes-por-aseguradora', methods=['GET'])
@token_required
def reporte_por_aseguradora():
    conn = get_db()
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM vista_expedientes_por_aseguradora")
            data = cur.fetchall()
    finally:
        conn.close()
    return success(data)


@app.route('/api/reportes/expedientes-por-abogado', methods=['GET'])
@token_required
def reporte_por_abogado():
    conn = get_db()
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT * FROM vista_expedientes_por_abogado")
            data = cur.fetchall()
    finally:
        conn.close()
    return success(data)


# ============================================================
# MÓDULO 7: JUZGADOS & CONDUCTORES
# ============================================================

@app.route('/api/juzgados', methods=['GET'])
@token_required
def get_juzgados():
    conn = get_db()
    try:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT j.id_juzgado, CONCAT(j.nombre, ' ', j.numero) AS nombre_completo,
                       c.nombre AS ciudad
                FROM juzgados j JOIN ciudades c ON j.id_ciudad = c.id_ciudad
                WHERE j.activo = 1 ORDER BY c.nombre, j.numero
            """)
            data = cur.fetchall()
    finally:
        conn.close()
    return success(data)


@app.route('/api/conductores', methods=['GET'])
@token_required
def get_conductores():
    conn = get_db()
    buscar = request.args.get('buscar', '')
    try:
        with conn.cursor() as cur:
            if buscar:
                cur.execute(
                    "SELECT * FROM conductores WHERE nombre LIKE %s OR apellido LIKE %s OR cedula LIKE %s",
                    [f'%{buscar}%'] * 3
                )
            else:
                cur.execute("SELECT * FROM conductores ORDER BY apellido")
            data = cur.fetchall()
    finally:
        conn.close()
    return success(data)


@app.route('/api/conductores', methods=['POST'])
@token_required
def create_conductor():
    body = request.get_json()
    if not body.get('nombre') or not body.get('apellido'):
        return error("Nombre y apellido son requeridos")

    conn = get_db()
    try:
        with conn.cursor() as cur:
            cur.execute("""
                INSERT INTO conductores (nombre, apellido, cedula, telefono, email)
                VALUES (%s, %s, %s, %s, %s)
            """, (body['nombre'], body['apellido'],
                  body.get('cedula'), body.get('telefono'), body.get('email')))
            conn.commit()
            new_id = cur.lastrowid
    except Exception as e:
        conn.rollback()
        return error(str(e))
    finally:
        conn.close()

    return success({"id_conductor": new_id}, "Conductor creado", 201)


# ============================================================
# ERROR HANDLERS
# ============================================================
@app.errorhandler(404)
def not_found(e):
    return error("Ruta no encontrada", 404)

@app.errorhandler(500)
def server_error(e):
    return error("Error interno del servidor", 500)


# ============================================================
# MAIN
# ============================================================
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
