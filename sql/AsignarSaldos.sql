-- Crear tabla de Saldos si no existe
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Saldos]') AND type in (N'U'))
BEGIN
    CREATE TABLE Saldos (
        ID INT IDENTITY(1,1) PRIMARY KEY,
        Monto DECIMAL(10,2)
    );

    -- Insertar los saldos
    INSERT INTO Saldos (Monto) VALUES 
    (2277), (3953), (4726), (1414), (627), (1784), (1634), (3958), (2156), (1347),
    (2166), (820), (2325), (3613), (2389), (4130), (2007), (3027), (2591), (3940),
    (3888), (2975), (4470), (2291), (3393), (3588), (3286), (2293), (4353), (3315),
    (4900), (794), (4424), (4505), (2643), (2217), (4193), (2893), (4120), (3352),
    (2355), (3219), (3064), (4893), (272), (1299), (4725), (1900), (4927), (4011);
END

-- Crear tabla de Gestores si no existe
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Gestores]') AND type in (N'U'))
BEGIN
    CREATE TABLE Gestores (
        ID INT IDENTITY(1,1) PRIMARY KEY,
        Nombre NVARCHAR(100)
    );

    -- Insertar 10 gestores
    INSERT INTO Gestores (Nombre) VALUES 
    ('Gestor1'), ('Gestor2'), ('Gestor3'), ('Gestor4'), ('Gestor5'),
    ('Gestor6'), ('Gestor7'), ('Gestor8'), ('Gestor9'), ('Gestor10');
END

-- Crear tabla de Saldos Asignados si no existe
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SaldosAsignados]') AND type in (N'U'))
BEGIN
    CREATE TABLE SaldosAsignados (
        ID INT IDENTITY(1,1) PRIMARY KEY,
        GestorID INT,
        Monto DECIMAL(10,2),
        FOREIGN KEY (GestorID) REFERENCES Gestores(ID)
    );
END

-- Crear o modificar el procedimiento almacenado
GO
CREATE OR ALTER PROCEDURE AsignarSaldosAGestores
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Calcular el número de iteraciones
        DECLARE @TotalSaldos INT = (SELECT COUNT(*) FROM Saldos);
        DECLARE @TotalGestores INT = (SELECT COUNT(*) FROM Gestores);
        DECLARE @Iteraciones INT = CEILING(CAST(@TotalSaldos AS FLOAT) / @TotalGestores);

        -- Limpiar asignaciones previas
        TRUNCATE TABLE SaldosAsignados;

        -- Declarar variables para el cursor
        DECLARE @GestorID INT;
        DECLARE @MontoSaldo DECIMAL(10,2);
        DECLARE @SaldoID INT;

        -- Declarar una variable de tabla para almacenar saldos ordenados
        DECLARE @SaldosOrdenados TABLE (
            NumFila INT IDENTITY(1,1),
            ID INT,
            Monto DECIMAL(10,2)
        );

        -- Insertar saldos ordenados en la variable de tabla
        INSERT INTO @SaldosOrdenados (ID, Monto)
        SELECT ID, Monto
        FROM Saldos
        ORDER BY Monto DESC;

        -- Iniciar el proceso de asignación
        DECLARE @IteracionActual INT = 1;
        DECLARE @IndiceSaldo INT = 1; -- Indice para la asignación de saldos

        -- Mientras existan saldos por asignar
        WHILE @IndiceSaldo <= @TotalSaldos
        BEGIN
            -- Cursor para iterar a través de los gestores
            DECLARE CursorGestores CURSOR FOR 
            SELECT ID FROM Gestores ORDER BY ID;

            OPEN CursorGestores;
            FETCH NEXT FROM CursorGestores INTO @GestorID;

            -- Asignar saldos a cada gestor
            WHILE @@FETCH_STATUS = 0 AND @IndiceSaldo <= @TotalSaldos
            BEGIN
                -- Obtener el siguiente saldo para asignar
                SELECT @SaldoID = ID, @MontoSaldo = Monto
                FROM @SaldosOrdenados
                WHERE NumFila = @IndiceSaldo;

                -- Asignar el saldo si está disponible
                IF @SaldoID IS NOT NULL
                BEGIN
                    INSERT INTO SaldosAsignados (GestorID, Monto)
                    VALUES (@GestorID, @MontoSaldo);
                END

                -- Avanzar al siguiente saldo
                SET @IndiceSaldo = @IndiceSaldo + 1;

                FETCH NEXT FROM CursorGestores INTO @GestorID;
            END

            CLOSE CursorGestores;
            DEALLOCATE CursorGestores;
        END

        -- Devolver los saldos asignados
        SELECT g.Nombre AS NombreGestor, sa.Monto
        FROM SaldosAsignados sa
        JOIN Gestores g ON sa.GestorID = g.ID
        ORDER BY g.ID, sa.Monto DESC;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
