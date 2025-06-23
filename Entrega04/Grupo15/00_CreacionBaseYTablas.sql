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
    CREATE DATABASE Com2900G15;
END
GO

USE Com2900G15;
GO

-- Crear esquemas si no existen
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'persona') EXEC('CREATE SCHEMA persona');
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'actividad') EXEC('CREATE SCHEMA actividad');
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'facturacion') EXEC('CREATE SCHEMA facturacion');
GO

--========================
--TABLA INSCRIPCION UNICA
--========================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'persona.Inscripcion') AND type in (N'U'))
BEGIN
    CREATE TABLE persona.Inscripcion (
        id_inscripcion INT IDENTITY PRIMARY KEY,
		fecha DATE NOT NULL
    );
END
GO

--===========================
--TABLA CATEGORIA (DEL SOCIO)
--===========================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'persona.Categoria') AND type in (N'U'))
BEGIN
    CREATE TABLE persona.Categoria (
        id_categoria INT IDENTITY(100,1) PRIMARY KEY,
        nombre NVARCHAR(100) NOT NULL,
        edad_min INT NOT NULL,
        edad_max INT NOT NULL,
        fecha_vigencia DATE NOT NULL,
		tarifa_categoria DECIMAL(10,2) NOT NULL
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
        email NVARCHAR(100) NOT NULL,
        fecha_nacimiento DATE NOT NULL,
        telefono NVARCHAR(20) NULL,
        parentesco NVARCHAR(100) NOT NULL --puede tener hardcodeado (padre, madre, tutor)
    );
END
GO

--================
--TABLA REEMBOLSO
--================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'facturacion.Reembolso') AND type = N'U')
BEGIN
    CREATE TABLE facturacion.Reembolso (
        id_reembolso INT IDENTITY PRIMARY KEY,
        fecha DATE NOT NULL,
        monto DECIMAL(10,2) NOT NULL
    );
END
GO

--================
--TABLA MEDIOPAGO
--================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'facturacion.MedioPago') AND type = N'U')
BEGIN
    CREATE TABLE facturacion.MedioPago (
        id_medio_pago INT IDENTITY PRIMARY KEY,
        nombre NVARCHAR(100) NOT NULL,
        permite_debito BIT NOT NULL,
        id_reembolso INT NULL,
        CONSTRAINT FK_MedioPago_Reembolso FOREIGN KEY (id_reembolso) REFERENCES facturacion.Reembolso(id_reembolso)
        );
END
GO

--===========
--TABLA PAGO
--===========
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'facturacion.Pago') AND type = N'U')
BEGIN
    CREATE TABLE facturacion.Pago (
        id_pago INT IDENTITY PRIMARY KEY,
        fecha_pago DATE NOT NULL,
        monto DECIMAL(10,2) NOT NULL,
        id_medio_pago INT NOT NULL,
        CONSTRAINT FK_Pago_MedioPago FOREIGN KEY (id_medio_pago) REFERENCES facturacion.MedioPago(id_medio_pago)
    );
END
GO

--==============
--TABLA FACTURA
--==============
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'facturacion.Factura') AND type = N'U')
BEGIN
    CREATE TABLE facturacion.Factura (
        id_factura INT IDENTITY PRIMARY KEY,
        fecha DATE NOT NULL,
        monto_total DECIMAL(10,2) NOT NULL,
        estado NVARCHAR(100) NOT NULL,
        fecha_vencimiento DATE NOT NULL,
        fecha_segundo_vencimiento DATE NOT NULL,--cuando se crea la factura, viene con ambas fechas
        id_pago INT NULL,
        CONSTRAINT FK_Factura_Pago FOREIGN KEY (id_pago) REFERENCES facturacion.Pago(id_pago)
    );
END
GO

--============
--TABLA CUOTA
--============
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'facturacion.Cuota') AND type = N'U')
BEGIN
    CREATE TABLE facturacion.Cuota (
        id_cuota INT IDENTITY PRIMARY KEY,
        tarifa_cuota DECIMAL(10,2) NOT NULL,
        id_factura INT NOT NULL,
        CONSTRAINT FK_Cuota_Factura FOREIGN KEY (id_factura) REFERENCES facturacion.Factura(id_factura)
    );
END
GO

--================
--TABLA MOROSIDAD
--================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'facturacion.Morosidad') AND type = N'U')
BEGIN
    CREATE TABLE facturacion.Morosidad (
        id_morosidad INT IDENTITY PRIMARY KEY,
        monto DECIMAL(10,2) NOT NULL,
		id_factura INT NOT NULL,
		CONSTRAINT FK_morosidad_factura FOREIGN KEY (id_factura) REFERENCES facturacion.factura(id_factura)
    );
END
GO

--=============
--TABLA SOCIO 
--=============
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'persona.Socio') AND type = N'U')
BEGIN
    CREATE TABLE persona.Socio (
        id_socio INT IDENTITY PRIMARY KEY,
        numero_socio VARCHAR(50) NOT NULL UNIQUE,
        nombre NVARCHAR(100) NOT NULL,
        apellido NVARCHAR(100) NOT NULL,
        dni VARCHAR(10) NOT NULL,
        email NVARCHAR(100) NOT NULL,
        fecha_nacimiento DATE NOT NULL,
        telefono VARCHAR(20) NULL,
        telefono_emergencia VARCHAR(20) NULL,
        obra_social NVARCHAR(100) NULL,
        nro_obra_social NVARCHAR(50) NULL,
        tel_emergencia_obra_social VARCHAR(20) NULL,
        estado NVARCHAR(100) NOT NULL,
        id_socio_responsable INT NULL,
        id_responsable_pago INT NULL,
        id_inscripcion INT NULL,
        id_cuota INT NULL,
        id_categoria INT NOT NULL,
        CONSTRAINT FK_Socio_Responsable FOREIGN KEY (id_socio_responsable) REFERENCES persona.Socio(id_socio),
        CONSTRAINT FK_Socio_ResponsablePago FOREIGN KEY (id_responsable_pago) REFERENCES persona.ResponsablePago(id_responsable_pago),
        CONSTRAINT FK_Socio_Inscripcion FOREIGN KEY (id_inscripcion) REFERENCES persona.Inscripcion(id_inscripcion),
        CONSTRAINT FK_Socio_Cuota FOREIGN KEY (id_cuota) REFERENCES facturacion.Cuota(id_cuota),
        CONSTRAINT FK_Socio_Categoria FOREIGN KEY (id_categoria) REFERENCES persona.Categoria(id_categoria)
    );
END
GO

--=====================
--TABLA COLONIAVERANO
--=====================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'actividad.Colonia') AND type = N'U')
BEGIN
    CREATE TABLE actividad.Colonia (
        id_colonia INT IDENTITY PRIMARY KEY,
        nombre NVARCHAR(100) NOT NULL,
        fecha_inicio DATE NOT NULL,
        fecha_fin DATE NOT NULL,
        tarifa DECIMAL(10,2) NOT NULL
    );
END
GO

--==========================
-- TABLA INSCRIPCIONCOLONIA
--==========================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'actividad.InscripcionColonia') AND type = N'U')
BEGIN
    CREATE TABLE actividad.InscripcionColonia (
        id_colonia INT NOT NULL,
        id_socio INT NOT NULL,
        fecha_inscripcion DATE NOT NULL,
		CONSTRAINT pk_inscripcioncolonia PRIMARY KEY (id_colonia, id_socio),
        CONSTRAINT FK_InscripcionColonia_Colonia FOREIGN KEY (id_colonia) REFERENCES actividad.Colonia(id_colonia),
        CONSTRAINT FK_InscripcionColonia_Socio FOREIGN KEY (id_socio) REFERENCES persona.Socio(id_socio)
    );
END
GO

--================
--TABLA ACTIVIDAD
--================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'actividad.Actividad') AND type = N'U')
BEGIN
    CREATE TABLE actividad.Actividad (
        id_actividad INT IDENTITY PRIMARY KEY,
        nombre NVARCHAR(100) NOT NULL,
        tarifa DECIMAL(10,2) NOT NULL,
        fecha_vigencia DATE NOT NULL
    );
END
GO

--============================
--TABLA INSCRIPCION ACTIVIDAD
--============================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'actividad.InscripcionActividad') AND type = N'U')
BEGIN
    CREATE TABLE actividad.InscripcionActividad (
        id_actividad INT NOT NULL,
        id_socio INT NOT NULL,
        fecha_inscripcion DATE NOT NULL,
		CONSTRAINT pk_inscripcionactividad PRIMARY KEY (id_actividad, id_socio),
        CONSTRAINT FK_InscripcionActividad_Actividad FOREIGN KEY (id_actividad) REFERENCES actividad.Actividad(id_actividad),
        CONSTRAINT FK_InscripcionActividad_Socio FOREIGN KEY (id_socio) REFERENCES persona.Socio(id_socio)
    );
