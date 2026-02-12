# Repositorio de Investigaciones con Supabase

Este proyecto es una aplicación web para gestionar un repositorio de investigaciones, con capa pública de consulta y panel de administración.

## Configuración inicial

### 1. Crear proyecto en Supabase
1. Accede a [Supabase](https://supabase.com) y crea un nuevo proyecto.
2. Copia la URL y la anon key (las proporcionadas ya están listas para usar con el proyecto existente).
3. En el Editor SQL, ejecuta el contenido de `schema.sql` para crear las tablas.

### 2. Configurar almacenamiento
1. En el panel de Supabase, ve a **Storage** y crea un bucket llamado `investigaciones_pdf`.
2. Hazlo público (o configura políticas de acceso; para este demo, público es suficiente).
3. (Opcional) Configura políticas de seguridad RLS según necesites.

### 3. Crear usuario administrador
1. En **Authentication > Users**, agrega un nuevo usuario con el correo que usarás como admin.
2. Reemplaza en las políticas RLS (schema.sql) el correo `admin@tudominio.com` por el tuyo.

### 4. Desplegar el frontend
Puedes usar cualquier servicio de hosting estático (Netlify, Vercel, GitHub Pages). Solo sube todos los archivos manteniendo la estructura de carpetas.

### 5. Probar
- Accede a `index.html` para ver la vista pública.
- Accede a `admin/login.html` e inicia sesión con las credenciales del admin.

## Estructura de archivos
- `supabase.js` - Configuración del cliente de Supabase.
- `styles.css` - Estilos personalizados.
- `index.html` - Página principal con listado y filtros.
- `detalle.html` - Detalle de investigación y solicitud de descarga.
- `admin/` - Panel de administración:
  - `login.html`
  - `dashboard.html`
  - `investigaciones.html`
  - `solicitudes.html`
- `schema.sql` - Script de creación de tablas.

## Funcionalidades implementadas
- [x] Listado público con filtros por pilar, año y texto.
- [x] Vista de detalle con resumen completo y palabras clave.
- [x] Solicitud de permiso de descarga (formulario).
- [x] Verificación de descarga mediante correo electrónico.
- [x] Panel de administración con login.
- [x] CRUD de investigaciones (incluye subida de PDF).
- [x] Gestión de solicitudes (aprobar/rechazar).

## Notas adicionales
- Los PDFs se sirven mediante URLs firmadas con validez de 1 hora.
- No se ha implementado envío de correos; la notificación es manual.
- Si se desea mayor seguridad, se puede modificar el flujo de descarga para generar tokens de un solo uso.

---

Para cualquier duda, contactar al desarrollador.
