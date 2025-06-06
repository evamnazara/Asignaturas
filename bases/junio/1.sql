use EMPRESANEW2
go 

--procedimiento pr_CrearEdicion
--se le pasa el nombre del curso, lugar, fecha, profesor y cree una nueva edición del curso. 
--En un valor de retorno se informará del existo o no (-1 si no existe en curso, -2  no existe el profesor y 0 se ha creado correctamente). 
--Si no se le pasa la fecha por defecto será dentro de un mes y si no se le pasa el lugar por defecto será Vigo

if OBJECT_ID('pr_CrearEdicion') is not null
	drop procedure pr_CrearEdicion
go

create procedure pr_CrearEdicion
	@nomeCurso varchar(30),
	@lugar varchar(25) = null,
	@fecha date = null,
	@profesor varchar(15)
as
begin
	if not exists (select 1 from CURSO where Nome = @nomeCurso) 
		return -1
	
	if not exists (select 1 from EMPREGADO where NSS=@profesor)
		return -2  
		
	if @fecha is null 
		set @fecha = DATEADD(MM,1,GETDATE())
	
	if @lugar is null 
		set @lugar = 'Vigo'
		
	insert into EDICION
		values (
		(select e.codigo from EDICION e 
				inner join CURSO c on c.Codigo = e.Codigo 
				where c.Nome = @nomeCurso),
		(select max(e.numero) + 1 from EDICION e 
				inner join CURSO c on c.Codigo = e.Codigo
				where c.Nome = @nomeCurso),
		@fecha,
		@lugar,
		@profesor
		) 

end
go
--select * from CURSO 
--select * from EMPREGADO
--select * from edicion

--exec pr_CrearEdicion 'Ciberseguridad','Sanxenxo',null,'0001112'


--procedimiento pr_CrearModificarCurso, que permita dar de alta un curso o modificar uno existente junto a una nueva edicion. Hay que tener en cuenta:
--Los parámetros que se le pasa son el nombre del curso, horas, lugar, fecha, profesor, nombreDepartamento.
--Si existe el curso se actualizan el número de horas y sino se crea el curso siguiendo siguiendo la numeracion en el código.
--Se crea una nueva edición, utilizando el procedimiento anterior.
--Y los alumnos será los empleados del departamento introducido.
--Hay que controlar los posibles errores con un parámetro de retorno.
--Utiliza transacciones explicitas si es el caso.
--Se visualizar un listado con el siguiente formato
--En el listado, para obtener el nombre completo del empleado que recibe el curso se hará con una función y también para obtener edad y el número total de  alumnos del curso