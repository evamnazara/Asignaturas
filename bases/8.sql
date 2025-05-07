--create procedure dbo.x
	--exec dbo.x

--sp_help nombreProcedimiento
--sp_helptext 
--sp_depends

--modificar el metodo: alter table / drop procedure 

---------------------------------------------------------
--1)

--a) Crea un procedimiento almacenado MayorDeDosEnteros que se le pasan dos números enteros y visualice un mensaje indicando si dichos números son iguales o cuál es el mayor.
--Pon un ejemplo de ejecución de dicho procedimiento por valor y otro por referencia

create procedure MayorDeDosEnteros
    @num1 int, 
    @num2 int
AS  
	if @num1 = @num2
		print 'Los números son iguales'
	if @num1 > @num2
		print 'El número ' + CAST(@num1 as varchar(10)) + ' es mayor que ' + CAST(@num2 as varchar(10))
	if @num1 < @num2
		print 'El número ' + CAST(@num2 as varchar(10)) + ' es mayor que ' + CAST(@num1 as varchar(10));

--por valor 
exec MayorDeDosEnteros 10,10
--por referencia 
exec MayorDeDosEnteros @num1= 25,@num2 = 5


--b)Modifica el anterior procedimiento, para que devuelva el mensaje en un parámetro de salida.  Pon un ejemplo de ejecución de este procedimiento por valor y otro por referencia .
go
alter procedure MayorDeDosEnteros
    @num1 int, 
    @num2 int,
    @res int output
AS  
	if @num1 = @num2
		set @res = 'Los números son iguales'
	if @num1 > @num2
		set @res = 'El número ' + CAST(@num1 as varchar(10)) + ' es mayor que ' + CAST(@num2 as varchar(10))
	if @num1 < @num2
		set @res = 'El número ' + CAST(@num2 as varchar(10)) + ' es mayor que ' + CAST(@num1 as varchar(10));

go 
declare @res smallint
exec MayorDeDosEnteros 10,2,@res OUTPUT
select 'El resultado es: ', @res

--2)Crea un procedimiento que se le pase un número entero positivo y visualice la suma desde 1 hasta el número introducido. Se tendrá que comprobar que el número introducido sea un número positivo, en caso de error el procedimiento retornará -1 y si el número es correcto retornará 0. Ejecuta este procedimiento, visualizando también el valor retornado, poniendo ejemplos significativos.

create procedure SumaDesdeEntero
	

--3)Crea un procedimiento almacenado MayorQueSueldoMin en la base de datos EMPRESA, para pasar un valor como parámetro (XXXX) y si ese valor es menor que el sueldo del empleado fijo que menos gana, se visualiza el mensaje “el valor XXXX es menor que el sueldo del empleado que menos gana: XXXX” sino visualiza “el valor XXXX no es menor que el sueldo del empleado que menos gana: XXXX”.

--Se deberá comprobar que el Valor XXXX será positivo devolviendo -1 en caso de error y 0 en caso contrario.

--Ejecuta este procedimiento, poniendo varios ejemplos significativos.

--4)      

--a)Crea un procedimiento llamado DatosDepartamento  que se le pase el nombre de un departamento y devuelva en parámetros para ese departamento:  el número de empleados de cualquier tipo, el número de empleados fijos, el total en salarios, el nombre completo del director de dicho departamento.

--También devolverá un valor de error -1 si no existe el departamento y 0 en caso contrario

--b)Crea un procedimiento llamado visualizardatosdepartamento  que se le pase un nombre de departamento y llame al procedimiento DatosDepartamento creando anteriormente. Debe visualizar la siguiente información tal como aparece en el siguiente ejemplo, teniendo en cuenta que si en la llamada no se le pasa ningún departamento, por defecto se visualizará el departamento Técnico :

-- DEPARTAMENTO: Persoal
-- DIRECTOR: Manuel Galán Galán
-- TOTAL SALARIO: 16695
-- NUMERO DE EMPLEADOS FIJOS 6 DE UN TOTAL DE 7 EMPLEADOS

--5)      

--a)Escribe un procedimiento InicialEmpleados que me devuelve todos los empleados (NSS, NombreCompleto, nombredepartamento, nombre completo del supervisor ) cuyo nombre empieza por una letra que se le pase por parámetro.  Teniendo en cuenta

--Si no tiene supervisor devolverá ‘Sin supervisor” .
-- Si no se le pasa ningún parámetro me tiene que devolver los empleados cuyo nombre empieza por C. 
--El  parámetro debe ser una letra, devolviendo -1 en caso de fallo (que nos sea el parámetro una letra) y el número de filas devueltas en caso de éxito.
-- Ejecuta este procedimiento, visualizando también el valor retornado, poniendo varios ejemplos significativos de funcionamiento.

--b) Escribe un procedimiento almacenado InsertarEmpleados, que reciba una inicial de una letra y  cree una tabla  llamada EmpregadoDepartamento con los campos NSS, NombreCompleto, nombredepartamento, supervisor e inserte los empleados cuyo nombre empieza por la letra que se le ha pasado por parámetro, utilizando para ello el procedimiento InicialEmpleados creado anteriormente 
--( nota: mira las sentencia INSERT ….EXECUTE  en UD6  o busca en la ayuda).

--Se deberá mostrar lo siguiente:

--Si la letra no es un carácter se visualizará el mensaje "parámetro incorrecto, no se insertará ningún registro",
-- Si no existe ningún nombre con esa letra se visualizará "no hay ningún empleado cuyo nombre empiece por la letra X"
--Y en caso contrario, se insertará los empleados en la tabla empregadoDepartamento visualizando también el número de registros insertados.
--Ejecuta este procedimiento, visualizando también el valor retornado, poniendo varios ejemplos significativos de funcionamiento.

--6)Crea una copia de la tabla EmpleadosFijos y utiliza la copia para realizar la operación que se indica a continuación. Codifica un procedimiento SubirSalario que reciba como parámetro un porcentaje y aumente en ese porcentaje el salario de  los empleados que tienen asignados más de 2 proyectos, teniendo en cuenta que si se trata de un empleado supervisor  ese porcentaje se le incrementa en un 5% más.  

-- El porcentaje de aumento debe estar comprendido entre el 1% y el 15%, en caso contrario, hay que visualizar un mensaje indicando el error.

--Si se realiza la actualización, se debe visualizar un mensaje  indicando el número de filas que se han modificado ( “SE HA AUMENTADO EL SALARIO A X EMPLEADOS”).
