use EMPRESANEW2
go

--Antes de crear objeto comprueba su existencia. Si existe se borra para volver a crearlo de nuevo.

--ejercicio a)

--Crea un campo en la tabla Empregados para almacenar el número de proyectos de un empleado. Como hay filas existentes que tome el valor nulo.

alter table empregado 
	add numeroProyectos smallint null
go 


--Crea un procedimiento llamado pr_ActulizarNumproy que se le pase el nss de un empleado y actualice el número de proyectos de dicho empleado. Debe devolver en un parámetro de salida el número de proyectos.  Se controlará los posibles errores, devolviendo -1 si no existe el empleado y 0 si existe.


if OBJECT_ID('pr_ActulizarNumproy') is not null 
	drop procedure pr_ActulizarNumproy
go 

create procedure pr_ActulizarNumproy
	@nssempregado varchar(10),
	@numProyectos smallint output
as
begin

	if not exists (select * from EMPREGADO where NSS = @nssempregado)
		return -1
	
	set @numProyectos = (
					select COUNT(*) from EMPREGADO_PROXECTO 
					where NSSEmpregado = @nssempregado	)
		return 0 
	
	update EMPREGADO 
		set numeroProyectos = @numProyectos where NSS = @nssempregado
	
	select nss,numeroProyectos from EMPREGADO where NSS = @nssempregado
end
go

--exec pr_ActulizarNumproy(nss)

--Crea un procedimiento llamado pr_ActualizarTodosNumproy  para actualizar el número de proyectos de todos los empleados de la empresa. Se deberá utilizar el anterior procedimiento.

if OBJECT_ID('pr_ActualizarTodosNumproy') is not null 
	drop procedure pr_ActualizarTodosNumproy
go


create procedure pr_ActualizarTodosNumproy
	@nomeEmpregado varchar(10),
	@numProyectos smallint,
	@nssEmpregado varchar(15)
	
as
begin 
	declare cursor_empleado cursor static 
	for (select nss, nome + ' ' + apelido1 + ' ' + isnull(apelido2,'')from empregado)
	declare @nss varchar(15),
			@nombre varchar(50),
			@numeroProyectos smallint
	open cursor_empleado
	
	fetch next from cursor_empleado
		into @nss,@nombre
	
	while (@@FETCH_STATUS = 0)
		begin
			exec pr_ActulizarNumproy 
			@nss, @numeroProyectos output 
			
			print 'empleado ' + @nombre + 'participa en ' + cast (@numeroProyectos as varchar(2)) + ' proyectos.'
			
		end
		close cursor_empleado
		deallocate cursor_empleado 


end
go

	
--b)

--Crea un procedimiento llamado pr_CrearEdicion, que se le pasa el nombre del curso, lugar, fecha, profesor y cree una nueva edición del curso. En un valor de retorno se informará del existo o no (-1 si no existe en curso, -2  no existe el profesor y 0 se ha creado correctamente). Si no se le pasa la fecha por defecto será dentro de un mes y si no se le pasa el lugar por defecto será Vigo

if OBJECT_ID('pr_CrearEdicion') is not null
	drop procedure pr_CrearEdicion 
go  

create procedure pr_CrearEdicion 
	@nombreCurso varchar (50),
	@lugarcurso varchar (30),
	@profesorCurso varchar(50) = null,
	@nuevafecha date = null

as
begin 
	declare 
		@nombre varchar (50),
		@lugar varchar (30) = 'Vigo', 
		@profesor varchar(50),
		@fecha date = datediff(MONTH,1,getdate()) --en un mes
	
	select @nombre 
end
go

--Se quiere crear un procedimiento llamado pr_CrearModificarCurso, que permita dar de alta un curso o modificar uno existente junto a una nueva edicion. Hay que tener en cuenta:
--Los parámetros que se le pasa son el nombre del curso, horas, lugar, fecha, profesor, nombreDepartamento.
--Si existe el curso se actualizan el número de horas y sino se crea el curso siguiendo siguiendo la numeracion en el código.
--Se crea una nueva edición, utilizando el procedimiento anterior.
--Y los alumnos será los empleados del departamento introducido.
--Hay que controlar los posibles errores con un parámetro de retorno.
--Utiliza transacciones explicitas si es el caso.
--Se visualizar un listado con el siguiente formato
--En el listado, para obtener el nombre completo del empleado que recibe el curso se hará con una función y también para obtener edad y el número total de  alumnos del curso
--Si es un nuevo curso :

--  Nuevo curso: XXXXXXXX    codigo: XXX   horas: XXXXXX     

--y si existe 

-- Nuevo curso: XXXXXXXX    codigo: XXX  modificadas  horas: XXXXXX

--A continuación informacion de la edición con el siguiente formato

--Edicion: XX     lugar: XXXXXX  fecha:  dd de XXXXX de aaaa  profesor: XXXXXXXX  ( nombre completo)

--Alumnos del departamento XXXXXXXXXX:

--                   nombre                         edad

--__________________________________________________________

--XXXXXX   XXXXXX    XXXXXX             XX

--XXXXXX   XXXXXX   XXXXXXX            XX

--------------------------------------------

--total alumnos:   XXXXXX