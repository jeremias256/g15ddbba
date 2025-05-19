CREATE PROCEDURE actividades.InscribirSocioEnActividad
    @id_socio INT,
    @id_actividad INT,
    @id_clase INT,
    @fecha_inicio DATE,
    @fecha_fin DATE = NULL,  -- Opcional
    @descuento DECIMAL(10,2) = NULL  -- Opcional
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que el socio exista
    IF NOT EXISTS (SELECT 1 FROM socios.Socio WHERE id_socio = @id_socio)
    BEGIN
        RAISERROR('El socio especificado no existe.', 16, 1);
        RETURN;
    END

    -- Validar que la actividad exista
    IF NOT EXISTS (SELECT 1 FROM actividades.Actividad WHERE id_actividad = @id_actividad)
    BEGIN
        RAISERROR('La actividad especificada no existe.', 16, 1);
        RETURN;
    END

    -- Validar que la clase exista y coincida con actividad
    IF NOT EXISTS (
        SELECT 1 FROM actividades.Clase
        WHERE id_clase = @id_clase AND id_actividad = @id_actividad
    )
    BEGIN
        RAISERROR('La clase especificada no existe o no pertenece a la actividad.', 16, 1);
        RETURN;
    END

    -- Insertar inscripci�n
    INSERT INTO actividades.SocioActividad
        (id_socio, id_actividad, id_clase, fecha_inicio, fecha_fin, descuento)
    VALUES
        (@id_socio, @id_actividad, @id_clase, @fecha_inicio, @fecha_fin, @descuento);
END
GO
