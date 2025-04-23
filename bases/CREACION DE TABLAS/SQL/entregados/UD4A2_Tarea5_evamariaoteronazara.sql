---- NOTAS DEBERES ----

--default!!
--5120kb - 5mb
--3072MB 
-- 


CREATE DATABASE DB_Ejemplo
ON PRIMARY (
NAME = 'DB_ejemplo6dat',
FILENAME = 'C:\DB_Ejemplo\DB_ejemplo6dat.mdf',
SIZE = 10MB,
FILEGROWTH = 15%,
MAXSIZE = 300MB
),
(
    NAME = 'DB_ejemplo6dat1',
    FILENAME = 'C:\DB_Ejemplo\DB_ejemplo6dat1.ndf',
    SIZE = 5MB,
    FILEGROWTH = 15%,
    MAXSIZE = 50MB
), 

--is default en select * from sys.filegroups 
FILEGROUP Grupo1DB_Ejemplo DEFAULT
(
    NAME = 'DB_ejemplo6dat2',
    FILENAME = 'C:\DB_Ejemplo\DB_ejemplo6dat2.ndf',
    SIZE = 20MB,
    FILEGROWTH = 15%,
    MAXSIZE = 50MB
),
(
    NAME = 'DB_ejemplo6dat3',
    FILENAME = 'C:\DB_Ejemplo\DB_ejemplo6dat3.ndf',
    SIZE = 10MB,
    FILEGROWTH = 15%,
    MAXSIZE = 50MB
),
FILEGROUP Grupo2DB_Ejemplo (
        NAME = 'DB2_ejemplo6dat3',
        FILENAME = 'C:\DB_Ejemplo\DB2_ejemplo6dat4.ndf',
        SIZE = 10MB,
        FILEGROWTH = 1MB
    ), 

(
        NAME = 'DB2_ejemplo6dat4',
        FILENAME = 'C:\DB_Ejemplo\DB2_ejemplo6dat5.ndf',
        SIZE = 10MB,
        FILEGROWTH = 18%
),

FILEGROUP Grupo3DB_Ejemplo (
        NAME = 'DB_ejemplo6dat5',
        FILENAME = 'C:\DB_Ejemplo\DB_ejemplo6dat6.ndf',
        SIZE = 10MB,
        FILEGROWTH = 1MB
),
(
        NAME = 'DB_ejemplo6dat7',
        FILENAME = 'C:\DB_Ejemplo\DB_ejemplo6dat7.ndf',
        SIZE = 10MB,
        MAXSIZE = UNLIMITED 
),
(
        NAME = 'DB_ejemplo6dat8',
        FILENAME = 'C:\DB_Ejemplo\DB_ejemplo6dat8.ndf',
        SIZE = 10MB,
        MAXSIZE = UNLIMITED
)

LOG ON (
        NAME = 'DB_Ejemplolog1',
        FILENAME = 'C:\DB_Ejemplo\DB_ejemplolog1.ldf',
        SIZE = 5MB,
        FILEGROWTH = 5MB,
        MAXSIZE = 25MB
    );
    
 exec sp_helpfilegroup
 
 select * from sys.filegroups
 
 select * from sys.database_files