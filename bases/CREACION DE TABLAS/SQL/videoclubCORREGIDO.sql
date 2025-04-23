--VIDEOCLUB 
USE master;

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'Videoclub')
    BEGIN
    	DROP DATABASE Videoclub;
    END 
GO
    
CREATE DATABASE Videoclub

ON PRIMARY (
	NAME = 'ArchivoPrincipal',
    FILENAME = 'C:\Videoclub\ArchivoPrincipal.ndf',
    SIZE = 5MB,
    FILEGROWTH = 2MB
),

FILEGROUP Datos_Peliculas DEFAULT (
	NAME = 'datosPeliculas1',
	FILENAME = 'C:\Videoclub\datosPeliculas1.mdf',
	SIZE = 20MB,
	FILEGROWTH = 10%,
	MAXSIZE = 60MB
),
(
	NAME = 'datosPeliculas2',
	FILENAME = 'C:\Videoclub\datosPeliculas2.mdf',
	SIZE = 20MB,
	FILEGROWTH = 10%,
	MAXSIZE = 60MB
)


GO

USE Videoclub;

GO

CREATE TYPE Nacionalidad FROM VARCHAR(15) NOT NULL;
CREATE TYPE Fecha FROM SMALLDATETIME NOT NULL; 

-- PELICULA
IF OBJECT_ID('PELICULA') IS NOT NULL
    DROP TABLE Socios;
GO

CREATE TABLE PELICULA (
    IdPelicula CHAR(7)not null, 
    Titulo VARCHAR(20),
    AñoProduccion SMALLINT,
    Genero VARCHAR(15),
    Duracion SMALLINT,
    Nacionalidad Nacionalidad,
    CodCategoria TINYINT,

	CONSTRAINT PK_Pelicula_IDPelicula PRIMARY KEY (IDPelicula),
	CONSTRAINT U_Pelicula_Titulo UNIQUE (Titulo, AñoProduccion),
	
	CHECK (IdPelicula LIKE '[PF][AEIOU]-[0-9][0-9][0-9][0-9]'),
	
	--integridad referencial : tiene que ser el mismo tipo en un sitio y en otro (claves foraneas a su tabla) 
	
    FOREIGN KEY (CodCategoria) REFERENCES CATEGORIA(CodCategoria) 
			ON UPDATE CASCADE 
			-- puede ponerse cascada , pero no siempre ->
			ON DELETE NO ACTION
) ON Datos_Peliculas;


--EJEMPLAR

IF OBJECT_ID('EJEMPLAR') IS NOT NULL
    DROP TABLE EJEMPLAR;
GO

CREATE TABLE EJEMPLAR (
    IdPelicula CHAR(7),
    IdEjemplar TINYINT,
    Estado CHAR(1) not null constraint Ejemplar_Estado DEFAULT 'B' 
		CHECK (Estado IN ('B', 'R', 'M')),

    FechaDeCompra Fecha DEFAULT (DATEADD(DAY, -2, GETDATE())),    
    
    --poner nombre! 
    
    CONSTRAINT PK_Ejemplar_IDPelicula PRIMARY KEY (IDPelicula, IDEjemplar),
    CONSTRAINT FK_Ejemplar_Pelicula FOREIGN KEY (IdPelicula) REFERENCES PELICULA(IdPelicula) 
			ON DELETE CASCADE 
			ON UPDATE CASCADE
)ON Datos_Peliculas;

--  SOCIO

IF OBJECT_ID('SOCIO') IS NOT NULL
    DROP TABLE SOCIO;
GO

