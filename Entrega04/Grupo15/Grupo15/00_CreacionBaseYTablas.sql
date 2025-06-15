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
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'socios') EXEC('CREATE SCHEMA socios');
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'usuarios') EXEC('CREATE SCHEMA usuarios');
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'actividades') EXEC('CREATE SCHEMA actividades');
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'facturacion') EXEC('CREATE SCHEMA facturacion');
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'pileta') EXEC('CREATE SCHEMA pileta');
GO

-- 1. Crear tablas sin dependencias (Roles, CategoriaSocio)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'usuarios.Rol') AND type in (N'U'))
BEGIN
    CREATE TABLE usuarios.Rol (
        id_rol INT IDENTITY PRIMARY KEY,
        nombre NVARCHAR(100) NOT NULL,
        descripcion NVARCHAR(255) NULL
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'socios.CategoriaSocio') AND type in (N'U'))
BEGIN
    CREATE TABLE socios.CategoriaSocio (
        id_categoria INT IDENTITY PRIMARY KEY,
        nombre NVARCHAR(100) NOT NULL,
        edad_min INT NOT NULL,
        edad_max INT NOT NULL,
        costo_membresia DECIMAL(10,2) NOT NULL,
        fecha_vigencia DATE NOT NULL
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'actividades.Actividad') AND type in (N'U'))
BEGIN
    CREATE TABLE actividades.Actividad (
        id_actividad INT IDENTITY PRIMARY KEY,
        nombre NVARCHAR(100) NOT NULL,
        costo_mensual DECIMAL(10,2) NOT NULL
    );
END
GO

-- 2. Crear tablas que referencian las anteriores

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'usuarios.Usuario') AND type in (N'U'))
BEGIN
    CREATE TABLE usuarios.Usuario (
        id_usuario INT IDENTITY PRIMARY KEY,
        usuario NVARCHAR(50) NOT NULL,
        contraseña NVARCHAR(255) NOT NULL,
        fecha_vigencia_contraseña DATE NOT NULL,
        id_rol INT NOT NULL,
        CONSTRAINT FK_Usuario_Rol FOREIGN KEY (id_rol) REFERENCES usuarios.Rol(id_rol)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'socios.Socio') AND type in (N'U'))
BEGIN
    CREATE TABLE socios.Socio (
        id_socio INT IDENTITY PRIMARY KEY,
        numero_socio NVARCHAR(50) NOT NULL UNIQUE,
        id_usuario INT NULL,
        nombre NVARCHAR(100) NOT NULL,
        apellido NVARCHAR(100) NOT NULL,
        dni NVARCHAR(20) NOT NULL,
        email NVARCHAR(100) NOT NULL,
        fecha_nacimiento DATE NOT NULL,
        telefono NVARCHAR(20) NULL,
        telefono_emergencia NVARCHAR(20) NULL,
        obra_social NVARCHAR(100) NULL,
        nro_obra_social NVARCHAR(50) NULL,
        tel_emergencia_obra_social NVARCHAR(20) NULL,
        id_categoria INT NOT NULL,
        responsable_id INT NULL,
        Estado BIT NOT NULL,
        CONSTRAINT FK_Socio_Usuario FOREIGN KEY (id_usuario) REFERENCES usuarios.Usuario(id_usuario),
        CONSTRAINT FK_Socio_CategoriaSocio FOREIGN KEY (id_categoria) REFERENCES socios.CategoriaSocio(id_categoria),
        CONSTRAINT FK_Socio_Responsable FOREIGN KEY (responsable_id) REFERENCES socios.Socio(id_socio)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'socios.Empleado') AND type in (N'U'))
BEGIN
    CREATE TABLE socios.Empleado (
        id_empleado INT IDENTITY PRIMARY KEY,
        id_usuario INT NOT NULL,
        nombre NVARCHAR(100) NOT NULL,
        apellido NVARCHAR(100) NOT NULL,
        dni NVARCHAR(20) NOT NULL,
        email NVARCHAR(100) NOT NULL,
        CONSTRAINT FK_Empleado_Usuario FOREIGN KEY (id_usuario) REFERENCES usuarios.Usuario(id_usuario)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'actividades.Clase') AND type in (N'U'))
