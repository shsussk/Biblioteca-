-- Habilitar extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Tabla de investigaciones
CREATE TABLE investigaciones (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    titulo TEXT NOT NULL,
    pilar TEXT NOT NULL CHECK (pilar IN ('suelo_fertilizacion', 'plagas_enfermedades', 'postcosecha', 'modelos_predictivos_innovacion')),
    autores TEXT NOT NULL,
    anio INTEGER NOT NULL,
    resumen TEXT NOT NULL,
    palabras_clave TEXT[] DEFAULT '{}',
    archivo_url TEXT,
    requiere_permiso BOOLEAN DEFAULT TRUE,
    nivel_acceso TEXT DEFAULT 'interno' CHECK (nivel_acceso IN ('interno', 'direccion', 'publico_parcial')),
    fecha_subida TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    ultima_actualizacion TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabla de solicitudes de descarga
CREATE TABLE solicitudes_descarga (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    id_documento UUID NOT NULL REFERENCES investigaciones(id) ON DELETE CASCADE,
    nombre TEXT NOT NULL,
    correo TEXT NOT NULL,
    institucion TEXT,
    motivo TEXT NOT NULL,
    fecha_solicitud TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    estado TEXT DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'aprobada', 'rechazada')),
    token_descarga TEXT,
    fecha_aprobacion TIMESTAMP WITH TIME ZONE
);

-- Índices para búsquedas rápidas
CREATE INDEX idx_investigaciones_pilar ON investigaciones(pilar);
CREATE INDEX idx_investigaciones_anio ON investigaciones(anio);
CREATE INDEX idx_solicitudes_estado ON solicitudes_descarga(estado);
CREATE INDEX idx_solicitudes_documento ON solicitudes_descarga(id_documento);

-- Políticas de seguridad (RLS)
ALTER TABLE investigaciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE solicitudes_descarga ENABLE ROW LEVEL SECURITY;

-- Política: todo el mundo puede leer investigaciones
CREATE POLICY "Lectura pública de investigaciones" ON investigaciones
    FOR SELECT USING (true);

-- Política: solo administradores pueden insertar/actualizar/eliminar investigaciones
-- (asumimos que el administrador se identifica por email; ajustar según sea necesario)
CREATE POLICY "Admin full access investigaciones" ON investigaciones
    FOR ALL USING (auth.jwt() ->> 'email' = 'admin@tudominio.com');

-- Política: cualquier persona puede insertar solicitudes
CREATE POLICY "Insertar solicitudes anónimo" ON solicitudes_descarga
    FOR INSERT WITH CHECK (true);

-- Política: solo administradores pueden leer/actualizar solicitudes
CREATE POLICY "Admin full access solicitudes" ON solicitudes_descarga
    FOR ALL USING (auth.jwt() ->> 'email' = 'admin@tudominio.com');

-- Nota: reemplazar 'admin@tudominio.com' por el correo real del administrador
