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

USE Com2900G15;
GO
-- =============================================
-- SPs de Eliminación - SolNorte
-- Unificado
-- =============================================

--============================
--TABLA INSCRIPCION (unica)
--============================
IF OBJECT_ID('persona.EliminarInscripcion', 'P') IS NOT NULL DROP PROCEDURE persona.EliminarInscripcion;
GO

CREATE PROCEDURE persona.EliminarInscripcion
    @id_inscripcion INT
AS
BEGIN
    SET NOCOUNT ON;

    -- valida si existe ese id ingresado
    IF NOT EXISTS (
        SELECT 1 FROM persona.Inscripcion
        WHERE id_inscripcion = @id_inscripcion
    )
    BEGIN
        RAISERROR('No existe una inscripción con ese ID.', 16, 1);
        RETURN;
    END

    -- si existe el id, lo elimina
    DELETE FROM persona.Inscripcion
    WHERE id_inscripcion = @id_inscripcion;
END
GO


--============================
--ELIMINAR CATEGORIA (socio) 
--============================
IF OBJECT_ID('persona.EliminarCategoria', 'P') IS NOT NULL DROP PROCEDURE persona.EliminarCategoria;
GO

CREATE PROCEDURE persona.EliminarCategoria
    @id_categoria INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Valida si hay socios asociados a esta categoría. 
    IF EXISTS (
        SELECT 1 
        FROM persona.Socio 
        WHERE id_categoria = @id_categoria
    )
    BEGIN
        RAISERROR('No se puede eliminar la categoría: tiene socios asociados.', 16, 1);
        RETURN;
    END

    -- Elimina categoria si no tiene un socio asociado
    DELETE FROM persona.Categoria
    WHERE id_categoria = @id_categoria;
END
GO


--======================
--TABLA RESPONSABLEPAGO V1
--======================
IF OBJECT_ID('persona.EliminarResponsablePago', 'P') IS NOT NULL DROP PROCEDURE persona.EliminarResponsablePago;
GO

CREATE PROCEDURE persona.EliminarResponsablePago
    @id_responsable_pago INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Valida si el responsable es responsable de pago de alguno de los socios
    IF EXISTS (
        SELECT 1 
        FROM persona.Socio 
        WHERE id_responsable_pago = @id_responsable_pago
    )
    BEGIN
        RAISERROR('No se puede eliminar: hay socios asociados a este responsable de pago.', 16, 1);
        RETURN;
    END

    -- eliminacion si no tiene un socio vinculado
    DELETE FROM persona.ResponsablePago
    WHERE id_responsable_pago = @id_responsable_pago;
END
GO
--=====================
--TABLA RESPONSABLEPAGO V2
--=====================
IF OBJECT_ID('persona.EliminarResponsablePago', 'P') IS NOT NULL DROP PROCEDURE persona.EliminarResponsablePago;
GO

CREATE PROCEDURE persona.EliminarResponsablePago
    @id_responsable_pago INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Valida SI hay socios ACTIVOS asociados a este responsable
    IF EXISTS (
        SELECT 1 
        FROM persona.Socio 
        WHERE id_responsable_pago = @id_responsable_pago
          AND Estado = 1
    )
    BEGIN
        RAISERROR('No se puede eliminar: hay socios ACTIVOS asociados a este responsable de pago.', 16, 1);
        RETURN;
    END

    -- Eliminación (solo si no hay socios o todos están dados de baja)
    DELETE FROM persona.ResponsablePago
    WHERE id_responsable_pago = @id_responsable_pago;
END
GO


--==================
--TABLA REEMBOLSO
--==================
IF OBJECT_ID('facturacion.EliminarReembolso', 'P') IS NOT NULL DROP PROCEDURE facturacion.EliminarReembolso;
GO

CREATE PROCEDURE facturacion.EliminarReembolso
    @id_reembolso INT
AS
BEGIN
    SET NOCOUNT ON;

	--valida si esta asociado a un medio de pago asociado
    IF EXISTS (
        SELECT 1 
        FROM facturacion.MedioPago 
        WHERE id_reembolso = @id_reembolso
    )
    BEGIN
        RAISERROR('No se puede eliminar: el reembolso está asociado a un medio de pago.', 16, 1);
        RETURN;
    END
	--elimina en caso de que no tenga un medio de pago asociado
    DELETE FROM facturacion.Reembolso
    WHERE id_reembolso = @id_reembolso;
END
GO
--================
--TABLA MEDIOPAGO
--================
IF OBJECT_ID('facturacion.EliminarMedioPago', 'P') IS NOT NULL DROP PROCEDURE facturacion.EliminarMedioPago;
GO

