USE Com2900G15;
GO

CREATE OR ALTER PROCEDURE persona.InsertarCategoriaSocio
    @nombre NVARCHAR(100),
    @edad_min INT,
    @edad_max INT,
    @fecha_vigencia DATE,
    @tarifa_categoria DECIMAL(10,2),
	@mensaje NVARCHAR(500) OUTPUT,
    @resultado INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;--evita que se muestre el mensaje de cuántas filas fueron afectadas

    BEGIN TRY
        --SANITIZAR PARÁMETRO
        DECLARE @nombre_upper NVARCHAR(100) = UPPER(LTRIM(RTRIM(@nombre)));

        -- 1.0 Validar que el nombre no esté vacío
        IF (ISNULL(@nombre_upper, '')) = ''
        BEGIN
            SET @resultado = -10;
            SET @mensaje = 'El nombre de la categoría no puede estar vacío';
            RETURN;
        END

        -- 1.1 Validación: Solo nombres permitidos
        IF @nombre_upper NOT IN ('MAYOR', 'CADETE', 'MENOR')
        BEGIN
            SET @resultado = -11;
            SET @mensaje = 'El nombre debe ser: "mayor", "cadete" o "menor" (sin importar mayúsculas)';
            RETURN;
        END

        -- 1.2 Verificar unicidad del nombre
        IF EXISTS (
            SELECT 1 FROM persona.Categoria c
            WHERE UPPER(LTRIM(RTRIM(c.nombre))) = @nombre_upper
        )
        BEGIN
            SET @resultado = -12;
            SET @mensaje = 'Ya existe una categoría con ese nombre';
            RETURN;
        END

        -- 2.0 Validar que las edades sean positivas y lógicas
        IF @edad_min < 0 OR @edad_max < 0 OR @edad_min > @edad_max
        BEGIN
            SET @resultado = -20;
            SET @mensaje = 'Rangos de edad inválidos (deben ser positivos y edad_min <= edad_max)';
            RETURN;
        END

        -- -- 2.1 2.2 2.3 Validar rangos de edad en las categorías
        -- Validar rangos según la categoría
        IF @nombre_upper = 'MENOR'
        BEGIN
            IF @edad_max > 12
            BEGIN
                SET @resultado = -21;
                SET @mensaje = 'Para categoría "menor": la edad máxima debe ser <= 12 años';
                RETURN;
            END
        END
        ELSE IF @nombre_upper = 'CADETE'
        BEGIN
            IF @edad_min < 13 OR @edad_max > 17
            BEGIN
                SET @resultado = -22;
                SET @mensaje = 'Para categoría "cadete": edad mínima >= 13 y edad máxima <= 17 años';
                RETURN;
            END
        END
        ELSE IF @nombre_upper = 'MAYOR'
        BEGIN
            IF @edad_min < 18
            BEGIN
                SET @resultado = -23;
                SET @mensaje = 'Para categoría "mayor": la edad mínima debe ser >= 18 años';
                RETURN;
            END
        END

        -- 3.0 Validar fecha de vigencia
        IF @fecha_vigencia < CAST(GETDATE() AS DATE)
        BEGIN
            SET @resultado = -30;
            SET @mensaje = 'La fecha de vigencia no puede ser anterior a hoy';
            RETURN;
        END

        -- 4.0 Validar tarifa
        IF @tarifa_categoria <= 0
        BEGIN
            SET @resultado = -40;
            SET @mensaje = 'La tarifa debe ser mayor a cero';
            RETURN;
        END

        -- CUMPLE VALIDACIONES
        
        INSERT INTO persona.Categoria (nombre, edad_min, edad_max, tarifa_categoria, fecha_vigencia)
        VALUES (@nombre_upper, @edad_min, @edad_max, @tarifa_categoria, @fecha_vigencia);

        SET @resultado = SCOPE_IDENTITY();
        SET @mensaje = 'Categoría "' + @nombre_upper + '" insertada correctamente con ID: ' + CAST(@resultado AS NVARCHAR(10)) + 
                      ' (Rango: ' + CAST(@edad_min AS NVARCHAR(10)) + '-' + CAST(@edad_max AS NVARCHAR(10)) + ' años)';

    END TRY

    BEGIN CATCH
        DECLARE @ErrorNumber INT = ERROR_NUMBER();
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorLine INT = ERROR_LINE();
        
        SET @resultado = -999;
        SET @mensaje = 'Error interno en línea ' + CAST(@ErrorLine AS NVARCHAR(10)) + ': ' + @ErrorMessage;
        
        PRINT '=== ERROR EN SP_InsertarCategoriaSocio ===';
        PRINT 'Número: ' + CAST(@ErrorNumber AS NVARCHAR(10));
        PRINT 'Mensaje: ' + @ErrorMessage;
        PRINT 'Línea: ' + CAST(@ErrorLine AS NVARCHAR(10));
        PRINT 'Parámetros recibidos:';
        PRINT '  @nombre: ' + ISNULL(@nombre, 'NULL');
        PRINT '  @edad_min: ' + CAST(@edad_min AS NVARCHAR(10));
        PRINT '  @edad_max: ' + CAST(@edad_max AS NVARCHAR(10));
        PRINT '  @tarifa_categoria: ' + CAST(@tarifa_categoria AS NVARCHAR(20));
        PRINT '  @fecha_vigencia: ' + CAST(@fecha_vigencia AS NVARCHAR(10));
        PRINT '==========================================';
    END CATCH
END;
GO
