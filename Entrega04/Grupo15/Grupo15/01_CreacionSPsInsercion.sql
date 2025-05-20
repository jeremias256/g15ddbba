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

-- Script para crear todos los Store Procedures en la base de datos SolNorte
-- Ejecutar en SSMS (no requiere modo SQLCMD)

USE Com2900G15;
GO

-- =====================
-- 1. SPs de usuarios
-- =====================
IF OBJECT_ID('usuarios.InsertarRol', 'P') IS NOT NULL DROP PROCEDURE usuarios.InsertarRol;
GO
CREATE PROCEDURE usuarios.InsertarRol
    @nombre NVARCHAR(50),
    @descripcion NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    -- Validar que el nombre sea único
    IF EXISTS (SELECT 1 FROM usuarios.Rol WHERE nombre = @nombre)
    BEGIN
        RAISERROR('El nombre del rol ya existe.', 16, 1);
        RETURN;
    END
    INSERT INTO usuarios.Rol (nombre, descripcion)
    VALUES (@nombre, @descripcion);
    SELECT SCOPE_IDENTITY() AS id_rol;
END;
GO

IF OBJECT_ID('usuarios.InsertarUsuario', 'P') IS NOT NULL DROP PROCEDURE usuarios.InsertarUsuario;
GO
CREATE PROCEDURE usuarios.InsertarUsuario
    @usuario NVARCHAR(50),
    @contraseña NVARCHAR(255),
    @fecha_vigencia_contraseña DATE,
    @id_rol INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que no exista un usuario con el mismo nombre
    IF EXISTS (SELECT 1 FROM usuarios.Usuario WHERE usuario = @usuario)
    BEGIN
        RAISERROR('Ya existe un usuario con ese nombre.', 16, 1);
        RETURN;
    END

    INSERT INTO usuarios.Usuario (usuario, contraseña, fecha_vigencia_contraseña, id_rol)
    VALUES (@usuario, @contraseña, @fecha_vigencia_contraseña, @id_rol);
    -- Retornar el id generado
    SELECT SCOPE_IDENTITY() AS id_usuario;
END;
GO

-- =====================
-- 2. SPs de socios
-- =====================
IF OBJECT_ID('socios.InsertarCategoriaSocio', 'P') IS NOT NULL DROP PROCEDURE socios.InsertarCategoriaSocio;
GO
CREATE PROCEDURE socios.InsertarCategoriaSocio
    @nombre NVARCHAR(100),
    @edad_min INT,
    @edad_max INT,
    @costo_membresia DECIMAL(10,2),
    @fecha_vigencia DATE,
    @resultado INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    -- Validaciones
    IF @edad_min < 0 OR @edad_max < 0 OR @edad_min > @edad_max
    BEGIN
        SET @resultado = -1; -- Edad inválida
        RETURN;
    END
    IF @costo_membresia < 0
    BEGIN
        SET @resultado = -2; -- Costo inválido
        RETURN;
    END
    -- Verificar unicidad del nombre
    IF EXISTS (SELECT 1 FROM socios.CategoriaSocio WHERE nombre = @nombre)
    BEGIN
        SET @resultado = -3; -- Nombre duplicado
        RETURN;
    END
    -- Inserción
    INSERT INTO socios.CategoriaSocio (nombre, edad_min, edad_max, costo_membresia, fecha_vigencia)
    VALUES (@nombre, @edad_min, @edad_max, @costo_membresia, @fecha_vigencia);
    SET @resultado = SCOPE_IDENTITY(); -- Devuelve el ID insertado
END;
GO

IF OBJECT_ID('socios.InsertarSocio', 'P') IS NOT NULL DROP PROCEDURE socios.InsertarSocio;
GO
CREATE PROCEDURE socios.InsertarSocio
    @numero_socio NVARCHAR(50),
    @id_usuario INT = NULL,
    @nombre NVARCHAR(100),
    @apellido NVARCHAR(100),
    @dni NVARCHAR(20),
    @email NVARCHAR(100),
    @fecha_nacimiento DATE,
    @telefono NVARCHAR(20) = NULL,
    @telefono_emergencia NVARCHAR(20) = NULL,
    @obra_social NVARCHAR(100) = NULL,
    @nro_obra_social NVARCHAR(50) = NULL,
    @tel_emergencia_obra_social NVARCHAR(20) = NULL,
    @id_categoria INT,
    @responsable_id INT = NULL,
    @Estado BIT
