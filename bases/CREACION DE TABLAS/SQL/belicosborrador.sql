USE master;

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'CONFLICTOSBELICOS')
    BEGIN
    	DROP DATABASE CONFLICTOSBELICOS;
    END 
GO

CREATE DATABASE CONFLICTOSBELICOS
ON 
PRIMARY (
    NAME = conflictos_data, 
    FILENAME = 'C:\conflictosbelicos\conflictos_data.mdf', 
    SIZE = 5MB, 
    FILEGROWTH = 15%
),

FILEGROUP grupo_interviene (
    NAME = grupo_datos1, 
    FILENAME = 'C:\conflictosbelicos\grupo_datos1.ndf', 
    SIZE = 8MB, 
    FILEGROWTH = 5MB
),

(
    NAME = grupo_datos2, 
    FILENAME = 'C:\conflictosbelicos\grupo_datos2.ndf', 
    SIZE = 8MB, 
    FILEGROWTH = 5MB
),
FILEGROUP grupo_traficantes (
    NAME = traficante_datos1, 
    FILENAME = 'C:\conflictosbelicos\traficante_datos1.ndf', 
    SIZE = 5MB, 
    FILEGROWTH = 3MB, 
    MAXSIZE = 12MB    
),
FILEGROUP grupo_organizaciones (
    NAME = organizacion_data1, 
    FILENAME = 'C:\conflictosbelicos\organizacion_data1.ndf', 
    SIZE = 8MB, 
    FILEGROWTH = 3MB
),
(
    NAME = organizacion_data2, 
    FILENAME = 'C:\conflictosbelicos\organizacion_data2.ndf', 
    SIZE = 8MB, FILEGROWTH = 3MB)

LOG ON (
    NAME = conflicto1_log, 
    FILENAME = 'C:\conflictosbelicos\conflicto1_log.ldf', 
    SIZE = 5MB, 
    FILEGROWTH = 3MB
),
(
    NAME = conflicto2_log, 
    FILENAME = 'C:\conflictosbelicos\conflicto2_log.ldf', 
    SIZE = 5MB, 
    FILEGROWTH = 3MB
);
EXEC sp_helpdb
EXEC sp_helpfilegroup
	select * from sys.filegroups
	SELECT * from SYS.data_spaces
	select * from sys.database_files
GO

USE CONFLICTOSBELICOS;

GO

IF EXISTS (SELECT * FROM SYS.schemas WHERE name='CONFLICTOS')
	BEGIN
		PRINT 'ya existe el esquema, se va a borrar'
    	DROP schema CONFLICTOS
    END 
GO

CREATE SCHEMA CONFLICTOS AUTHORIZATION dbo;
GO

IF EXISTS (SELECT * FROM SYS.schemas WHERE name='GRUPOS')
	BEGIN
		PRINT 'ya existe el esquema, se va a borrar'
    	DROP schema GRUPOS
    END 

GO
--no hace falta la autorizacion pero weno 
CREATE SCHEMA GRUPOS AUTHORIZATION dbo;
GO

IF EXISTS (SELECT * FROM SYS.schemas WHERE name='TRAFICANTES')
	BEGIN
		PRINT 'ya existe el esquema, se va a borrar'
    	DROP schema TRAFICANTES
    END 

GO
CREATE SCHEMA TRAFICANTES AUTHORIZATION dbo;
GO


IF EXISTS (SELECT * FROM SYS.schemas WHERE name='ORGANIZACIONES')
	BEGIN
		PRINT 'ya existe el esquema, se va a borrar'
    	DROP schema ORGANIZACIONES
    END 
go
CREATE SCHEMA ORGANIZACIONES AUTHORIZATION dbo;
GO


IF EXISTS (SELECT * FROM SYS.schemas WHERE name='ARMAS')
	BEGIN
		PRINT 'ya existe el esquema, se va a borrar'
    	DROP schema ARMAS
    END 
GO 
CREATE SCHEMA ARMAS AUTHORIZATION dbo;
GO

--conprobacion de creación

CREATE TYPE fecha FROM date NULL;
go


-- TABLA PAIS
CREATE TABLE PAIS (
    codigoPais INT,
    nombre VARCHAR(100) NOT NULL,

    CONSTRAINT PK_PAIS PRIMARY KEY (codigoPais)
);

-- TABLA CONFLICTO
CREATE TABLE CONFLICTOS.CONFLICTO (
    idConflicto INT,
    nombre VARCHAR(100) NOT NULL,
    causa VARCHAR(20),
    fechaInicio fecha,
    fechaFin DATETIME NULL DEFAULT NULL,
    codigoPais INT,

    CONSTRAINT CONFLICTO PRIMARY KEY (idConflicto),
    CONSTRAINT FK_ConflictoPais FOREIGN KEY (codigoPais) REFERENCES PAIS(codigoPais) 
        ON DELETE SET NULL,
    CONSTRAINT ck_causaConflicto CHECK (causa IN ('Racial', 'Territorial', 'Religioso', 'Economico'))
);

