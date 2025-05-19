USE SolNorte;
GO

CREATE OR ALTER PROCEDURE facturacion.InsertarPago
    @id_factura INT,
    @id_detalle INT = NULL,
    @id_medio INT = NULL,
    @fecha_pago DATE,
    @monto DECIMAL(10,2),
    @tipo NVARCHAR(50) = NULL  -- opcional, puede ser NULL
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

        -- Validar que el detalle exista solo si se pasa un id_detalle
        IF @id_detalle IS NOT NULL AND NOT EXISTS (SELECT 1 FROM facturacion.DetalleFactura WHERE id_detalle = @id_detalle)
        BEGIN
            RAISERROR('El detalle de factura especificado no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validar que el medio de pago exista solo si se pasa un id_medio
        IF @id_medio IS NOT NULL AND NOT EXISTS (SELECT 1 FROM facturacion.MedioPago WHERE id_medio = @id_medio)
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
        THROW;
    END CATCH
END;
GO
