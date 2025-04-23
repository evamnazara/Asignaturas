--sin acabar!! 


use master

IF EXISTS (SELECT * FROM SYS.databases WHERE name = 'BDFOTOGRAFIA')
	BEGIN
		DROP DATABASE BDFOTOGRAFIA
	END
GO 

CREATE DATABASE BDFOTOGRAFIA

ON PRIMARY (
	NAME = ArchivoPrincipal,
    FILENAME = 'C:\ArquivosBD\BDFotografia\ArchivoPrincipal.mdf',
    SIZE = 15 MB,
	FILEGROWTH = 0
),

FILEGROUP Datos_Fotografía DEFAULT (
    NAME='datosFotos1',
    FILENAME='C:\ArquivosBD\BDFotografia\datosFotos1.ndf',
    SIZE= 10 MB, 
	FILEGROWTH = 10%, 
    MAXSIZE = 50 MB  
),
(
    NAME='datosfotos2',
    FILENAME='C:\ArquivosBD\BDFotografia\datosfotos2.ndf',
    SIZE= 10 MB,
    FILEGROWTH = 10%, 
    MAXSIZE = 50MB
)

GO 
USE BDFOTOGRAFIA
GO

EXEC sp_helpdb 

create table exposiciones (
    codExposicion smallint IDENTITY (1,5),
    nombreExposicion char(30) UNIQUE,
    descripcion varchar(50),
    tematica varchar(50),

    CONSTRAINT PK_EXPOSICIONES PRIMARY KEY (codExposicion),
    CONSTRAINT CK_TEMATICA CHECK 
		(tematica IN ('naturaleza', 'gentes', 'fiestas', 'tradiciones', 'espacios', 'edificios', 'deportes'))

);

create table centros (
	codCentro varchar(5),	
	nombreCentro varchar(30) NOT NULL ,
	--FALTA PONER EL DEFAULT DE DFECHA HACE DOS AÑOS
	fechainauguración DATE,
	mCuadrados float,
	telefono varchar(9),
	páginaWeb varchar(30) NULL,
	direccion varchar(30) NOT NULL,
	localidad varchar(40) NOT NULL,
	
	CONSTRAINT PK_CENTRO PRIMARY KEY (codCentro),
	CONSTRAINT U_NOMBRECENTRO UNIQUE (nombreCentro),
	
	CONSTRAINT CK_CODIGOCENTRO CHECK (codCentro LIKE '[A-Z]-[0-9][0-9][0-9]'),
    CONSTRAINT CK_TELEFONO CHECK (telefono LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);

create table provincia (
	codProvincia smallint IDENTITY (1,1),
	nombreProvincia varchar(40),
	
	
	CONSTRAINT PK_PROVINCIA PRIMARY KEY (codProvincia),
	CONSTRAINT U_NOMBREPROVINCIA UNIQUE (nombreProvincia),
);

create table localidad (
	codLocalidad smallint IDENTITY (1,1),
	nombreLocalidad varchar(40),
	paginaWeb varchar(70),
	numHabitantes int,
	provincia smallint,
	
	 
	CONSTRAINT PK_LOCALIDAD PRIMARY KEY (codLocalidad),
	CONSTRAINT U_NOMBRELOCALIDAD UNIQUE (nombreLocalidad),
	
	CONSTRAINT MINIMO_HABITANTES CHECK (numHabitantes > '1000'),
	CONSTRAINT FK_PROVINCIA_LOCALIDAD FOREIGN KEY (provincia)
		REFERENCES Provincia(codProvincia),
	constraint d_habitantes CHECK (numHabitantes = '5000')
	
);
go
exec sp_help
go

exec sp_helpconstraint 'provincia'



create table sala (
	numSala int,
	centro varchar(5), --FORANEA
	mCuadrados float,
	
	--no menos de 20 m2 ni mayores de 1000 m2 y por defecto 100 m2
);

--CREATE TABLE FOTOGRAFIA ();


--cosas de fotógrafos y las fotografía en Primary
-- resto de las tablas en Datos_fotografía

DATEDIFF (YEAR, fechaNaciMiento, GETDATE())  >= 18 ANd
		(MONTH (GETDATE()) > MONTH(fechaNaciMiento)  
		OR 
			MONTH (GETDATE() = MONTH(fechaNaciMiento) 
			and DAY(GETDATE()) >= DAY(fechaNaciMiento))
)