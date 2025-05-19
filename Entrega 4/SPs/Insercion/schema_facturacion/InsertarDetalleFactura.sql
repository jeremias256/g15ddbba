USE SolNorte;
GO

CREATE OR ALTER PROCEDURE facturacion.InsertarDetalleFactura
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

        -- Insertar en DetalleFactura
        INSERT INTO facturacion.DetalleFactura (
            id_factura,
            descripcion,
            monto,
            id_actividad,
            id_pase_pileta,
            id_reservaSUM
        )
        VALUES (
            @id_factura,
            @descripcion,
            @monto,
            @id_actividad,
            @id_pase_pileta,
            @id_reservaSUM
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
