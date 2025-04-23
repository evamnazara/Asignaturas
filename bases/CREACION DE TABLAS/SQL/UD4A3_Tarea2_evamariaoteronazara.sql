-- ============= NOTAS:
-- si se sabe la longitud fija es char y no varchar
-- en regex no existen operadores + o similares
-- (1,1) es valor inicial e incremento (podria ser (5,10) y empezaria en 5 e iria de 10 en 10
-- la fk puede ir a nivel de columna si es un solo valor
-- la check igual //COMPARAR FECHAS ES SIEMPRE TABLA 
-- distinto <> o != 
-- chuleta 
-- create index // cluster o no cluster 


-- ej 1
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'ProyectosdeInvestigacion')
BEGIN
    CREATE DATABASE ProyectosdeInvestigacion;
END;
GO

USE ProyectosdeInvestigacion;
GO

IF OBJECT_ID('Departamentos') IS NOT NULL
    DROP TABLE Departamentos;
GO

CREATE TABLE Departamentos (
    CodigoDpto INT IDENTITY(1,1),
    NombreDpto VARCHAR(50) UNIQUE,
		--la longitud si no esta especificada se pone mas o menos coherente
    Telefono CHAR(9) NULL, --si se sabe longitud fija es char y no varchar
    Director CHAR(9) NULL,
	
    CONSTRAINT PK_Departamentos PRIMARY KEY (CodigoDpto),
    CONSTRAINT CK_Telefono CHECK (Telefono LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') --regex
 
);

EXEC sp_help 'Departamentos'

-- ej 2

IF EXISTS (SELECT * FROM sys.types WHERE name = 'TipoDNI')
    DROP TYPE TipoDNI;
GO

CREATE TYPE TipoDNI FROM CHAR(9) NOT NULL;
GO

IF OBJECT_ID('Sedes') IS NOT NULL
    DROP TABLE Sedes;
GO

CREATE TABLE Sedes (
    CodigoSede INT IDENTITY(1,1),
    NombreSede VARCHAR(100) NOT NULL,
    Campus VARCHAR(100) NULL,
    
    CONSTRAINT PK_CODIGOSEDE PRIMARY KEY (CodigoSede),
    CONSTRAINT UQ_NOMBRESEDE UNIQUE (NombreSede)
);

EXEC sp_help 'Sedes';
GO

-- ej 3

IF OBJECT_ID('Grupos') IS NOT NULL
    DROP TABLE Grupos;
GO

CREATE TABLE Grupos (
    CodigoGrupo INT IDENTITY(1,1),
    NombreGrupo VARCHAR(100) UNIQUE NOT NULL,
    CodigoDpto int NULL,
    AreaConocimiento VARCHAR(100) NULL,
    Lider TipoDNI NULL,

    FOREIGN KEY (CodigoDpto) REFERENCES Departamentos(CodigoDpto), 
    --se puede omitir porque por defecto referencia a la primaria
    CONSTRAINT PK_CODIGOGRUPO PRIMARY KEY (CodigoGrupo)
);
GO

EXEC sp_help 'Grupos';
GO