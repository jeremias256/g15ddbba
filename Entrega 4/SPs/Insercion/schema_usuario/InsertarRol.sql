CREATE PROCEDURE usuarios.InsertarRol
    @nombre NVARCHAR(50),
    @descripcion NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que el nombre sea �nico
    IF EXISTS (SELECT 1 FROM usuarios.Rol WHERE nombre = @nombre)
    BEGIN
        RAISERROR('El nombre del rol ya existe.', 16, 1);
        RETURN;
    END

    INSERT INTO usuarios.Rol (nombre, descripcion)
    VALUES (@nombre, @descripcion);

    SELECT SCOPE_IDENTITY() AS id_rol;
END;
GO
