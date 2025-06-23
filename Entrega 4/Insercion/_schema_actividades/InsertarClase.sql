USE SolNorte;
GO

CREATE PROCEDURE actividades.InsertarClase
    @id_actividad INT,
    @id_categoria INT,
    @dia_semana NVARCHAR(20),
    @hora_inicio TIME,
    @hora_fin TIME
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que hora_fin sea mayor que hora_inicio
    IF @hora_fin <= @hora_inicio
    BEGIN
        RAISERROR('La hora_fin debe ser mayor que la hora_inicio.', 16, 1);
        RETURN;
    END

    -- Validar que la actividad exista
    IF NOT EXISTS (SELECT 1 FROM actividades.Actividad WHERE id_actividad = @id_actividad)
    BEGIN
        RAISERROR('La actividad especificada no existe.', 16, 1);
        RETURN;
    END

    -- Validar que la categoria exista
    IF NOT EXISTS (SELECT 1 FROM socios.CategoriaSocio WHERE id_categoria = @id_categoria)
    BEGIN
        RAISERROR('La categor�a de socio especificada no existe.', 16, 1);
        RETURN;
    END

    -- Insertar la nueva clase
    INSERT INTO actividades.Clase (id_actividad, id_categoria, dia_semana, hora_inicio, hora_fin)
    VALUES (@id_actividad, @id_categoria, @dia_semana, @hora_inicio, @hora_fin);

    -- Retornar el id generado
    SELECT SCOPE_IDENTITY() AS id_clase;
END
GO
