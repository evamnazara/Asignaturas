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

use CONFLICTOSBELICOS 
go 

--comprobacion de creación
--innecesario el 1 ig 
select * from sys.schemas where principal_id=1 and name!='dbo'
select * from INFORMATION_SCHEMA.SCHEMATA
go

--tipo fecha
CREATE TYPE fecha FROM date;
go

SELECT * from sys.types where is_user_defined=1


GO
---jeje
if exists (
	select * FROM sys.tables WHERE name = 'RACIAL'
	AND SCHEMA_ID = SCHEMA_ID('Conflictos')
)
DROP TABLE CONFLICTOS.racial;
GO 

CREATE TABLE CONFLICTOS.RACIAL (
	CODIGOCONFLICTO SMALLINT,
	ETNIA VARCHAR(20)
	
	CONSTRAINT PK_RACIAL_CODCONFLICTO PRIMARY KEY (CODIGOCONFLICTO)
)

GO
---jeje
if exists (
	select * FROM sys.tables WHERE name = 'TERRITORIAL'
	AND SCHEMA_ID = SCHEMA_ID('Conflictos')
)
DROP TABLE CONFLICTOS.TERRITORIAL;
GO 

CREATE TABLE CONFLICTOS.Territorial (
	CODIGOCONFLICTO SMALLINT,
	ETNIA VARCHAR(20)
	
	CONSTRAINT PK_Territorial_CODCONFLICTO PRIMARY KEY (CODIGOCONFLICTO)
)

GO
---jeje
if exists (
	select * FROM sys.tables WHERE name = 'RELIGIOSO'
	AND SCHEMA_ID = SCHEMA_ID('Conflictos')
)
DROP TABLE CONFLICTOS.RELIGIOSO;
GO 

CREATE TABLE CONFLICTOS.Religioso (
	CODIGOCONFLICTO SMALLINT,
	ETNIA VARCHAR(20)
	
	CONSTRAINT PK_Religioso_CODCONFLICTO PRIMARY KEY (CODIGOCONFLICTO)
)

GO
---jeje
if exists (
	select * FROM sys.tables WHERE name = 'ECONOMICO'
	AND SCHEMA_ID = SCHEMA_ID('Conflictos')
)
DROP TABLE CONFLICTOS.ECONOMICO;
GO 


CREATE TABLE CONFLICTOS.Economico (
	CODIGOCONFLICTO SMALLINT,
	MATERIASPRIMAS VARCHAR(20)
	
	CONSTRAINT PK_Economico_CODCONFLICTO PRIMARY KEY (CODIGOCONFLICTO)
)

go

if exists (
	select * FROM sys.tables WHERE name = 'CONFLICTO'
	AND SCHEMA_ID = SCHEMA_ID('Conflictos')
)
DROP TABLE CONFLICTOS.CONFLICTO;
GO

CREATE TABLE CONFLICTOS.CONFLICTO (
    idConflicto SMALLINT,
    nombre VARCHAR(100) NOT NULL,
    causa VARCHAR(20),
    Muertos int,
    heridos int,
    fechaInicio fecha,
    fechaFin DATETIME NULL DEFAULT NULL,
    codigoPais INT,

    CONSTRAINT pk_CONFLICTO PRIMARY KEY (idConflicto),
    --CONSTRAINT FK_ConflictoPais FOREIGN KEY (codigoPais) REFERENCES PAIS(codigoPais) 
    --    ON DELETE SET NULL,
    CONSTRAINT ck_causaConflicto CHECK (causa IN ('Racial', 'Territorial', 'Religioso', 'Economico'))
)

GO

--clacves foraneas  xd

ALTER TABLE CONFLICTOS.RACIAL 
	add constraint fk_racial_conflictos FOREIGN KEY (codigoconflicto) REFERENCES Conflictos.conflicto
			ON DELETE CASCADE
			ON UPDATE CASCADE 
			
go 

ALTER TABLE CONFLICTOS.TERRITORIAL 
	add constraint fk_TERRITORIAL_conflictos FOREIGN KEY (codigoconflicto) REFERENCES Conflictos.conflicto
			ON DELETE CASCADE
			ON UPDATE CASCADE 
			
go 

ALTER TABLE CONFLICTOS.RELIGIOSO 
	add constraint fk_RELIGIOSO_conflictos FOREIGN KEY (codigoconflicto) REFERENCES Conflictos.conflicto
			ON DELETE CASCADE
			ON UPDATE CASCADE 
			
go 

ALTER TABLE CONFLICTOS.ECONOMICO 
	add constraint fk_ECONOMICO_conflictos FOREIGN KEY (codigoconflicto) REFERENCES Conflictos.conflicto
			ON DELETE CASCADE
			ON UPDATE CASCADE 
			
go 


exec sp_helpdb

exec sp_helpconstraint 'Conflictos.Racial'
exec sp_helpconstraint 'Conflictos.Territorial'
exec sp_helpconstraint 'Conflictos.Religioso'
exec sp_helpconstraint 'Conflictos.Economico'

GO
if exists (
	select * FROM sys.tables WHERE name = 'GRUPO'
	AND SCHEMA_ID = SCHEMA_ID('grupos')
)
DROP TABLE grupos.GRUPO
GO

CREATE TABLE GRUPOS.GRUPO (
    codigoGrupo INT,
    nombreGrupo VARCHAR(100) NOT NULL
    
    CONSTRAINT PK_GRUPOSGRUPOS PRIMARY KEY (codigogrupo)
);

--grupo interviene 
GO
if exists (
	select * FROM sys.tables WHERE name = 'INTERVIENE'
	AND SCHEMA_ID = SCHEMA_ID('grupos')
)
DROP TABLE grupos.INTERVIENE
GO

CREATE TABLE GRUPOS.INTERVIENE (
    idConflicto SMALLINT,
    codigoGrupo INT,
	fechaInicio FECHA 
	
	CONSTRAINT DF_INTERVIENE_FECHAIMNICIO DEFAULT GETDATE(),
	
    CONSTRAINT PK_GruposInterviene PRIMARY KEY (idConflicto, codigoGrupo),
    
    CONSTRAINT FK_IntervieneConflicto FOREIGN KEY (idConflicto) REFERENCES CONFLICTOS.CONFLICTO(idConflicto) 
        ON DELETE CASCADE,
        
    CONSTRAINT FK_IntervieneGrupo FOREIGN KEY (codigoGrupo) REFERENCES GRUPOS.GRUPO(codigoGrupo) 
		ON DELETE CASCADE
);

GO
if exists (
	select * FROM sys.tables WHERE name = 'DIVISION'
	AND SCHEMA_ID = SCHEMA_ID('grupos')
)
DROP TABLE grupos.DIVISION
GO

CREATE TABLE GRUPOS.DIVISION (
);
