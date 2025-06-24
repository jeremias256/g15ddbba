USE Com2900G15;
GO

CREATE OR ALTER PROCEDURE actividad.InsertarColonia
    @nombre NVARCHAR(100),
    @fecha_inicio DATE,
    @fecha_fin DATE,
    @tarifa DECIMAL(10,2)
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
            THROW 50001, 'El nombre de la colonia no puede estar vacío.', 1;
        END

        -- 1.1 Validar que la colonia no exista
        IF EXISTS (
            SELECT 1 FROM actividad.Colonia c
            WHERE LOWER(LTRIM(RTRIM(c.nombre))) = @nombre_lower
        )
        BEGIN
            SET @resultado = 11;
            THROW 50001, 'El nombre de la colonia ya existe.', 1;
        END

        -- 2.0 Validar fecha inicio y fin
        IF @fecha_inicio IS NULL OR @fecha_fin IS NULL
        BEGIN
            SET @resultado = 20;
            THROW 50001, 'Las fechas de inicio y fin no pueden estar vacías.', 1;
        END

        -- 2.1 Validar que la fecha de fin se mayor a inicio
        IF @fecha_fin <= @fecha_inicio
        BEGIN
            SET @resultado = 21;
            THROW 50001, 'La fecha de fin debe ser posterior a la fecha de inicio.', 1;
        END

        -- 3.0 Validar que la tarifa sea positiva
        IF @tarifa <= 0
        BEGIN
            SET @resultado = 30;
            THROW 50001, 'La tarifa debe ser un valor positivo.', 1;
        END

        INSERT INTO actividad.Colonia(nombre, tarifa, fecha_inicio, fecha_fin)
        VALUES (@nombre_lower, @tarifa, @fecha_inicio, @fecha_fin);
        SET @resultado = SCOPE_IDENTITY();
        SET @mensaje = 'Colonia "' + @nombre + '" insertada correctamente con ID: ' + CAST(@resultado AS NVARCHAR(10));
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