CREATE PROCEDURE facturacion.EliminarMedioPago
    @id_medio INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si fue utilizado en algún pago
    IF EXISTS (
        SELECT 1 
        FROM facturacion.Pago 
        WHERE id_medio_pago = @id_medio
    )
    BEGIN
        RAISERROR('No se puede eliminar: el medio de pago fue utilizado en al menos un pago.', 16, 1);
        RETURN;
    END

    -- Eliminar en caso de que el no fue usado en un pago
    DELETE FROM facturacion.MedioPago
    WHERE id_medio = @id_medio;
END
GO

--==================
--TABLA PAGO
--==================
IF OBJECT_ID('facturacion.EliminarPago', 'P') IS NOT NULL DROP PROCEDURE facturacion.EliminarPago;
GO

CREATE PROCEDURE facturacion.EliminarPago
    @id_pago INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si el pago está vinculado a alguna factura
    IF EXISTS (
        SELECT 1 
        FROM facturacion.Factura 
        WHERE id_pago = @id_pago
    )
    BEGIN
        RAISERROR('No se puede eliminar: el pago está asociado a una factura.', 16, 1);
        RETURN;
    END

    -- Elimina en caso de que no este asociado a una factura
    DELETE FROM facturacion.Pago
    WHERE id_pago = @id_pago;
END
GO

--===============
--TABLA FACTURA
--===============
IF OBJECT_ID('facturacion.EliminarFactura', 'P') IS NOT NULL DROP PROCEDURE facturacion.EliminarFactura;
GO

CREATE PROCEDURE facturacion.EliminarFactura
    @id_factura INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si hay detalles asociados
    IF EXISTS (
        SELECT 1 FROM facturacion.DetalleFactura
        WHERE id_factura = @id_factura
    )
    BEGIN
        RAISERROR('No se puede eliminar: la factura tiene detalles asociados.', 16, 1);
        RETURN;
    END

    -- Validar si hay cuotas asociadas
    IF EXISTS (
        SELECT 1 FROM facturacion.Cuota
        WHERE id_factura = @id_factura
    )
    BEGIN
        RAISERROR('No se puede eliminar: la factura tiene cuotas asociadas.', 16, 1);
        RETURN;
    END

    -- Validar si hay socios vinculados a esas cuotas
    IF EXISTS (
        SELECT 1 FROM persona.Socio
        WHERE id_cuota IN (
            SELECT id_cuota FROM facturacion.Cuota WHERE id_factura = @id_factura
        )
    )
    BEGIN
        RAISERROR('No se puede eliminar: hay socios vinculados a esta factura mediante cuotas.', 16, 1);
        RETURN;
    END

    -- Eliminación 
    DELETE FROM facturacion.Factura
    WHERE id_factura = @id_factura;
END
GO


--=============
-- TABLA CUOTA
--=============
IF OBJECT_ID('facturacion.EliminarCuota', 'P') IS NOT NULL DROP PROCEDURE facturacion.EliminarCuota;
GO

CREATE PROCEDURE facturacion.EliminarCuota
    @id_cuota INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si la cuota está asociada a un socio
    IF EXISTS (
        SELECT 1 
        FROM persona.Socio 
        WHERE id_cuota = @id_cuota
    )
    BEGIN
        RAISERROR('No se puede eliminar: la cuota está asociada a un socio.', 16, 1);
        RETURN;
    END

    -- Eliminación segura
    DELETE FROM facturacion.Cuota
    WHERE id_cuota = @id_cuota;
END
GO

---===============
--TABLA MOROSIDAD
--================
IF OBJECT_ID('facturacion.EliminarMorosidad', 'P') IS NOT NULL DROP PROCEDURE facturacion.EliminarMorosidad;
GO

CREATE PROCEDURE facturacion.EliminarMorosidad
    @id_morosidad INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si el id ingresado existe
    IF NOT EXISTS (
        SELECT 1 FROM facturacion.Morosidad
        WHERE id_morosidad = @id_morosidad
    )
    BEGIN
        RAISERROR('No existe una morosidad con ese ID.', 16, 1);
        RETURN;
    END

    -- Eliminación segura
    DELETE FROM facturacion.Morosidad
    WHERE id_morosidad = @id_morosidad;
END
GO

--=============================
-- TABLA SOCIO (borrado logico)
--=============================
IF OBJECT_ID('persona.DarBajaSocio', 'P') IS NOT NULL DROP PROCEDURE persona.DarBajaSocio;
GO

CREATE PROCEDURE persona.DarBajaSocio
    @id_socio INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1 FROM persona.Socio WHERE id_socio = @id_socio
    )
    BEGIN
        RAISERROR('El socio no existe.', 16, 1);
        RETURN;
    END

    -- Ya está dado de baja
    IF EXISTS (
        SELECT 1 FROM persona.Socio 
        WHERE id_socio = @id_socio AND Estado = 0
    )
    BEGIN
        RAISERROR('El socio ya se encuentra dado de baja.', 16, 1);
        RETURN;
    END

    -- Borrado lógico
    UPDATE persona.Socio
    SET Estado = 0
    WHERE id_socio = @id_socio;
