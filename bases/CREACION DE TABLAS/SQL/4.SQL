-- Uso de la base de datos
USE ProyectosdeInvestigacion;
GO

IF NOT EXISTS (SELECT * FROM sys.filegroups WHERE name = 'GrupoProfes')
    ALTER DATABASE ProyectosdeInvestigacion ADD FILEGROUP GrupoProfes;
GO

ALTER DATABASE ProyectosdeInvestigacion ADD FILE 
( 
    NAME = 'Profes1',
    FILENAME = 'C:\SQLData\Profes1.ndf',
    SIZE = 2MB, MAXSIZE = 15MB, FILEGROWTH = 1MB
) 
TO FILEGROUP GrupoProfes;
GO

CREATE TABLE Profesores (
    DNI TipoDNI PRIMARY KEY,
    Nombre NVARCHAR(105) COLLATE Latin1_General_CI_AI NULL,
    Apellidos NVARCHAR(205) COLLATE Latin1_General_CI_AI NULL,
    Titulacion NVARCHAR(100) NOT NULL CHECK (Titulacion IN ('Arquitecto', 'Diplomado', 'Doctor', 'Ingeniero', 'Ingeniero Técnico', 'Licenciado')),
    FechaInicioInvestigacion DATE DEFAULT GETDATE(),
    FechaFinInvestigacion DATE NULL CHECK (FechaFinInvestigacion IS NULL OR FechaFinInvestigacion >= FechaInicioInvestigacion),
    Grupo INT CHECK (Grupo >= 0),
    Hombre BIT NOT NULL,
    NumHijos INT DEFAULT 0,
    EstadoCivil NVARCHAR(50),
    Suplemento AS (NumHijos * 100) PERSISTED,
    AñosDeInvestigacion AS DATEDIFF(YEAR, FechaInicioInvestigacion, GETDATE()) PERSISTED,
    Usuario AS USER PERSISTED,
    SueldoBase DECIMAL(18,2) NOT NULL DEFAULT 0,
    Complementos DECIMAL(18,2) NOT NULL DEFAULT 0,
    CONSTRAINT UQ_Profesor UNIQUE (Nombre, Apellidos)
) ON GrupoProfes;
GO

-- Crear tabla ProyectosInv en el grupo de archivos principal
ALTER TABLE ProyectosInv DROP COLUMN GuidProyecto;
GO

CREATE TABLE ProyectosInv (
    CodigoProyecto INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    NombreProyecto NVARCHAR(200) NOT NULL CHECK (NombreProyecto NOT LIKE '[0-9]%'),
    Presupuesto DECIMAL(18,2) NOT NULL CHECK (Presupuesto > 1000),
    FechaInicio DATE NOT NULL DEFAULT DATEADD(DAY, -15, GETDATE()),
    FechaFin DATE NULL CHECK (FechaFin IS NULL OR (YEAR(FechaFin) = YEAR(FechaInicio) AND MONTH(FechaFin) = MONTH(FechaInicio))),
    Grupo INT
);
GO

CREATE TABLE Participa (
    DNI TipoDNI,
    CodigoProyecto INT,
    FechaInicio DATE,
    FechaCese DATE,
    Dedicacion INT,
    Observaciones NVARCHAR(MAX),
    PRIMARY KEY (DNI, CodigoProyecto, FechaInicio),
    FOREIGN KEY (DNI) REFERENCES Profesores(DNI),
    FOREIGN KEY (CodigoProyecto) REFERENCES ProyectosInv(CodigoProyecto)
);
GO

CREATE TABLE Ubicacion (
    CodigoSede SMALLINT NOT NULL,
    CodigoDepartamento INT NOT NULL,
    OrdenAntigüedad INT NOT NULL CHECK (OrdenAntigüedad > 0),
    PRIMARY KEY (CodigoSede, CodigoDepartamento)
) ON GrupoProfes;
GO

CREATE TABLE Programas (
    CodigoPrograma CHAR(3) DEFAULT 'P00' CHECK (CodigoPrograma LIKE '[PR]%' AND CodigoPrograma LIKE '%[0-9]%'),
    NombrePrograma NVARCHAR(200) NULL,
    FechaFin DATE DEFAULT GETDATE(),
    CONSTRAINT UQ_NombrePrograma UNIQUE (NombrePrograma)
);
GO

CREATE TABLE Financiacion (
    CodigoPrograma CHAR(3) DEFAULT 'P00',
    CodigoProyecto INT,
    Financiacion DECIMAL(18,2) CHECK (Financiacion > 2500) NOT VALID,
    FOREIGN KEY (CodigoProyecto) REFERENCES ProyectosInv(CodigoProyecto)
);
GO

INSERT INTO Programas (CodigoPrograma, NombrePrograma) VALUES ('P01', 'Programa de Investigación');
GO

ALTER TABLE Programas ADD FechaInicio DATE NULL DEFAULT GETDATE();
SELECT FechaInicio FROM Programas;
GO

ALTER TABLE Programas DROP COLUMN FechaInicio;
ALTER TABLE Programas ADD FechaInicio DATE NULL DEFAULT GETDATE() WITH VALUES;
GO

-- Eliminar relación Financiacion/Programas y recrearla por defecto
ALTER TABLE Financiacion DROP CONSTRAINT FK_Financiacion_Programas;
GO
ALTER TABLE Financiacion ADD FOREIGN KEY (CodigoPrograma) REFERENCES Programas(CodigoPrograma) ON DELETE SET DEFAULT;
GO

ALTER TABLE ProyectosInv NOCHECK CONSTRAINT ALL;
ALTER TABLE ProyectosInv CHECK CONSTRAINT ALL;
GO
