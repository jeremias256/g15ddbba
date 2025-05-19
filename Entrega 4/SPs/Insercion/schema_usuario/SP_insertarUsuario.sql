CREATE PROCEDURE usuarios.InsertarUsuario
    @usuario NVARCHAR(50),
    @contraseña NVARCHAR(255),
    @fecha_vigencia_contraseña DATE,
    @id_rol INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que no exista un usuario con el mismo nombre
    IF EXISTS (SELECT 1 FROM usuarios.Usuario WHERE usuario = @usuario)
    BEGIN
        RAISERROR('Ya existe un usuario con ese nombre.', 16, 1);
        RETURN;
    END

    INSERT INTO usuarios.Usuario (usuario, contrase�a, fecha_vigencia_contrase�a, id_rol)
    VALUES (@usuario, @contrase�a, @fecha_vigencia_contrase�a, @id_rol);

    -- Retornar el id generado
    SELECT SCOPE_IDENTITY() AS id_usuario;
END;
GO
