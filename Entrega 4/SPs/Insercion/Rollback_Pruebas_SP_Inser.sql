-- Rollback de datos insertados por Pruebas_SP_Inser.sql
-- Ejecutar después de las pruebas para dejar la base limpia
USE SolNorte;
GO

-- Eliminar dependencias primero (detalle, pagos, inscripciones, etc.)

-- FACTURACION
DELETE FROM facturacion.Pago;
DELETE FROM facturacion.DetalleFactura;
DELETE FROM facturacion.Factura;
DELETE FROM facturacion.SaldoAFavor;
DELETE FROM facturacion.MedioPago;

-- ACTIVIDADES
DELETE FROM actividades.SocioActividad;
DELETE FROM actividades.Clase;
DELETE FROM actividades.Actividad;

-- PILETA
DELETE FROM pileta.PasePileta;
DELETE FROM pileta.Invitado;
DELETE FROM pileta.InscripcionColonia;
DELETE FROM pileta.ReservaSUM;
DELETE FROM pileta.ColoniaVerano;

-- SOCIOS
DELETE FROM socios.Socio;
DELETE FROM socios.Empleado;
DELETE FROM socios.CategoriaSocio;

-- USUARIOS
DELETE FROM usuarios.Usuario;
DELETE FROM usuarios.Rol;

-- Fin del rollback