CREATE TABLE SOCIO (
    Numero SMALLINT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    DNI CHAR(9) not null 
		CONSTRAINT U_SOCIOS UNIQUE 
		
		CONSTRAINT ck_socios 
		CHECK (DNI LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Za-z]'),
    Nombre VARCHAR(20),
    Apellidos VARCHAR(20),
    Direccion VARCHAR(30),
    Telefono CHAR(9) 
		CHECK (Telefono LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
)ON[PRIMARY]

GO

-- ALQUILER 
IF OBJECT_ID('ALQUILER') IS NOT NULL
    DROP TABLE ALQUILER;
GO

CREATE TABLE ALQUILER (
    IdEjemplar TINYINT not null,
    IdPelicula CHAR(7) not null,
    FechaAlq Fecha DEFAULT GETDATE(),
    NumeroSocio SMALLINT,
    FechaEstimadaDev AS DATEADD(DAY, 15, FechaAlq),
    FechaDev Fecha NULL,
    
    CONSTRAINT PK_Alquiler_IDPeliculaIDEjemplar PRIMARY KEY (IdEjemplar, IdPelicula, FechaAlq),
				
    CONSTRAINT FK_AlquilerEjemplar FOREIGN KEY (IdEjemplar, IdPelicula) 
	REFERENCES EJEMPLAR(IdEjemplar, IdPelicula) 
			ON DELETE CASCADE 
			ON UPDATE CASCADE,
    
    
    CONSTRAINT FK_SocioAlquila FOREIGN KEY (NumeroSocio) 
    REFERENCES SOCIO(Numero) 
			ON DELETE CASCADE 
			ON UPDATE CASCADE,
			
	CONSTRAINT CK_FechaAlquiler CHECK (FechaDev >= FechaAlq)
	
)on Datos_Peliculas;

-- ACTOR 
IF OBJECT_ID('ACTOR') IS NOT NULL
    DROP TABLE ACTOR;
GO

CREATE TABLE ACTOR (
    Nombre VARCHAR(25),
    IDPelicula CHAR(7) not null,
    Nacionalidad Nacionalidad,
    Sexo CHAR(1) DEFAULT 'M' 
		
	CONSTRAINT pk_actor PRIMARY KEY (IDPelicula, nombre),
	--CONSTRAINT fk_actor_pelicula FOREIGN KEY 
	--REFERENCES PELICULA(IDPelicula),
	
	CONSTRAINT CK_SexoActor CHECK (Sexo IN ('H', 'M')),
);

--FAMILIAR
IF OBJECT_ID('FAMILIAR') IS NOT NULL
    DROP TABLE FAMILIAR;
GO

CREATE TABLE FAMILIAR (
    DNI CHAR(9) PRIMARY KEY 
		CHECK (DNI LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Za-z]'),
    Nombre VARCHAR(60),
    Parentesco VARCHAR(15),
    FechaNacimiento Fecha,
    NumeroSocio SMALLINT,

    CONSTRAINT FK_NumSocioFamiliar FOREIGN KEY (NumeroSocio) REFERENCES SOCIO(Numero) 
			ON DELETE CASCADE 
			ON UPDATE CASCADE
			--TIENE SENTIDO si se borra el socio se borra el familiar
			--si no, hay que borrar todos los familiares de un socio antes de poder borrarlo a el 
)ON [PRIMARY];


-- ACTUA 
IF OBJECT_ID('ACTUA') IS NOT NULL
    DROP TABLE ACTUA;
GO
CREATE TABLE ACTUA (
    NombreActor VARCHAR(25),
    IdPelicula CHAR(7),
    PrincSec CHAR(1) DEFAULT 'P' CHECK (PrincSec IN ('P', 'S')),
    PRIMARY KEY (NombreActor, IdPelicula),

    FOREIGN KEY (NombreActor) REFERENCES ACTOR(Nombre) 
			ON DELETE NO ACTION 
			ON UPDATE NO ACTION,
    FOREIGN KEY (IdPelicula) REFERENCES PELICULA(IdPelicula) 
			ON DELETE CASCADE 
			ON UPDATE CASCADE
) ON Datos_Peliculas;



-- DIRECTOR 
IF OBJECT_ID('DIRECTOR') IS NOT NULL
    DROP TABLE DIRECTOR;
GO

CREATE TABLE DIRECTOR (
    Nombre VARCHAR(25) PRIMARY KEY,
    Nacionalidad Nacionalidad
);

-- DIRIGE 
IF OBJECT_ID('DIRIGE') IS NOT NULL
    DROP TABLE DIRIGE;
GO

CREATE TABLE DIRIGE (
    IdPelicula CHAR(7),
    NombreDirector VARCHAR(25),
    PRIMARY KEY (IdPelicula, NombreDirector),

    FOREIGN KEY (IdPelicula) REFERENCES PELICULA(IdPelicula) 
			ON DELETE CASCADE 
			ON UPDATE CASCADE,
    FOREIGN KEY (NombreDirector) REFERENCES DIRECTOR(Nombre) 
			ON DELETE NO ACTION 
			ON UPDATE NO ACTION --?
);


-- CATEGORIA 
IF OBJECT_ID('CATEGORIA') IS NOT NULL
    DROP TABLE CATEGORIA;
GO

CREATE TABLE CATEGORIA (
    CodCategoria TINYINT IDENTITY(1,5) PRIMARY KEY,
    Precio MONEY,
    Descripcion VARCHAR(30)
    
    CONSTRAINT ck_precio CHECK (Precio >= 1 AND Precio <= 300),
    
);
--se añade la clave foranea que faltaba 

ALTER TABLE PELICULA 
	ADD CONSTRAINT FK_PeliculaCategoria FOREIGN KEY REFERENCES CATEGORIA(CodCategoria) 
	ON UPDATE CASCADE
	ON DELETE NO ACTION;


-- + modificaciones

--cambiar el valor del alquiler por defecto 

ALTER TABLE ALQUILER 
	ADD PrecioAlquiler 
	MONEY NOT NULL 
	CONSTRAINT DF_Alquiler_PrecioAlquiler DEFAULT 4 WITH VALUES;

ALTER TABLE ALQUILER 
	ADD CONSTRAINT DF_FechaAlquiler DEFAULT getdate();

ALTER TABLE ALQUILER 
	ADD CONSTRAINT DF_SOCIOFECHAALTA DEFAULT getdate();

-- 5a) DISTRIBUIDORA

