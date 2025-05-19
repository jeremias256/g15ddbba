CREATE PROCEDURE socios.InsertarCategoriaSocio
    @nombre NVARCHAR(100),
    @edad_min INT,
    @edad_max INT,
    @costo_membresia DECIMAL(10,2),
    @fecha_vigencia DATE,
    @resultado INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validaciones
    IF @edad_min < 0 OR @edad_max < 0 OR @edad_min > @edad_max
    BEGIN
        SET @resultado = -1; -- Edad inv�lida
        RETURN;
    END

    IF @costo_membresia < 0
    BEGIN
        SET @resultado = -2; -- Costo inv�lido
        RETURN;
    END

    -- Verificar unicidad del nombre
    IF EXISTS (SELECT 1 FROM socios.CategoriaSocio WHERE nombre = @nombre)
    BEGIN
        SET @resultado = -3; -- Nombre duplicado
        RETURN;
    END

    -- Inserci�n
    INSERT INTO socios.CategoriaSocio (nombre, edad_min, edad_max, costo_membresia, fecha_vigencia)
    VALUES (@nombre, @edad_min, @edad_max, @costo_membresia, @fecha_vigencia);

    SET @resultado = SCOPE_IDENTITY(); -- Devuelve el ID insertado
END;
GO
