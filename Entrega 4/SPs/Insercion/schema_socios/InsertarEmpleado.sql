CREATE PROCEDURE socios.InsertarEmpleado
    @id_usuario INT,
    @nombre NVARCHAR(100),
    @apellido NVARCHAR(100),
    @dni NVARCHAR(20),
    @email NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar duplicidad de id_usuario
    IF EXISTS (SELECT 1 FROM socios.Empleado WHERE id_usuario = @id_usuario)
    BEGIN
        RAISERROR('Ya existe un empleado con ese id_usuario.', 16, 1);
        RETURN;
    END;
    -- Validar duplicidad de dni
    IF EXISTS (SELECT 1 FROM socios.Empleado WHERE dni = @dni)
    BEGIN
        RAISERROR('Ya existe un empleado con ese DNI.', 16, 1);
        RETURN;
    END;

    INSERT INTO socios.Empleado (id_usuario, nombre, apellido, dni, email)
    VALUES (@id_usuario, @nombre, @apellido, @dni, @email);

    SELECT SCOPE_IDENTITY() AS id_empleado;
END;
GO
