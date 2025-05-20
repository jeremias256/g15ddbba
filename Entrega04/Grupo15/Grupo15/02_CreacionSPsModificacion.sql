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

USE Com2900G15
Go
-- =============================================
-- BLOQUE: USUARIOS
-- =============================================
IF OBJECT_ID('usuarios.ModificarUsuario', 'P') IS NOT NULL DROP PROCEDURE usuarios.ModificarUsuario;
GO
CREATE PROCEDURE usuarios.ModificarUsuario
    @id_usuario INT,
    @usuario NVARCHAR(50),
    @contraseña NVARCHAR(255),
    @fecha_vigencia_contraseña DATE,
    @id_rol INT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM usuarios.Usuario WHERE id_usuario = @id_usuario)
    BEGIN
        RAISERROR('No existe el usuario especificado.', 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM usuarios.Usuario WHERE usuario = @usuario AND id_usuario <> @id_usuario)
    BEGIN
        RAISERROR('Ya existe un usuario con ese nombre.', 16, 1);
        RETURN;
    END
    UPDATE usuarios.Usuario
    SET usuario = @usuario,
        contraseña = @contraseña,
        fecha_vigencia_contraseña = @fecha_vigencia_contraseña,
        id_rol = @id_rol
    WHERE id_usuario = @id_usuario;
    SELECT @id_usuario AS id_usuario;
END;
GO

IF OBJECT_ID('usuarios.ModificarRol', 'P') IS NOT NULL DROP PROCEDURE usuarios.ModificarRol;
GO
CREATE PROCEDURE usuarios.ModificarRol
    @id_rol INT,
    @nombre NVARCHAR(50),
    @descripcion NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM usuarios.Rol WHERE id_rol = @id_rol)
    BEGIN
        RAISERROR('No existe el rol especificado.', 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM usuarios.Rol WHERE nombre = @nombre AND id_rol <> @id_rol)
    BEGIN
        RAISERROR('El nombre del rol ya existe.', 16, 1);
        RETURN;
    END
    UPDATE usuarios.Rol
    SET nombre = @nombre,
        descripcion = @descripcion
    WHERE id_rol = @id_rol;
    SELECT @id_rol AS id_rol;
END;
GO

-- =============================================
-- BLOQUE: SOCIOS
-- =============================================
IF OBJECT_ID('socios.ModificarSocio', 'P') IS NOT NULL DROP PROCEDURE socios.ModificarSocio;
GO
CREATE PROCEDURE socios.ModificarSocio
    @id_socio INT,
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
    IF NOT EXISTS (SELECT 1 FROM socios.Socio WHERE id_socio = @id_socio)
    BEGIN
        RAISERROR('No existe el socio especificado.', 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM socios.Socio WHERE numero_socio = @numero_socio AND id_socio <> @id_socio)
    BEGIN
        RAISERROR('El numero_socio ya existe.', 16, 1);
        RETURN;
    END
    UPDATE socios.Socio
    SET numero_socio = @numero_socio,
        id_usuario = @id_usuario,
        nombre = @nombre,
        apellido = @apellido,
        dni = @dni,
        email = @email,
        fecha_nacimiento = @fecha_nacimiento,
        telefono = @telefono,
        telefono_emergencia = @telefono_emergencia,
        obra_social = @obra_social,
        nro_obra_social = @nro_obra_social,
        tel_emergencia_obra_social = @tel_emergencia_obra_social,
        id_categoria = @id_categoria,
        responsable_id = @responsable_id,
        Estado = @Estado
    WHERE id_socio = @id_socio;
    SELECT @id_socio AS id_socio;
END;
GO

IF OBJECT_ID('socios.ModificarEmpleado', 'P') IS NOT NULL DROP PROCEDURE socios.ModificarEmpleado;
GO
CREATE PROCEDURE socios.ModificarEmpleado
    @id_empleado INT,
    @id_usuario INT,
    @nombre NVARCHAR(100),
    @apellido NVARCHAR(100),
    @dni NVARCHAR(20),
    @email NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM socios.Empleado WHERE id_empleado = @id_empleado)
    BEGIN
        RAISERROR('No existe el empleado especificado.', 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM socios.Empleado WHERE id_usuario = @id_usuario AND id_empleado <> @id_empleado)
    BEGIN
        RAISERROR('Ya existe un empleado con ese id_usuario.', 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM socios.Empleado WHERE dni = @dni AND id_empleado <> @id_empleado)
    BEGIN
        RAISERROR('Ya existe un empleado con ese DNI.', 16, 1);
        RETURN;
    END
    UPDATE socios.Empleado
    SET id_usuario = @id_usuario,
        nombre = @nombre,
        apellido = @apellido,
        dni = @dni,
        email = @email
    WHERE id_empleado = @id_empleado;
    SELECT @id_empleado AS id_empleado;
