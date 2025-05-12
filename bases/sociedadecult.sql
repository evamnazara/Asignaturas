use SOCIEDADE_CULTURAL
go

--1)Executa o guión BD_SOCIEDADE_CULTURAL_GuionCreacion.sql para crear a base de datos SOCIEDAD CULTURAL en SQL Server e a continuación xera o diagrama de base de datos para familiarizarte co deseño da BBDD.

--2)      Indica o número  de aulas que hai nos distintos estados . Nunha columna aparecerá cada estado diferente (co texto Ben, Mal ou Regular) e noutra o número de aulas de cada estado. Faino de dúas maneiras e ver  cal é máis óptima.  
select COUNT(*) as numeroAulas,
	case 
		when estado = 'B' then 'Ben'
		when estado = 'M' then 'Mal'
		when estado = 'R' then 'Regular'
	end as EstadoAula
from AULA
group by estado
	--having COUNT(*) > 2

--3)     Nome, data de inicio ( formato: dd de mes de yyyy), hora (hh:mm), prezo daquelas actividades non gratuítas do mes de febreiro de calquera ano. Faino de dúas maneiras  e ver  cal é máis óptima ( ou mes ten que ir en letras,  exemplo,  xaneiro,etc..   
-- nome                           data inicio                                          hora            prezo
--TENIS PARA PRINCIPIANTES  Lunes, 10 de Febrero de 2014           16:00            301.55
select nome,
	DATENAME(WEEKDAY,data_ini) + ', ' +
	CAST(DAY(data_ini) as varchar(2)) + ' de ' +
	DATENAME(MONTH,data_fin) + ' de ' + 
	CAST(YEAR(data_ini) as varchar(4)) 
	as Data,
	DATENAME(HOUR,data_ini) as HoraInicio
from ACTIVIDADE
where MONTH(data_ini) > 2 and prezo > 0


--4)     a)Indica o nome e a aula das actividades nas que participan menos de dous socios.
select a.nome, a.num_aula 
from ACTIVIDADE a 
left join SOCIO_REALIZA_ACTI SRA on a.identificador = SRA.id_actividade 
group by a.nome, a.num_aula
having count(SRA.num_socio)< 2

-- b)Para las actividades nas que participan máis de 1 socio, visualizar nome, aula e o número de profesores     que a cursan

select a.nome,a.num_aula,COUNT(PCA.num_profesorado)
from ACTIVIDADE a
inner join PROFE_CURSA_ACTI pca on pca.id_actividade=a.identificador
left join SOCIO_REALIZA_ACTI sra on sra.id_actividade = a.identificador 
group by a.nome,a.num_aula 
having COUNT(num_socio) > 1


--5)     Visualiza o  NIF ( formato dd.ddd.dd-letra), nome completo e teléfono fixo xunto á localidade con formato:(localidad)ddd-dd-dd-dd)  dos empregados que non asisten a actividades e dos que temos o teléfono fixo.

--Faino das seguintes maneiras:  subconsultas,  text de existencia e  multitabla. Ver cales son as máis óptimas.
select 
	e.nome + ' ' + e.ape1 as NomeCompleto,
	SUBSTRING(e.nif,1,2) + '.' + SUBSTRING(e.nif,3,3) + '.' + SUBSTRING(e.nif,6,2)+RIGHT(e.nif,1)  as NIF,
	e.tel_fixo, e.tel_mobil,
	'('+localidade_enderezo+')' + '('+cod_provincia_enderezo+')' 	
	from EMPREGADO e
left join PROFE_CURSA_ACTI pcr on pcr.num_profesorado = e.numero
where 
	pcr.num_profesorado is null 
	and tel_fixo is not null


--6)     a)Nome, data de inicio e fin (solo fecha formato dd/mm/aaaa) e duración en semanas das actividades con prezo menor que a cota máis cara existente. Se é menor que algunha será menor q a máis cara. 
SELECT 
    a.nome,
    CONVERT(varchar(10), a.data_ini, 103) AS DataInicio,
    CONVERT(varchar(10), a.data_fin, 103) AS DataFin,
    DATEDIFF(WEEK, a.data_ini, a.data_fin) AS DuracionSemanas
FROM actividade a
WHERE a.prezo < (SELECT MAX(importe) FROM cota);



--CONVERT ( tipo de datos, expresión [ , código del estilo ] 
-- - Para filtrar o comparar los datos, faino das seguintes maneiras:  -1.- utilizando solo un operador de comparación ( <,>,=,...)  e 2- utilizando operador comparación máis operador de conxunto (>some, <some,>all ,=in, etc....)

--    b)  Nome, data de inicio e fin (solo fecha formato dd/mm/aaaa) e duración en semanas das actividades  que superar la media de la duración en semanas de todas las actividades