-- TABLA GRUPO
CREATE TABLE GRUPOS.GRUPO (
    codigoGrupo INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- TABLA INTERVIENE
CREATE TABLE GRUPOS.INTERVIENE (
    idConflicto INT,
    codigoGrupo INT,

    CONSTRAINT PK_GruposInterviene PRIMARY KEY (idConflicto, codigoGrupo),
    CONSTRAINT FK_IntervieneConflicto FOREIGN KEY (idConflicto) REFERENCES CONFLICTOS.CONFLICTO(idConflicto) 
        ON DELETE CASCADE,
    CONSTRAINT FK_IntervieneGrupo FOREIGN KEY (codigoGrupo) REFERENCES GRUPOS.GRUPO(codigoGrupo) 
        ON DELETE CASCADE
);

-- TABLA LIDER
CREATE TABLE GRUPOS.LIDER (
    codigoLider CHAR(5),
    nombre VARCHAR(100) NOT NULL,
    codigoGrupo INT,

    CONSTRAINT PK_LIDERGRUPO PRIMARY KEY (codigoLider),
    CONSTRAINT FK_LiderGrupo FOREIGN KEY (codigoGrupo) REFERENCES GRUPOS.GRUPO(codigoGrupo) 
        ON DELETE SET NULL,
    CONSTRAINT CK_CodigoLider CHECK (codigoLider LIKE 'LD[0-9][0-9][0-9]' OR codigoLider LIKE 'LR[0-9][0-9][0-9]')
);

-- TABLA JEFE
CREATE TABLE GRUPOS.JEFE (
    codigoJefe INT,
    nombre VARCHAR(100) NOT NULL,
    codigoGrupo INT NULL,
    
    CONSTRAINT PK_JEFEGRUPO PRIMARY KEY (codigoJefe),
    CONSTRAINT FK_JefeGrupo FOREIGN KEY (codigoGrupo) REFERENCES GRUPOS.GRUPO(codigoGrupo) 
        ON DELETE SET NULL
);

-- TABLA ORGANIZACIONES
CREATE TABLE ORGANIZACIONES.ORGANIZACIONES (
    idOrganizacion INT,
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(20),
    CONSTRAINT PK_ORGANIZACION PRIMARY KEY (idOrganizacion),
    CONSTRAINT CK_ORGANIZACIONES CHECK (tipo IN ('Gubernamental', 'No Gubernamental', 'Internacional'))
);

-- TABLA DIALOGA
CREATE TABLE ORGANIZACIONES.DIALOGA (
    idOrganizacion INT,
    idConflicto INT,

    CONSTRAINT PK_ORGANIZADIALOGO PRIMARY KEY (idOrganizacion, idConflicto),
    CONSTRAINT FK_DialogaOrganizacion FOREIGN KEY (idOrganizacion) REFERENCES ORGANIZACIONES.ORGANIZACIONES(idOrganizacion) 
        ON DELETE CASCADE,
    CONSTRAINT FK_DialogaConflicto FOREIGN KEY (idConflicto) REFERENCES CONFLICTOS.CONFLICTO(idConflicto) 
        ON DELETE CASCADE
);

-- TABLA MEDIA
CREATE TABLE ORGANIZACIONES.MEDIA (
    idMedia INT,
    tipoAyuda VARCHAR(20),

    CONSTRAINT PK_ORGANIZACIONESMEDIA PRIMARY KEY (idMedia),
    CONSTRAINT CK_TIPOAYUDA CHECK (tipoAyuda IN ('Médica', 'Diplomática', 'Presencial'))
);

-- TABLA ARMA (ARMAS)
CREATE TABLE ARMAS.ARMA (
    codigoArma INT,
    tipo VARCHAR(100) UNIQUE NOT NULL,
    alcance INT NOT NULL,
    unidadAlcance VARCHAR(10) DEFAULT 'km',

    CONSTRAINT PK_codigoArma PRIMARY KEY (codigoArma),
    CONSTRAINT CK_alcanceArmas CHECK (unidadAlcance IN ('m', 'km'))
);

-- TABLA CATEGORIA ARMA
CREATE TABLE ARMAS.CATEGORIA (
    nombre VARCHAR(50),
    descripcion TEXT NOT NULL,

    CONSTRAINT PK_categoriaArmas PRIMARY KEY (nombre)
);

-- TABLA ARMA-CATEGORIA
CREATE TABLE ARMAS.ARMA_CATEGORIA (
    codigoArma INT,
    nombreCategoria VARCHAR(50),

    CONSTRAINT PK_armaCategoria PRIMARY KEY (codigoArma, nombreCategoria),
    CONSTRAINT FK_ArmaCategoria FOREIGN KEY (codigoArma) REFERENCES ARMAS.ARMA(codigoArma) 
        ON DELETE CASCADE,
    CONSTRAINT FK_Categoria FOREIGN KEY (nombreCategoria) REFERENCES ARMAS.CATEGORIA(nombre) 
        ON DELETE CASCADE
);

-- TABLA STOCK
CREATE TABLE TRAFICANTES.STOCK (
    codigoArma INT,
    cantidad INT NOT NULL,

    CONSTRAINT PK_stockTraficantes PRIMARY KEY (codigoArma),
    CONSTRAINT FK_StockArma FOREIGN KEY (codigoArma) REFERENCES ARMAS.ARMA(codigoArma) ON DELETE CASCADE
);

-- TABLA TRAFICANTE
CREATE TABLE TRAFICANTES.TRAFICANTE (
    idTraficante INT ,
    nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(50) NOT NULL,

    CONSTRAINT PK_TRAFICANTES PRIMARY KEY (idTraficante)
);

-- TABLA SUMINISTRA
CREATE TABLE TRAFICANTES.SUMINISTRA (
    idTraficante INT,
    codigoArma INT,
    cantidad INT NOT NULL,
    
    CONSTRAINT PK_suministraTraficantes PRIMARY KEY (idTraficante, codigoArma),

    CONSTRAINT FK_SuministraTraficante FOREIGN KEY (idTraficante) REFERENCES TRAFICANTES.TRAFICANTE(idTraficante) 
        ON DELETE CASCADE,
        
    CONSTRAINT FK_SuministraArma FOREIGN KEY (codigoArma) REFERENCES ARMAS.ARMA(codigoArma) 
        ON DELETE CASCADE
);