AS
BEGIN
    SET NOCOUNT ON;
    -- Validar que número socio sea único
    IF EXISTS (SELECT 1 FROM socios.Socio WHERE numero_socio = @numero_socio)
    BEGIN
        RAISERROR('El numero_socio ya existe.', 16, 1);
        RETURN;
    END
    -- Validar que no sean ambos NULL
    IF (@id_usuario IS NULL AND @responsable_id IS NULL)
    BEGIN
        RAISERROR('Error: id_usuario y responsable_id no pueden ser ambos NULL.', 16, 1);
        RETURN;
    END
    -- Validar que no sean ambos NO NULL
    IF (@id_usuario IS NOT NULL AND @responsable_id IS NOT NULL)
    BEGIN
        RAISERROR('Error: id_usuario y responsable_id no pueden ser ambos con valor.', 16, 1);
        RETURN;
    END
    -- Insertar el nuevo socio
    INSERT INTO socios.Socio 
        (numero_socio, id_usuario, nombre, apellido, dni, email, fecha_nacimiento, telefono, telefono_emergencia,
         obra_social, nro_obra_social, tel_emergencia_obra_social, id_categoria, responsable_id, Estado)
    VALUES
        (@numero_socio, @id_usuario, @nombre, @apellido, @dni, @email, @fecha_nacimiento, @telefono, @telefono_emergencia,
         @obra_social, @nro_obra_social, @tel_emergencia_obra_social, @id_categoria, @responsable_id, @Estado);
    SELECT SCOPE_IDENTITY() AS id_socio;
END;
GO

IF OBJECT_ID('socios.InsertarEmpleado', 'P') IS NOT NULL DROP PROCEDURE socios.InsertarEmpleado;
GO
CREATE PROCEDURE socios.InsertarEmpleado
    @id_usuario INT,
    @nombre NVARCHAR(100),
    @apellido NVARCHAR(100),
    @dni NVARCHAR(20),
    @email NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO socios.Empleado (id_usuario, nombre, apellido, dni, email)
    VALUES (@id_usuario, @nombre, @apellido, @dni, @email);
    SELECT SCOPE_IDENTITY() AS id_empleado;
END;
GO

-- =====================
-- 3. SPs de actividades
-- =====================
IF OBJECT_ID('actividades.InsertarActividad', 'P') IS NOT NULL DROP PROCEDURE actividades.InsertarActividad;
GO
CREATE PROCEDURE actividades.InsertarActividad
    @nombre NVARCHAR(100),
    @costo_mensual DECIMAL(10,2),
    @fecha_vigencia DATE,
    @resultado INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Validar que no exista una actividad con el mismo nombre
        IF EXISTS (
            SELECT 1 FROM actividades.Actividad
            WHERE nombre = @nombre
        )
        BEGIN
            SET @resultado = -1; -- Ya existe
            RETURN;
        END;
        INSERT INTO actividades.Actividad (nombre, costo_mensual)
        VALUES (@nombre, @costo_mensual);
        SET @resultado = SCOPE_IDENTITY(); -- Retornar ID generado
    END TRY
    BEGIN CATCH
        SET @resultado = -2; -- Error general
    END CATCH
END;
GO

IF OBJECT_ID('actividades.InsertarClase', 'P') IS NOT NULL DROP PROCEDURE actividades.InsertarClase;
GO
CREATE PROCEDURE actividades.InsertarClase
    @id_actividad INT,
    @id_categoria INT,
    @dia_semana NVARCHAR(20),
    @hora_inicio TIME,
    @hora_fin TIME
AS
BEGIN
    SET NOCOUNT ON;
    -- Validar que hora_fin sea mayor que hora_inicio
    IF @hora_fin <= @hora_inicio
    BEGIN
        RAISERROR('La hora_fin debe ser mayor que la hora_inicio.', 16, 1);
        RETURN;
    END
    -- Validar que la actividad exista
    IF NOT EXISTS (SELECT 1 FROM actividades.Actividad WHERE id_actividad = @id_actividad)
    BEGIN
        RAISERROR('La actividad especificada no existe.', 16, 1);
        RETURN;
    END
    -- Validar que la categoria exista
    IF NOT EXISTS (SELECT 1 FROM socios.CategoriaSocio WHERE id_categoria = @id_categoria)
    BEGIN
        RAISERROR('La categoría de socio especificada no existe.', 16, 1);
        RETURN;
    END
    -- Insertar la nueva clase
    INSERT INTO actividades.Clase (id_actividad, id_categoria, dia_semana, hora_inicio, hora_fin)
    VALUES (@id_actividad, @id_categoria, @dia_semana, @hora_inicio, @hora_fin);
    -- Retornar el id generado
    SELECT SCOPE_IDENTITY() AS id_clase;
