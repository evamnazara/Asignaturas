use BDCatastro
go

if OBJECT_ID('fnPropietarioPiso') is not null
	drop function fnPropietarioPiso
go

/*
Se quiere saber el dueño ( nombre completo) de un determinado piso. Se hará utilizando un procedimiento y también se realizará el mismo ejercicio utilizando una función.
Si el piso existe, se devolverá el nombre completo del dueño.

Si la calle no existe se devuelve -1

Si la calle existe pero no existe el número se devolverá -2

Si la planta no existe en la calle y número dado se devolverá -3

Y si no existe la puerta en la planta de una determinada calle y número se devolverá -4
*/
create function fnPropietarioPiso 
	(@calle varchar(40), 
	@numero smallint, 
	@planta tinyint, 
	@puerta char(1))
returns varchar

as 
begin 
	if not exists (select calle from PISO where CALLE=@calle) 
		return -1 
	if not exists (select calle,numero from PISO where NUMERO=@numero)
		return -2
	
	if not exists (select calle,numero,planta from PISO where PLANTA=@planta)
		return -3
	
	if not exists (select calle,numero,PLANTA,puerta from PISO where puerta=@puerta)
		return -4
	
	declare @dniprop varchar(9);
	set @dniprop = (select DNIPROPIETARIO from piso 
		where CALLE=@calle and NUMERO=@numero 
		and PLANTA=@planta and PUERTA=@puerta) 
		
	return @dniprop 
	
end
go

select dbo.fnPropietarioPiso('Alegria',44,1,'A')
select dbo.fnPropietarioPiso('Alegria',45,1,'A') from PISO
select dbo.fnPropietarioPiso('Alegria',44,9,'A') from PISO
select dbo.fnPropietarioPiso('Alegria',44,1,'Z') from PISO

select * from PISO 

--procedimiento 
if OBJECT_ID('prPropietarioPiso') is not null
	drop procedure prPropietarioPiso
go

create procedure prPropietarioPiso
	@calle varchar(40), 
	@numero smallint, 
	@planta tinyint, 
	@puerta char(1),
	@dniprop varchar(9) = null output,
	@nombreprop varchar(50) = null output
as
begin
	if not exists (select calle from PISO where CALLE=@calle) 
		return -1 
		
	if not exists (select calle,numero from PISO where NUMERO=@numero)
		return -2
	
	if not exists (select calle,numero,planta from PISO where PLANTA=@planta)
		return -3
	
	if not exists (select calle,numero,PLANTA,puerta from PISO where puerta=@puerta)
		return -4

	else 
	select @dniprop = DNIPROPIETARIO from piso where CALLE=@calle and NUMERO=@numero and PLANTA=@planta and PUERTA=@puerta;	
	
	select @nombreprop = nombre + ' ' + APELLIDO1 + ' ' + ISNULL(APELLIDO2,'') 
			from PROPIETARIO 
			inner join PISO p on p.DNIPROPIETARIO = PROPIETARIO.DNI
			where DNI = @dniprop;
		
	return 0
	
end
go

--para ver 

if OBJECT_ID('prVisualizarPropietarioPiso') is not null
	drop procedure prVisualizarPropietarioPiso 
go
 
create procedure prVisualizarPropietarioPiso 
	@calle varchar(40), 
	@numero smallint, 
	@planta tinyint, 
	@puerta char(1)
