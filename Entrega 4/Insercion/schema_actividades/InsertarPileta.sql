USE Com2900G15;
GO

CREATE OR ALTER PROCEDURE actividad.InsertarPileta
    @descuento_lluvia BIT,
    @fecha_vigencia DATE,
    @tarifa DECIMAL(10,2),
    @id_invitado INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @resultado INT = 999;
		DECLARE @mensaje NVARCHAR(500);

        -- 1.0 Validar que la fecha de vigencia no sea nula y posterior a la fecha
        IF @fecha_vigencia IS NULL OR @fecha_vigencia <= CAST(GETDATE() AS DATE)
        BEGIN
            SET @resultado = 20;
            THROW 50001, 'La fecha de vigencia no puede ser nula o anterior a la fecha actual.', 1;
        END

        -- 2.0 Validar que la tarifa sea positiva
        IF @tarifa <= 0
        BEGIN
            SET @resultado = 30;
            THROW 50001, 'La tarifa debe ser un valor positivo.', 1;
        END

        INSERT INTO actividad.Pileta(descuento_lluvia, fecha_vigencia, tarifa, id_invitado)
        VALUES (@descuento_lluvia, @fecha_vigencia, @tarifa, @id_invitado);
        SET @resultado = SCOPE_IDENTITY();
        SET @mensaje = 'Pileta insertada correctamente con ID: ' + CAST(@resultado AS NVARCHAR(10));
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