END;
GO

IF OBJECT_ID('socios.ModificarCategoriaSocio', 'P') IS NOT NULL DROP PROCEDURE socios.ModificarCategoriaSocio;
GO
CREATE PROCEDURE socios.ModificarCategoriaSocio
    @id_categoria INT,
    @nombre NVARCHAR(100),
    @edad_min INT,
    @edad_max INT,
    @costo_membresia DECIMAL(10,2),
    @fecha_vigencia DATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM socios.CategoriaSocio WHERE id_categoria = @id_categoria)
    BEGIN
        RAISERROR('No existe la categoría especificada.', 16, 1);
        RETURN;
    END
    IF @edad_min < 0 OR @edad_max < 0 OR @edad_min > @edad_max
    BEGIN
        RAISERROR('Rango de edad inválido.', 16, 1);
        RETURN;
    END
    IF @costo_membresia < 0
    BEGIN
        RAISERROR('Costo inválido.', 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM socios.CategoriaSocio WHERE nombre = @nombre AND id_categoria <> @id_categoria)
    BEGIN
        RAISERROR('Nombre de categoría duplicado.', 16, 1);
        RETURN;
    END
    UPDATE socios.CategoriaSocio
    SET nombre = @nombre,
        edad_min = @edad_min,
        edad_max = @edad_max,
        costo_membresia = @costo_membresia,
        fecha_vigencia = @fecha_vigencia
    WHERE id_categoria = @id_categoria;
    SELECT @id_categoria AS id_categoria;
END;
GO

-- =============================================
-- BLOQUE: PILETA
-- =============================================
IF OBJECT_ID('pileta.ModificarColonia', 'P') IS NOT NULL DROP PROCEDURE pileta.ModificarColonia;
GO
CREATE PROCEDURE pileta.ModificarColonia
    @id_colonia INT,
    @nombre NVARCHAR(100),
    @monto DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM pileta.Colonia WHERE id_colonia = @id_colonia)
    BEGIN
        RAISERROR('No existe la colonia especificada.', 16, 1);
        RETURN;
    END
    IF LEN(LTRIM(RTRIM(@nombre))) = 0
    BEGIN
        RAISERROR('El nombre de la colonia no puede estar vacío.', 16, 1);
        RETURN;
    END
    UPDATE pileta.Colonia
    SET nombre = @nombre,
        monto = @monto
    WHERE id_colonia = @id_colonia;
    SELECT @id_colonia AS id_colonia;
END;
GO

