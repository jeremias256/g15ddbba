USE SolNorte;
GO

CREATE OR ALTER PROCEDURE pileta.InsertarPasePileta
    @id_socio INT,
    @fecha DATE,
    @tarifa DECIMAL(10, 2),
    @tipo NVARCHAR(50),
    @id_invitado INT = NULL  -- Opcional
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

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO
