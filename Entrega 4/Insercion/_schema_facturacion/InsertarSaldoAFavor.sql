USE SolNorte;
GO

CREATE OR ALTER PROCEDURE facturacion.InsertarActualizarSaldoAFavor
    @id_socio INT,
    @monto DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Validar que el socio exista
        IF NOT EXISTS (SELECT 1 FROM socios.Socio WHERE id_socio = @id_socio)
        BEGIN
            RAISERROR('El socio especificado no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Verificar si ya existe saldo a favor para el socio
        IF EXISTS (SELECT 1 FROM facturacion.SaldoAFavor WHERE id_socio = @id_socio)
        BEGIN
            -- Actualizar monto sumando al existente
            UPDATE facturacion.SaldoAFavor
            SET monto = monto + @monto
            WHERE id_socio = @id_socio;
        END
        ELSE
        BEGIN
            -- Insertar nuevo saldo a favor
            INSERT INTO facturacion.SaldoAFavor (id_socio, monto)
            VALUES (@id_socio, @monto);
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO
