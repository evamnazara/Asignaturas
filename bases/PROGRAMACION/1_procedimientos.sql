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

IF OBJECT_ID('MayorDeDosEnteros', 'P') IS NOT NULL
    drop procedure MayorDeDosEnteros;
GO

create procedure MayorDeDosEnteros
    @num1 int, 
    @num2 int
AS  
BEGIN
    if @num1 = @num2
        print 'Los números son iguales';
    else if @num1 > @num2
        print 'El número ' + CAST(@num1 as varchar(10)) + ' es mayor que ' + CAST(@num2 as varchar(10));
    else
        print 'El número ' + CAST(@num2 as varchar(10)) + ' es mayor que ' + CAST(@num1 as varchar(10));
END;
go 

--por valor 
exec MayorDeDosEnteros 10,10
--por referencia 
exec MayorDeDosEnteros @num1= 25,@num2 = 5;


--b)Modifica el anterior procedimiento, para que devuelva el mensaje en un parámetro de salida.  Pon un ejemplo de ejecución de este procedimiento por valor y otro por referencia .
go
alter procedure MayorDeDosEnteros
    @num1 int, 
    @num2 int,
    @res varchar(100) output
AS  
begin
	if @num1 = @num2
		set @res = 'Los números son iguales';
	else if @num1 > @num2
		set @res = 'El número ' + CAST(@num1 as varchar(10)) + ' es mayor que ' + CAST(@num2 as varchar(10));
	else if @num1 < @num2
		set @res = 'El número ' + CAST(@num2 as varchar(10)) + ' es mayor que ' + CAST(@num1 as varchar(10));
end;
go 

declare @res varchar(50);
--por valor: 
exec MayorDeDosEnteros 10,2,@res OUTPUT;
select 'Resultado: ', @res;

--por referencia 
exec MayorDeDosEnteros @num1 = 3, @num2 = 5, @res = @res output;
select 'Resultado: ', @res;
go

--2)Crea un procedimiento que se le pase un número entero positivo y visualice la suma desde 1 hasta el número introducido. Se tendrá que comprobar que el número introducido sea un número positivo, en caso de error el procedimiento retornará -1 y si el número es correcto retornará 0. Ejecuta este procedimiento, visualizando también el valor retornado, poniendo ejemplos significativos.
if OBJECT_ID('SumaDesdeEntero', 'P') is not null 
	drop procedure SumaDesdeEntero
go 

create procedure SumaDesdeEntero
    @num int,
    @res2 int output
as

begin
    if @num <= 0
    begin
        set @res2 = -1;
        return;
    end

    declare @suma int = 0;
    declare @i int = 1;

    while @i <= @num
    begin
        set @suma += @i;
        set @i += 1;
    end

    print 'La suma desde 1 hasta ' + CAST(@num AS VARCHAR(10)) + ' es: ' + CAST(@suma AS VARCHAR(10));
    set @res2 = 0;
end;
go 



----3)Crea un procedimiento almacenado MayorQueSueldoMin en la base de datos EMPRESA, para pasar un valor como parámetro (XXXX) y si ese valor es menor que el sueldo del empleado fijo que menos gana, se visualiza el mensaje “el valor XXXX es menor que el sueldo del empleado que menos gana: XXXX” sino visualiza “el valor XXXX no es menor que el sueldo del empleado que menos gana: XXXX”.
----Se deberá comprobar que el Valor XXXX será positivo devolviendo -1 en caso de error y 0 en caso contrario.
use empresanew
go 

if object_id('mayorquesueldomin', 'p') is not null 
	drop procedure mayorquesueldomin
go 

create procedure mayorquesueldomin
    @valor float,
    @resultado varchar(100) output
as
begin
    if @valor <= 0
    begin
        set @resultado = -1;
        return;
    end

    declare @sueldomin float;
    select @sueldomin = min(salario) from empregadofixo;

    if @valor < @sueldomin
        print 'El valor ' + cast(@valor as varchar) + 
              ' es menor que el sueldo del empleado que menos gana: ' + cast(@sueldomin as varchar);
    else
        print 'El valor ' + cast(@valor as varchar) + 
              ' no es menor que el sueldo del empleado que menos gana: ' + cast(@sueldomin as varchar);

    set @resultado = 0;
end;
go 

-- negativo
declare @mensaje varchar(200), @resultado int;
exec @resultado = mayorquesueldomin -50, @mensaje output;
print cast(@resultado as varchar);
print @mensaje;
go 

--menor 
declare @mensaje varchar(200), @resultado int;
exec @resultado = mayorquesueldomin 500.00, @mensaje output;
print cast(@resultado as varchar);
print @mensaje;
go

