use PASTELERIA
go 


if OBJECT_ID('prTraspaso') is not null 
	drop procedure prTraspaso
go 

--alter table pastelero 
--	add FechaBaja date null
--go

create procedure prTraspaso
	@alias1 varchar(30),
	@alias2 varchar(30),
	@numPastelerias smallint output, 
	@numRecetas smallint output
as 
begin

	if not exists (select 1 from PASTELERO where ALIAS = @alias1)
		return -1
	
	if not exists(select 1 from PASTELERO where ALIAS = @alias2)
		return -2
	
	begin transaction
	begin try
		declare @cod1 numeric, @cod2 numeric
		set @cod1 = (select codigo from PASTELERO where ALIAS = @alias1)
		set @cod2= (select codigo from PASTELERO where ALIAS = @alias2)
		
		update PASTELERO
			set FechaBaja = GETDATE() 
			where ALIAS = @alias1 
		
		
		update PASTELERIA
			set CODPASTELERO = @cod2
			where CODPASTELERO = @cod1
			
		set @numPastelerias = @@ROWCOUNT
		
		update RECETA
			set CODPASTELERO = @cod2
			where CODPASTELERO = @cod1
				
		set @numRecetas = @@ROWCOUNT
		
	commit transaction
		
		print 'se han traspasado ' + cast(@numPastelerias as varchar(3)) + ' y ' + cast(@numRecetas as varchar(3))  + ' recetas' 
		return 0
	end try 
	begin catch
		rollback 
		print 'error' 
	end catch	
end
go

declare @return int, @numpastelerias int, @numrecetas int 
exec @return =  prTraspaso 'Lucita','Manolin',@numrecetas output, @numpastelerias output
print cast(@return as varchar(5))


--exec @return = prTraspaso 'Carlitos','alias3',@numPastelerias output, @numRecetas output
exec prTraspaso 'Lucita','alias', @numPastelerias = @numpastelerias output, @numRecetas = @numRecetas output

print cast(@return as varchar(3))




--ej 2 

if OBJECT_ID('pr_IngredienteReceta') is not null
	drop procedure pr_IngredienteReceta
go 

create procedure pr_IngredienteReceta
	@nombreingrediente varchar(30) = 'Huevo'
as
begin

	print replicate('-',10) + ' LISTA DE INGREDIENTES QUE LLEVAN ' + @nombreIngrediente + replicate('-',10)
	
	if not exists (select 1 from INGREDIENTE where NOME = @nombreingrediente) 
		begin 
			print SPACE(15) + ' EL INGREDIENTE NO EXISTE EN LA BASE DE DATOS '
			RETURN -1
		end
		
	else if not exists (select ri.COD_INGREDIENTE from RECETA_INGREDIENTE ri
						inner join INGREDIENTE i on i.CODIGO = ri.COD_INGREDIENTE
						where i.NOME = @nombreingrediente ) 
		begin
			print space(15) + ' EL INGREIDENTE EXISTE PERO NO EXISTE NINGUNA RECETA QUE LO LLEVE'
		end
	
	-- variables del cursor 
	else
	BEGIN 
	
	declare @alias varchar(15), @receta varchar(50), @dificultade varchar(15), @tiempo float, @numReceta int 
	set @numReceta = 0
	
	declare cursorIngredientes cursor dynamic for 
		select r.nombre, p.alias, r.dificultad, r.tiempo from receta r inner join pastelero p on p.codigo = r.codpastelero
	open cursorIngredientes 
	
	fetch next from cursorIngredientes into @receta,@alias,@dificultade,@tiempo
	while @@FETCH_STATUS != -1 
		begin 
		if @@FETCH_STATUS != -2
		fetch next from cursorIngredientes into @receta,@alias,@dificultade,@tiempo
			begin 
				set @numReceta = @numReceta + 1
				print 'Receta ' + cast(@numReceta as varchar(3)) + replicate('.',6) + ':' + @receta 
					+ ' perteneciente a ' + @alias 
				print space(15) + 'Dificultade ' + @dificultade + ' Tiempo: ' + cast(@tiempo as varchar(3)) 
			
				fetch next from cursorIngredientes into @receta,@alias,@dificultade,@tiempo
			end 
		end

	
	close cursorIngredientes 
	deallocate cursorIngredientes
	END 
end
go

exec pr_IngredienteReceta 'COCO'
exec pr_IngredienteReceta 'noexisto'
exec pr_IngredienteReceta 'Leche'



--3 

--3.1
IF OBJECT_ID('fnTrofeosPastelero') is not null
	drop function fnTrofeosPastelero
go 


create function fnTrofeosPastelero(@codpastelero numeric)
	returns varchar(max)
as
begin 
	declare @cadTrofeos varchar(max)
	set @cadtrofeos = ''
	
	--cursor 
	declare @nombreT varchar(20), @año int
	
	declare cursorTrofeos cursor for 
		select trofeo, anho from trofeo where codpastelero = @codpastelero 
		
	open cursorTrofeos
	fetch next from cursorTrofeos into @nombreT, @año
	
	while @@FETCH_STATUS = 0 
	begin
		set @cadTrofeos = @cadTrofeos + @nombreT + ' - ' + CAST(@año as varchar(3)) + ' | '
		fetch next from cursorTrofeos into @nombreT, @año
	end
	
	close cursorTrofeos
	deallocate cursorTrofeos
	
	return @cadtrofeos
	
	
end
go


IF OBJECT_ID('fnInfoPasteleros') is not null
	drop function fnInfoPasteleros
go 


create function fnInfoPasteleros(@provincia varchar(15),@numero int)
returns table 
as
return (
	select 
	p.ALIAS as ALIAS,
	p.NOMBRE + ' ' + p.APELLIDO1 + ' ' + ISNULL(p.APELLIDO2,'') as [NOMBRE COMPLETO],
	coalesce(m.NOMBRE + ' ' + m.APELLIDO1 + ' ' + ISNULL(m.APELLIDO2,''), 'SIN MAESTRO') as MAESTRO,
	dbo.fnTrofeosPastelero(p.CODIGO) as TROFEOS
	
	from PASTELERO p
	left join PASTELERO m on m.CODIGO = p.PASTELEROMAESTRO
	where p.CODPROVINCIA = (select CODIGO from PROVINCIA where NOMBRE = @provincia)
	and (select COUNT(*) from TROFEO where CODPASTELERO = p.CODIGO) >= @numero
)
go


if OBJECT_ID('prVisualizarInfoPasteleros') is not null 
	drop procedure prVisualizarInfoPasteleros
go 

create procedure prVisualizarInfoPasteleros
	@nombreProvicincia varchar(39) = 'Lugo',
	@numTrofeos int = 1

as 
begin 
	if not exists (select 1 from PROVINCIA where NOMBRE = @nombreProvicincia)
		begin
			print 'la provincia no existe'
			return -1
		end
	else if @numTrofeos < 0 
		begin
			print 'el número tiene que ser positivo'
			return -2
		end
	
	if not exists (select * from dbo.fnInfoPasteleros(@nombreProvicincia,@numTrofeos)) 
		begin 
			print 'existe, pero no ha gana-do tantos premios'
		end 
	else 
	begin
		select * from dbo.fnInfoPasteleros(@nombreProvicincia,@numTrofeos) 
	end 

end 
go 

exec prVisualizarInfoPasteleros 'Pera',0
exec prVisualizarInfoPasteleros 'Lugo',3894
exec prVisualizarInfoPasteleros 'Lugo',1