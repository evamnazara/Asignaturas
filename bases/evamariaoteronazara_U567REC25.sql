--Eva Maria Otero Nazara 
--DNI 77416510M 

use GALERIAARTE
go 

--1 

select 
	cast(CODIGO as varchar(5)) as CODIGO,
	NOME + '(' + PAIS + ')' AS NOMBRE,
	CASE 
		when data_falecemento is null then cast(DATEDIFF(year,DATA_NACEMENTO,getdate()) AS varchar(10)) + ' anos vivo.'
		else CAST(DATEDIFF(YEAR,data_nacemento,Data_falecemento) as varchar (10)) + '(' + CAST( DATEDIFF(YEAR,DATA_FALECEMENTO,GETDATE()) as varchar(5)) + ').'
	END AS edad
 from ARTISTA a 
 where 
		a.CODIGO  in (SELECT a.CODIGO from ARTISTA a 
						inner join OBRA o on o.COD_ARTISTA = a.CODIGO
						inner join ESCULTURA e on e.CODIGO = o.codigo) 
						
		and a.codigo not in (SELECT a.CODIGO from ARTISTA a 
						inner join OBRA o on o.COD_ARTISTA = a.CODIGO
						inner join cadro c on c.CODIGO = o.codigo) 
order by a.NOME desc


--2

select distinct 
	CAST(p.CODIGO as varchar(3)) as CodigoPatrocinador,
	p.NOME as NomePatrocinador,
	COUNT(*) as NumeroArtistas 
from patrocinador p 
	left join patrocinador_artista pa on pa.COD_PATROCINADOR = p.CODIGO 
	left join artista a on a.CODIGO = pa.COD_ARTISTA
	left join ESCOLA e on e.CODIGO = a.COD_ESCOLA

where DATEPART(YEAR,e.DATA_APARICION) > 1930

group by p.NOME, p.CODIGO
order by NumeroArtistas desc, p.NOME asc


--3


select 
	CAST(a.CODIGO as varchar(3)) + ' - ' + a.NOME as nome,
	a.LOCALIDADE as localidade
from artista a 
where a.DATA_FALECEMENTO is not null 
	and exists (select a.CODIGO, count(*) as numObras
						from ARTISTA a
						inner join OBRA o on o.COD_ARTISTA = a.CODIGO
						inner join ESCULTURA e on e.CODIGO = o.CODIGO 
						left join GALERIA g on g.CODIGO = o.COD_GALERIA
						group by a.CODIGO 
						having COUNT(*) > 1)

order by LEN(a.localidade) desc, a.NOME asc;

--4 
select a.NOME + COALESCE(' -' + e.nome + '-','') as [NOMBRE(ESCUELA)],
	COALESCE(maestro.nome + ' (' + maestro.pais + ')','') as [MAESTRO(PAIS]
from ARTISTA a 
	left join ESCOLA e on e.CODIGO = a.COD_ESCOLA 
	left join artista maestro on maestro.CODIGO = a.COD_MESTRE --no tiene poe que tenerlo
	
where a.DATA_FALECEMENTO is not null 
	and DATEDIFF(year,a.DATA_FALECEMENTO,GETDATE()) >= 10
order by a.NOME asc;

--5

IF OBJECT_ID ('CopiaGaleria') IS NOT NULL
    DROP TABLE CopiaGaleria;
--copia de la tabla 
select * into CopiaGaleria from GALERIA 
--update 
update CopiaGaleria
set metros =
	case 
		when metros > (SELECT AVG(metros) from GALERIA g
							inner join LOCALIDADE l on l.CODIGO = g.COD_LOCALIDADE
							inner join PROVINCIA p on p.CODIGO = l.COD_PROVINCIA
						) then  METROS + (METROS * 0.30)
		else METROS + (METROS * 0.15)
	end 

--select * from GALERIA 
--select * from CopiaGaleria 

--6 
--6A) crear tabla 
IF OBJECT_ID ('CopiaGaleriaArte') IS NOT NULL
    DROP TABLE CopiaGaleriaArte;
go 

create table CopiaGaleriaArte (
	codigo int not null,
	nombre varchar(59) not null,
	contacto varchar (30) not null,
	fechainauguracion varchar(50),
	metros int null
);

insert into CopiaGaleriaArte 
select 
	g.CODIGO as CODIGO, 
	g.NOME as NOME,
	COALESCE('(' + LEFT(g.TELEFONO1,3) + ') ' + SUBSTRING(g.TELEFONO1,4,6),g.email,'') as CONTACTO,
	CAST(datename(WEEKDAY,g.DATAINAGURACION) as varchar(15)) + ', ' + datename(DAY, g.DATAINAGURACION) +
		 ' de ' + DATENAME(MONTH,g.DATAINAGURACION)+ ' de ' + DATENAME(YEAR,g.DATAINAGURACION) as [DATA INAUGURACION],
	g.metros as METROS
	from galeria g 
		inner join OBRA o on o.COD_GALERIA = g.CODIGO
		inner join CADRO c on c.CODIGO = o.CODIGO
	where c.TECNICA in ('Acuarela','Oleo','Grabado') 
	group by g.CODIGO,g.NOME,g.TELEFONO1,g.EMAIL,g.DATAINAGURACION,g.METROS
	having COUNT(*) > 1

select * from CopiaGaleriaArte

--6b 

delete from CopiaGaleriaArte
WHERE nombre in (SELECT top 3 with ties nombre
					from CopiaGaleriaArte 
					order by metros ASC) 
select * from CopiaGaleriaArte

--7 

begin transaction 
	declare 
		@codArtistaJoven int,
		@codLucas int,
		@fechaNacLucas date;
	
	set @codArtistaJoven = (select top 1 CODIGO from ARTISTA order by DATA_NACEMENTO desc,CODIGO asc)
	set @codLucas = (SELECT MAX(CODIGO)+ 1 from ARTISTA)
	set @fechaNacLucas = GETDATE()

begin try 

	insert into ARTISTA (CODIGO, NOME, LOCALIDADE, PAIS,DATA_NACEMENTO, DATA_FALECEMENTO,COD_MESTRE,COD_ESCOLA)
	values ( @codLucas, 'LUCAS GOMEZ',
		(select LOCALIDADE from ARTISTA where NOME = 'Luis Vicente'),
		(select pais from ARTISTA where NOME = 'Luis Vicente'),
		@fechaNacLucas, --
		null, 
		@codArtistaJoven,
		(select codigo from ESCOLA where NOME = 'Azulona')
	)
	print 'Artista Lucas insertado'
	
	insert into OBRA (CODIGO,NOME,MEDIDAS,ANO,COD_ARTISTA,COD_GALERIA)
	values(	
		(select MAX(codigo)+1 from OBRA),
		'El beso','40X70', DATEADD(MONTH,-4,GETDATE()),@codLucas, 
		(SELECT codigo from GALERIA where nome = 'La Casona')
		) 
		
	insert into ESCULTURA (CODIGO,material)
	values ((select codigo from OBRA where NOME = 'El Beso'), 'Bronce')
	
	print 'Escultura El Beso insertada'
	
	insert into OBRA (CODIGO,NOME,MEDIDAS,ANO,COD_ARTISTA,COD_GALERIA)
	values(	
		(select MAX(codigo)+1 from OBRA),
		'Las Margaritas',null,DATEADD(DAY,-2,GETDATE()), @codLucas, 
		(SELECT codigo from GALERIA where nome = 'La Casona')
		) 
		
	insert into CADRO (CODIGO,TECNICA)
	values(	
		(select codigo from OBRA where NOME = 'Las Margaritas'), 'Acuarela')
	
	print 'Cadro Las Margaritas insertado'

	update ARTISTA 
	set COD_MESTRE = @codLucas
	where NOME = 'André Pagnol' 
	print 'Insertado como maestro de andré'
commit transaction 
end try

begin catch
	rollback transaction 
	print 'Error'
end catch 

