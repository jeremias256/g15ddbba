USE SolNorte;
GO

CREATE OR ALTER PROCEDURE pileta.InsertarInvitado
    @nombre NVARCHAR(100),
    @apellido NVARCHAR(100),
    @dni CHAR(8),
    @id_socio_invitante INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Validar existencia del socio
        IF NOT EXISTS (
            SELECT 1 FROM socios.Socio WHERE id_socio = @id_socio_invitante
        )
        BEGIN
            RAISERROR('El socio con ID %d no existe.', 16, 1, @id_socio_invitante);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar invitado
        INSERT INTO pileta.Invitado (
            nombre,
            apellido,
            dni,
            id_socio_invitante
        )
        VALUES (
            @nombre,
            @apellido,
            @dni,
            @id_socio_invitante
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