as 
begin
	declare @dniprop varchar(9), @nombreprop varchar(50), @resultado int
	set @resultado = -99 
	
	exec @resultado = prPropietarioPiso 
	@calle = @calle,
	@numero = @numero,
	@planta = @planta,
	@puerta = @puerta,
	@dniprop = @dniprop output,
	@nombreprop = @nombreprop output
	
	if @resultado = 0
        print 'el dueño del piso ' + @calle + ',' + cast(@numero as varchar) + ' ' + cast(@planta as varchar) + ' ' + @puerta + ' es ' + @nombreprop;
    else if @resultado = -1
        print 'no existe la calle ' + @calle;
    else if @resultado = -2
        print 'no existe el número ' + cast(@numero as varchar) + ' en la calle ' + @calle;
    else if @resultado = -3
        print 'no existe la planta ' + cast(@planta as varchar) + ' en la calle ' + @calle + ',' + cast(@numero as varchar);
    else if @resultado = -4
        print 'no existe la puerta ' + @puerta + ' en la planta ' + cast(@planta as varchar) + ' de la calle ' + @calle + ',' + cast(@numero as varchar);

end 
go

exec prVisualizarPropietarioPiso 'Alegria',44,1,'A'

select * from piso

select nombre from PROPIETARIO where DNI='88888822H'

/*
b)     Se hará lo mismo que anteriormente pero ahora utilizando una función llamada fnPropietarioPiso que reciba un piso y devuelva el nombre del dueño si el piso existe sino se devolverá el valor del tipo de error ( -1,-2,..). y se visualizará  el dueño o un mensaje representativo según el error.

 Para ejecutar la anterior función se hará haciendo una llamada dentro del procedimiento prVisualizarPropietarioPiso2

2.- Escribe  un procedimiento almacenado prPisosTiene1 que llama a un segundo procedimiento prPisosTiene2, mostrando  la información requerida o si .

prPisosTiene2 recibe el dni de una persona y devuelve el número de pisos que posee ésta ( en un parámetro de salida). También devolverá un código de estado que me permitirá saber si:

la persona no existe,
si no se le ha pasado ningún DNI de persona ( se le pasa NULL)
si la persona no tiene pisos
o si devuelve un valor con el número de pisos.
En cada procedimiento visualiza cada nivel de anidación. (El nivel actual de anidación es devuelto por la función @@NESTLEVEL)

Al llamar al procedimiento prPisosTiene2 en prPisosTiene1, utiliza paso de parámetros por referencia y , muestra  la información requerida o un mensaje significativo según el código de estado.

Para devolver el código de estado, hazlo se dos maneras:

a)      como parámetro de salida
b)     como valor de retorno.
*/


if OBJECT_ID('prPisosTiene2') is not null 
	drop procedure prPisosTiene2  
go 

create procedure prPisosTiene2 
	@dniprop varchar(9),
	@numpisos smallint output
as
begin
	
	--la persona no existe,
	if not exists (select 1 from PROPIETARIO where DNI = @dniprop)
		return -1 
		
	--si no se le ha pasado ningún DNI de persona ( se le pasa NULL)
	if @dniprop is null 
		return -2
		
	--si la persona no tiene pisos
	if (select COUNT(*) from PISO where DNIPROPIETARIO = @dniprop) = 0 
		return -3 
	
	--o si devuelve un valor con el número de pisos.
	else 
		select @numpisos = COUNT(*) from PISO where DNIPROPIETARIO = @dniprop
		return 0
end;
go 



if OBJECT_ID('prPisosTiene1') is not null 
	drop procedure prPisosTiene1  
go 

create procedure prPisosTiene1 
	@dniprop varchar(9)
as
begin
	declare @numpisos smallint, @resultado int
	
	exec @resultado = prPisosTiene2
			@dniprop = @dniprop, 
			@numpisos = @numpisos output
	
	if @resultado = -1
        print 'la persona no existe.';
    else if @resultado = -2
        print 'no se ha proporcionado ningún dni.';
    else if @resultado = -3
        print 'la persona no tiene pisos.';
    else if @resultado = 0
        print 'la persona tiene ' + cast(@numpisos as varchar) + ' piso(s).';
    else
        print 'estado desconocido.';

end
go 



exec prpisostiene1 '88888822h'; --ok
exec prpisostiene1 '99888888m'; --sin pisos
exec prpisostiene1 '00000000z'; --persona no existe
exec prpisostiene1 null; --sin dni


