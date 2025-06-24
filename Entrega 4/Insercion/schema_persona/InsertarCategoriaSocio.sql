USE Com2900G15;
GO

CREATE OR ALTER PROCEDURE persona.InsertarCategoriaSocio
    @nombre NVARCHAR(100),
    @edad_min INT,
    @edad_max INT,
    @fecha_vigencia DATE,
    @tarifa_categoria DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        --SANITIZAR PARÁMETRO
        DECLARE @nombre_upper NVARCHAR(100) = UPPER(LTRIM(RTRIM(@nombre)));
		DECLARE @resultado INT = 999;
		DECLARE @mensaje NVARCHAR(500);

        -- 1.0 Validar que el nombre no esté vacío
        IF (ISNULL(@nombre_upper, '')) = ''
        BEGIN
            SET @resultado = 10;
		    THROW 50001, 'El nombre de la categoría no puede estar vacío.', 1;
        END

        --1.1 Validación: Solo nombres permitidos
        IF @nombre_upper NOT IN ('MAYOR', 'CADETE', 'MENOR')
        BEGIN
            SET @resultado = 11;
            THROW 50001, 'El nombre debe ser: "mayor", "cadete" o "menor" (sin importar mayúsculas).', 1;
        END
        ---- 1.2 Verificar unicidad del nombre
        IF EXISTS (
            SELECT 1 FROM persona.Categoria c
            WHERE UPPER(LTRIM(RTRIM(c.nombre))) = @nombre_upper
        )
        BEGIN
            SET @resultado = 12;
            THROW 50001, 'Ya existe una categoría con ese nombre.', 1;
        END
        

        ---- 2.0 Validar que las edades sean positivas y lógicas
        IF @edad_min < 0 OR @edad_max < 0 OR @edad_min > @edad_max
        BEGIN
            SET @resultado = 20;
            THROW 50001, 'Rangos de edad inválidos (deben ser positivos y edad_min <= edad_max).', 1;
        END
        -- 2.1 2.2 2.3 Validar rangos de edad en las categorías
        -- Validar rangos según la categoría
        IF @nombre_upper = 'MENOR'
        BEGIN
           IF @edad_max > 12
           BEGIN
               SET @resultado = 21;
               THROW 50001, 'Para categoría "menor": la edad máxima debe ser <= 12 años.', 1;
            END
        END
        ELSE IF @nombre_upper = 'CADETE'
        BEGIN
           IF @edad_min < 13 OR @edad_max > 17
           BEGIN
               SET @resultado = 22;
               THROW 50001, 'Para categoría "cadete": edad mínima >= 13 y edad máxima <= 17 años.', 1;
           END
        END
        ELSE IF @nombre_upper = 'MAYOR'
        BEGIN
           IF @edad_min < 18
           BEGIN
               SET @resultado = 23;
               THROW 50001, 'Para categoría "mayor": la edad mínima debe ser >= 18 años.', 1;
           END
        END

        -- 3.0 Validar fecha de vigencia
        IF @fecha_vigencia < CAST(GETDATE() AS DATE)
        BEGIN
            SET @resultado = 30;
            THROW 50001, 'La fecha de vigencia no puede ser anterior a hoy.', 1;
        END
        

        -- 4.0 Validar tarifa
        IF @tarifa_categoria <= 0
        BEGIN
            SET @resultado = 40;
            THROW 50001, 'La tarifa debe ser mayor a cero.', 1;
        END

        ---- CUMPLE VALIDACIONES
        INSERT INTO persona.Categoria (nombre, edad_min, edad_max, tarifa_categoria, fecha_vigencia)
        VALUES (@nombre_upper, @edad_min, @edad_max, @tarifa_categoria, @fecha_vigencia);

        SET @resultado = SCOPE_IDENTITY();
        SET @mensaje = 'Categoría "' + @nombre_upper + '" insertada correctamente con ID: ' + CAST(@resultado AS NVARCHAR(10));
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