END
GO

IF OBJECT_ID('actividades.InscribirSocioEnActividad', 'P') IS NOT NULL DROP PROCEDURE actividades.InscribirSocioEnActividad;
GO
CREATE PROCEDURE actividades.InscribirSocioEnActividad
    @id_socio INT,
    @id_actividad INT,
    @id_clase INT,
    @fecha_inicio DATE,
    @fecha_fin DATE = NULL,  -- Opcional
    @descuento DECIMAL(10,2) = NULL  -- Opcional
AS
BEGIN
    SET NOCOUNT ON;
    -- Validar que el socio exista
    IF NOT EXISTS (SELECT 1 FROM socios.Socio WHERE id_socio = @id_socio)
    BEGIN
        RAISERROR('El socio especificado no existe.', 16, 1);
        RETURN;
    END
    -- Validar que la actividad exista
    IF NOT EXISTS (SELECT 1 FROM actividades.Actividad WHERE id_actividad = @id_actividad)
    BEGIN
        RAISERROR('La actividad especificada no existe.', 16, 1);
        RETURN;
    END
    -- Validar que la clase exista y coincida con actividad
    IF NOT EXISTS (
        SELECT 1 FROM actividades.Clase
        WHERE id_clase = @id_clase AND id_actividad = @id_actividad
    )
    BEGIN
        RAISERROR('La clase especificada no existe o no pertenece a la actividad.', 16, 1);
        RETURN;
    END
    -- Insertar inscripción
    INSERT INTO actividades.SocioActividad
        (id_socio, id_actividad, id_clase, fecha_inicio, fecha_fin, descuento)
    VALUES
        (@id_socio, @id_actividad, @id_clase, @fecha_inicio, @fecha_fin, @descuento);
END
GO