END
GO

--===============
--TABLA INVITADO
--===============
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'actividad.Invitado') AND type = N'U')
BEGIN
    CREATE TABLE actividad.Invitado (
        id_invitado INT IDENTITY PRIMARY KEY,
        nombre NVARCHAR(100) NOT NULL,
        apellido NVARCHAR(100) NOT NULL
    );
END
GO

--==============
--TABLA PILETA 
--==============
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'actividad.Pileta') AND type = N'U')
BEGIN
    CREATE TABLE actividad.Pileta (
        id_pileta INT IDENTITY PRIMARY KEY,
        descuento_lluvia BIT NOT NULL,
        fecha_vigencia DATE NOT NULL,
        --tipo NVARCHAR(50) NOT NULL,--AHORA LO PONEMOS EN INSCRIPCION
        tarifa DECIMAL(10,2) NOT NULL,
        id_invitado INT NOT NULL,
        CONSTRAINT FK_Pileta_Invitado FOREIGN KEY (id_invitado) REFERENCES actividad.Invitado(id_invitado)
    );
END
GO

--========================
--TABLA INSCRIPCIONPILETA
--========================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'actividad.InscripcionPileta') AND type = N'U')
BEGIN
    CREATE TABLE actividad.InscripcionPileta (
        id_pileta INT NOT NULL,
        id_socio INT NOT NULL,
        fecha_inscripcion DATE NOT NULL,
		tipo_inscripcion NVARCHAR(100) NOT NULL,
		CONSTRAINT pk_inscripcionpileta PRIMARY KEY (id_pileta, id_socio),
        CONSTRAINT FK_InscripcionPileta_Pileta FOREIGN KEY (id_pileta) REFERENCES actividad.Pileta(id_pileta),
        CONSTRAINT FK_InscripcionPileta_Socio FOREIGN KEY (id_socio) REFERENCES persona.Socio(id_socio)
    );
END
GO

--==============
--TABLA SUM/Sums
--==============
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'actividad.Sums') AND type = N'U')
BEGIN
    CREATE TABLE actividad.Sums(
        id_sum INT IDENTITY PRIMARY KEY,
        fecha DATE NOT NULL,
        hora_inicio TIME NOT NULL,
        hora_fin TIME NOT NULL,
        tarifa DECIMAL(10,2) NOT NULL
    );
END
GO

--========================
--TABLA RESERVA(SUM/Sums)
--========================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'actividad.Reserva') AND type = N'U')
BEGIN
    CREATE TABLE actividad.Reserva (
        id_sum INT NOT NULL,
        id_socio INT NOT NULL,
        fecha_inscripcion DATE NOT NULL,
        CONSTRAINT pk_reserva PRIMARY KEY (id_sum, id_socio),
        CONSTRAINT FK_Reserva_Sum FOREIGN KEY (id_sum) REFERENCES actividad.Sums(id_sum),
        CONSTRAINT FK_Reserva_Socio FOREIGN KEY (id_socio) REFERENCES persona.Socio(id_socio)
    );
END
GO

--=======================
--TABLA DETALLEDEFACTURA
--=======================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'facturacion.DetalleFactura') AND type = N'U')
BEGIN
    CREATE TABLE facturacion.DetalleFactura (
        id_detalle INT IDENTITY PRIMARY KEY,
        descripcion NVARCHAR(255) NOT NULL,
        monto DECIMAL(10,2) NOT NULL,
        id_factura INT NOT NULL,
        id_actividad INT NULL,
        id_pileta INT NULL,--*id_pileta
        id_sum INT NULL,
        id_colonia INT NULL,
        CONSTRAINT FK_DetalleFactura_Factura FOREIGN KEY (id_factura) REFERENCES facturacion.Factura(id_factura),
        CONSTRAINT FK_DetalleFactura_Actividad FOREIGN KEY (id_actividad) REFERENCES actividad.Actividad(id_actividad),
        CONSTRAINT FK_DetalleFactura_Pileta FOREIGN KEY (id_pileta) REFERENCES actividad.Pileta(id_pileta),
        CONSTRAINT FK_DetalleFactura_Sums FOREIGN KEY (id_sum) REFERENCES actividad.Sums(id_sum),
        CONSTRAINT FK_DetalleFactura_Colonia FOREIGN KEY (id_colonia) REFERENCES actividad.Colonia(id_colonia)
    );
END
GO