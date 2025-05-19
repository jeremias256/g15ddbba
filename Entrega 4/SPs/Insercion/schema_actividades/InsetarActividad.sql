CREATE PROCEDURE actividades.InsertarActividad
    @nombre NVARCHAR(100),
    @costo_mensual DECIMAL(10,2),
    @fecha_vigencia DATE,
    @resultado INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Validar que no exista una actividad con el mismo nombre y vigencia
        IF EXISTS (
            SELECT 1 FROM actividades.Actividad
            WHERE nombre = @nombre AND fecha_vigencia = @fecha_vigencia
        )
        BEGIN
            SET @resultado = -1; -- Ya existe
            RETURN;
        END;

        INSERT INTO actividades.Actividad (nombre, costo_mensual, fecha_vigencia)
        VALUES (@nombre, @costo_mensual, @fecha_vigencia);

        SET @resultado = SCOPE_IDENTITY(); -- Retornar ID generado
    END TRY
    BEGIN CATCH
        SET @resultado = -2; -- Error general
    END CATCH
END;
GO
