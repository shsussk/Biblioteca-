CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

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

CREATE INDEX idx_investigaciones_pilar ON investigaciones(pilar);
CREATE INDEX idx_investigaciones_anio ON investigaciones(anio);
CREATE INDEX idx_solicitudes_estado ON solicitudes_descarga(estado);
CREATE INDEX idx_solicitudes_documento ON solicitudes_descarga(id_documento);

ALTER TABLE investigaciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE solicitudes_descarga ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Lectura pública de investigaciones" ON investigaciones
    FOR SELECT USING (true);

-- CAMBIA 'admin@tudominio.com' por tu correo real
CREATE POLICY "Admin full access investigaciones" ON investigaciones
    FOR ALL USING (auth.jwt() ->> 'email' = 'admin@tudominio.com');

CREATE POLICY "Insertar solicitudes anónimo" ON solicitudes_descarga
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Admin full access solicitudes" ON solicitudes_descarga
    FOR ALL USING (auth.jwt() ->> 'email' = 'admin@tudominio.com');
