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
exec prFamiliarEdad 15, @res output;
select @res
go

declare @res varchar(60);
exec prFamiliarEdad -3, @res output;
select @res
go

declare @res varchar(60);
exec prFamiliarEdad 200, @res output;
select @res
go


--2.- Crea una función llamada fnNumEmplMayorQueEdad, se le pasa el nombre del departamento y una edad y devuelve el número de empleados de dicho departamento mayores de la edad. Si no existe el departamento se visualizará devolverá -1 y si la edad es negativa -2. (Utiliza la función fnEdad)
--Pon varios ejemplos de llamada a la función para comprobar todos los posibles  casos que se puedan dar.
if object_id('fnNumEmplMayorQueEdad', 'fn') is not null
    drop function fnNumEmplMayorQueEdad;
go

create function fnNumEmplMayorQueEdad
(
    @nomeDepto varchar(50),
    @edad int
)
returns int
as
begin
    declare @resultado int;

    if @edad < 0
        return -2;

    if not exists (select 1 from departamento where nome = @nomeDepto)
        return -1;

    select @resultado = count(*)
    from empregado e
    inner join departamento d on e.cod_dpto = d.cod_dpto
    where d.nome = @nomeDepto
        and dbo.fnEdad(e.datanacemento) > @edad;

    return @resultado;
end;
go

select dbo.fnNumEmplMayorQueEdad('Departamento que no existe', 43); 
select dbo.fnNumEmplMayorQueEdad('PERSOAL', 32);
select dbo.fnNumEmplMayorQueEdad('PERSOAL', -25);



--3.-Crea una función que me devuelva el nombre del departamento, nombre completo del empleado director del departamento y número de proyectos que controlan para aquellos departamentos que controlan más de N proyectos, siendo n un parámetro.
--Haz este ejercicio  de dos manera:  
--a) función inline  Return (select …..) 
--b) función inline múltiples sentencias Insert…select    return.
--Pon ejemplos de llamada a la función.
if object_id('fnProyectosDepartamento', 'if') is not null
    drop function fnProyectosDepartamento;
go

create function fnProyectosDepartamento(@n int)
returns table
as
return
    select 
        d.nome as NomeDepartamento,
        e.nome + ' ' + e.apelido1 + ' ' + isnull(e.apelido2, '') as NomeDirector,
        count(p.cod_proxecto) as NumProxectos
    from departamento d
    join empregado e on d.nss_dir = e.nss
    join proxecto p on d.cod_dpto = p.cod_dpto
    group by d.nome, e.nome, e.apelido1, e.apelido2
    having count(p.cod_proxecto) > @n;
go

--4.-
--a)Crear una función fnEsvocal que recibe una letra y devuelva  si se trata de si es o no una vocal (Se considera también las vocales acentúas).
if object_id('fnEsVocal', 'fn') is not null
    drop function fnEsVocal;
go

create function fnEsVocal(@letra char(1))
returns bit
as
begin
    if @letra in ('a','e','i','o','u','á','é','í','ó','ú','A','E','I','O','U','Á','É','Í','Ó','Ú')
        return 1;
    return 0;
end;
go


--b)Crea una función fnVocales que se le pase una cadena ( máximo 250 caracteres) y devuelva el número de vocales que contiene. Utiliza la anterior función.

if object_id('fnVocales', 'fn') is not null
    drop function fnVocales;
go

create function fnVocales(@cadena varchar(250))
returns int
as
begin
    declare 
		@i int = 1, 
		@contador int = 0;

    while @i <= len(@cadena)
    begin
        if dbo.fnEsVocal(substring(@cadena, @i, 1)) = 1
            set @contador += 1;
        set @i += 1;
    end

    return @contador;
end;
go



--c)Crea una función fnVocalesNombre que se le pase un nombre de departamento y devuelva el nombre completo y el número de vocales que tiene este, de los empleados que no pertenezcan al departamento dado.

if object_id('fnVocalesNombre', 'if') is not null
    drop function fnVocalesNombre;
go

create function fnVocalesNombre(@nomeDpto varchar(100))
returns table
as
return
    select 
        e.nome + ' ' + e.apelido1 + ' ' + isnull(e.apelido2,'') as NomeCompleto,
        dbo.fnVocales(e.nome + e.apelido1 + isnull(e.apelido2,'')) as NumVocales
    from empregado e
    	inner join departamento d on e.cod_dpto = d.cod_dpto
    where d.nome != @nomeDpto;
go

--Utilizando la función fnVocalesNombre, haz una consulta que visualice el nombre de los empleados que tienen en su nombre y apellidos el máximo número de vocales.
select top 1 *
from dbo.fnVocalesNombre('TÉCNICO')
order by NumVocales desc;

--5)Escribe un procedimiento almacenado prVisualizaTabla que reciba como parámetros de entrada el nombre de una base de datos, el esquema y el nombre de una tabla y visualice todas las filas de esa tabla. Si no se proporciona el esquema, será por defecto dbo. Comprueba que los parámetros proporcionados existan los objetos, visualizando un mensaje significativo en caso contrario (Por ejemplo, si no existe la base de datos, se puede visualizar “'No existe la base de datos  XXX”).

--Pon varios ejemplos de  llamadas al procedimiento
if object_id('prVisualizaTabla', 'P') is not null
    drop procedure prVisualizaTabla;
go

create procedure prVisualizaTabla
    @nombreBD sysname,
    @esquema sysname = 'dbo',
    @nombreTabla sysname
as
begin
    if not exists (select * from sys.databases where name = @nombreBD)
    begin
        print 'No existe la base de datos ' + @nombreBD;
        return;
    end

    declare @sql nvarchar(max);

    if not exists (
        select * 
        from [master].sys.objects o
        join [master].sys.schemas s on o.schema_id = s.schema_id
        where o.name = @nombreTabla and s.name = @esquema
    )
    begin
        print 'No existe la tabla ' + @esquema + '.' + @nombreTabla + ' en la base de datos ' + @nombreBD;
        return;
    end

    set @sql = 'SELECT * FROM [' + @nombreBD + '].[' + @esquema + '].[' + @nombreTabla + ']';
    exec sp_executesql @sql;
end;
go

exec prVisualizaTabla 'EMPRESANEW', 'dbo', 'EMPREGADO';
