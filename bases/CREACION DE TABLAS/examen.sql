--Eva María Otero Názara 
--DNI 77416510M

USE master 
GO 
IF EXISTS (SELECT * FROM SYS.databases WHERE name='RIOS')
BEGIN
	DROP DATABASE RIOS
END

CREATE DATABASE RIOS 

ON PRIMARY(	
	NAME = archivo_Data1,
    FILENAME = 'C:\exrios\archivo_Data1.mdf',
    SIZE = 20MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 0 ),
    
FILEGROUP Grupo1_info( 
	NAME = archivo_Sec1,
    FILENAME = 'C:\exrios\archivo_Sec1.ndf',
    SIZE = 10mb,
    MAXSIZE = unlimited,
    FILEGROWTH = 500KB 
    ),
( 
	NAME = archivo_Sec2,
    FILENAME = 'C:\exrios\archivo_Sec2.ndf',
    SIZE = 10mb,
    MAXSIZE = unlimited,
    FILEGROWTH = 500KB  
)

LOG ON( 
	NAME = archivo_log1,
    FILENAME = 'C:\exrios\archivo_log1.ldf',
    SIZE = 15MB,
    MAXSIZE = 30MB,
    FILEGROWTH = 3MB ) ;
GO

use RIOS

go 

ALTER DATABASE rios
	REMOVE FILE archivo_Sec2;
	
ALTER DATABASE rios 
	MODIFY FILEGROUP Grupo1_info DEFAULT;

exec sp_helpdb 'rios'

--EJERCICIO 2

--TABLA RIO 
GO 
IF EXISTS (SELECT * FROM SYS.tables WHERE name='RIOS')
BEGIN
	DROP table RIOS
END
 
create table Rio 
(
	Codigo smallint not null,
	Nombre varchar(30) not null,
	nacimiento varchar(40) null,
	Vertiente varchar(15)
		CONSTRAINT DF_VERTIENTE_RIO DEFAULT 'MEDITERRANEA',  
		-- check Mediterranea, Atlantica, Cantabra
	longitud float not null, 
	caudalAnual int not null,
	caudalTrimestral float not null,
	actividad varchar (20)NOT NULL,
	
	CONSTRAINT PK_RIOS PRIMARY KEY (Codigo),
	CONSTRAINT U_NOMBRERIO UNIQUE (Nombre),
	
	CONSTRAINT CK_CODIGORIO CHECK (Codigo LIKE '[0-9][0-9][0-9][R,A]'),
	CONSTRAINT CK_VERTIENTE_RIO CHECK (Vertiente IN ('Mediterranea', 'Atlantica', 'Cantabra')),
	CONSTRAINT CK_LONGITUDRIO CHECK (longitud > 20.5) ,
	CONSTRAINT CK_CAUDALANUAL CHECK (caudalAnual BETWEEN 10 AND 1000),
	CONSTRAINT CK_CAUDALTRIMESTRAL CHECK (caudalTrimestral = caudalAnual / 3)
	
);

exec sp_help 'rio'
exec sp_helpconstraint 'rio'

--TABLA TRAMO 

GO 
IF EXISTS (SELECT * FROM SYS.tables WHERE name='TRAMO')
BEGIN
	DROP table TRAMO
END

CREATE TABLE TRAMO (
	CodRio smallint not null,
	Numero smallint not null,
	kilometros float not null
		CONSTRAINT DF_KILOMETROS_TRAMO DEFAULT 2.5, 
	curso varchar (10) not null
		CONSTRAINT DF_CURSO_TRAMORIO DEFAULT 'medio',
	lugarInicio varchar(40) not null,
	lugarFin varchar(40)not null,
	
	CONSTRAINT PK_TRAMO PRIMARY KEY (CodRio,Numero),
	CONSTRAINT FK_TRAMO_RIO FOREIGN KEY (CodRio) references Rio(Codigo)
		on delete cascade
		on update cascade,
	
	CONSTRAINT CK_KILOMETROSTRAMO CHECK (kilometros BETWEEN 0.5 AND 10),
	CONSTRAINT CK_CURSO_TRAMORIO CHECK (curso IN ('alto', 'medio', 'bajo')),
	CONSTRAINT CK_LUGARFINTRAMO CHECK (lugarFin != lugarInicio)
)

exec sp_help 'TRAMO'
exec sp_helpconstraint 'TRAMO'


--TABLA ESPECIETRAMO

GO 
IF EXISTS (SELECT * FROM SYS.tables WHERE name='ESPECIETRAMO')
BEGIN
	DROP table ESPECIETRAMO
END

