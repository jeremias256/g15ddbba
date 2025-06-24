USE Com2900G15;
GO

-- DROP PROCEDURE persona.InsertarSocio;
-- GO

CREATE OR ALTER PROCEDURE persona.InsertarSocio
    @numero_socio NVARCHAR(50),
    @nombre NVARCHAR(100),
    @apellido NVARCHAR(100),
    @dni NVARCHAR(10),
    @email NVARCHAR(100),
    @fecha_nacimiento DATE,
    @telefono NVARCHAR(20) = NULL,
    @telefono_emergencia NVARCHAR(20) = NULL,
    @obra_social NVARCHAR(100) = NULL,
    @nro_obra_social NVARCHAR(50) = NULL,
    @tel_emergencia_obra_social NVARCHAR(20) = NULL,
    @estado BIT,
    @id_socio_responsable INT = NULL,
    @id_responsable_pago INT = NULL,
    @id_inscripcion INT = NULL,
    @id_cuota INT = NULL,
    @id_categoria INT,
    --DATOS SI EL SOCIO ES MENOR DE EDAD, CARGAMOS DATOS DEL RESPONSABLE
    @nombre_responsable NVARCHAR(100) = NULL,
    @apellido_responsable NVARCHAR(100) = NULL,
    @dni_responsable NVARCHAR(20) = NULL,
    @email_responsable NVARCHAR(100) = NULL,
    @fecha_nacimiento_responsable DATE = NULL,
    @telefono_responsable NVARCHAR(20) = NULL,
    @parentesco NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        DECLARE @numero_socio_clean NVARCHAR(100) = LOWER(LTRIM(RTRIM(@numero_socio)));
        DECLARE @nombre_upper NVARCHAR(100) = LOWER(LTRIM(RTRIM(@nombre)));
        DECLARE @apellido_upper NVARCHAR(100) = LOWER(LTRIM(RTRIM(@apellido)));
        DECLARE @dni_upper NVARCHAR(100) = LOWER(LTRIM(RTRIM(@dni)));
        DECLARE @email_upper NVARCHAR(100) = LOWER(LTRIM(RTRIM(@email)));
        DECLARE @telefono_clean NVARCHAR(100) = (LTRIM(RTRIM(@telefono)));
        DECLARE @telefono_emergencia_clean NVARCHAR(100) = (LTRIM(RTRIM(@telefono_emergencia)));
        DECLARE @obra_social_clean NVARCHAR(100) = LOWER(LTRIM(RTRIM(@obra_social)));
        DECLARE @nro_obra_social_clean NVARCHAR(100) = (LTRIM(RTRIM(@nro_obra_social)));
        DECLARE @tel_emergencia_obra_social_clean NVARCHAR(100) = (LTRIM(RTRIM(@tel_emergencia_obra_social)));
        DECLARE @resultado INT = 999;
        DECLARE @mensaje NVARCHAR(500);
        DECLARE @edad INT;

        -- 1.0 Validar que el número de socio no esté vacío
        IF (ISNULL(@numero_socio_clean, '')) = ''
        BEGIN
            SET @resultado = 10;
            THROW 50001, 'El número de socio no puede estar vacío.', 1;
        END

        -- 1.1 Validar que el número de socio sea único
        IF EXISTS (
            SELECT 1 FROM persona.Socio s
            WHERE LTRIM(RTRIM(s.numero_socio)) = @numero_socio_clean
        )
        BEGIN
            SET @resultado = 11;
            THROW 50001, 'El número de socio ya existe.', 1;
        END

        -- 2.0 Validar que el nombre no esté vacío
        IF (ISNULL(@nombre_upper, '')) = ''
        BEGIN
            SET @resultado = 20;
            THROW 50001, 'El nombre no puede estar vacío.', 1;
        END

        -- 3.0 Validar que el apellido no esté vacío
        IF (ISNULL(@apellido_upper, '')) = ''
        BEGIN
            SET @resultado = 20;
            THROW 50001, 'El apellido no puede estar vacío.', 1;
        END

        -- 4.0 Validar que el DNI no esté vacío
        IF (ISNULL(@dni_upper, '')) = ''
        BEGIN
            SET @resultado = 40;
            THROW 50001, 'El DNI no puede estar vacío.', 1;
        END

        -- 4.1 Validar que el DNI sea único
        IF EXISTS (
            SELECT 1 FROM persona.Socio s
            WHERE LTRIM(RTRIM(s.dni)) = @dni_upper
        )
        BEGIN
            SET @resultado = 41;
            THROW 50001, 'El DNI ya existe.', 1;
        END

        -- 5.0 Validar que el email no esté vacío
        IF (ISNULL(@email_upper, '')) = ''
        BEGIN
            SET @resultado = 50;
            THROW 50001, 'El email no puede estar vacío.', 1;
        END

        -- 5.1 Validar que el email sea único
        IF EXISTS (
            SELECT 1 FROM persona.Socio s
            WHERE LTRIM(RTRIM(s.email)) = @email_upper
        )
        BEGIN
            SET @resultado = 51;
            THROW 50001, 'El email ya existe.', 1;
        END

        -- 6.0 Validar que la fecha de nacimiento no sea nula
        IF (ISNULL(@fecha_nacimiento, '') = '')
        BEGIN
            SET @resultado = 60;
            THROW 50001, 'La fecha de nacimiento no puede ser nula.', 1;
        END

        -- 6.1 Validar que la fecha de nacimiento no sea futura
        IF @fecha_nacimiento > CAST(GETDATE() AS DATE)
        BEGIN
            SET @resultado = 61;
            THROW 50001, 'La fecha de nacimiento no puede ser futura.', 1;
        END

        -- 7.0 Estado debe ser 0 o 1
        IF @estado NOT IN (0, 1)
        BEGIN
            SET @resultado = 70;
            THROW 50001, 'El estado debe ser 0 (inactivo) o 1 (activo).', 1;
        END

        -- 8.0 Validar que el id_inscripcion no sea nulo
        IF (ISNULL(@id_inscripcion, '') = '')
        BEGIN
            SET @resultado = 80;
            THROW 50001, 'El id_inscripcion no puede ser nulo.', 1;
        END

        -- 8.1 Validar que el id_inscripcion exista
        IF NOT EXISTS (
            SELECT 1 FROM persona.Inscripcion i
            WHERE i.id_inscripcion = @id_inscripcion
        )
        BEGIN
            SET @resultado = 81;
            THROW 50001, 'El id_inscripcion no existe.', 1;
        END

        -- 9.0 Validar que id_categoria no sea nulo
        IF (ISNULL(@id_categoria, '') = '')
        BEGIN
            SET @resultado = 90;
            THROW 50001, 'El id_categoria no puede ser nulo.', 1;
        END

        -- 9.1 Validar que id_categoria exista
        IF NOT EXISTS (
            SELECT 1 FROM persona.Categoria c
            WHERE c.id_categoria = @id_categoria
        )
        BEGIN
            SET @resultado = 91;
            THROW 50001, 'El id_categoria no existe.', 1;
        END

        SET @edad = DATEDIFF(YEAR, @fecha_nacimiento, GETDATE())

        IF(@edad < 18 AND @id_socio_responsable IS NULL)
        BEGIN
            -- 10.0 Validar que el nombre del responsable no esté vacío
            IF((ISNULL(@nombre_responsable, '') = '') OR (ISNULL(@apellido_responsable, '') = ''))
            BEGIN
                SET @resultado = 100;
                THROW 50001, 'El nombre y apellido del responsable no pueden estar vacíos para menores de edad.', 1;
            END

            -- 10.1 Validar que el DNI del responsable no esté vacío
            IF(ISNULL(@dni_responsable, '') = '')
            BEGIN
                SET @resultado = 101;
                THROW 50001, 'El DNI del responsable no puede estar vacío para menores de edad.', 1;
            END

            -- 10.2 Validar que el email del responsable no esté vacío
            IF(ISNULL(@email_responsable, '') = '')
            BEGIN
                SET @resultado = 102;
                THROW 50001, 'El email del responsable no puede estar vacío para menores de edad.', 1;
            END

            -- 10.3 Validar que la fecha de nacimiento del responsable no sea nula
            IF(ISNULL(@fecha_nacimiento_responsable, '') = '')
            BEGIN
                SET @resultado = 103;
                THROW 50001, 'La fecha de nacimiento del responsable no puede estar vacía para menores de edad.', 1;
            END

            -- 10.4 Validar parentesco no esté vacío
            IF(ISNULL(@parentesco, '') = '')
            BEGIN
                SET @resultado = 104;
                THROW 50001, 'El parentesco del responsable no puede estar vacío para menores de edad.', 1;
            END

            INSERT INTO persona.ResponsablePago(nombre, apellido, dni, email, fecha_nacimiento, telefono, parentesco)
            VALUES (@nombre_responsable, @apellido_responsable, @dni_responsable, @email_responsable, @fecha_nacimiento_responsable, @telefono_responsable, @parentesco);
            SET @id_responsable_pago = SCOPE_IDENTITY();

            INSERT INTO persona.Socio(numero_socio, nombre, apellido, dni, email, fecha_nacimiento, telefono, telefono_emergencia, obra_social, nro_obra_social, tel_emergencia_obra_social, estado, id_socio_responsable, id_responsable_pago, id_inscripcion, id_cuota, id_categoria)
            VALUES (@numero_socio, @nombre, @apellido, @dni, @email, @fecha_nacimiento, @telefono, @telefono_emergencia, @obra_social, @nro_obra_social, @tel_emergencia_obra_social, @estado, @id_socio_responsable, @id_responsable_pago, @id_inscripcion, @id_cuota, @id_categoria);

            SET @resultado = SCOPE_IDENTITY();
            SET @mensaje = 'Socio "' + @nombre + ' ' + @apellido + '" insertado correctamente con ID: ' + CAST(@resultado AS NVARCHAR(10));
            PRINT @mensaje;
            RETURN;
        END
        ELSE
        BEGIN
            INSERT INTO persona.Socio(numero_socio, nombre, apellido, dni, email, fecha_nacimiento, telefono, telefono_emergencia, obra_social, nro_obra_social, tel_emergencia_obra_social, estado, id_socio_responsable, id_responsable_pago, id_inscripcion, id_cuota, id_categoria)
            VALUES (@numero_socio, @nombre, @apellido, @dni, @email, @fecha_nacimiento, @telefono, @telefono_emergencia, @obra_social, @nro_obra_social, @tel_emergencia_obra_social, @estado, @id_socio_responsable, @id_responsable_pago, @id_inscripcion, @id_cuota, @id_categoria);

            SET @resultado = SCOPE_IDENTITY();
            SET @mensaje = 'Socio "' + @nombre + ' ' + @apellido + '" insertado correctamente con ID: ' + CAST(@resultado AS NVARCHAR(10));
            PRINT @mensaje;
            RETURN;
        END
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
