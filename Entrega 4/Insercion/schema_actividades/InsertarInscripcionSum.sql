USE Com2900G15;
GO

DROP PROCEDURE IF EXISTS actividad.InsertarReserva;
GO

CREATE OR ALTER PROCEDURE actividad.InsertarReserva
    @id_sum INT,
    @id_socio INT,
    @fecha_inscripcion DATE
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @resultado INT = 999;
		DECLARE @mensaje NVARCHAR(500);

        -- 1.0 Validar que la fecha de inscripción no sea nula
        IF @fecha_inscripcion IS NULL
        BEGIN
            SET @resultado = 10;
            THROW 50001, 'La fecha de inscripción no puede ser nula.', 1;
        END

        INSERT INTO actividad.Reserva(id_sum, id_socio, fecha_inscripcion)
        VALUES (@id_sum, @id_socio, @fecha_inscripcion);
        SET @resultado = SCOPE_IDENTITY();
        SET @mensaje = 'Inscripción del socio ' + CAST(@id_socio AS NVARCHAR(10)) + ' en la reserva ' + CAST(@id_sum AS NVARCHAR(10)) + ' realizada correctamente.';
        PRINT @mensaje;
        RETURN;

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorLine INT = ERROR_LINE();
        DECLARE @ErrorProcedure NVARCHAR(128) = ERROR_PROCEDURE();
        
		PRINT '*** ERROR EN PROCEDURE : ' + @ErrorProcedure + ' ***';
        PRINT '*** ERROR EN LÍNEA : ' + CAST(@ErrorLine AS NVARCHAR(10)) + ' ***';
        PRINT '*** CÓDIGO DE ERROR : ' + CAST(@resultado AS NVARCHAR(10)) + ' ***';
		PRINT '*** DESCRIPCIÓN DEL ERROR : ' + @ErrorMessage + ' ***';
        THROW;
    END CATCH
END;
GO
