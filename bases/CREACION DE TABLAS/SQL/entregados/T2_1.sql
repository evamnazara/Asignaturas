CREATE DATABASE BDCreateDB2
ON PRIMARY (
NAME = BDCreateDB2_Data,
FILENAME = 'C:\BDCreateDB2\BDCreateDB2_Data.mdf',
SIZE = 3MB, -- el tamaño minimo tiene que ser igual que el model
FILEGROWTH = 15%,
MAXSIZE = UNLIMITED) --pred

LOG ON (
NAME = BDCreateDB2_Log,
FILENAME = 'C:\BDCreateDB2\BDCreateDB2_Log.ldf',
SIZE = 2MB,
FILEGROWTH = 15%,
MAXSIZE = 5MB
);