--   c) Nome, data de inicio e fin (solo fecha formato dd/mm/aaaa) e duración en semanas das actividades  que superan a media da duración en semanas  só tendo en conta as actividades con igual o menor prezo.
select a.nome,
	CONVERT(varchar(10),a.data_fin,103) as DataInicio, 
	CONVERT(varchar(10),a.data_fin, 103) as DataFin,
	DATEDIFF(WEEK,a.data_ini, a.data_fin) as DuracionSemanas 
from ACTIVIDADE a
where prezo > (select MAX(importe) from cota)


--7)Nome e importe das cotas que están asignadas a un socio polo menos e cuxo prezo está entre 40 e 100€.

select distinct
	c.nome,c.importe
from cota c
inner join SOCIO s on c.codigo=s.cod_cota
where c.importe between 40 and 100


--- Resólvea de dúas maneiras: utilizando  joins ( multitabla), con  subconsultas, e con test de existencia. Ver  cal é a máis óptima

--8)     NIF e nome completo dos socios que realizan actividades impartidas por profesores que cursan algunha actividade.

select s.nif, s.nome
from SOCIO s
	inner join SOCIO_REALIZA_ACTI src on src.num_socio = s.numero
	inner join ACTIVIDADE a on a.identificador = src.id_actividade
	inner join PROFE_CURSA_ACTI pcr on pcr.id_actividade = a.identificador

--9)     a) Para cada socio que recomendou a outro socio, visualiza  nif,  nombrecompleto, numero de socios recomendados, numero de actividades que cursa.

SELECT 
    s.nif,
    s.nome + ' ' + s.ape1 + ' ' + ISNULL(s.ape2, '') AS nomeCompleto,
    COUNT(DISTINCT s2.numero) AS numRecomendados,
    COUNT(DISTINCT sra.id_actividade) AS numActividades
FROM socio s
LEFT JOIN socio s2 ON s2.socio_recomienda = s.numero 
LEFT JOIN SOCIO_REALIZA_ACTI sra ON sra.num_socio = s.numero 
GROUP BY s.nif, s.nome, s.ape1, s.ape2
HAVING COUNT(DISTINCT s2.numero) > 0

--b) Para cada socio, visualiza o seu  nif , nome completo, idade e nome completo,  nif e idade do socio que lle recomendou. Se non foi recomendado mostrarase esta información en branco.

SELECT 
    s.nif, s.nome + ' ' + s.ape1 + ' ' + ISNULL(s.ape2, '') AS nomeCompleto,
    DATEDIFF(dd,s.data_nac,GETDATE()) / 365.25 as Idade,
    s2.nome as socioRecomenda
FROM socio s
	left join SOCIO s2 on s2.numero = s.socio_recomienda


--c) Para cada socio que realiza máis dunha actividade, visualiza a súa  nif , nome completo, idade e nome completo do socio que lle recomendou. Se non foi recomendado mostrarase esta información en branco.

select
	s.nif, 
	s.nome + ' ' + s.ape1 as NomeSocio,
	DATEDIFF(dd,s.data_nac,GETDATE()) / 365.25 as IdadeSocio,
	s2.nif, s2.nome + ' ' + s2.ape1 as SocioRecomienda,
	DATEDIFF(dd,s2.data_nac,getDATE()) / 365.25 as IdadeSocioRecomienda
from SOCIO s
left join SOCIO s2 on s2.numero = s.socio_recomienda
inner join SOCIO_REALIZA_ACTI SRA on sra.num_socio = s.numero

GROUP BY 
    s.nif, s.nome, s.ape1, s.ape2, s.data_nac,
    s2.nif, s2.nome, s2.ape1, s2.ape2, s2.data_nac
HAVING COUNT(*) > 1;

--10)  NIF dos empregados cuxos salarios mensuais son maiores que a suma dos prezos das actividades que imparte.

select e.nif, SUM(a.prezo),e.salario_mes
from EMPREGADO e 

inner join PROFESORADO p on p.num_prof = e.numero
inner join ACTIVIDADE a on p.num_prof = a.num_profesorado_imparte
group by e.nif,e.salario_mes
having e.salario_mes > SUM(a.prezo)

--11)  NIF, nome completo e o cargo de todos os empregados, xunto co nome das actividades que cursan. Aínda que un empregado non curse ningunha actividade tamén debe aparecer.
SELECT 
    e.nif AS NIFEmpleado, 
    e.nome + ' ' + e.ape1 + ' ' + ISNULL(e.ape2, '') AS NomeEmpleado,
    e.cargo,
    a.nome AS NomeActividade