BEGIN
    CREATE TABLE actividades.Clase (
        id_clase INT IDENTITY PRIMARY KEY,
        id_actividad INT NOT NULL,
        id_categoria INT NOT NULL,
        dia_semana NVARCHAR(20) NOT NULL,
        hora_inicio TIME NOT NULL,
        hora_fin TIME NOT NULL,
        CONSTRAINT FK_Clase_Actividad FOREIGN KEY (id_actividad) REFERENCES actividades.Actividad(id_actividad),
        CONSTRAINT FK_Clase_CategoriaSocio FOREIGN KEY (id_categoria) REFERENCES socios.CategoriaSocio(id_categoria)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'actividades.SocioActividad') AND type in (N'U'))
BEGIN
    CREATE TABLE actividades.SocioActividad (
        id_socio INT NOT NULL,
        id_actividad INT NOT NULL,
        id_clase INT NOT NULL,
        fecha_inicio DATE NOT NULL,
        fecha_fin DATE NULL,
        descuento DECIMAL(10,2) NULL,
        PRIMARY KEY (id_socio, id_actividad, id_clase),
        CONSTRAINT FK_SocioActividad_Socio FOREIGN KEY (id_socio) REFERENCES socios.Socio(id_socio),
        CONSTRAINT FK_SocioActividad_Actividad FOREIGN KEY (id_actividad) REFERENCES actividades.Actividad(id_actividad),
        CONSTRAINT FK_SocioActividad_Clase FOREIGN KEY (id_clase) REFERENCES actividades.Clase(id_clase)
    );
END
GO

-- 4. Esquema pileta (depende de Socio)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'pileta.Invitado') AND type in (N'U'))
BEGIN
    CREATE TABLE pileta.Invitado (
        id_invitado INT IDENTITY PRIMARY KEY,
        nombre NVARCHAR(100) NOT NULL,
        apellido NVARCHAR(100) NOT NULL,
        dni NVARCHAR(20) NOT NULL,
        id_socio_invitante INT NOT NULL,
        CONSTRAINT FK_Invitado_Socio FOREIGN KEY (id_socio_invitante) REFERENCES socios.Socio(id_socio)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'pileta.PasePileta') AND type in (N'U'))
BEGIN
    CREATE TABLE pileta.PasePileta (
        id_pase INT IDENTITY PRIMARY KEY,
        id_socio INT NOT NULL,
        id_invitado INT NULL,
        fecha DATE NOT NULL,
        tipo NVARCHAR(50) NULL,
        tarifa DECIMAL(10,2) NULL,
        lluvia BIT NOT NULL,
        CONSTRAINT FK_PasePileta_Socio FOREIGN KEY (id_socio) REFERENCES socios.Socio(id_socio),
        CONSTRAINT FK_PasePileta_Invitado FOREIGN KEY (id_invitado) REFERENCES pileta.Invitado(id_invitado)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'pileta.ReservaSUM') AND type in (N'U'))
BEGIN
    CREATE TABLE pileta.ReservaSUM (
        id_reserva INT IDENTITY PRIMARY KEY,
        id_socio INT NOT NULL,
        fecha DATE NOT NULL,
        hora_inicio TIME NOT NULL,
        hora_fin TIME NOT NULL,
        monto DECIMAL(10,2) NOT NULL,
        CONSTRAINT FK_ReservaSUM_Socio FOREIGN KEY (id_socio) REFERENCES socios.Socio(id_socio)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'pileta.ColoniaVerano') AND type in (N'U'))
BEGIN
    CREATE TABLE pileta.ColoniaVerano (
        id_colonia INT IDENTITY PRIMARY KEY,
        nombre NVARCHAR(100) NOT NULL,
        fecha_inicio DATE NOT NULL,
        fecha_fin DATE NOT NULL,
        costo DECIMAL(10,2) NOT NULL
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'pileta.InscripcionColonia') AND type in (N'U'))
BEGIN
    CREATE TABLE pileta.InscripcionColonia (
        id_colonia INT NOT NULL,
        id_socio INT NOT NULL,
        fecha_inscripcion DATE NOT NULL,
        PRIMARY KEY (id_colonia, id_socio),
        CONSTRAINT FK_InscripcionColonia_Colonia FOREIGN KEY (id_colonia) REFERENCES pileta.ColoniaVerano(id_colonia),
        CONSTRAINT FK_InscripcionColonia_Socio FOREIGN KEY (id_socio) REFERENCES socios.Socio(id_socio)
    );
