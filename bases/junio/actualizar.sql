--Tarea 3 UD9 - Refuerzo 3 Cursores , procedimientos y funciones
use EMPRESANEW2
go

--añadir campo 
--alter table empregado
--	add NumeroProxectos int null
--go 

--pr_ActulizarNumproy que se le pase el nss de un empleado y actualice el número de proyectos de dicho empleado. Debe devolver en un parámetro de salida el número de proyectos.  Se controlará los posibles errores, devolviendo -1 si no existe el empleado y 0 si existe.

if OBJECT_ID('pr_ActulizarNumproy') is not null
	drop procedure pr_ActulizarNumproy
go

create procedure pr_ActulizarNumproy
	@nss varchar(15),
	@numProxectos int output
as
begin
	-- -1 si no existe 
	if not exists (select 1 from EMPREGADO where NSS = @nss)
		begin
			return -1
		end 
	
	--0 si si 
	else 
		
			set @numProxectos = (
				 select count(*) from empregado e 
						inner join empregado_proxecto ep on ep.NSSEmpregado = e.NSS
						where e.nss = @nss )
			
			--actualizar OJO EL WHERE 
				update EMPREGADO
					set NumeroProxectos = @numProxectos where NSS = @nss
				 
				
			select nss,numeroproxectos from EMPREGADO where NSS = @nss
			return 0
		
end
go

declare @numproxectos int 

exec pr_ActulizarNumproy '0010010', @numproxectos = @numproxectos output


--Crea un procedimiento llamado pr_ActualizarTodosNumproy  para actualizar el número de proyectos de todos los empleados de la empresa. 
--Se deberá utilizar el anterior procedimiento. Se visualizará para cada empleado el nombre completo, dni y el número de proyectos que se actualizan.


if OBJECT_ID('pr_ActualizarTodosNumproy') is not null
	drop procedure pr_ActualizarTodosNumproy
go

create procedure pr_ActualizarTodosNumproy
	@nomeEmpregado varchar(50),
	@nssEmpregado varchar(15),
	@numProxectos smallint
as
begin
	declare cursorEmpleados cursor for 
    select nome + ' ' + apelido1 + ' ' + isnull(apelido2,''), nss, numeroProxectos 
		from empregado
		
		declare 
			@nss varchar, 
			@nomecompleto varchar(50), 
			@numeroProxectos int
	open cursorEmpleados
	fetch next from cursorEmpleados into @nomecompleto,@nss

	while @@FETCH_STATUS = 0 
	begin 	 
		exec pr_ActulizarNumproy 
				@nss,@numProxectos = @numeroProxectos output
		
		fetch next from cursorEmpleados into @nomecompleto,@nss
	end 
	
	close cursorEmpleados
	deallocate cursorEmpleados
end
go 

select * from EMPREGADO
exec pr_ActualizarTodosNumproy
select * from EMPREGADO

