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
    @fecha DATE,
    @mensaje NVARCHAR(500) OUTPUT,
    @resultado INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Sanitizar parámetro de fecha
        SET @fecha = CAST(@fecha AS DATE);

        -- Validar que la fecha no sea nula
        IF @fecha IS NULL
        BEGIN
            SET @resultado = -10;
            SET @mensaje = 'La fecha de inscripción no puede ser nula.';
            RETURN;
        END

        -- Validar que la fecha sea válida (no futura)
        IF @fecha > CAST(GETDATE() AS DATE)
        BEGIN
            SET @resultado = -11;
            SET @mensaje = 'La fecha de inscripción no puede ser futura.';
            RETURN;
        END

        -- CUMPLE VALIDACIONES

        INSERT INTO persona.Inscripcion (fecha)
        VALUES (@fecha);

        SET @resultado = SCOPE_IDENTITY();
        SET @mensaje = 'Inscripción realizada con éxito con ID: ' + CAST(@resultado AS NVARCHAR(10));
        RETURN;
    END TRY

    BEGIN CATCH
        DECLARE @ErrorNumber INT = ERROR_NUMBER();
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorLine INT = ERROR_LINE();

        SET @resultado = -999;
        SET @mensaje = 'Error inesperado: ' + ERROR_MESSAGE();

        PRINT '=== ERROR EN SP_InsertarInscripcionSocio ===';
        PRINT 'Número: ' + CAST(@ErrorNumber AS NVARCHAR(10));
        PRINT 'Mensaje: ' + @ErrorMessage;
        PRINT 'Línea: ' + CAST(@ErrorLine AS NVARCHAR(10));
        PRINT 'Parámetro recibido:';
        PRINT '  @fecha: ' + CAST(@fecha AS NVARCHAR(10));
        PRINT '==========================================';
        RETURN;
    END CATCH
    
END;