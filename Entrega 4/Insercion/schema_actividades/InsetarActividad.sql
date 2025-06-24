USE Com2900G15;
GO

CREATE OR ALTER PROCEDURE actividad.InsertarActividad
    @nombre NVARCHAR(100),
    @tarifa DECIMAL(10,2),
    @fecha_vigencia DATE
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @nombre_lower NVARCHAR(100) = LOWER(LTRIM(RTRIM(@nombre)));
        DECLARE @resultado INT = 999;
		DECLARE @mensaje NVARCHAR(500);

        -- 1.0 Validar que el nombre no esté vacío
        IF (ISNULL(@nombre_lower, '')) = ''
        BEGIN
            SET @resultado = 10;
            THROW 50001, 'El nombre de la actividad no puede estar vacío.', 1;
        END

        -- 1.1 Validar que la actividad no exista
        IF EXISTS (
            SELECT 1 FROM actividad.Actividad a
            WHERE LOWER(LTRIM(RTRIM(a.nombre))) = @nombre_lower
        )
        BEGIN
            SET @resultado = 11;
            THROW 50001, 'Ya existe una actividad con ese nombre.', 1;
        END

        -- 2.0 Validar que la tarifa sea positiva
        IF @tarifa <= 0
        BEGIN
            SET @resultado = 20;
            THROW 50001, 'La tarifa debe ser un valor positivo.', 1;
        END

        -- 3.0 Validar que la fecha de vigencia no sea negativa
        IF @fecha_vigencia < CAST(GETDATE() AS DATE)
        BEGIN
            SET @resultado = 30;
            THROW 50001, 'La fecha de vigencia no puede ser pasada.', 1;
        END

        INSERT INTO actividad.Actividad(nombre, tarifa, fecha_vigencia)
        VALUES (@nombre_lower, @tarifa, @fecha_vigencia);
        SET @resultado = SCOPE_IDENTITY();
        SET @mensaje = 'Actividad "' + @nombre + '" insertada correctamente con ID: ' + CAST(@resultado AS NVARCHAR(10));
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
