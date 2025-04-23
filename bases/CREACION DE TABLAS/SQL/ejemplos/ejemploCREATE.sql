CREATE DATABASE Ejemplo

ON PRIMARY ( 
    NAME=Ejemplo_data,
    FILENAME= 'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\Ejemplo.mdf',
    SIZE=10MB,
    MAXSIZE=15MB,
    FILEGROWTH=20%
    )


LOG ON (
    NAME=Ejemplo_log,
    FILENAME= 'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\
    MSSQL\DATA\Ejemplo.ldf',
    SIZE=3MB,
    MAXSIZE=5MB,
    FILEGROWTH=1MB 
    )

IF DB_ID ('VENTAS') IS NOT NULL

DROP DATABASE VENTAS;
GO

CREATE DATABASE VENTAS
ON PRIMARY 
( 
    NAME = 'ventas_dat',
    FILENAME ='C:\ventas\ventasdat.mdf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 15% 
    ),
    

( NAME = 'ventas1_dat',
FILENAME = 'C:\ventas\ventasdat1.ndf',
 SIZE = 10,
MAXSIZE = 50,
FILEGROWTH = 15%),
FILEGROUP Grupo1Ventas
 ( NAME = 'Ventas2_dat',
FILENAME = 'C:\ventas\ventasdat2.ndf',
SIZE = 10,
MAXSIZE = 50,
FILEGROWTH = 5 ),
 ( NAME = 'ventas3_dat',
FILENAME = 'C:\ventas\ventasdat3.ndf',
 SIZE = 10,
 MAXSIZE = 50,
FILEGROWTH = 5 ),
FILEGROUP Grupo2Ventas
 ( NAME = 'ventas4_dat',
FILENAME = 'C:\ventas\ventasdat4.ndf',
SIZE = 10,
MAXSIZE = 50,
FILEGROWTH = 5 ),
 ( NAME = 'ventas5_dat',
FILENAME = 'C:\ventas\ventasdat5.ndf',
SIZE = 10,
MAXSIZE = 50,
FILEGROWTH = 5 )
LOG ON
 ( NAME = 'Ventas_log',
FILENAME = 'C:\ventas\ventaslog.ldf',
SIZE = 5MB,
 MAXSIZE = 25MB,
FILEGROWTH = 5MB )