-- =====================
-- 4. SPs de facturación
-- =====================
IF OBJECT_ID('facturacion.InsertarFactura', 'P') IS NOT NULL DROP PROCEDURE facturacion.InsertarFactura;
GO
CREATE PROCEDURE facturacion.InsertarFactura
    @id_socio INT,
    @fecha DATE,
    @monto_total DECIMAL(10,2),
    @estado NVARCHAR(50),
    @fecha_vencimiento DATE,
    @fecha_segundo_vencimiento DATE = NULL,
    @recargo DECIMAL(10,2) = NULL,
    @pagador NVARCHAR(100) = NULL,
    @tipo NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        -- Validar existencia del socio
        IF NOT EXISTS (SELECT 1 FROM socios.Socio WHERE id_socio = @id_socio)
        BEGIN
            RAISERROR('El socio con ID %d no existe.', 16, 1, @id_socio);
            ROLLBACK TRANSACTION;
            RETURN;
        END;
        -- Validar que la fecha de vencimiento sea posterior a la fecha
        IF @fecha_vencimiento <= @fecha
        BEGIN
            RAISERROR('La fecha de vencimiento debe ser posterior a la fecha de emisión.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;
        -- Insertar la factura
        INSERT INTO facturacion.Factura (
            fecha, id_socio, monto_total, estado,
            fecha_vencimiento, fecha_segundo_vencimiento,
            recargo, pagador, tipo
        )
        VALUES (
            @fecha, @id_socio, @monto_total, @estado,
            @fecha_vencimiento, @fecha_segundo_vencimiento,
            @recargo, @pagador, @tipo
        );
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH
END;
GO

IF OBJECT_ID('facturacion.InsertarDetalleFactura', 'P') IS NOT NULL DROP PROCEDURE facturacion.InsertarDetalleFactura;
GO
CREATE PROCEDURE facturacion.InsertarDetalleFactura
    @id_factura INT,
    @descripcion NVARCHAR(255),
    @monto DECIMAL(10,2),
    @id_actividad INT = NULL,
    @id_pase_pileta INT = NULL,
    @id_reservaSUM INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Validar existencia de factura
        IF NOT EXISTS (
            SELECT 1 FROM facturacion.Factura WHERE id_factura = @id_factura
        )
        BEGIN
            RAISERROR('La factura con ID %d no existe.', 16, 1, @id_factura);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Validar existencia de actividad (si se pasa)
        IF @id_actividad IS NOT NULL AND NOT EXISTS (
            SELECT 1 FROM actividades.Actividad WHERE id_actividad = @id_actividad
        )
        BEGIN
            RAISERROR('La actividad con ID %d no existe.', 16, 1, @id_actividad);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Validar existencia de pase de pileta (si se pasa)
        IF @id_pase_pileta IS NOT NULL AND NOT EXISTS (
            SELECT 1 FROM pileta.PasePileta WHERE id_pase = @id_pase_pileta
        )
        BEGIN
            RAISERROR('El pase de pileta con ID %d no existe.', 16, 1, @id_pase_pileta);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Validar existencia de reserva de SUM (si se pasa)
        IF @id_reservaSUM IS NOT NULL AND NOT EXISTS (
            SELECT 1 FROM pileta.ReservaSUM WHERE id_reserva = @id_reservaSUM
        )
        BEGIN
            RAISERROR('La reserva SUM con ID %d no existe.', 16, 1, @id_reservaSUM);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Insertar detalle
        INSERT INTO facturacion.DetalleFactura (
            id_factura, descripcion, monto, id_actividad, id_pase_pileta, id_reservaSUM
        )
        VALUES (
            @id_factura, @descripcion, @monto, @id_actividad, @id_pase_pileta, @id_reservaSUM
        );
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH
END;
GO

IF OBJECT_ID('facturacion.InsertarMedioPago', 'P') IS NOT NULL DROP PROCEDURE facturacion.InsertarMedioPago;
GO
CREATE PROCEDURE facturacion.InsertarMedioPago
    @nombre NVARCHAR(100),
    @permite_debito BIT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        INSERT INTO facturacion.MedioPago (nombre, permite_debito)
        VALUES (@nombre, @permite_debito);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

IF OBJECT_ID('facturacion.InsertarPago', 'P') IS NOT NULL DROP PROCEDURE facturacion.InsertarPago;
GO
CREATE PROCEDURE facturacion.InsertarPago
    @id_factura INT,
    @id_detalle INT = NULL,
    @id_medio INT = NULL,
    @fecha_pago DATE,
    @monto DECIMAL(10,2),
    @tipo NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Validar que la factura exista
        IF NOT EXISTS (SELECT 1 FROM facturacion.Factura WHERE id_factura = @id_factura)
        BEGIN
            RAISERROR('La factura especificada no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Validar que el detalle exista
        IF NOT EXISTS (SELECT 1 FROM facturacion.DetalleFactura WHERE id_detalle = @id_detalle)
        BEGIN
            RAISERROR('El detalle de factura especificado no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Validar que el medio de pago exista
        IF NOT EXISTS (SELECT 1 FROM facturacion.MedioPago WHERE id_medio = @id_medio)
        BEGIN
            RAISERROR('El medio de pago especificado no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Insertar en Pago
        INSERT INTO facturacion.Pago (
            id_factura,
            id_detalle,
            id_medio,
            fecha_pago,
            monto,
            tipo
        )
        VALUES (
            @id_factura,
            @id_detalle,
            @id_medio,
            @fecha_pago,
            @monto,
            @tipo
        );
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH
END;
GO

IF OBJECT_ID('facturacion.InsertarActualizarSaldoAFavor', 'P') IS NOT NULL DROP PROCEDURE facturacion.InsertarActualizarSaldoAFavor;
GO
CREATE PROCEDURE facturacion.InsertarActualizarSaldoAFavor
    @id_socio INT,
    @monto DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Validar que el socio exista
        IF NOT EXISTS (SELECT 1 FROM socios.Socio WHERE id_socio = @id_socio)
        BEGIN
            RAISERROR('El socio especificado no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Verificar si ya existe saldo a favor para el socio
        IF EXISTS (SELECT 1 FROM facturacion.SaldoAFavor WHERE id_socio = @id_socio)
        BEGIN
            -- Actualizar monto sumando al existente
            UPDATE facturacion.SaldoAFavor
            SET monto = monto + @monto
            WHERE id_socio = @id_socio;
        END
        ELSE
        BEGIN
            -- Insertar nuevo saldo a favor
            INSERT INTO facturacion.SaldoAFavor (id_socio, monto)
            VALUES (@id_socio, @monto);
        END
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

-- =====================
-- 5. SPs de pileta
-- =====================
IF OBJECT_ID('pileta.InsertarColonia', 'P') IS NOT NULL DROP PROCEDURE pileta.InsertarColonia;
GO
CREATE PROCEDURE pileta.InsertarColonia
    @nombre NVARCHAR(100),
    @monto DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Validar que el nombre no esté vacío
        IF LEN(LTRIM(RTRIM(@nombre))) = 0
        BEGIN
            RAISERROR('El nombre de la colonia no puede estar vacío.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Insertar en Colonia
        INSERT INTO colonia.Colonia (
            nombre,
            monto
        )
        VALUES (
            @nombre,
            @monto
        );
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

IF OBJECT_ID('pileta.InsertarInscripcionColonia', 'P') IS NOT NULL DROP PROCEDURE pileta.InsertarInscripcionColonia;
GO
CREATE PROCEDURE pileta.InsertarInscripcionColonia
    @id_colonia INT,
    @id_socio INT,
    @fecha_inscripcion DATE
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Validar que la colonia exista
        IF NOT EXISTS (SELECT 1 FROM pileta.ColoniaVerano WHERE id_colonia = @id_colonia)
        BEGIN
            RAISERROR('La colonia especificada no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Validar que el socio exista
        IF NOT EXISTS (SELECT 1 FROM socios.Socio WHERE id_socio = @id_socio)
        BEGIN
            RAISERROR('El socio especificado no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Validar que la inscripción no exista (PK compuesta)
        IF EXISTS (SELECT 1 FROM pileta.InscripcionColonia WHERE id_colonia = @id_colonia AND id_socio = @id_socio)
        BEGIN
            RAISERROR('La inscripción ya existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Insertar inscripción
        INSERT INTO pileta.InscripcionColonia (
            id_colonia,
            id_socio,
            fecha_inscripcion
        )
        VALUES (
            @id_colonia,
            @id_socio,
            @fecha_inscripcion
        );
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

IF OBJECT_ID('pileta.InsertarInvitado', 'P') IS NOT NULL DROP PROCEDURE pileta.InsertarInvitado;
GO
CREATE PROCEDURE pileta.InsertarInvitado
    @nombre NVARCHAR(100),
    @apellido NVARCHAR(100),
    @dni CHAR(8),
    @id_socio_invitante INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Validar existencia del socio
        IF NOT EXISTS (
            SELECT 1 FROM socios.Socio WHERE id_socio = @id_socio_invitante
        )
        BEGIN
            RAISERROR('El socio con ID %d no existe.', 16, 1, @id_socio_invitante);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Insertar invitado
        INSERT INTO pileta.Invitado (
            nombre,
            apellido,
            dni,
            id_socio_invitante
        )
        VALUES (
            @nombre,
            @apellido,
            @dni,
            @id_socio_invitante
        );
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

IF OBJECT_ID('pileta.InsertarPasePileta', 'P') IS NOT NULL DROP PROCEDURE pileta.InsertarPasePileta;
GO
CREATE PROCEDURE pileta.InsertarPasePileta
    @id_socio INT,
    @fecha DATE,
    @tarifa DECIMAL(10, 2),
    @tipo NVARCHAR(50),
    @id_invitado INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Validar existencia del socio
        IF NOT EXISTS (
            SELECT 1 FROM socios.Socio WHERE id_socio = @id_socio
        )
        BEGIN
            RAISERROR('El socio con ID %d no existe.', 16, 1, @id_socio);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Validar existencia del invitado (si se proporciona)
        IF @id_invitado IS NOT NULL AND NOT EXISTS (
            SELECT 1 FROM pileta.Invitado WHERE id_invitado = @id_invitado
        )
        BEGIN
            RAISERROR('El invitado con ID %d no existe.', 16, 1, @id_invitado);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Insertar pase pileta
        INSERT INTO pileta.PasePileta (
            id_socio,
            fecha,
            tarifa,
            tipo,
            id_invitado
        )
        VALUES (
            @id_socio,
            @fecha,
            @tarifa,
            @tipo,
            @id_invitado
        );
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

IF OBJECT_ID('pileta.InsertarReservaSUM', 'P') IS NOT NULL DROP PROCEDURE pileta.InsertarReservaSUM;
GO
CREATE PROCEDURE pileta.InsertarReservaSUM
    @id_socio INT,
    @fecha DATE,
    @hora_inicio TIME,
    @hora_fin TIME,
    @monto DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Validar existencia del socio
        IF NOT EXISTS (
            SELECT 1 FROM socios.Socio WHERE id_socio = @id_socio
        )
        BEGIN
            RAISERROR('El socio con ID %d no existe.', 16, 1, @id_socio);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Validar que la hora de inicio sea menor que la hora de fin
        IF @hora_inicio >= @hora_fin
        BEGIN
            RAISERROR('La hora de inicio debe ser menor que la hora de fin.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Insertar reserva SUM
        INSERT INTO sum.ReservaSUM (
            id_socio,
            fecha,
            hora_inicio,
            hora_fin,
            monto
        )
        VALUES (
            @id_socio,
            @fecha,
            @hora_inicio,
            @hora_fin,
            @monto
        );
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO
