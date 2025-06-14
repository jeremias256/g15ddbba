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

-- =============================================
-- 1. usuarios.EliminarRol
-- =============================================
IF OBJECT_ID('usuarios.EliminarRol', 'P') IS NOT NULL DROP PROCEDURE usuarios.EliminarRol;
GO
CREATE PROCEDURE usuarios.EliminarRol
    @id_rol INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Verificar que no existan usuarios con este rol
    IF EXISTS (SELECT 1 FROM usuarios.Usuario WHERE id_rol = @id_rol)
    BEGIN
        RAISERROR('No se puede eliminar el rol porque existen usuarios asociados.', 16, 1);
        RETURN;
    END
    DELETE FROM usuarios.Rol WHERE id_rol = @id_rol;
END
GO

-- =============================================
-- 2. usuarios.EliminarUsuario
-- =============================================
IF OBJECT_ID('usuarios.EliminarUsuario', 'P') IS NOT NULL DROP PROCEDURE usuarios.EliminarUsuario;
GO
CREATE PROCEDURE usuarios.EliminarUsuario
    @id_usuario INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Verificar que no existan socios o empleados con este usuario
    IF EXISTS (SELECT 1 FROM socios.Socio WHERE id_usuario = @id_usuario)
    BEGIN
        RAISERROR('No se puede eliminar el usuario porque está asociado a un socio.', 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM socios.Empleado WHERE id_usuario = @id_usuario)
    BEGIN
        RAISERROR('No se puede eliminar el usuario porque está asociado a un empleado.', 16, 1);
        RETURN;
    END
    DELETE FROM usuarios.Usuario WHERE id_usuario = @id_usuario;
END
GO

-- =============================================
-- 3. socios.EliminarCategoriaSocio
-- =============================================
IF OBJECT_ID('socios.EliminarCategoriaSocio', 'P') IS NOT NULL DROP PROCEDURE socios.EliminarCategoriaSocio;
GO
CREATE PROCEDURE socios.EliminarCategoriaSocio
    @id_categoria INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Verificar que no existan socios con esta categoría
    IF EXISTS (SELECT 1 FROM socios.Socio WHERE id_categoria = @id_categoria)
    BEGIN
        RAISERROR('No se puede eliminar la categoría porque existen socios asociados.', 16, 1);
        RETURN;
    END
    DELETE FROM socios.CategoriaSocio WHERE id_categoria = @id_categoria;
END
GO

-- =============================================
-- 4. socios.EliminarEmpleado
-- =============================================
IF OBJECT_ID('socios.EliminarEmpleado', 'P') IS NOT NULL DROP PROCEDURE socios.EliminarEmpleado;
GO
CREATE PROCEDURE socios.EliminarEmpleado
    @id_empleado INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Verificar que no existan registros dependientes (agregar validaciones si corresponde)
    DELETE FROM socios.Empleado WHERE id_empleado = @id_empleado;
END
GO

-- =============================================
-- 5. socios.EliminarSocio
-- =============================================
IF OBJECT_ID('socios.EliminarSocio', 'P') IS NOT NULL DROP PROCEDURE socios.EliminarSocio;
GO
CREATE PROCEDURE socios.EliminarSocio
    @id_socio INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Verificar que no existan inscripciones, facturas, etc. asociadas
    IF EXISTS (SELECT 1 FROM actividades.SocioActividad WHERE id_socio = @id_socio)
    BEGIN
        RAISERROR('No se puede eliminar el socio porque tiene inscripciones a actividades.', 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM facturacion.Factura WHERE id_socio = @id_socio)
    BEGIN
        RAISERROR('No se puede eliminar el socio porque tiene facturas asociadas.', 16, 1);
        RETURN;
    END
    DELETE FROM socios.Socio WHERE id_socio = @id_socio;
END
GO