IF OBJECT_ID('pileta.ModificarInvitado', 'P') IS NOT NULL DROP PROCEDURE pileta.ModificarInvitado;
GO
CREATE PROCEDURE pileta.ModificarInvitado
    @id_invitado INT,
    @nombre NVARCHAR(100),
    @apellido NVARCHAR(100),
    @dni CHAR(8),
    @id_socio_invitante INT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM pileta.Invitado WHERE id_invitado = @id_invitado)
    BEGIN
        RAISERROR('No existe el invitado especificado.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM socios.Socio WHERE id_socio = @id_socio_invitante)
    BEGIN
        RAISERROR('El socio invitante no existe.', 16, 1);
        RETURN;
    END
    UPDATE pileta.Invitado
    SET nombre = @nombre,
        apellido = @apellido,
        dni = @dni,
        id_socio_invitante = @id_socio_invitante
    WHERE id_invitado = @id_invitado;
    SELECT @id_invitado AS id_invitado;
END;
GO

IF OBJECT_ID('pileta.ModificarReservaSUM', 'P') IS NOT NULL DROP PROCEDURE pileta.ModificarReservaSUM;
GO
CREATE PROCEDURE pileta.ModificarReservaSUM
    @id_reserva INT,
    @id_socio INT,
    @fecha DATE,
    @hora_inicio TIME,
    @hora_fin TIME,
    @monto DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM pileta.ReservaSUM WHERE id_reserva = @id_reserva)
    BEGIN
        RAISERROR('No existe la reserva especificada.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM socios.Socio WHERE id_socio = @id_socio)
    BEGIN
        RAISERROR('El socio con ID especificado no existe.', 16, 1);
        RETURN;
    END
    IF @hora_inicio >= @hora_fin
    BEGIN
        RAISERROR('La hora de inicio debe ser menor que la hora de fin.', 16, 1);
        RETURN;
    END
    UPDATE pileta.ReservaSUM
    SET id_socio = @id_socio,
        fecha = @fecha,
        hora_inicio = @hora_inicio,
        hora_fin = @hora_fin,
        monto = @monto
    WHERE id_reserva = @id_reserva;
    SELECT @id_reserva AS id_reserva;
END;
GO

IF OBJECT_ID('pileta.ModificarPasePileta', 'P') IS NOT NULL DROP PROCEDURE pileta.ModificarPasePileta;
GO
CREATE PROCEDURE pileta.ModificarPasePileta
    @id_pase INT,
    @id_socio INT,
    @fecha DATE,
    @tarifa DECIMAL(10, 2),
    @tipo NVARCHAR(50),
    @id_invitado INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM pileta.PasePileta WHERE id_pase = @id_pase)
    BEGIN
        RAISERROR('No existe el pase de pileta especificado.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM socios.Socio WHERE id_socio = @id_socio)
    BEGIN
        RAISERROR('El socio con ID especificado no existe.', 16, 1);
        RETURN;
    END
    IF @id_invitado IS NOT NULL AND NOT EXISTS (SELECT 1 FROM pileta.Invitado WHERE id_invitado = @id_invitado)
    BEGIN
        RAISERROR('El invitado especificado no existe.', 16, 1);
        RETURN;
    END
    UPDATE pileta.PasePileta
    SET id_socio = @id_socio,
        fecha = @fecha,
        tarifa = @tarifa,
        tipo = @tipo,
        id_invitado = @id_invitado
    WHERE id_pase = @id_pase;
    SELECT @id_pase AS id_pase;
END;
GO

IF OBJECT_ID('pileta.ModificarInscripcionColonia', 'P') IS NOT NULL DROP PROCEDURE pileta.ModificarInscripcionColonia;
GO
CREATE PROCEDURE pileta.ModificarInscripcionColonia
    @id_colonia INT,
    @id_socio INT,
    @fecha_inscripcion DATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM pileta.InscripcionColonia WHERE id_colonia = @id_colonia AND id_socio = @id_socio)
    BEGIN
        RAISERROR('No existe la inscripción especificada.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM pileta.ColoniaVerano WHERE id_colonia = @id_colonia)
    BEGIN
        RAISERROR('La colonia especificada no existe.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM socios.Socio WHERE id_socio = @id_socio)
    BEGIN
        RAISERROR('El socio especificado no existe.', 16, 1);
        RETURN;
    END
    UPDATE pileta.InscripcionColonia
    SET fecha_inscripcion = @fecha_inscripcion
    WHERE id_colonia = @id_colonia AND id_socio = @id_socio;
    SELECT @id_colonia AS id_colonia, @id_socio AS id_socio;
END;
GO

-- =============================================
-- BLOQUE: FACTURACION
-- =============================================
IF OBJECT_ID('facturacion.ModificarFactura', 'P') IS NOT NULL DROP PROCEDURE facturacion.ModificarFactura;
GO
CREATE PROCEDURE facturacion.ModificarFactura
    @id_factura INT,
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
    IF NOT EXISTS (SELECT 1 FROM facturacion.Factura WHERE id_factura = @id_factura)
    BEGIN
        RAISERROR('No existe la factura especificada.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM socios.Socio WHERE id_socio = @id_socio)
    BEGIN
        RAISERROR('El socio con ID especificado no existe.', 16, 1);
        RETURN;
    END
    IF @fecha_vencimiento <= @fecha
    BEGIN
        RAISERROR('La fecha de vencimiento debe ser posterior a la fecha de emisión.', 16, 1);
        RETURN;
    END
    UPDATE facturacion.Factura
    SET id_socio = @id_socio,
        fecha = @fecha,
        monto_total = @monto_total,
        estado = @estado,
        fecha_vencimiento = @fecha_vencimiento,
        fecha_segundo_vencimiento = @fecha_segundo_vencimiento,
        recargo = @recargo,
        pagador = @pagador,
        tipo = @tipo
    WHERE id_factura = @id_factura;
    SELECT @id_factura AS id_factura;
END;
GO

IF OBJECT_ID('facturacion.ModificarDetalleFactura', 'P') IS NOT NULL DROP PROCEDURE facturacion.ModificarDetalleFactura;
GO
CREATE PROCEDURE facturacion.ModificarDetalleFactura
    @id_detalle INT,
    @id_factura INT,
    @descripcion NVARCHAR(255),
    @monto DECIMAL(10,2),
    @id_actividad INT = NULL,
    @id_pase_pileta INT = NULL,
    @id_reservaSUM INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM facturacion.DetalleFactura WHERE id_detalle = @id_detalle)
    BEGIN
        RAISERROR('No existe el detalle de factura especificado.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM facturacion.Factura WHERE id_factura = @id_factura)
    BEGIN
        RAISERROR('La factura especificada no existe.', 16, 1);
        RETURN;
    END
    UPDATE facturacion.DetalleFactura
    SET id_factura = @id_factura,
        descripcion = @descripcion,
        monto = @monto,
        id_actividad = @id_actividad,
        id_pase_pileta = @id_pase_pileta,
        id_reservaSUM = @id_reservaSUM
    WHERE id_detalle = @id_detalle;
    SELECT @id_detalle AS id_detalle;
END;
GO

IF OBJECT_ID('facturacion.ModificarMedioPago', 'P') IS NOT NULL DROP PROCEDURE facturacion.ModificarMedioPago;
GO
CREATE PROCEDURE facturacion.ModificarMedioPago
    @id_medio INT,
    @nombre NVARCHAR(100),
    @permite_debito BIT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM facturacion.MedioPago WHERE id_medio = @id_medio)
    BEGIN
        RAISERROR('No existe el medio de pago especificado.', 16, 1);
        RETURN;
    END
    UPDATE facturacion.MedioPago
    SET nombre = @nombre,
        permite_debito = @permite_debito
    WHERE id_medio = @id_medio;
    SELECT @id_medio AS id_medio;
END;
GO

IF OBJECT_ID('facturacion.ModificarPago', 'P') IS NOT NULL DROP PROCEDURE facturacion.ModificarPago;
GO
CREATE PROCEDURE facturacion.ModificarPago
    @id_pago INT,
    @id_factura INT,
    @id_detalle INT = NULL,
    @id_medio INT = NULL,
    @fecha_pago DATE,
    @monto DECIMAL(10,2),
    @tipo NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM facturacion.Pago WHERE id_pago = @id_pago)
    BEGIN
        RAISERROR('No existe el pago especificado.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM facturacion.Factura WHERE id_factura = @id_factura)
    BEGIN
        RAISERROR('La factura especificada no existe.', 16, 1);
        RETURN;
    END
    IF @id_detalle IS NOT NULL AND NOT EXISTS (SELECT 1 FROM facturacion.DetalleFactura WHERE id_detalle = @id_detalle)
    BEGIN
        RAISERROR('El detalle de factura especificado no existe.', 16, 1);
        RETURN;
    END
    IF @id_medio IS NOT NULL AND NOT EXISTS (SELECT 1 FROM facturacion.MedioPago WHERE id_medio = @id_medio)
    BEGIN
        RAISERROR('El medio de pago especificado no existe.', 16, 1);
        RETURN;
    END
    UPDATE facturacion.Pago
    SET id_factura = @id_factura,
        id_detalle = @id_detalle,
        id_medio = @id_medio,
        fecha_pago = @fecha_pago,
        monto = @monto,
        tipo = @tipo
    WHERE id_pago = @id_pago;
    SELECT @id_pago AS id_pago;
END;
GO

IF OBJECT_ID('facturacion.ModificarSaldoAFavor', 'P') IS NOT NULL DROP PROCEDURE facturacion.ModificarSaldoAFavor;
GO
CREATE PROCEDURE facturacion.ModificarSaldoAFavor
    @id_socio INT,
    @monto DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM facturacion.SaldoAFavor WHERE id_socio = @id_socio)
    BEGIN
        RAISERROR('No existe el saldo a favor especificado.', 16, 1);
        RETURN;
    END
    UPDATE facturacion.SaldoAFavor
    SET monto = @monto
    WHERE id_socio = @id_socio;
    SELECT @id_socio AS id_socio;
END;
GO

-- =============================================
-- BLOQUE: ACTIVIDADES
-- =============================================
IF OBJECT_ID('actividades.ModificarActividad', 'P') IS NOT NULL DROP PROCEDURE actividades.ModificarActividad;
GO
CREATE PROCEDURE actividades.ModificarActividad
    @id_actividad INT,
    @nombre NVARCHAR(100),
    @costo_mensual DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM actividades.Actividad WHERE id_actividad = @id_actividad)
    BEGIN
        RAISERROR('No existe la actividad especificada.', 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM actividades.Actividad WHERE nombre = @nombre AND id_actividad <> @id_actividad)
    BEGIN
        RAISERROR('Ya existe una actividad con ese nombre.', 16, 1);
        RETURN;
    END
    UPDATE actividades.Actividad
    SET nombre = @nombre,
        costo_mensual = @costo_mensual
    WHERE id_actividad = @id_actividad;
    SELECT @id_actividad AS id_actividad;