END
GO

-- 3. Facturacion (depende de Socio)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'facturacion.Factura') AND type in (N'U'))
BEGIN
    CREATE TABLE facturacion.Factura (
        id_factura INT IDENTITY PRIMARY KEY,
        fecha DATE NOT NULL,
        id_socio INT NOT NULL,
        monto_total DECIMAL(10,2) NOT NULL,
        estado NVARCHAR(50) NOT NULL,
        fecha_vencimiento DATE NOT NULL,
        fecha_segundo_vencimiento DATE NULL,
        recargo DECIMAL(10,2) NULL,
        pagador NVARCHAR(100) NULL,
        tipo NVARCHAR(50) NULL,
        CONSTRAINT FK_Factura_Socio FOREIGN KEY (id_socio) REFERENCES socios.Socio(id_socio)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'facturacion.DetalleFactura') AND type in (N'U'))
BEGIN
    CREATE TABLE facturacion.DetalleFactura (
        id_detalle INT IDENTITY PRIMARY KEY,
        id_factura INT NOT NULL,
        descripcion NVARCHAR(255) NOT NULL,
        monto DECIMAL(10,2) NOT NULL,
        id_actividad INT NULL,
        id_pase_pileta INT NULL,
        id_reservaSUM INT NULL,
        CONSTRAINT FK_DetalleFactura_Factura FOREIGN KEY (id_factura) REFERENCES facturacion.Factura(id_factura),
        CONSTRAINT FK_DetalleFactura_Actividad FOREIGN KEY (id_actividad) REFERENCES actividades.Actividad(id_actividad),
        CONSTRAINT FK_DetalleFactura_PasePileta FOREIGN KEY (id_pase_pileta) REFERENCES pileta.PasePileta(id_pase),
        CONSTRAINT FK_DetalleFactura_ReservaSUM FOREIGN KEY (id_reservaSUM) REFERENCES pileta.ReservaSUM(id_reserva)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'facturacion.MedioPago') AND type in (N'U'))
BEGIN
    CREATE TABLE facturacion.MedioPago (
        id_medio INT IDENTITY PRIMARY KEY,
        nombre NVARCHAR(100) NOT NULL,
        permite_debito BIT NOT NULL
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'facturacion.Pago') AND type in (N'U'))
BEGIN
    CREATE TABLE facturacion.Pago (
        id_pago INT IDENTITY PRIMARY KEY,
        id_factura INT NOT NULL,
        id_detalle INT NOT NULL,
        fecha_pago DATE NOT NULL,
        id_medio INT NOT NULL,
        monto DECIMAL(10,2) NOT NULL,
        tipo NVARCHAR(50) NULL,
        CONSTRAINT FK_Pago_Factura FOREIGN KEY (id_factura) REFERENCES facturacion.Factura(id_factura),
        CONSTRAINT FK_Pago_DetalleFactura FOREIGN KEY (id_detalle) REFERENCES facturacion.DetalleFactura(id_detalle),
        CONSTRAINT FK_Pago_MedioPago FOREIGN KEY (id_medio) REFERENCES facturacion.MedioPago(id_medio)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'facturacion.SaldoAFavor') AND type in (N'U'))
BEGIN
    CREATE TABLE facturacion.SaldoAFavor (
        id_socio INT PRIMARY KEY,
        monto DECIMAL(10,2) NOT NULL,
        CONSTRAINT FK_SaldoAFavor_Socio FOREIGN KEY (id_socio) REFERENCES socios.Socio(id_socio)
    );
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'usuarios.Inscripcion') AND type in (N'U'))
BEGIN
    CREATE TABLE usuarios.Inscripcion (
        id_inscripcion INT IDENTITY PRIMARY KEY,
        id_usuario INT,
        id_socio INT,
		CONSTRAINT FK_Incripcion_Usuario FOREIGN KEY (id_usuario) REFERENCES usuarios.usuario(id_usuario),
		CONSTRAINT FK_Inscripcion_Socio FOREIGN KEY (id_socio) REFERENCES socios.socio (id_socio)
    );
END
GO