CREATE TABLE ESPECIETRAMO (
	CodRio smallint not null,
	Numero smallint not null,
	
	CONSTRAINT PK_ESPECIETRAMO PRIMARY KEY (CodRio,Numero),
	CONSTRAINT FK_ESPECIETRAMO_TRAMO FOREIGN KEY (CodRio,Numero) references TRAMO(CodRio,Numero)
		on delete cascade
		on update cascade,
)

exec sp_help 'ESPECIETRAMO'
exec sp_helpconstraint 'ESPECIETRAMO'


--TABLA ESPECIE 

GO 
IF EXISTS (SELECT * FROM SYS.tables WHERE name='ESPECIE')
BEGIN
	DROP table ESPECIE
END

CREATE TABLE ESPECIE (
	CodEspecie int IDENTITY (5,5) not null,
	Nombre varchar(45) not null,
	Comestible bit null,
	
	CONSTRAINT PK_ESPECIE PRIMARY KEY (CodEspecie),
)

GO

exec sp_help 'ESPECIETRAMO'
exec sp_helpconstraint 'ESPECIETRAMO'

 
ALTER TABLE ESPECIETRAMO 
	ADD codEspecie int not null,
	CONSTRAINT FK_ESPECIE_ESPECIETRAMO FOREIGN KEY (CodEspecie) references ESPECIE(CodEspecie)
		ON UPDATE CASCADE
		ON DELETE CASCADE;
go 

ALTER TABLE ESPECIETRAMO 
	DROP CONSTRAINT PK_ESPECIETRAMO;
go 

ALTER TABLE ESPECIETRAMO 
	add CONSTRAINT PK_ESPECIETRAMO primary key (CodRio,Numero,CodEspecie);
	go

exec sp_help 'ESPECIETRAMO'
exec sp_helpconstraint 'ESPECIETRAMO'


--ejercicio 3

--a) borrar curso de tramo 

--primero borrar sus restricciones
ALTER TABLE TRAMO 
	drop 
	constraint DF_CURSO_TRAMORIO, 
	constraint CK_CURSO_TRAMORIO;
go 


ALTER TABLE TRAMO 
	drop column curso;

exec sp_help 'TRAMO'
exec sp_helpconstraint 'TRAMO'

GO

--b) añadir afluentes a rio 

ALTER TABLE RIO 
	ADD 
	codAfluente smallint not null,
	CONSTRAINT FK_AFLUENTES_RIOS foreign key (codAfluente) references rio(Codigo)	
		ON UPDATE NO ACTION
		ON DELETE NO ACTION
			BEGIN
				PRINT 'El rio no puede borrarse ya que tiene afluentes' 
			END
;

exec sp_help 'RIO'
exec sp_helpconstraint 'RIO'
--c) modificar actividar del rio 

GO 

ALTER TABLE RIO 
	ADD 
--		CONSTRAINT DF_ACTIVIDAD_RIO DEFAULT 'estacional',
		CONSTRAINT CK_ACTIVIDAD_RIO CHECK (actividad IN ('perenne', 'estacional', 'transitorio'));

exec sp_help 'RIO'
exec sp_helpconstraint 'RIO'
		
-- EJERCICIO 4 

GO 
IF EXISTS (SELECT * FROM SYS.tables WHERE name='PLAYAFLUVIAL')
BEGIN
	DROP table PLAYAFLUVIAL
END

CREATE TABLE PLAYAFLUVIAL (
	codPlaya smallint IDENTITY (1,5) not null,
	CodRio smallint not null,
	Numero smallint not null,
	nombrePlaya varchar (20) not null,
	caracteristicas varchar (120) null,
	phAgua float
		CONSTRAINT DF_PHAGUA_PLAYAFLUVIAL DEFAULT 7.5,
	servicios varchar(100),
	
	fechaUltimaInspeccion datetime
		CONSTRAINT DF_PLAYAFLUVIAL_FECHAULTIMAINSPECCION DEFAULT (DATEDIFF (MONTH, GETDATE(),-2)),
	CONSTRAINT PK_PLAYAFLUVIAL PRIMARY KEY (codPlaya,CodRio,Numero),
	CONSTRAINT FK_PLAYAFLUVIAL_TRAMO FOREIGN KEY (CodRio,Numero) references TRAMO(CodRio,Numero)
		on delete cascade
		on update cascade,
		
	CONSTRAINT CK_PHAGUA_PLAYAFLUVIAL CHECK (phagua >= 4 and phagua <= 9)

)
GO

exec sp_help 'playafluvial'
exec sp_helpconstraint 'playafluvial'
