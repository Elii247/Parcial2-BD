# 🏛️ Delgado & Delgado — Sistema de Gestión de Expedientes

API REST con Flask + MariaDB para la firma de abogados Delgado & Delgado.

---

## 📁 Archivos del proyecto

```
├── 01_schema.sql        # Crea la base de datos y tablas
├── 02_seed_data.sql     # Inserta datos de prueba
├── 03_views.sql         # Crea las 5 vistas SQL
├── app.py               # API REST con Flask (conector PyMySQL)
├── requirements.txt     # Dependencias de Python
└── README.md            # Este archivo
```

---

## ✅ Requisitos previos

Instala estos programas antes de empezar:

| Programa | Descarga |
|---|---|
| Python 3.10+ | https://python.org/downloads |
| MariaDB 10.6+ | https://mariadb.org/download |
| HeidiSQL (para ver las tablas visualmente, solo Windows) | https://heidisql.com/download.php |
| DBeaver (alternativa multiplataforma) | https://dbeaver.io/download |
| Postman (para probar la API) | https://postman.com/downloads |

> **¿Tienes XAMPP?** XAMPP incluye MariaDB. Solo asegúrate de tener el módulo MySQL/MariaDB activo en el panel de XAMPP.

---

## 🗄️ Paso 1 — Configurar la Base de Datos en MariaDB

### Opción A: Usando HeidiSQL o DBeaver
1. Abre el programa y conéctate a tu servidor MariaDB local
2. Abre y ejecuta **`01_schema.sql`** → crea la base de datos y todas las tablas
3. Abre y ejecuta **`02_seed_data.sql`** → inserta los datos de prueba
4. Abre y ejecuta **`03_views.sql`** → crea las 5 vistas

### Opción B: Usando la terminal
```bash
# En Windows (CMD):
mysql -u root -p < 01_schema.sql
mysql -u root -p < 02_seed_data.sql
mysql -u root -p < 03_views.sql

# En Linux/Mac:
mariadb -u root -p < 01_schema.sql
mariadb -u root -p < 02_seed_data.sql
mariadb -u root -p < 03_views.sql
```

> Te pedirá tu contraseña de MariaDB cada vez. Si no pusiste contraseña, solo presiona Enter.

---

## 🐍 Paso 2 — Instalar dependencias de Python

Abre una terminal/CMD en la carpeta del proyecto y ejecuta:

```bash
pip install -r requirements.txt
```

Esto instalará automáticamente:

| Librería | Para qué sirve |
|---|---|
| `Flask` | Framework del servidor web |
| `PyMySQL` | Conector Python ↔ MariaDB (puro Python, sin instalaciones extras) |
| `PyJWT` | Generación de tokens de autenticación JWT |
| `bcrypt` | Encriptación segura de contraseñas |
| `python-dotenv` | Manejo de variables de entorno |

---

## ⚙️ Paso 3 — Configurar la conexión a MariaDB

### Opción A: Editar directamente en app.py
Abre `app.py` y busca la sección `DB_CONFIG` (está al inicio del archivo):

```python
DB_CONFIG = {
    'host':     'localhost',   # dirección de tu servidor MariaDB
    'user':     'root',        # ← tu usuario de MariaDB
    'password': '',            # ← tu contraseña de MariaDB
    'database': 'delgado_abogados',
    'cursorclass': pymysql.cursors.DictCursor,
    'charset':  'utf8mb4',
}
```

### Opción B: Usar archivo .env (recomendado)
Crea un archivo llamado **`.env`** en la misma carpeta que `app.py`:

```
DB_HOST=localhost
DB_USER=root
DB_PASS=tu_contraseña_aqui
DB_NAME=delgado_abogados
SECRET_KEY=cualquier_texto_secreto_largo
```

> Con el archivo `.env` no necesitas tocar el código. Es la forma más segura.

---

## 🚀 Paso 4 — Ejecutar la API

```bash
python app.py
```

Si todo está bien verás esto en la terminal:

```
 * Running on http://0.0.0.0:5000
 * Debug mode: on
```

La API queda disponible en: **http://localhost:5000**

---

## 🧪 Paso 5 — Probar la API con Postman

### 1. Hacer Login (siempre es el primer paso)

| Campo | Valor |
|---|---|
| Método | `POST` |
| URL | `http://localhost:5000/api/auth/login` |
| Body | raw → JSON |

```json
{
  "username": "jperez",
  "password": "password123"
}
```

