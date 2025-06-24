USE Com2900G15;
GO

CREATE OR ALTER PROCEDURE actividad.InsertarSum
    @fecha DATE,
    @hora_inicio TIME,
    @hora_fin TIME,
    @tarifa DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @resultado INT = 999;
		DECLARE @mensaje NVARCHAR(500);

        -- 2.0 Validar fecha sea válida
        IF @fecha IS NULL OR @fecha < CAST(GETDATE() AS DATE)
        BEGIN
            SET @resultado = 10;
            THROW 50001, 'La fecha no puede ser nula o anterior a la fecha actual.', 1;
        END

        -- 2.1 Validar que la hora de fin sea mayor a inicio
        IF @hora_fin <= @hora_inicio
        BEGIN
            SET @resultado = 11;
            THROW 50001, 'La hora de fin debe ser posterior a la hora de inicio.', 1;
        END

        -- 3.0 Validar que la tarifa sea positiva
        IF @tarifa <= 0
        BEGIN
            SET @resultado = 20;
            THROW 50001, 'La tarifa debe ser un valor positivo.', 1;
        END

        INSERT INTO actividad.Sums(fecha, hora_inicio, hora_fin, tarifa)
        VALUES (@fecha, @hora_inicio, @hora_fin, @tarifa);
        SET @resultado = SCOPE_IDENTITY();
        SET @mensaje = 'Sum insertada correctamente con ID: ' + CAST(@resultado AS NVARCHAR(10));
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