FROM empregado e
LEFT JOIN profesorado p ON p.num_prof = e.numero
LEFT JOIN profe_cursa_acti pca ON pca.num_profesorado = p.num_prof
LEFT JOIN actividade a ON a.identificador = pca.id_actividade;


--12)  NIF e gasto en actividades realizadas dos socios que levan gastado en actividades máis do valor da cota máxima.

select s.nif, SUM(a.prezo) as gastoTotal
	from SOCIO s

inner join SOCIO_REALIZA_ACTI sra on s.numero = num_socio
inner join ACTIVIDADE a on sra.id_actividade = a.identificador

group by s.nif
having SUM(a.prezo) > (SELECT MAX(importe) from COTA)

--13)  Numero, descrición, superficie e estado das aulas xunto co nome, prezo  das actividades e número de aula na que se imparten. Faino das seguintes maneiras (Repasa a combinación de tablas e os posibles casos de combinación):


--a)Deben aparecer todas as actividades independentemente de teñen ou non asignadas unha aula
select a.nome as Actividade,
		a.prezo as PrezoActi,
		au.numero as NumAula,
		au.descricion as DescAula,
		au.superficie as SupAula,
		au.estado as EstadoAula
from ACTIVIDADE a
	left join AULA au on au.numero = a.num_aula

--b)Deben aparecer todas as aulas aínda que non teñan asociada ningunha actividade

select a.nome as Actividade,
		a.prezo as PrezoActi,
		au.numero as NumAula,
		au.descricion as DescAula,
		au.superficie as SupAula,
		au.estado as EstadoAula
from aula au
	left join ACTIVIDADE a on au.numero = a.num_aula

--c)Deben aparecer todas as actividades independentemente de teñen ou non asignadas unha aula, e todas as aulas aínda que non teñan asociada ningunha actividade.   

select a.nome as Actividade,
		a.prezo as PrezoActi,
		au.numero as NumAula,
		au.descricion as DescAula,
		au.superficie as SupAula,
		au.estado as EstadoAula
from aula au
	full join ACTIVIDADE a on au.numero = a.num_aula

-- 14)  Obtén as datas de inicio e fin, e duración en días, meses, semanas e horas de todas as actividades.

--15)  Listaxe coa data de inicio das actividades na primeira columna. Nas seguintes aparecerán: a data de inicio adiantada 1 ano, a data de inicio adiantada 3 meses, a data de inicio retrasada 4 días e a data de inicio retrasada 2 horas.

--16)  Queremos crear unha táboa de nome INFO_TELEFONOS co nome, apelidos e teléfono de todos os socios. Deberá visualizarse o teléfono1, se o ten, senón o teléfono2, e se non ten teléfono amosarase a frase 'Sen teléfono'.
 if OBJECT_ID('info_telefonos') is not null
 drop table info_telefonos
go

select nome + ' ' + ape1 + ' ' + ISNULL(ape2,'') as nomeCompleto, 
coalesce(tel_mobil,tel_fixo,'sin telefono') as Telefono
into info_telefonos 
from SOCIO 
--17)  ¿Quen son os socios  que están apuntados a máis actividades? faino  de dous maneiras: 1.-con top e 2.- de forma estándar ( sin utilizar top)

select top 1 with ties s.numero,s.nome,COUNT(*)
from SOCIO s
inner join SOCIO_REALIZA_ACTI sra on sra.num_socio = s.numero
group by s.numero, s.nome
order by COUNT(*) desc


--18)  Reformase a  aula de cociña para que o seu estado sexa Bo e amplíase en 20 metros máis dos que tiña. Actualiza a información na base de datos.


--19)  Apúntase un novo socio á sociedade. O seu nif é 90897867B e o seu nome é Peter Smith.  Naceu o 19 de febreiro de 1990 e o seu teléfono é 690112233. Vive na rúa Paz nº15 15444 Milladoiro (A Coruña). Entra por recomendación de Jorge del Carmen Lérez  e vai  ser do mesmo tipo de socio que éste. Abona ao apuntarse a cota habitual e vai realizar a actividade de Zumba, que xa deixa pagada. Introduce esta información na base de datos tendo en conta que  queremos asegurarnos de que a información da base de datos quede  consistente. (Non quede a operación a medias e faino das maneiras que coñezas)

begin transaction
begin try 
	insert into SOCIO (numero,nif,data_nac,telefono1,)
	values ()
	commit transaction 
end try 
begin catch
rollback transaction 
	print 'error' 
end catch