-- mayor 
declare @mensaje varchar(200), @resultado int;
exec @resultado = mayorquesueldomin 8500.00, @mensaje output;
print cast(@resultado as varchar);
print @mensaje;
go


----4)      

----a)Crea un procedimiento llamado DatosDepartamento  que se le pase el nombre de un departamento y devuelva en parámetros para ese departamento:  el número de empleados de cualquier tipo, el número de empleados fijos, el total en salarios, el nombre completo del director de dicho departamento.
----También devolverá un valor de error -1 si no existe el departamento y 0 en caso contrario

use empresanew
go;

if object_id('datosdepartamento', 'p') is not null 
	drop procedure datosdepartamento
go 

create procedure datosdepartamento
    @nombredepto varchar(50),
    @numemp int output,
    @numempfijos int output,
    @totalsalario float output,
    @nombredirector varchar(100) output,
    @retorno int output
as
begin
    if not exists (select 1 from departamento where nomedepartamento = @nombredepto)
    begin
        set @retorno = -1;
        return;
    end

    select @numemp = count(*) from empregado e
	inner join departamento d on d.numdepartamento = e.numdepartamentopertenece
	where nomedepartamento = @nombredepto;

    select @numempfijos = count(*) from empregado e 
	inner join departamento d on d.numdepartamento = e.numdepartamentopertenece
	where nomedepartamento = @nombredepto;
    
    select @totalsalario = sum(salario) from empregadofixo ef
	inner join empregado e on ef.nss = e.nss
	inner join departamento d on d.numdepartamento = e.numdepartamentopertenece
	where nomedepartamento = @nombredepto;

    select @nombredirector = nome + ' ' + apelido1 + ' ' + isnull(apelido2,'') from empregado
    where nss = (select nssdirector from departamento d
	inner join empregado e on e.nss = d.nssdirector);

    set @retorno = 0;
end;
go 
----b)Crea un procedimiento llamado visualizardatosdepartamento  que se le pase un nombre de departamento y llame al procedimiento DatosDepartamento creando anteriormente. Debe visualizar la siguiente información tal como aparece en el siguiente ejemplo, teniendo en cuenta que si en la llamada no se le pasa ningún departamento, por defecto se visualizará el departamento Técnico :

-- DEPARTAMENTO: Persoal
-- DIRECTOR: Manuel Galán Galán
-- TOTAL SALARIO: 16695
-- NUMERO DE EMPLEADOS FIJOS 6 DE UN TOTAL DE 7 EMPLEADOS
use empresanew
go;

if object_id('visualizardatosdepartamento', 'p') is not null 
	drop procedure visualizardatosdepartamento
go 

create procedure visualizardatosdepartamento
    @nombredepto varchar(20) = 'técnico'
as
begin
    declare 
    @numemp int, 
    @numempfijos int, 
    @totalsalario float,
    @nombredirector varchar(100), 
    @retorno int;

    exec datosdepartamento
        @nombredepto, @numemp output, @numempfijos output,
        @totalsalario output, @nombredirector output, @retorno output;

    if @retorno = -1
        print 'departamento no encontrado';
    else
    begin
        print 'departamento: ' + @nombredepto;
        print 'director: ' + @nombredirector;
        print 'total salario: ' + cast(@totalsalario as varchar);
        print 'numero de empleados fijos ' + cast(@numempfijos as varchar) + 
              ' de un total de ' + cast(@numemp as varchar) + ' empleados';
    end
end;
go

exec visualizardatosdepartamento;
go 
----5)      

----a)Escribe un procedimiento InicialEmpleados que me devuelve todos los empleados (NSS, NombreCompleto, nombredepartamento, nombre completo del supervisor ) cuyo nombre empieza por una letra que se le pase por parámetro.  Teniendo en cuenta

----Si no tiene supervisor devolverá ‘Sin supervisor” .
---- Si no se le pasa ningún parámetro me tiene que devolver los empleados cuyo nombre empieza por C. 
----El  parámetro debe ser una letra, devolviendo -1 en caso de fallo (que nos sea el parámetro una letra) y el número de filas devueltas en caso de éxito.


use empresanew
go; 

if object_id('inicialempleados', 'p') is not null 
	drop procedure inicialempleados
go 

create procedure inicialempleados
    @inicial char(1) = 'c',
    @retorno int output
