--las restricciones default van a nivel de columna 
--si algo da error, por ejemplo reflexivas o que referencien una reflexiva
    on delete no action
    on update no action

--nombre y esquema
if exists (
	select * FROM sys.tables WHERE name = 'lider'
	AND SCHEMA_ID = SCHEMA_ID('GRUPOS')
)
GO 
create blablabababa

EXEC sp_helpdb
EXEC sp_helpfilegroup
exec sp_helpconstraint 'Conflictos.Racial'

	select * from sys.filegroups
	SELECT * from SYS.data_spaces
	select * from sys.database_files

--tabla organizaciones.media 
    DEFAULT DATEADD(MM,2,GETDATE())

-- CALCULO DE DIFERENCIAS
DATEDIFF (YEAR, fechaNaciMiento, GETDATE())  >= 18 ANd
		(MONTH (GETDATE()) > MONTH(fechaNaciMiento)  
		OR 
			MONTH (GETDATE() = MONTH(fechaNaciMiento) 
			and DAY(GETDATE()) >= DAY(fechaNaciMiento))
)

datediff (YEAR, getdate(), fechaNacimiento / 365,25 >= 18);