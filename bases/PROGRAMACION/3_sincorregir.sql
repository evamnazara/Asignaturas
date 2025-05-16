/*
Antes de crear cualquier procedimiento o función comprueba su existencia.

Se quiere saber el dueño ( nombre completo) de un determinado piso. Se hará utilizando un procedimiento y también se realizará el mismo ejercicio utilizando una función.
Si el piso existe, se devolverá el nombre completo del dueño.
Si la calle no existe se devuelve -1
Si la calle existe pero no existe el número se devolverá -2
Si la planta no existe en la calle y número dado se devolverá -3
Y si no existe la puerta en la planta de una determinada calle y número se devolverá -4

*/

if object_id('prpropietariopiso') is not null
    drop procedure prpropietariopiso;
go

create procedure prpropietariopiso
    @calle nvarchar(100),
    @numero int,
    @planta int,
    @puerta char(1),
    @nombrepropietario nvarchar(200) output
as
begin
    declare @dnipropietario char(10);

    if not exists (select 1 from piso where calle = @calle)
        return -1;

    if not exists (select 1 from piso where calle = @calle and numero = @numero)
        return -2;

    if not exists (select 1 from piso where calle = @calle and numero = @numero and planta = @planta)
        return -3;

    if not exists (select 1 from piso where calle = @calle and numero = @numero and planta = @planta and puerta = @puerta)
        return -4;

    select @dnipropietario = dnipropietario
    from piso
    where calle = @calle and numero = @numero and planta = @planta and puerta = @puerta;

    select @nombrepropietario = nombre + ' ' + apellido1 + ' ' + apellido2
    from propietario
    where dni = @dnipropietario;

    return 0;
end;
go

/*
a) Se creará un procedimiento llamado prPropietarioPiso que reciba un piso y devuelva en un parámetro de salida el nombre del dueño. Se controlará los errores utilizando un valor de retorno.
Para ejecutar el anterior procedimiento se hará haciendo una llamada dentro del procedimiento prVisualizarPropietarioPiso y se visualizará  el dueño o un mensaje representativo según el error.

Ejemplo de salida:
El dueño del piso Alegria,44 1 A es Elena González de la Sierra
no existe puerta Z en la planta 1 de la calle Alegria,44
no existe la planta 9 en la calle Alegria,44
no existe la calle Luna
*/

if object_id('prvisualizarpropietariopiso') is not null
    drop procedure prvisualizarpropietariopiso;
go

create procedure prvisualizarpropietariopiso
    @calle nvarchar(100),
    @numero int,
    @planta int,
    @puerta char(1)
as
begin
    declare @nombrepropietario nvarchar(200);
    declare @resultado int;

    set @resultado = -99;

    exec @resultado = prpropietariopiso
        @calle = @calle,
        @numero = @numero,
        @planta = @planta,
        @puerta = @puerta,
        @nombrepropietario = @nombrepropietario output;

    if @resultado = 0
        print 'el dueño del piso ' + @calle + ',' + cast(@numero as varchar) + ' ' + cast(@planta as varchar) + ' ' + @puerta + ' es ' + @nombrepropietario;
    else if @resultado = -1
        print 'no existe la calle ' + @calle;
    else if @resultado = -2
        print 'no existe el número ' + cast(@numero as varchar) + ' en la calle ' + @calle;
    else if @resultado = -3
        print 'no existe la planta ' + cast(@planta as varchar) + ' en la calle ' + @calle + ',' + cast(@numero as varchar);
    else if @resultado = -4
        print 'no existe la puerta ' + @puerta + ' en la planta ' + cast(@planta as varchar) + ' de la calle ' + @calle + ',' + cast(@numero as varchar);
end;
go

exec prvisualizarpropietariopiso 'alegria', 44, 1, 'a'; -- : prueba ok
exec prvisualizarpropietariopiso 'callequenoexiste', 44, 1, 'a'; -- error -1: calle 
exec prvisualizarpropietariopiso 'alegria', 345, 1, 'a'; -- error -2: número 
exec prvisualizarpropietariopiso 'alegria', 44, 678, 'a'; -- error -3: planta 
exec prvisualizarpropietariopiso 'alegria', 44, 1, 'z'; -- error -4: puerta 


/*
b)Se hará lo mismo que anteriormente pero ahora utilizando una función llamada fnPropietarioPiso que reciba un piso y devuelva el nombre del dueño si el piso existe sino se devolverá el valor del tipo de error ( -1,-2,..). y se visualizará  el dueño o un mensaje representativo según el error.

Para ejecutar la anterior función se hará haciendo una llamada dentro del procedimiento prVisualizarPropietarioPiso2
*/

if object_id('fnpropietariopiso') is not null
    drop function fnpropietariopiso;
go

create function fnpropietariopiso(
    @calle varchar(100),
    @numero int,
    @planta int,
    @puerta char(1)
)
returns nvarchar(200)
as
begin
    declare @resultado nvarchar(200);
    declare @dni varchar(20);

    if not exists (select 1 from vivienda where calle = @calle)
        return '-1';
    if not exists (select 1 from vivienda where calle = @calle and numero = @numero)
        return '-2';
    if not exists (select 1 from piso where calle = @calle and numero = @numero and planta = @planta)
        return '-3';
    if not exists (select 1 from piso where calle = @calle and numero = @numero and planta = @planta and puerta = @puerta)
        return '-4';

    select @dni = dnipropietario
    from piso
    where calle = @calle and numero = @numero and planta = @planta and puerta = @puerta;

    select @resultado = nombre + ' ' + apellido1 + ' ' + ISNULL(apellido2,'')
    from propietario
    where dni = @dni;

    return @resultado;
end;
go

if object_id('prvisualizarpropietariopiso2') is not null
    drop procedure prvisualizarpropietariopiso2;
go

create procedure prvisualizarpropietariopiso2
    @calle varchar(100),
    @numero int,
    @planta int,
    @puerta char(1)
as
begin
    declare @resultado nvarchar(200);
    set @resultado = dbo.fnpropietariopiso(@calle, @numero, @planta, @puerta);

    if @resultado = '-1'
        print 'no existe la calle ' + @calle;
    else if @resultado = '-2'
        print 'no existe el número ' + cast(@numero as varchar) + ' en la calle ' + @calle;
    else if @resultado = '-3'
        print 'no existe la planta ' + cast(@planta as varchar) + ' en la calle ' + @calle + ',' + cast(@numero as varchar);
    else if @resultado = '-4'
        print 'no existe la puerta ' + @puerta + ' en la planta ' + cast(@planta as varchar) + ' de la calle ' + @calle + ',' + cast(@numero as varchar);
    else
        print 'el dueño del piso ' + @calle + ',' + cast(@numero as varchar) + ' ' + cast(@planta as varchar) + ' ' + @puerta + ' es ' + @resultado;
end;
go

exec prvisualizarpropietariopiso2 'damasco', 3, 1, 'b';
exec prvisualizarpropietariopiso2 'damasco', 3, 1, 'z';
exec prvisualizarpropietariopiso2 'damasco', 3, 9, 'a';
exec prvisualizarpropietariopiso2 'damasco', 99, 1, 'a';
exec prvisualizarpropietariopiso2 'callequenoexiste', 3, 1, 'a';


/*
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


-- prpisostiene2
if object_id('prpisostiene2') is not null
    drop procedure prpisostiene2;
go

create procedure prpisostiene2
    @dni varchar(20),
    @numpisos int output,
    @estado int output
as
begin
    print 'nivel de anidación: ' + cast(@@nestlevel as varchar)

    if @dni is null
    begin
        set @estado = 2;
        return 2;
    end;

    if not exists (select 1 from propietario where dni = @dni)
    begin
        set @estado = 1;
        return 1;
    end;

    select @numpisos = count(*) from piso where dnipropietario = @dni;

    if @numpisos = 0
    begin
        set @estado = 3;
        return 3;
    end;

    set @estado = 4;
    return 4;
end;
go


if object_id('prpisostiene1') is not null
    drop procedure prpisostiene1;
go

create procedure prpisostiene1
    @dni varchar(20)
as
begin
    declare @numpisos int, @estado int, @retorno int;

    print 'nivel de anidación: ' + cast(@@nestlevel as varchar)

    exec @retorno = prpisostiene2 @dni, @numpisos output, @estado output;

    if @estado = 1
        print 'la persona no existe.';
    else if @estado = 2
        print 'no se ha proporcionado ningún dni.';
    else if @estado = 3
        print 'la persona no tiene pisos.';
    else if @estado = 4
        print 'la persona tiene ' + cast(@numpisos as varchar) + ' piso(s).';
    else
        print 'estado desconocido.';
end;
go

exec prpisostiene1 '88888822h'; --ok
exec prpisostiene1 '99888888m'; --sin pisos
exec prpisostiene1 '00000000z'; --persona no existe
exec prpisostiene1 null; --sin dni
