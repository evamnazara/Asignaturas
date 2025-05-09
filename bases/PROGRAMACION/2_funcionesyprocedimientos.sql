use EMPRESANEW
go;

--a) Crea una función llama fnEdad que se le pase una  fecha de nacimiento y devuelva su edad.
if object_id ('fnEdad','if') is not null 
drop function fnEdad 
go 
create function fnEdad
	(@fechanacimiento datetime) 
	returns int
as
begin  
	return datediff (dd,@fechanacimiento,getdate() ) / 365.25;
end 
go

-- Haz una consulta que devuelva el nombre completo y edad de los empleados fijos utilizando esta función.
select e.nome + ' ' + e.Apelido1 + ' ' + ISNULL(Apelido2,'') as NomeCompleto,
	dbo.fnEdad(e.DataNacemento) as Idade
	from EMPREGADO e 
	inner join EMPREGADOFIXO ef on e.NSS = ef.NSS
go;

--b)Utilizando la anterior función, crea un procedimiento llamado prFamiliarEdad que se le pase una edad y visualice los empleados (nombre, apellidos y número familiares)  que tienen más de un familiar que supera a la edad pasada como parámetro.

--Hay que comprobar que el parámetro sea correcto, (no puede ser negativo ni superar los 150 años),  devolviendo -1 en caso de fallo (que nos sea correcto el parámetro) y el número de filas devueltas en caso de éxito.

if OBJECT_ID('prFamiliarEdad', 'P') is not null
	drop procedure prFamiliarEdad;
go

create procedure prFamiliarEdad
	@edad int,
	@respuesta as varchar(60) output
as
begin 
	if @edad > 150 
		begin
			set @respuesta = -1;
			print 'La edad no puede ser mayor que 150'
			return;
		end 
		
	else if @edad < 0 
		begin 
			set @respuesta = -1;
			print 'La edad no puede ser menor que 0'
			return; 
		end
	
	else 
	begin 
		set @respuesta = (select e.nome + ' ' + e.apelido1 + ' ' + ISNULL(e.apelido2,'') as NomeCompleto,
						count(*) as NumFamiliares
						from EMPREGADO e
						inner join familiar f on e.nss = f.nss_empregado
						where dbo.fnEdad(f.dataNacemento) > @edad
						group by e.Nome,e.Apelido1,e.Apelido2)
	end;
								
end;
go

--Pon varios ejemplos de llamada ( éxito y caso de error)
declare @res varchar(60);
exec prFamiliarEdad -3, @res output;
select @res
go

declare @res varchar(60);
exec prFamiliarEdad 200, @res output;
select @res
go

declare @res varchar(60);
exec prFamiliarEdad 15, @res output;
select @res
go
--prueba



--2.- Crea una función llamada fnNumEmplMayorQueEdad, se le pasa el nombre del departamento y una edad y devuelve el número de empleados de dicho departamento mayores de la edad. Si no existe el departamento se visualizará devolverá -1 y si la edad es negativa -2. (Utiliza la función fnEdad)

--Pon varios ejemplos de llamada a la función para comprobar todos los posibles  casos que se puedan dar.

--3.-Crea una función que me devuelva el nombre del departamento, nombre completo del empleado director del departamento y número de proyectos que controlan para aquellos departamentos que controlan más de N proyectos, siendo n un parámetro.

--Haz este ejercicio  de dos manera:  a) función inline  Return (select …..) b) función inline múltiples sentencias Insert…select    return.

--Pon ejemplos de llamada a la función.

--4.-

--a)Crear una función fnEsvocal que recibe una letra y devuelva  si se trata de si es o no una vocal (Se considera también las vocales acentúas).

--b)Crea una función fnVocales que se le pase una cadena ( máximo 250 caracteres) y devuelva el número de vocales que contiene. Utiliza la anterior función.

--c)Crea una función fnVocalesNombre que se le pase un nombre de departamento y devuelva el nombre completo y el número de vocales que tiene este, de los empleados que no pertenezcan al departamento dado.

--Utilizando la función fnVocalesNombre, haz una consulta que visualice el nombre de los empleados que tienen en su nombre y apellidos el máximo número de vocales.

--Hazlo de dos formas: utilizando top y de forma estándar.

--5)Escribe un procedimiento almacenado prVisualizaTabla que reciba como parámetros de entrada el nombre de una base de datos, el esquema y el nombre de una tabla y visualice todas las filas de esa tabla. Si no se proporciona el esquema, será por defecto dbo. Comprueba que los parámetros proporcionados existan los objetos, visualizando un mensaje significativo en caso contrario (Por ejemplo, si no existe la base de datos, se puede visualizar “'No existe la base de datos  XXX”).

--Pon varios ejemplos de  llamadas al procedimiento

--Nota:

-- 1.-Repasa en  ud4  información de las vistas de catálogo para obtener información de las bases de datos, esquemas y tablas. También cómo se hace referencia a cualquier objeto  [bd].[esquema].objeto 

-- 2.-Mira en la ayuda información sobre EXECUTE ( o EXEC) , no solo sirve para ejecutar procedimientos almacenados sino también para ejecutar una consulta  EXEC(‘SELECT ……FROM ..’)