exec sp_help 'alquiler' 


CREATE TABLE DISTRIBUIDORA (
    IdDistribuidora TINYINT IDENTITY(1,1),
    Nombre VARCHAR(20) UNIQUE,
    Direccion VARCHAR(50),
    Fax CHAR(9) NULL ,
    Email VARCHAR(60) NULL
    
    constraint pk_DISTRIBUIDORA PRIMARY KEY (IDDistribuidora),
    constraint ck_fax CHECK (Fax LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
);

ALTER TABLE PELICULA 
	ADD CONSTRAINT FK_DistribuidoraPelicula FOREIGN KEY 
	REFERENCES DISTRIBUIDORA(IdDistribuidora) 
	ON UPDATE CASCADE 
	ON DELETE NO ACTION;

CREATE TABLE RECOMENDACION (
    NumeroSocio SMALLINT,
    SocioRecomendado SMALLINT,
    PRIMARY KEY (NumeroSocio, SocioRecomendado),

    FOREIGN KEY (NumeroSocio) REFERENCES SOCIO(Numero) 
				ON DELETE SET NULL 
				--ON UPDATE CASCADE,
				ON UPDATE NO ACTION,
				
    FOREIGN KEY (SocioRecomendado) REFERENCES SOCIO(Numero) 
				ON DELETE SET NULL 
				--ON UPDATE CASCADE
				ON UPDATE NO ACTION
				
);
--si no deja, poner noaction

--6
ALTER TABLE PELICULA NOCHECK CONSTRAINT ALL;
ALTER TABLE ALQUILER NOCHECK CONSTRAINT ALL;

ALTER TABLE PELICULA CHECK CONSTRAINT ALL;
ALTER TABLE ALQUILER CHECK CONSTRAINT ALL;