-- =============================================
-- 6. actividades.EliminarActividad
-- =============================================
IF OBJECT_ID('actividades.EliminarActividad', 'P') IS NOT NULL DROP PROCEDURE actividades.EliminarActividad;
GO
CREATE PROCEDURE actividades.EliminarActividad
    @id_actividad INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Verificar que no existan clases o inscripciones asociadas
    IF EXISTS (SELECT 1 FROM actividades.Clase WHERE id_actividad = @id_actividad)
    BEGIN
        RAISERROR('No se puede eliminar la actividad porque tiene clases asociadas.', 16, 1);
        RETURN;
    END
    IF EXISTS (SELECT 1 FROM actividades.SocioActividad WHERE id_actividad = @id_actividad)
    BEGIN
        RAISERROR('No se puede eliminar la actividad porque tiene inscripciones asociadas.', 16, 1);
        RETURN;
    END
    DELETE FROM actividades.Actividad WHERE id_actividad = @id_actividad;
END
GO

--================================
--7. pileta.EliminarColoniaVerano
--================================
IF OBJECT_ID('pileta.EliminarColoniaVerano', 'P') IS NOT NULL DROP PROCEDURE pileta.EliminarColoniaVerano;
GO
CREATE PROCEDURE pileta.EliminarColoniaVerano
    @id_colonia INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar que no exista inscripciones a esa colonia
    IF NOT EXISTS (SELECT 1 FROM pileta.InscripcionColonia WHERE id_colonia = @id_colonia)
    BEGIN
        RAISERROR('No se puede eliminar existen inscripciones para esa colonia.', 16, 1);
        RETURN;
    END

    -- Eliminación física de la colonia de verano
    DELETE FROM pileta.ColoniaVerano WHERE id_colonia = @id_colonia;

END;
GO


--================================
--8.facturacion.EliminarMedioPago 
--================================
IF OBJECT_ID('facturacion.EliminarMedioPago', 'P') IS NOT NULL DROP PROCEDURE facturacion.EliminarMedioPago;
GO
CREATE PROCEDURE facturacion.EliminarMedioPago
    @id_medio INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el medio de pago existe antes de eliminarlo
    IF NOT EXISTS (SELECT 1 FROM facturacion.MedioPago WHERE id_medio = @id_medio)
    BEGIN
        RAISERROR('El medio de pago especificado no existe.', 16, 1);
        RETURN;
    END

    -- Eliminación física del medio de pago
    DELETE FROM facturacion.MedioPago WHERE id_medio = @id_medio;

END;
GO

--======================================
--9. pileta.EliminarInscripcionColonia
--======================================
IF OBJECT_ID('pileta.EliminarInscripcionColonia', 'P') IS NOT NULL DROP PROCEDURE pileta.EliminarInscripcionColonia;
GO
CREATE PROCEDURE pileta.EliminarInscripcionColonia
    @id_colonia INT,
    @id_socio INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que la inscripción existe antes de eliminarla
    IF NOT EXISTS (
        SELECT 1 FROM pileta.InscripcionColonia 
        WHERE id_colonia = @id_colonia AND id_socio = @id_socio
    )
    BEGIN
        RAISERROR('La inscripción no existe.', 16, 1);
        RETURN;
    END

    -- Eliminar la inscripción
    DELETE FROM pileta.InscripcionColonia
    WHERE id_colonia = @id_colonia AND id_socio = @id_socio;
END;
GO

--============================
--10. pileta.EliminarInvitado 
--============================
IF OBJECT_ID('pileta.EliminarInvitado', 'P') IS NOT NULL DROP PROCEDURE pileta.EliminarInvitado;
GO
CREATE PROCEDURE pileta.EliminarInvitado
    @id_invitado INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el invitado tiene registros asociados en PasePileta
    IF EXISTS (SELECT 1 FROM pileta.PasePileta WHERE id_invitado = @id_invitado)
    BEGIN
        RAISERROR('No se puede eliminar el invitado porque tiene pases de pileta asociados.', 16, 1);
        RETURN;
    END

    -- Eliminación física del invitado
    DELETE FROM pileta.Invitado WHERE id_invitado = @id_invitado;
END;
GO

