-- Enunciado: Entrega 4- Documento de instalación y configuración
-- Fecha de entrega: 23/06/2025
-- Comisión: 2900
-- Grupo: 15
-- Materia: Bases de Datos Aplicada
-- Integrantes:
--   - Yerimen Lombardo - DNI 42115925
--   - Jeremias Menacho - DNI 37783029
--   - Ivan Morales     - DNI 39772619
--   - Nicolas Pioli    - DNI 43781515

USE Com2900G15;
GO

CREATE OR ALTER PROCEDURE persona.InsertarInscripcionSocio
    @fecha DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @resultado INT = 999;
		DECLARE @mensaje NVARCHAR(500);

        -- Sanitizar parámetro de fecha
        SET @fecha = CAST(@fecha AS DATE);

        IF @fecha IS NULL
        BEGIN
            SET @resultado = 10;
            THROW 50001, 'La fecha de inscripción no puede ser nula.', 1;
            RETURN;
        END

        -- Validar que la fecha sea válida (no futura)
        IF @fecha > CAST(GETDATE() AS DATE)
        BEGIN
            SET @resultado = 11;
            THROW 50001, 'La fecha de inscripción no puede ser futura.', 1;
            RETURN;
        END

        -- CUMPLE VALIDACIONES

        INSERT INTO persona.Inscripcion (fecha)
        VALUES (@fecha);

        SET @resultado = SCOPE_IDENTITY();
        SET @mensaje = 'Fecha "' + CAST(@fecha AS NVARCHAR(10)) + '" insertada correctamente con ID: ' + CAST(@resultado AS NVARCHAR(10));
        PRINT @mensaje;
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