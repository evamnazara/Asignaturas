IF DB
_
ID ('VIDEOJUEGOS') IS NOT NULL
DROP DATABASE VIDEOJUEGOS;
GO
CREATE DATABASE VIDEOJUEGOS
ON PRIMARY
(
NAME = 'videojuegos1
_
dat'
,
FILENAME ='C:\basedatos\videojuegos\videojuegosdatos1.mdf'
,
SIZE = 10MB,
MAXSIZE = 50,
FILEGROWTH = 15%
),
(
NAME = 'videojuegos2
_
dat'
,
FILENAME = 'C:\basedatos\videojuegos\videojuegosdatos2.ndf'
,
SIZE = 20MB,
FILEGROWTH = 2
),
FILEGROUP Grupo1Videojuego
(
NAME = 'videojuegos3
_
dat'
,
FILENAME = 'C:\basedatos\videojuegos\videojuegosdatos3.ndf'
,
SIZE = 15,
MAXSIZE = 40,
FILEGROWTH = 10
),
(
NAME = 'videojuegos4
_
dat'
,
FILENAME = 'C:\basedatos\videojuegos\videojuegosdatos4.ndf'
,
SIZE = 25,
FILEGROWTH = 0
),
FILEGROUP Grupo2Videojuego
(
NAME = 'videojuegos5
_
dat'
,
FILENAME = 'C:\basedatos\videojuegos\videojuegosdatos5.ndf'
)
LOG ON
(
NAME = 'videojuegos1
_
log'
,
FILENAME = 'C:\basedatos\videojuegos\videojuegoslog1.ldf'
,
SIZE = 15MB,
MAXSIZE = 100MB,
FILEGROWTH = 15MB
),
(
NAME = 'videojuegos2
_
log'
,
FILENAME = 'C:\basedatos\videojuegos\videojuegoslog2.ldf'
)