La respuesta te dará un **token**. Cópialo:
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "usuario": { "nombre": "Juan Pérez", "rol": "Admin" }
  }
}
```

---

### 2. Configurar el token en Postman

Para todos los demás endpoints, en Postman ve a la pestaña **Authorization**:
- Type: **Bearer Token**
- Token: pega el token copiado

---

### 3. Endpoints disponibles

| Método | URL | Descripción |
|---|---|---|
| `POST` | `/api/auth/login` | Iniciar sesión → obtener token |
| `GET` | `/api/auth/me` | Ver datos de mi usuario |
| `GET` | `/api/dashboard` | Contadores + agenda del día |
| `GET` | `/api/expedientes` | Listar expedientes (con filtros) |
| `GET` | `/api/expedientes/1` | Ver expediente por ID |
| `POST` | `/api/expedientes` | Crear nuevo expediente |
| `PUT` | `/api/expedientes/1` | Editar un expediente |
| `GET` | `/api/aseguradoras` | Listar aseguradoras |
| `POST` | `/api/aseguradoras` | Crear aseguradora |
| `GET` | `/api/tipos-caso` | Listar tipos de caso |
| `POST` | `/api/tipos-caso` | Crear tipo de caso |
| `GET` | `/api/abogados` | Listar abogados con carga |
| `POST` | `/api/abogados` | Registrar nuevo abogado |
| `GET` | `/api/conductores` | Listar/buscar conductores |
| `POST` | `/api/conductores` | Crear conductor |
| `GET` | `/api/juzgados` | Listar juzgados activos |
| `GET` | `/api/reportes/expedientes-por-aseguradora` | Reporte por aseguradora |
| `GET` | `/api/reportes/expedientes-por-abogado` | Reporte por abogado |

---

### 4. Ejemplo — Crear un expediente

```json
POST http://localhost:5000/api/expedientes

{
  "codigo_expediente": "EXP-999",
  "id_conductor": 1,
  "id_aseguradora": 1,
  "numero_caso": "CASO-2024-001",
  "id_tipo_caso": 1,
  "id_abogado": 2,
  "id_juzgado": 5,
  "fecha_inicio": "2024-01-15",
  "fecha_finalizacion": "2024-06-30",
  "formato": "5435435"
}
```

---

### 5. Ejemplo — Filtrar expedientes

```
GET http://localhost:5000/api/expedientes?aseguradora=ASSA&estado=En Curso&page=1
GET http://localhost:5000/api/expedientes?buscar=anthony
```

---

### 6. Ejemplo — Crear un abogado

```json
POST http://localhost:5000/api/abogados

{
  "nombre": "Carlos",
  "apellido": "Mendez",
  "email": "cmendez@delgado.com",
  "username": "cmendez",
  "password": "miPassword123",
  "titulo": "Lic.",
  "especialidad": "Tránsito y Seguros"
}
```

---

## 👥 Usuarios de prueba

| Usuario | Contraseña | Rol |
|---|---|---|
| `jperez` | `password123` | Admin |
| `dcampbell` | `password123` | Abogado |
| `hgray` | `password123` | Abogado |
| `wharris` | `password123` | Abogado |

---

## ❌ Errores comunes y soluciones

| Error | Causa | Solución |
|---|---|---|
| `ModuleNotFoundError: No module named 'pymysql'` | Falta instalar dependencias | Ejecuta `pip install -r requirements.txt` |
| `Access denied for user 'root'` | Usuario o contraseña incorrectos | Revisa `DB_CONFIG` en `app.py` o el archivo `.env` |
| `Unknown database 'delgado_abogados'` | No se ejecutó el schema | Ejecuta `01_schema.sql` primero |
| `Table doesn't exist` | Falta ejecutar las vistas | Ejecuta `03_views.sql` |
| `401 Token requerido` | No se envió el token | Agrega el Bearer Token en Postman → Authorization |
| `401 Token expirado` | El token duró más de 8 horas | Haz login nuevamente para obtener un token fresco |
| Puerto 5000 ocupado | Otro programa usa ese puerto | Cambia al final de `app.py`: `app.run(port=5001)` |
| `Can't connect to MariaDB server` | MariaDB no está corriendo | Inicia el servicio MariaDB o XAMPP |

---

## 🗂️ Estructura de la Base de Datos

```
roles ──────────────────┐
                        ↓
ciudades ──→ juzgados   usuarios ──→ abogados ──┐
                        ↓                       │
aseguradoras ───────→ expedientes ←─────────────┘
tipos_caso ──────────→ expedientes
conductores ─────────→ expedientes
estados_expediente ──→ expedientes
                        ↓              ↓
                      agenda    documentos_expediente
```

---

*Delgado & Delgado — Firma de Abogados | Parcial 2 | Flask + MariaDB + PyMySQL*