--==============================
--11. pileta.EliminarPasePileta
--==============================
IF OBJECT_ID('pileta.EliminarPasePileta', 'P') IS NOT NULL DROP PROCEDURE pileta.EliminarPasePileta;
GO
CREATE PROCEDURE pileta.EliminarPasePileta
    @id_pase INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el pase existe antes de eliminarlo
    IF NOT EXISTS (SELECT 1 FROM pileta.PasePileta WHERE id_pase = @id_pase)
    BEGIN
        RAISERROR('El pase especificado no existe.', 16, 1);
        RETURN;
    END

    -- Verificar si el pase tiene registros en DetalleFactura 
    IF EXISTS (SELECT 1 FROM facturacion.DetalleFactura WHERE id_pase_pileta = @id_pase)
    BEGIN
        RAISERROR('No se puede eliminar el pase porque está referenciado en DetalleFactura.', 16, 1);
        RETURN;
    END

    -- Eliminación física del pase de pileta
    DELETE FROM pileta.PasePileta WHERE id_pase = @id_pase;
END;
GO

--====================================
--12. facturacion.EliminarSaldoAFavor 
--====================================
IF OBJECT_ID('facturacion.EliminarSaldoAFavor', 'P') IS NOT NULL DROP PROCEDURE facturacion.EliminarSaldoAFavor;
GO
CREATE PROCEDURE facturacion.EliminarSaldoAFavor
    @id_socio INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si hay registros de saldo para el socio
    IF NOT EXISTS (SELECT 1 FROM facturacion.SaldoAFavor WHERE id_socio = @id_socio)
    BEGIN
        RAISERROR('No se puede eliminar el saldo porque no existe un registro asociado al socio ingresado.', 16, 1);
        RETURN;
    END

    -- Eliminación de todos los registros de saldo del socio
    DELETE FROM facturacion.SaldoAFavor WHERE id_socio = @id_socio;
END;
GO

--=======================================
--13. actividades.EliminarSocioActividad
--=======================================
IF OBJECT_ID('actividades.EliminarSocioActividad', 'P') IS NOT NULL DROP PROCEDURE actividades.EliminarSocioActividad;
GO
CREATE PROCEDURE actividades.EliminarSocioActividad
    @id_socio INT,
    @id_actividad INT,
    @id_clase INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si la inscripción existe antes de eliminarla
    IF NOT EXISTS (
        SELECT 1 FROM actividades.SocioActividad 
        WHERE id_socio = @id_socio AND id_actividad = @id_actividad AND id_clase = @id_clase
    )
    BEGIN
        RAISERROR('No se puede eliminar porque la inscripción especificada no existe.', 16, 1);
        RETURN;
    END

    -- Eliminación física de la inscripción en SocioActividad
    DELETE FROM actividades.SocioActividad 
    WHERE id_socio = @id_socio AND id_actividad = @id_actividad AND id_clase = @id_clase;
END;
GO

--=================================
--14. actividades.EliminarClase
--=================================
IF OBJECT_ID('actividades.EliminarClase', 'P') IS NOT NULL DROP PROCEDURE actividades.EliminarClase;
GO
 CREATE PROCEDURE actividades.EliminarClase
    @id_clase INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si la clase existe antes de eliminarla
    IF NOT EXISTS (SELECT 1 FROM actividades.Clase WHERE id_clase = @id_clase)
    BEGIN
        RAISERROR('No se puede eliminar porque la clase especificada no existe.', 16, 1);
        RETURN;
    END

    -- Verificar si la clase está referenciada en SocioActividad
    IF EXISTS (SELECT 1 FROM actividades.SocioActividad WHERE id_clase = @id_clase)
    BEGIN
        RAISERROR('No se puede eliminar porque la clase está referenciada en SocioActividad.', 16, 1);
        RETURN;
    END

    -- Eliminación física de la clase
    DELETE FROM actividades.Clase WHERE id_clase = @id_clase;
END;
GO

