IF EXISTS (SELECT * FROM sys.databases WHERE name = 'BD_TiposUsuario1')
    BEGIN
    DROP DATABASE BD_TiposUsuario1;
    END 
    
CREATE DATABASE BD_TiposUsuario1

GO 
exec sp_helpdb BD_TiposUsuario1
GO 

USE BD_TiposUsuario1
GO

-- TipoCodigo Datos de tipo carácter de 10 caracteres

BEGIN
	IF EXISTS(Select * from sys.types where name='TipoCodigo') 
	DROP TYPE TipoCodigo
END
GO 

CREATE TYPE TipoCodigo from char (10) NULL 
Select * from sys.types where name='TipoCodigo'

GO

--TipoNum: Un número completo que no excederá 30000

BEGIN
	IF EXISTS(Select * from sys.types where name='TipoNum') 
	DROP TYPE TipoNum
END
GO 
--
CREATE TYPE TipoNum from char (3000) 
Select * from sys.types where name='TipoNum'
GO 

--TipoTelefono: Datos de tipo carácter de 9 caracteres que permita NULL
BEGIN
	IF EXISTS(Select * from sys.types where name='TipoTelefono') 
	DROP TYPE TipoTelefono
END
GO 



CREATE TYPE TipoTelefono from char (9) NULL 
Select * from sys.types where name='TipoTelefono'
GO 

--TipoNombreCorto: Datos de tipo caracteres variables de hasta 15 caracteres

BEGIN
	IF EXISTS(Select * from sys.types where name='TipoNombreCorto') 
	DROP TYPE TipoNombreCorto
END
GO 

CREATE TYPE TipoNombreCorto from varchar (15)  
Select * from sys.types where name='TipoNombreCorto'
GO 

--verificaciones

SELECT * FROM sys.types WHERE is_user_defined = 1;
GO

SELECT * FROM information_schema.domains 
GO

EXEC sp_helpdb 'BD_TiposUsuario1';
GO

EXEC sp_help 'TipoCodigo';
GO