END;
GO

IF OBJECT_ID('actividades.ModificarClase', 'P') IS NOT NULL DROP PROCEDURE actividades.ModificarClase;
GO
CREATE PROCEDURE actividades.ModificarClase
    @id_clase INT,
    @id_actividad INT,
    @id_categoria INT,
    @dia_semana NVARCHAR(20),
    @hora_inicio TIME,
    @hora_fin TIME
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM actividades.Clase WHERE id_clase = @id_clase)
    BEGIN
        RAISERROR('No existe la clase especificada.', 16, 1);
        RETURN;
    END
    IF @hora_fin <= @hora_inicio
    BEGIN
        RAISERROR('La hora_fin debe ser mayor que la hora_inicio.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM actividades.Actividad WHERE id_actividad = @id_actividad)
    BEGIN
        RAISERROR('La actividad especificada no existe.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM socios.CategoriaSocio WHERE id_categoria = @id_categoria)
    BEGIN
        RAISERROR('La categoría especificada no existe.', 16, 1);
        RETURN;
    END
    UPDATE actividades.Clase
    SET id_actividad = @id_actividad,
        id_categoria = @id_categoria,
        dia_semana = @dia_semana,
        hora_inicio = @hora_inicio,
        hora_fin = @hora_fin
    WHERE id_clase = @id_clase;
    SELECT @id_clase AS id_clase;
END;
GO

IF OBJECT_ID('actividades.ModificarActividadSocioClase', 'P') IS NOT NULL DROP PROCEDURE actividades.ModificarActividadSocioClase;
GO
CREATE PROCEDURE actividades.ModificarActividadSocioClase
    @id_actividad_socio_clase INT,
    @id_socio INT,
    @id_actividad INT,
    @id_clase INT,
    @fecha_inicio DATE,
    @fecha_fin DATE = NULL,
    @descuento DECIMAL(10,2) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM actividades.ActividadSocioClase WHERE id_actividad_socio_clase = @id_actividad_socio_clase)
    BEGIN
        RAISERROR('No existe la inscripción especificada.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM socios.Socio WHERE id_socio = @id_socio)
    BEGIN
        RAISERROR('El socio especificado no existe.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM actividades.Actividad WHERE id_actividad = @id_actividad)
    BEGIN
        RAISERROR('La actividad especificada no existe.', 16, 1);
        RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM actividades.Clase WHERE id_clase = @id_clase AND id_actividad = @id_actividad)
    BEGIN
        RAISERROR('La clase especificada no existe o no corresponde a la actividad.', 16, 1);
        RETURN;
    END
    UPDATE actividades.ActividadSocioClase
    SET id_socio = @id_socio,
        id_actividad = @id_actividad,
        id_clase = @id_clase,
        fecha_inicio = @fecha_inicio,
        fecha_fin = @fecha_fin,
        descuento = @descuento
    WHERE id_actividad_socio_clase = @id_actividad_socio_clase;
    SELECT @id_actividad_socio_clase AS id_actividad_socio_clase;
END;
GO
