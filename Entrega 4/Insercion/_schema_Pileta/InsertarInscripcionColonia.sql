USE SolNorte;
GO

CREATE OR ALTER PROCEDURE pileta.InsertarInscripcionColonia
    @id_colonia INT,
    @id_socio INT,
    @fecha_inscripcion DATE
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Validar que la colonia exista
        IF NOT EXISTS (SELECT 1 FROM pileta.ColoniaVerano WHERE id_colonia = @id_colonia)
        BEGIN
            RAISERROR('La colonia especificada no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validar que el socio exista
        IF NOT EXISTS (SELECT 1 FROM socios.Socio WHERE id_socio = @id_socio)
        BEGIN
            RAISERROR('El socio especificado no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validar que la inscripci�n no exista (PK compuesta)
        IF EXISTS (SELECT 1 FROM pileta.InscripcionColonia WHERE id_colonia = @id_colonia AND id_socio = @id_socio)
        BEGIN
            RAISERROR('La inscripci�n ya existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar inscripci�n
        INSERT INTO pileta.InscripcionColonia (
            id_colonia,
            id_socio,
            fecha_inscripcion
        )
        VALUES (
            @id_colonia,
            @id_socio,
            @fecha_inscripcion
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
