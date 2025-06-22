-- Enunciado: Entrega 4- Documento de instalación y configuración
-- Fecha de entrega: 19/05/2025
-- Comisión: 2900
-- Grupo: 15
-- Materia: Bases de Datos Aplicada
-- Integrantes:
--   - Yerimen Lombardo - DNI 42115925
--   - Jeremias Menacho - DNI 37783029
--   - Ivan Morales     - DNI 39772619
--   - Nicolas Pioli    - DNI 43781515

-- Crear base de datos y usarla
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'Com2900G15')
BEGIN
	--PRINT 'NO EXISTE';--ENTRA AL IF SI NO EXISTE === TRUE
    CREATE DATABASE Com2900G15;
END
GO

USE Com2900G15;
GO

-- Crear esquemas si no existen
-- xq no usar CREATE SCHEMA personas ?
-- CREATE SCHEMA no puede usarse dentro de un IF, SQL SERVER requiere que se ejecute como una
-- din�mica
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'persona') EXEC('CREATE SCHEMA persona');
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'actividad') EXEC('CREATE SCHEMA actividad');
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'facturacion') EXEC('CREATE SCHEMA facturacion');
GO

-- 1. Crear tablas sin dependencias
--SELECT OBJECT_ID('personas.Rol');--1205579333
--SELECT * FROM sys.objects WHERE object_id = 1205579333;--tabla rol
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'usuarios.Rol') AND type in (N'U'))
--IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'persona.rol'))
--EXEC sp_rename 'personas.ROL', 'rol';
--DROP TABLE personas.ROL;
/*BEGIN
	--PRINT 'NO EXISTE LA TABLA, CREARLA';
    CREATE TABLE personas.rol (
        id_rol INT IDENTITY PRIMARY KEY,
        nombre NVARCHAR(100) NOT NULL,
        descripcion NVARCHAR(255) NULL
    );	
END*/
--===========================
--TABLA CATEGORIA (DEL SOCIO)
--===========================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'persona.Categoria') AND type in (N'U'))
BEGIN
    CREATE TABLE persona.Categoria (
        id_categoria INT IDENTITY PRIMARY KEY,
        nombre NVARCHAR(100) NOT NULL,
        edad_min INT NOT NULL,
        edad_max INT NOT NULL,
        fecha_vigencia DATE NOT NULL,
        tarifa_categoria DECIMAL(10,2) NOT NULL
   );
END
GO

--========================
--TABLA INSCRIPCION UNICA
--========================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('persona.Inscripcion'))
BEGIN
    CREATE TABLE persona.Inscripcion (
        id_inscripcion INT IDENTITY PRIMARY KEY,
        fecha DATE NOT NULL
   );
END
GO

--======================
--TABLA RESPONSABLEPAGO
--======================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'persona.ResponsablePago') AND type = N'U')
BEGIN
    CREATE TABLE persona.ResponsablePago (
        id_responsable_pago INT IDENTITY PRIMARY KEY,
		nombre NVARCHAR(100) NOT NULL,
		apellido NVARCHAR(100) NOT NULL,
		dni NVARCHAR(20) NOT NULL,
		mail NVARCHAR(100) NOT NULL,
        fecha_nacimiento DATE NOT NULL,
		telefono NVARCHAR(20) NULL,
		parentesco NVARCHAR(100) NOT NULL --puede tener hardcodeado (padre, madre, tutor)
   );
END
GO

--=====================
--TABLA COLONIAVERANO
--=====================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'actividad.Colonia'))
BEGIN
    CREATE TABLE actividad.Colonia (
        id_colonia INT IDENTITY PRIMARY KEY,
		nombre NVARCHAR(100) NOT NULL,
        fecha_inicio DATE NOT NULL,
		fecha_fin DATE NOT NULL,
		tarifa INT NOT NULL,
   );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'actividad.sum'))
BEGIN
    CREATE TABLE actividad.sum (
        id_sum INT IDENTITY PRIMARY KEY,
        fecha DATE NOT NULL,
		hora_inicio TIME NOT NULL,
		hora_fin TIME NOT NULL,
		tarifa INT NOT NULL,
   );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'actividad.actividad'))
BEGIN
    CREATE TABLE actividad.actividad (
        id_actividad INT IDENTITY PRIMARY KEY,
        nombre NVARCHAR(100) NOT NULL,
        tarifa DECIMAL(10,2) NOT NULL,
		fecha_vigencia DATE NOT NULL,
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'actividad.invitado'))
BEGIN
    CREATE TABLE actividad.invitado (
        id_invitado INT IDENTITY PRIMARY KEY,
        nombre NVARCHAR(100) NOT NULL,
		apellido NVARCHAR(100) NOT NULL,
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('facturacion.reembolso'))
BEGIN
    CREATE TABLE facturacion.reembolso (
        id_reembolso INT IDENTITY PRIMARY KEY,
		fecha DATE NOT NULL,
		monto INT NOT NULL
    );
END
GO

--ALTER SCHEMA actividades TRANSFER personas.ACTIVIDAD;--CAMBIAR DE ESQUEMA A UNA TABLA
/*SELECT s.name AS esquema, t.name AS tabla
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'personas';*/--VER LAS TABLAS DE UN ESQUEMA

-- 2. Crear tablas que referencian las anteriores

GO
--ALTER TABLE personas.usuario
--ADD es_empleado BIT NOT NULL DEFAULT 0;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('facturacion.mediopago'))
BEGIN
    CREATE TABLE facturacion.mediopago (
        id_medio INT IDENTITY PRIMARY KEY,
		nombre NVARCHAR(100) NOT NULL,
		permite_debito BIT NOT NULL, --TRUE/FALSE
		id_reembolso INT NOT NULL,
		CONSTRAINT fk_mediopago_reembolso FOREIGN KEY (id_reembolso) REFERENCES facturacion.reembolso(id_reembolso)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('facturacion.pago'))
BEGIN
    CREATE TABLE facturacion.pago (
        id_pago INT IDENTITY PRIMARY KEY,
		fecha_pago DATE NOT NULL,
		monto INT NOT NULL,
		id_medio INT NOT NULL,
		CONSTRAINT fk_pago_mediopago FOREIGN KEY (id_medio) REFERENCES facturacion.mediopago(id_medio)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'facturacion.factura'))
BEGIN
    CREATE TABLE facturacion.factura (
        id_factura INT IDENTITY PRIMARY KEY,
		fecha DATE NOT NULL,
		monto_total INT NOT NULL,
		estado NVARCHAR(100) NOT NULL,
		fecha_vencimiento DATE NOT NULL,
		fecha_segundo_vencimiento DATE NOT NULL,
		id_pago INT NOT NULL,
		CONSTRAINT fk_factura_pago FOREIGN KEY (id_pago) REFERENCES facturacion.pago(id_pago)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('facturacion.cuota'))
BEGIN
    CREATE TABLE facturacion.cuota (
        id_cuota INT IDENTITY PRIMARY KEY,
		tarifa_cuota INT NOT NULL,
		id_factura INT NOT NULL,
		CONSTRAINT fk_cuota_factura FOREIGN KEY (id_factura) REFERENCES facturacion.factura(id_factura)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('facturacion.morosidad'))
BEGIN
    CREATE TABLE facturacion.morosidad (
        id_morosidad INT IDENTITY PRIMARY KEY,
		monto INT NOT NULL,
		id_factura INT NOT NULL,
		CONSTRAINT fk_morosidad_factura FOREIGN KEY (id_factura) REFERENCES facturacion.factura(id_factura)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'persona.socio'))