END
GO

--====================
--TABLA COLONIA
--===================
IF OBJECT_ID('actividad.EliminarColonia', 'P') IS NOT NULL DROP PROCEDURE actividad.EliminarColonia;
GO

CREATE PROCEDURE actividad.EliminarColonia
    @id_colonia INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si la colonia tiene inscripciones asociadas
    IF EXISTS (
        SELECT 1 
        FROM actividad.InscripcionColonia 
        WHERE id_colonia = @id_colonia
    )
    BEGIN
        RAISERROR('No se puede eliminar la colonia: tiene inscripciones asociadas.', 16, 1);
        RETURN;
    END

    -- Validar si fue facturada
    IF EXISTS (
        SELECT 1 
        FROM facturacion.DetalleFactura 
        WHERE id_colonia = @id_colonia
    )
    BEGIN
        RAISERROR('No se puede eliminar la colonia: está vinculada a una factura.', 16, 1);
        RETURN;
    END

    -- Eliminación segura
    DELETE FROM actividad.Colonia
    WHERE id_colonia = @id_colonia;
END
GO

--=========================
--TABLA INSCRIPCIONCOLONIA
--========================
IF OBJECT_ID('actividad.EliminarInscripcionColonia', 'P') IS NOT NULL DROP PROCEDURE actividad.EliminarInscripcionColonia;
GO

CREATE PROCEDURE actividad.EliminarInscripcionColonia
    @id_colonia INT,
    @id_socio INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar existencia de la inscripción
    IF NOT EXISTS (
        SELECT 1 
        FROM actividad.InscripcionColonia
        WHERE id_colonia = @id_colonia AND id_socio = @id_socio
    )
    BEGIN
        RAISERROR('No existe una inscripción de colonia con esos datos.', 16, 1);
        RETURN;
    END

    -- Eliminación segura
    DELETE FROM actividad.InscripcionColonia
    WHERE id_colonia = @id_colonia AND id_socio = @id_socio;
END
GO


--====================
--TABLA ACTIVIDAD 
--===================
IF OBJECT_ID('actividad.EliminarActividad', 'P') IS NOT NULL DROP PROCEDURE actividad.EliminarActividad;
GO

CREATE PROCEDURE actividad.EliminarActividad
    @id_actividad INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar referencias en InscripcionActividad
    IF EXISTS (
        SELECT 1 FROM actividad.InscripcionActividad
        WHERE id_actividad = @id_actividad
    )
    BEGIN
        RAISERROR('No se puede eliminar la actividad: tiene inscripciones asociadas.', 16, 1);
        RETURN;
    END

    -- Verificar referencias en DetalleFactura
    IF EXISTS (
        SELECT 1 FROM facturacion.DetalleFactura
        WHERE id_actividad = @id_actividad
    )
    BEGIN
        RAISERROR('No se puede eliminar la actividad: está asociada a una factura.', 16, 1);
        RETURN;
    END

    -- Eliminación segura
    DELETE FROM actividad.Actividad
    WHERE id_actividad = @id_actividad;
END
GO

--===========================
--TABLA INSCRIPCIONACTIVIDAD
--===========================
IF OBJECT_ID('actividad.EliminarInscripcionActividad', 'P') IS NOT NULL DROP PROCEDURE actividad.EliminarInscripcionActividad;
GO

CREATE PROCEDURE actividad.EliminarInscripcionActividad
    @id_actividad INT,
    @id_socio INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1 
        FROM actividad.InscripcionActividad 
        WHERE id_actividad = @id_actividad AND id_socio = @id_socio
    )
    BEGIN
        RAISERROR('No existe una inscripción con esos datos.', 16, 1);
        RETURN;
    END

    DELETE FROM actividad.InscripcionActividad
    WHERE id_actividad = @id_actividad AND id_socio = @id_socio;
END
GO

--================
--TABLA INVITADO
--===============
IF OBJECT_ID('actividad.EliminarInvitado', 'P') IS NOT NULL DROP PROCEDURE actividad.EliminarInvitado;
GO

CREATE PROCEDURE actividad.EliminarInvitado
    @id_invitado INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si el invitado está asociado a alguna pileta
    IF EXISTS (
        SELECT 1 
        FROM actividad.Pileta 
        WHERE id_invitado = @id_invitado
    )
    BEGIN
        RAISERROR('No se puede eliminar el invitado: está asociado a una entrada de pileta.', 16, 1);
        RETURN;
    END

    -- Eliminación segura
    DELETE FROM actividad.Invitado
    WHERE id_invitado = @id_invitado;
