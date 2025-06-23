USE SolNorte;
GO

CREATE OR ALTER PROCEDURE facturacion.InsertarMedioPago
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
