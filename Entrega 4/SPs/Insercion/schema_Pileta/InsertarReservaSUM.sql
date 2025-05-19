USE SolNorte;
GO

CREATE OR ALTER PROCEDURE pileta.InsertarReservaSUM
    @id_socio INT,
    @fecha DATE,
    @hora_inicio TIME,
    @hora_fin TIME,
    @monto DECIMAL(10,2)
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

        -- Validar que la hora de inicio sea menor que la hora de fin
        IF @hora_inicio >= @hora_fin
        BEGIN
            RAISERROR('La hora de inicio debe ser menor que la hora de fin.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar reserva SUM
        INSERT INTO sum.ReservaSUM (
            id_socio,
            fecha,
            hora_inicio,
            hora_fin,
            monto
        )
        VALUES (
            @id_socio,
            @fecha,
            @hora_inicio,
            @hora_fin,
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
