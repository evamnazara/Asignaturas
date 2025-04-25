use BDEmpresa
go;

--1. El empleado con NSS 1122331 va a trabajar 3 horas en el proyecto 'Melloras sociais'.

select * from EMPREGADO_PROXECTO

declare @nssempleado varchar(15) = (select NSS from EMPREGADO where nss = '1122331')
declare @codigoprox varchar(15) = (select NSS from EMPREGADO where nss = '1122331')

insert into EMPREGADO_PROXECTO(NSSEmpregado,NumProxecto,horas)
values (@nssempleado,@codigoprox,3)
	

--2. Elimina los salarios de los empleados del departamento de INNOVACIÓN.

/*delete Salario from EMPREGADO
	inner join DEPARTAMENTO on Nss
	where ( select 
	NomeDepartamento = 'INNOVACION')*/

--3. Todas las personas que no son jefas de ningún departamento, de las que no tenemos registrado su salario pasan a cobrar 1900.

update EMPREGADOFIXO 
	SET Salario = 1900
	
	from DEPARTAMENTO 
	inner join EMPREGADO on NumDepartamento = NumDepartamentoPertenece
	where empregadofixo.Salario isnull
	and nsssupervida 


--4. La empresa va a realizar un ajuste, con lo cual decide eliminar el departamento de estadística, pasando a depender del departamento de Innovación los empleados que pertenecían a este departamento. Haz los cambios que consideres necesarios teniendo en cuenta que :
--4.A el que era jefe del departamento de estadística pasa a depender del jefe de departamento de Innovación y tiene a su cargo al resto de empleados que cambiaron de departamento.

--4.B Los proyectos que dependían de este departamento pasan a depender del departamento de Innovación.


--5. El jefe de departamento de Innovación pasa a cobrar 3900.


--6. Haz una consulta que cree una tabla (DPTO_CONTA) con el nombre, apellidos y proyectos (nombre) en los que están trabajando todos los empleados que trabajan en el departamento de contabilidad.


--7. Elimina el contenido de la tabla DPTO_CONTA.


--8. El departamento TÉCNICO decide que ningún empleado del departamento debería cobrar menos del "actual" salario medio del departamento, con lo cual decide subir el sueldo a aquellos empleados que cobran menos de este salario para pasar a cobrar esta cantidad.


--9. Introduce en la DPTO_CONTA el nombre y los apellidos de los empleados del departamento de Contabilidad que son de Vigo, tienen algún hijo (o hija) y cobran un salario mayor que la media del salario de todos los empleados de la empresa.