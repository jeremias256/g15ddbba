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
            RAISERROR('La fecha de vencimiento debe ser posterior a la fecha de emisi�n.', 16, 1);
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

        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH;
END;
GO
