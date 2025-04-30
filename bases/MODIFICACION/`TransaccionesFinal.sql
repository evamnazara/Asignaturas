use EMPRESANEW 
go

/*2._ Utiliza transacciones explícitas para garantizar que se realiza la operación completa correspondiente al ejercicio 4 de la Tarea 3 de la UD6.*/

--3.- Hubo un error en la asignación de las horas semanales de los empleados del departamento  Persoal en el proyecto PORTAL. En los que no hay registrado el número de horas tiene que ser  15 y en los que si está registrado tiene que aumentar el número de horas en este valor, con límite 25 ( si supera el limite, se asigna este valor).
/*begin catch
begin rollback
	PRINT 'error'
end catch*/

/*update EMPREGADO_PROXECTO
	set Horas = CASE
		WHEN ISNULL(HORASEXTRAS,0)+15 <= 25 then ISNULL(HORASEXTRAS,0)+15
		else 25
from EMPREGADO e 
	inner join EMPREGADO_PROXECTO ep on e.NSS = ep.NSSEmpregado
	inner join PROXECTO p on ep.NumProxecto = p.NumProxecto*/

--4._El departamento de PERSOAL crea un proyecto de nombre 'INFORMATIZACIÓN DE PERMISOS' que se va a realizar en VIGO y en el que quiere que se implique todo el personal que pertenece a este departamento 

--Modifica el campo Nombre de Proyecto para poder permitir almacenar todos los caracteres del nombre del proyecto que se pretende crear.

--El jefe de departamento le dedicará 8 horas semanales.

--Los empleados le dedicarán 5 horas semanales cada uno, teniendo en cuenta que no pueden superar 42 horas semanales dedicadas a proyectos (En ese caso dedicarían el número de horas que tuviesen disponibles hasta llegar a 42 y si no tuvieran horas disponibles no se asignarían al proyecto).  

--A los empleados que pasen de 40 horas dedicadas a proyectos les incrementará el sueldo, pagándoles 12 euros más a la semana por cada hora extra que hagan.
--Utiliza transacciones implícitas para garantizar que se realiza la operación correctamente.*/

alter table proxecto
alter column nomeproxecto varchar(50) not null;

declare @depart;
set @depart = (select numdepartamento from DEPARTAMENTO where NomeDepartamento = 'persoal')
set implicit_transactions on 

begin try
	insert into PROXECTO 
	values(
			(select max(numproxecto) +1 from PROXECTO),
			'INFORMATIZACIÓN DE PERMISOS',
			'vigo', @depart)
			

commit transaction
end try

begin catch
begin rollback
	print 'error'
end catch