BEGIN
    CREATE TABLE persona.socio (
        id_socio INT IDENTITY PRIMARY KEY,
        numero_socio VARCHAR(16) NOT NULL UNIQUE,
        nombre NVARCHAR(100) NOT NULL,
        apellido NVARCHAR(100) NOT NULL,
        dni VARCHAR(10) NOT NULL,
        email NVARCHAR(100) NOT NULL,
        fecha_nacimiento DATE NOT NULL,
        telefono VARCHAR(20) NULL,
        telefono_emergencia VARCHAR(20) NULL,
        obra_social VARCHAR(100) NULL,
        nro_obra_social VARCHAR(50) NULL,
        tel_emergencia_obra_social VARCHAR(20) NULL,
        estado NVARCHAR(100) NOT NULL,
		id_socio_responsable INT NOT NULL,
		id_responsable_pago INT NOT NULL,
		id_inscripcion INT NOT NULL,
		id_cuota INT NOT NULL,
		id_categoria INT NOT NULL,
		CONSTRAINT fk_socio_responsable FOREIGN KEY (id_socio) REFERENCES persona.socio(id_socio),
		CONSTRAINT fk_socio_responsable_pago FOREIGN KEY (id_responsable_pago) REFERENCES persona.responsablepago(id_responsable_pago),
		CONSTRAINT fk_socio_inscripcion FOREIGN KEY (id_inscripcion) REFERENCES persona.inscripcion(id_inscripcion),
		CONSTRAINT fk_socio_cuota FOREIGN KEY (id_cuota) REFERENCES facturacion.cuota(id_cuota),
		CONSTRAINT fk_socio_categoria FOREIGN KEY (id_categoria) REFERENCES persona.categoria(id_categoria),
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('actividad.inscripcioncolonia'))
BEGIN
    CREATE TABLE actividad.inscripcioncolonia (
        id_colonia INT NOT NULL,
		id_socio INT NOT NULL,
		fecha_inscripcion DATE NOT NULL,
		CONSTRAINT pk_inscripcioncolonia PRIMARY KEY (id_colonia, id_socio),
		CONSTRAINT fk_colonia_socio FOREIGN KEY (id_colonia) REFERENCES actividad.colonia(id_colonia),
		CONSTRAINT fk_socio_colonia FOREIGN KEY (id_socio) REFERENCES persona.socio(id_socio),
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('actividad.reserva'))
BEGIN
    CREATE TABLE actividad.reserva (
        id_sum INT NOT NULL,
		id_socio INT NOT NULL,
		fecha_inscripcion DATE NOT NULL,
		CONSTRAINT pk_reserva PRIMARY KEY (id_sum, id_socio),
		CONSTRAINT fk_sum_socio FOREIGN KEY (id_sum) REFERENCES actividad.sum(id_sum),
		CONSTRAINT fk_socio_sum FOREIGN KEY (id_socio) REFERENCES persona.socio(id_socio),
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('actividad.inscripcionactividad'))
BEGIN
    CREATE TABLE actividad.inscripcionactividad (
        id_actividad INT NOT NULL,
		id_socio INT NOT NULL,
		fecha_inscripcion DATE NOT NULL,
		CONSTRAINT pk_inscripcionactividad PRIMARY KEY (id_actividad, id_socio),
		CONSTRAINT fk_actividad_socio FOREIGN KEY (id_actividad) REFERENCES actividad.actividad(id_actividad),
		CONSTRAINT fk_socio_actividad FOREIGN KEY (id_socio) REFERENCES persona.socio(id_socio),
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('actividad.inscripcionactividad'))
BEGIN
    CREATE TABLE actividad.inscripcionactividad (
        id_actividad INT NOT NULL,
		id_socio INT NOT NULL,
		fecha_inscripcion DATE NOT NULL,
		CONSTRAINT pk_inscripcionactividad PRIMARY KEY (id_actividad, id_socio),
		CONSTRAINT fk_actividad_socio FOREIGN KEY (id_actividad) REFERENCES actividad.actividad(id_actividad),
		CONSTRAINT fk_socio_actividad FOREIGN KEY (id_socio) REFERENCES persona.socio(id_socio),
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('actividad.pileta'))
BEGIN
    CREATE TABLE actividad.pileta (
        id_pileta INT IDENTITY PRIMARY KEY,
		descuento_lluvia INT NOT NULL,
		fecha_vigencia DATE NOT NULL,
		tarifa INT NOT NULL,
		id_invitado INT NOT NULL,
		CONSTRAINT fk_pileta_invitado FOREIGN KEY (id_invitado) REFERENCES actividad.invitado(id_invitado),
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'actividad.inscripcionpileta'))
BEGIN
    CREATE TABLE actividad.inscripcionpileta (
        id_pileta INT NOT NULL,
		id_socio INT NOT NULL,
		fecha_inscripcion DATE NOT NULL,
		tipo_inscripcion NVARCHAR(100) NOT NULL,
		CONSTRAINT pk_inscripcionpileta PRIMARY KEY (id_pileta, id_socio),
		CONSTRAINT fk_pileta_socio FOREIGN KEY (id_pileta) REFERENCES actividad.pileta(id_pileta),
		CONSTRAINT fk_socio_pileta FOREIGN KEY (id_socio) REFERENCES persona.socio(id_socio),
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'facturacion.detallefactura'))
BEGIN
    CREATE TABLE facturacion.detallefactura (
        id_detalle INT IDENTITY PRIMARY KEY,
		detalle NVARCHAR(100) NOT NULL,
		monto INT NOT NULL,
		id_factura INT NOT NULL,
		id_actividad INT NOT NULL,
		id_pileta INT NOT NULL,
		id_sum INT NOT NULL,
		id_colonia INT NOT NULL,
		CONSTRAINT fk_detallefactura_factura FOREIGN KEY (id_factura) REFERENCES facturacion.factura(id_factura),
		CONSTRAINT fk_detallefactura_actividad FOREIGN KEY (id_actividad) REFERENCES actividad.actividad(id_actividad),
		CONSTRAINT fk_detallefactura_pileta FOREIGN KEY (id_pileta) REFERENCES actividad.pileta(id_pileta),
		CONSTRAINT fk_detallefactura_sum FOREIGN KEY (id_sum) REFERENCES actividad.sum(id_sum),
		CONSTRAINT fk_detallefactura_colonia FOREIGN KEY (id_colonia) REFERENCES actividad.colonia(id_colonia)
    );
END
GO