END
GO

--=================
--TABLA PILETA
--===================
IF OBJECT_ID('actividad.EliminarPileta', 'P') IS NOT NULL
    DROP PROCEDURE actividad.EliminarPileta;
GO

CREATE PROCEDURE actividad.EliminarPileta
    @id_pileta INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si la pileta está asociada a alguna inscripción
    IF EXISTS (
        SELECT 1 
        FROM actividad.InscripcionPileta 
        WHERE id_pileta = @id_pileta
    )
    BEGIN
        RAISERROR('No se puede eliminar la pileta: tiene inscripciones asociadas.', 16, 1);
        RETURN;
    END

    -- Validar si fue facturada
    IF EXISTS (
        SELECT 1 
        FROM facturacion.DetalleFactura 
        WHERE id_pase_pileta = @id_pileta
    )
    BEGIN
        RAISERROR('No se puede eliminar la pileta: está asociada a una factura.', 16, 1);
        RETURN;
    END

    -- Eliminación segura
    DELETE FROM actividad.Pileta
    WHERE id_pileta = @id_pileta;
END
GO

--========================
--TABLA INSCRIPCIONPILETA
--========================
IF OBJECT_ID('actividad.EliminarInscripcionPileta', 'P') IS NOT NULL DROP PROCEDURE actividad.EliminarInscripcionPileta;
GO

CREATE PROCEDURE actividad.EliminarInscripcionPileta
    @id_pileta INT,
    @id_socio INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validación: ¿existe esta inscripción?
    IF NOT EXISTS (
        SELECT 1 
        FROM actividad.InscripcionPileta
        WHERE id_pileta = @id_pileta AND id_socio = @id_socio
    )
    BEGIN
        RAISERROR('No existe una inscripción a pileta con esos datos.', 16, 1);
        RETURN;
    END

    -- Eliminación
    DELETE FROM actividad.InscripcionPileta
    WHERE id_pileta = @id_pileta AND id_socio = @id_socio;
END
GO



--===========
--TABLA sums
--===========
IF OBJECT_ID('actividad.EliminarSums', 'P') IS NOT NULL DROP PROCEDURE actividad.EliminarSums;
GO

CREATE PROCEDURE actividad.EliminarSums
    @id_sum INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar si el SUM tiene reservas
    IF EXISTS (
        SELECT 1 
        FROM actividad.Reserva 
        WHERE id_sum = @id_sum
    )
    BEGIN
        RAISERROR('No se puede eliminar: el SUM tiene reservas asociadas.', 16, 1);
        RETURN;
    END

    -- Validar si está vinculado a una detalle de factura
    IF EXISTS (
        SELECT 1 
        FROM facturacion.DetalleFactura 
        WHERE id_sum = @id_sum
    )
    BEGIN
        RAISERROR('No se puede eliminar: el SUM está relacionado con una factura.', 16, 1);
        RETURN;
    END

    -- Eliminación segura
    DELETE FROM actividad.Sums
    WHERE id_sum = @id_sum;
END
GO


--==============
--TABLA RESERVA
--==============
IF OBJECT_ID('actividad.EliminarReserva', 'P') IS NOT NULL DROP PROCEDURE actividad.EliminarReserva;
GO

CREATE PROCEDURE actividad.EliminarReserva
    @id_sum INT,
    @id_socio INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Valida si existe esta reserva
    IF NOT EXISTS (
        SELECT 1 
        FROM actividad.Reserva 
        WHERE id_sum = @id_sum AND id_socio = @id_socio
    )
    BEGIN
        RAISERROR('No existe una reserva para ese socio y SUM.', 16, 1);
        RETURN;
    END

    -- Eliminación
    DELETE FROM actividad.Reserva
    WHERE id_sum = @id_sum AND id_socio = @id_socio;
END
GO

--=====================
--TABLA DETALLEFACTURA
--=====================
IF OBJECT_ID('facturacion.EliminarDetalleFactura', 'P') IS NOT NULL DROP PROCEDURE facturacion.EliminarDetalleFactura;
GO

CREATE PROCEDURE facturacion.EliminarDetalleFactura
    @id_detalle INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Valida si existe el detalle ingresado
    IF NOT EXISTS (
        SELECT 1 
        FROM facturacion.DetalleFactura
        WHERE id_detalle = @id_detalle
    )
    BEGIN
        RAISERROR('No existe un detalle con ese ID.', 16, 1);
        RETURN;
    END

    -- Eliminación 
    DELETE FROM facturacion.DetalleFactura
    WHERE id_detalle = @id_detalle;
END
GO
