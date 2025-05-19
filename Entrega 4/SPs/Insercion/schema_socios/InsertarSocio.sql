CREATE PROCEDURE socios.InsertarSocio
    @numero_socio NVARCHAR(50),
    @id_usuario INT = NULL,
    @nombre NVARCHAR(100),
    @apellido NVARCHAR(100),
    @dni NVARCHAR(20),
    @email NVARCHAR(100),
    @fecha_nacimiento DATE,
    @telefono NVARCHAR(20) = NULL,
    @telefono_emergencia NVARCHAR(20) = NULL,
    @obra_social NVARCHAR(100) = NULL,
    @nro_obra_social NVARCHAR(50) = NULL,
    @tel_emergencia_obra_social NVARCHAR(20) = NULL,
    @id_categoria INT,
    @responsable_id INT = NULL,
    @Estado BIT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que n�mero socio sea �nico
    IF EXISTS (SELECT 1 FROM socios.Socio WHERE numero_socio = @numero_socio)
    BEGIN
        RAISERROR('El numero_socio ya existe.', 16, 1);
        RETURN;
    END

    -- Validar que no sean ambos NULL
    IF (@id_usuario IS NULL AND @responsable_id IS NULL)
    BEGIN
        RAISERROR('Error: id_usuario y responsable_id no pueden ser ambos NULL.', 16, 1);
        RETURN;
    END

    -- Validar que no sean ambos NO NULL (si quieres que solo uno pueda estar presente)
    IF (@id_usuario IS NOT NULL AND @responsable_id IS NOT NULL)
    BEGIN
        RAISERROR('Error: id_usuario y responsable_id no pueden ser ambos con valor.', 16, 1);
        RETURN;
    END

    -- Insertar el nuevo socio
    INSERT INTO socios.Socio 
        (numero_socio, id_usuario, nombre, apellido, dni, email, fecha_nacimiento, telefono, telefono_emergencia,
         obra_social, nro_obra_social, tel_emergencia_obra_social, id_categoria, responsable_id, Estado)
    VALUES
        (@numero_socio, @id_usuario, @nombre, @apellido, @dni, @email, @fecha_nacimiento, @telefono, @telefono_emergencia,
         @obra_social, @nro_obra_social, @tel_emergencia_obra_social, @id_categoria, @responsable_id, @Estado);

    SELECT SCOPE_IDENTITY() AS id_socio;
END;
GO