--===============================
--15. pileta.EliminarReservaSUM
--===============================
IF OBJECT_ID('pileta.EliminarReservaSUM', 'P') IS NOT NULL DROP PROCEDURE pileta.EliminarReservaSUM;
GO
CREATE PROCEDURE pileta.EliminarReservaSUM
    @id_reserva INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si la reserva existe antes de eliminarla
    IF NOT EXISTS (SELECT 1 FROM pileta.ReservaSUM WHERE id_reserva = @id_reserva)
    BEGIN
        RAISERROR('No se puede eliminar porque la reserva especificada no existe.', 16, 1);
        RETURN;
    END

    -- Verificar si la reserva está referenciada en DetalleFactura
    IF EXISTS (SELECT 1 FROM facturacion.DetalleFactura WHERE id_reserva = @id_reserva)
    BEGIN
        RAISERROR('No se puede eliminar porque la reserva está referenciada en DetalleFactura.', 16, 1);
        RETURN;
    END

    -- Eliminación física de la reserva
    DELETE FROM pileta.ReservaSUM WHERE id_reserva = @id_reserva;
END;
GO

--=============================
--16. facturacion.EliminarPago
--=============================
IF OBJECT_ID('facturacion.EliminarPago', 'P') IS NOT NULL DROP PROCEDURE facturacion.EliminarPago;
GO
CREATE PROCEDURE facturacion.EliminarPago
    @id_pago INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el pago existe antes de eliminarlo
    IF NOT EXISTS (SELECT 1 FROM facturacion.Pago WHERE id_pago = @id_pago)
    BEGIN
        RAISERROR('No se puede eliminar porque el pago especificado no existe.', 16, 1);
        RETURN;
    END

    -- Eliminación física del pago
    DELETE FROM facturacion.Pago WHERE id_pago = @id_pago;
END;
GO

--==================================
--17. facturacion.EliminarFactura
--==================================
IF OBJECT_ID('facturacion.EliminarFactura', 'P') IS NOT NULL DROP PROCEDURE facturacion.EliminarFactura;
GO
CREATE PROCEDURE facturacion.EliminarFactura
    @id_factura INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si la factura existe antes de eliminarla
    IF NOT EXISTS (SELECT 1 FROM facturacion.Factura WHERE id_factura = @id_factura)
    BEGIN
        RAISERROR('No se puede eliminar porque la factura especificada no existe.', 16, 1);
        RETURN;
    END

    -- Verificar si la factura está referenciada en Pago
    IF EXISTS (SELECT 1 FROM facturacion.Pago WHERE id_factura = @id_factura)
    BEGIN
        RAISERROR('No se puede eliminar porque la factura está referenciada en Pago.', 16, 1);
        RETURN;
    END

    -- Verificar si la factura está referenciada en DetalleFactura
    IF EXISTS (SELECT 1 FROM facturacion.DetalleFactura WHERE id_factura = @id_factura)
    BEGIN
        RAISERROR('No se puede eliminar porque la factura está referenciada en DetalleFactura.', 16, 1);
        RETURN;
    END

    -- Eliminación física de la factura
    DELETE FROM facturacion.Factura WHERE id_factura = @id_factura;
END;
GO

--=======================================
--18. facturacion.EliminarDetalleFactura 
--=======================================
IF OBJECT_ID('facturacion.EliminarDetalleFactura', 'P') IS NOT NULL DROP PROCEDURE facturacion.EliminarDetalleFactura;
GO
CREATE PROCEDURE facturacion.EliminarDetalleFactura
    @id_detalle INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el detalle de factura existe antes de eliminarlo
    IF NOT EXISTS (SELECT 1 FROM facturacion.DetalleFactura WHERE id_detalle = @id_detalle)
    BEGIN
        RAISERROR('No se puede eliminar porque el detalle de factura especificado no existe.', 16, 1);
        RETURN;
    END

    -- Verificar si el detalle de factura está referenciado en Pago
    IF EXISTS (SELECT 1 FROM facturacion.Pago WHERE id_detalle = @id_detalle)
    BEGIN
        RAISERROR('No se puede eliminar porque el detalle de factura está referenciado en Pago.', 16, 1);
        RETURN;
    END

    -- Eliminación física del detalle de factura
    DELETE FROM facturacion.DetalleFactura WHERE id_detalle = @id_detalle;
END;
GO
