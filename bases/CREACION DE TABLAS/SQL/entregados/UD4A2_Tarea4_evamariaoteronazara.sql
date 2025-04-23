-- BEGIN / END

CREATE DATABASE Ventas
ON PRIMARY (
NAME = Ventas_root,
FILENAME = 'C:\Ventas\Ventas_root.mdf',
SIZE = 10MB,
FILEGROWTH = 15%,
MAXSIZE = 50MB
),


FILEGROUP grupo_clientes (
    NAME = cliente_data1,
    FILENAME = 'C:\Ventas\cliente_data1.ndf',
    SIZE = 10MB,
    FILEGROWTH = 15%,
    MAXSIZE = 50MB
    ), 

    (
    NAME = cliente_data2,
    FILENAME = 'C:\Ventas\cliente_data2.ndf',
    SIZE = 10MB,
    FILEGROWTH = 15%,
    MAXSIZE = 50MB
    ),
    (
    NAME = cliente_data3,
    FILENAME = 'C:\Ventas\cliente_data3.ndf',
    SIZE = 10MB,
    FILEGROWTH = 15%,
    MAXSIZE = 50MB
    ),



FILEGROUP grupo_producto (
        NAME = producto_data1,
        FILENAME = 'C:\Ventas\producto_data1.ndf',
        SIZE = 10MB,
        FILEGROWTH = 0 --el archivo no crece 
    ), 

    (
        NAME = producto_data2,
        FILENAME = 'C:\Ventas\producto_data2.ndf',
        SIZE = 10MB,
        FILEGROWTH = 0
    )

LOG ON (
        NAME = log_data1,
        FILENAME = 'C:\Ventas\log_data1.ldf',
        SIZE = 5MB,
        FILEGROWTH = 5MB,
        MAXSIZE = 25MB
    );
    

   -- EXEC sp_helpdb 'Ventas';  
