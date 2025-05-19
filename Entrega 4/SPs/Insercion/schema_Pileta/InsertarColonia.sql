USE SolNorte;
GO

CREATE OR ALTER PROCEDURE pileta.InsertarColonia
    @nombre NVARCHAR(100),
    @monto DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Validar que el nombre no est� vac�o
        IF LEN(LTRIM(RTRIM(@nombre))) = 0
        BEGIN
            RAISERROR('El nombre de la colonia no puede estar vac�o.', 16, 1);
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