as
begin

    if @inicial not like '[a-z]' and @inicial not like '[A-Z]'
    begin
        set @retorno = -1;
        return;
    end

    select 
        e.nss, 
        e.nome + ' ' + e.apelido1 + ' ' + e.apelido2 as nombrecompleto,
        d.nomedepartamento as nombredepartamento,
        coalesce(s.nome + ' ' + s.apelido1 + ' ' + s.apelido2, 'sin supervisor') as supervisor
    from empregado e
    join departamento d on e.numdepartamentopertenece = d.numdepartamento
    left join empregado s on e.nsssupervisa = s.nss
    where e.nome like @inicial + '%'

    set @retorno = @@rowcount
end
go

----b) Escribe un procedimiento almacenado InsertarEmpleados, que reciba una inicial de una letra y  cree una tabla  llamada EmpregadoDepartamento con los campos NSS, NombreCompleto, nombredepartamento, supervisor e inserte los empleados cuyo nombre empieza por la letra que se le ha pasado por parámetro, utilizando para ello el procedimiento InicialEmpleados creado anteriormente 
----( nota: mira las sentencia INSERT ….EXECUTE  en UD6  o busca en la ayuda).

----Se deberá mostrar lo siguiente:

----Si la letra no es un carácter se visualizará el mensaje "parámetro incorrecto, no se insertará ningún registro",
---- Si no existe ningún nombre con esa letra se visualizará "no hay ningún empleado cuyo nombre empiece por la letra X"
----Y en caso contrario, se insertará los empleados en la tabla empregadoDepartamento visualizando también el número de registros insertados.
----Ejecuta este procedimiento, visualizando también el valor retornado, poniendo varios ejemplos significativos de funcionamiento.
use empresanew
go; 

if object_id('insertarempleados', 'p') is not null 
	drop procedure insertarempleados
go 

create procedure insertarempleados
    @inicial char(1)
as
begin
    declare @retorno int;

    if @inicial not like '[a-z]' and @inicial not like '[A-Z]'
    begin
        print 'parámetro incorrecto, no se insertará ningún registro';
        return;
    end

    if object_id('empregadodepartamento', 'u') is null
    begin
        create table empregadodepartamento (
            nss char(11),
            nombrecompleto nvarchar(100),
            nombredepartamento nvarchar(50),
            supervisor nvarchar(100)
        );
    end
    else
    begin
        truncate table empregadodepartamento;
    end

    insert into empregadodepartamento (nss, nombrecompleto, nombredepartamento, supervisor)
    exec inicialempleados @inicial, @retorno output;

    if @retorno = -1
    begin
        print 'parámetro incorrecto, no se insertará ningún registro';
    end
    else if @retorno = 0
    begin
        print 'no hay ningún empleado cuyo nombre empiece por la letra ' + @inicial;
    end
    else
    begin
        print 'se han insertado ' + cast(@retorno as varchar) + ' empleados en la tabla empregadodepartamento';
    end
end
go


----6)Crea una copia de la tabla EmpleadosFijos y utiliza la copia para realizar la operación que se indica a continuación. Codifica un procedimiento SubirSalario que reciba como parámetro un porcentaje y aumente en ese porcentaje el salario de  los empleados que tienen asignados más de 2 proyectos, teniendo en cuenta que si se trata de un empleado supervisor  ese porcentaje se le incrementa en un 5% más.  

---- El porcentaje de aumento debe estar comprendido entre el 1% y el 15%, en caso contrario, hay que visualizar un mensaje indicando el error.

----Si se realiza la actualización, se debe visualizar un mensaje  indicando el número de filas que se han modificado ( “SE HA AUMENTADO EL SALARIO A X EMPLEADOS”).

--copia
use empresanew;
go

if object_id('empregadofixo_copia', 'u') is not null
    drop table empregadofixo_copia;
go

select *
into empregadofixo_copia
from empregadofixo;
go


--procedimiento
create procedure subirsalario
    @porcentaje int
as
begin
    if @porcentaje < 1 or @porcentaje > 15
    begin
        print 'error: el porcentaje debe estar entre 1% y 15%';
        return;
    end

    declare @filas int;

    update ef
    set ef.salario = ef.salario * 
        (1 + 
         case 
             when ef.nss in (
                 select distinct e.nsssupervisa 
                 from empregado e 
                 where e.nsssupervisa is not null
             )
             then (@porcentaje + 5) / 100.0
             else @porcentaje / 100.0
         end)
    from empregadofixo_copia ef
    where ef.nss in (
        select ep.nssempregado
        from empregado_proxecto ep
        group by ep.nssempregado
        having count(distinct ep.numproxecto) > 2
    );
    
    set @filas = @@rowcount;
    print 'se ha aumentado el salario a ' + cast(@filas as varchar) + ' empleados';
end;
go