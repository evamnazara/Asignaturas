--1. Selecciona todas las empleadas que viven en Pontevedra, Santiago o Vigo.
select nome + ' ' + apelido1 + ' ' + isnull(apelido2,'') as NomeCompleto
from empregado
where sexo = 'M' 
	and localidade in ('Pontevedra','Santiago','Vigo');

--2. Haz una consulta que devuelva los nombres y fecha de nacimiento de los hijos e hijas de modo que aparezcan en primer lugar los 
--hijos de empleados y a continuación las hijas y dentro de esto ordenados por edad.
SELECT nome  + ' ' + apelido1 + ' ' + ISNULL(apelido2,'') as NomeCompleto, DataNacemento
	from FAMILIAR 
	where parentesco in ('hijo','hija')
	order by parentesco asc, DataNacemento asc;


--3. Haz una consulta que muestre el nombre del curso y el número de horas de los dos cursos que más duran.
-- En el caso de haber un empate deben visualizarse todos.
select top 2 with ties nome, horas from curso
order by horas desc;


--4. ¿En qué localidades se desarrollan proyectos? Muéstralas por orden alfabético. 
select distinct lugar from proxecto
order by lugar asc;

--5. Muestra los datos de las tareas que están sin terminar.
select * from tarefa 
--where estado not in ('Finalizada'); 
where data_fin is null 

--6. Muestra el nombre completo y NSS de los empleados que tienen un supervisor, de Lugo o Monforte, que nacieron entre el año 1970 y 1990.
select nome + ' ' + apelido1 + ' ' + isnull(apelido2,'') as NomeCompleto,
	NSS as NSSEMpregado
	from empregado 
	where Localidade in ('Lugo','Monforte') 
	and YEAR(DataNacemento) between 1970 and 1990


--7. Obtén una relación de localidades de empleados junto con sus gentilicios teniendo en cuenta que no deben aparecer valores duplicados 
--y las siguientes correspondencias (en caso de no tener correspondencia deberá indicar "Otro").
/*Lugo - lucense
Pontevedra - pontevedrés
Vigo - vigués
Santiago - compostelano
Monforte - monfortino */

select distinct localidade, 
	case Localidade
		when 'Lugo' then 'Lucense'
		when 'Pontevedra' then 'Pontevedresa' 
		when 'Vigo' then 'vigués'
		when 'Santiago' then 'compostelano'
		when 'Monforte' then 'monfortino'
	end as gentilicio 
from empregado;

/*8. Vamos a mejorar la consulta anterior para que tenga en cuenta si se trata de un hombre o una mujer y de este modo ponga:
Lugo - lucense 
Pontevedra - pontevedrés / pontevedresa
Vigo - vigués / viguesa
Santiago - compostelano /compostelana
Monforte - monfortino /monfortina */

select distinct localidade,  
	case 
		when localidade in ('vigo') and sexo = 'M' then 'Viguesa'
		when localidade in ('Pontevedra') and sexo = 'H'  then 'Pontevedrés'

	end as gentilicio
from empregado




--9. Muestra el nombre completo de los empleados y la fecha de nacimiento de la siguiente manera:
--azucena paz farto - miercoles, 28 de febrero de 1996 

SELECT 
    nome + ' ' + apelido1 + ' ' + ISNULL(apelido2, '') AS nomeCompleto,
    DATENAME(weekday, dataNacemento) + ', ' +
    CAST(DAY(dataNacemento) AS VARCHAR(2)) + ' de ' +
    DATENAME(month, dataNacemento) + ' de ' +
    CAST(YEAR(dataNacemento) AS VARCHAR(4)) AS dataNacemento
FROM empregado;


--10. Muestra el nombre completo de los familiares que tienen un apellido (cuaquiera de los dos) de menos de 5 letras, 
--ordenados por primer apellido y dentro de este por segundo apellido.
select nome + ' ' + apelido1 + ' ' + isnull(apelido2, '') as nomecompleto 
from familiar
where len(apelido1) < 5 
	or len(apelido2) < 5 
order by apelido1 asc, apelido2 asc;

--11._ Mostra unha relación de departamentos (nome) y persoal (nome completo) asociados a este, ordeados por departamento e 
--dentro deste por nome  completo en orden descendente.
select 
	d.NomeDepartamento as NomeDepartamento,
	e.nome + ' ' + e.apelido1 + ' ' + isnull(e.apelido2, '') as nomeCompletoEmpregado
	from empregado e 
	
	inner join departamento d on d.numDepartamento = e.numDepartamentoPertenece 
order by d.NomeDepartamento asc, nomeCompletoEmpregado desc; 

SELECT 
    d.nomeDepartamento AS nomeDepartamento,
    e.nome + ' ' + e.apelido1 + ' ' + ISNULL(e.apelido2, '') AS nomeCompleto
FROM empregado e
INNER JOIN departamento d ON d.numDepartamento = e.numDepartamentoPertenece
ORDER BY d.nomeDepartamento ASC, nomeCompleto DESC;

--12._ Selecciona todas as empregadas fixas que viven en Pontevedra, Santiago ou Vigo ou aqueles empregados fixos que cobran máis de 3000 euros.
select 
	e.nome, e.apelido1, e.apelido2,	e.localidade,
	 ef.salario 
from empregado e  
	inner join empregadofixo ef on ef.nss = e.nss

where e.localidade in ('Vigo','Santiago','Pontevedra')
or ef.salario > 3000


--13._ Fai unha consulta que seleccione todas as empregadas (NSS, nome e apelido1) que viven en Pontevedra ou Vigo 
--e que teñen algún familiar dado de alta na empresa.
select 
	e.nome, e.apelido1, e.nss
from empregado e
	inner join familiar f on f.nss = e.nss
where e.sexo = 'M' 
	and e.localidade in ('Pontevedra','Vigo');

--14._Fai unha relación (nome do departamento e nome completo do empregado e do fillo/filla) de todos os empregados do 
--departamento técnico ou de informática e que son pais dun neno (de calquera sexo)..  

select 
	d.nomeDepartamento as NomeDepartamento,
	e.nome + ' ' + e.apelido1 as NomeEmpregado,
	f.nome + ' ' + f.apelido1 as NomeFillo
from empregado e
	inner join departamento d on d.numDepartamento = e.numDepartamentoPertenece 
	inner join familiar f on f.NSS_empregado = e.NSS 
where 
	d.nomeDepartamento in ('Técnico','Informática')
	and f.parentesco in ('Fillo','Filla');
		
--15._Fai unha consulta que amose o 20% dos homes que traballan no departamento de Informática, Estadística ou Innovación.

select top 20 percent 
	e.nome, e.apelido1, 
	d.nomeDepartamento
from empregado e
	inner join departamento d on d.numDepartamento = e.numDepartamentoPertenece
where d.nomeDepartamento in ('Informática','Estadística','Innovación');

--16._Mostra todos os datos da táboa empregado xunto co nome e número de horas dos proxectos nos que participou o empregado e salario, 
--pero só para aqueles empregados fixos dos departamentos de Informática e Técnico que cobran entre 1500 e 3000 euros e que naceron con 
--anterioridade ao ano 1980.

select
	e.nss, e.nome, e.apelido1, 
	p.nomeProxecto,
	ep.horas,
	ef.salario
from empregado e
	inner join empregado_proxecto ep on ep.nssempregado = e.nss
	inner join proxecto p on p.numProxecto = ep.numProxecto
	inner join empregadofixo ef on ef.nss = e.nss
	inner join departamento d on d.numDepartamento = e.numDepartamentoPertenece
where 
	ef.salario between 1500 and 3000
	and d.nomeDepartamento in ('Informática','Técnico')
	and YEAR(e.dataNacemento) < 1980;
	

--17._ ¿Cánto suman os salarios dos empregados fixos? ¿E cal é a media? Fai unha consulta que devolva os dous valores.
select SUM(salario) as TotalSalario,
		avg(salario) as salarioMedio 
from EmpregadoFixo

--18._ Fai unha consulta que devolva o número de empregados fixos que ten cada departamento e a media dos salarios.
select nomeDepartamento, count(*) as numeroEMpregados,
		cast(avg(Salario) as decimal(8,2)) as MediaSalario 
from empregadofixo ef

	inner join empregado e on e.nss = ef.nss
	inner join departamento d on e.numDepartamentoPertenece = d.numDepartamento
group by nomeDepartamento 

--19._ Fai unha consulta que nos diga cantos empregados naceron cada ano a partir de 1969.
select COUNT(*) as EmpregadosNacidosPorAno,
		YEAR(DataNacemento) as Ano
from EMPREGADO
where YEAR(DataNacemento) > 1969
group by YEAR(DataNacemento)


--20._Fai unha consulta que devolva o número de empregados de cada sexo. Deberá visualizarse o texto do xeito seguinte: O número de homes é 24 (e o mesmo para as mulleres).  
select
CASE 
	when sexo = 'M' then 'O número de mulleres é: ' + CAST(COUNT(*) as varchar(4))
	when Sexo = 'H' then 'O número de homes é: ' + CAST(COUNT(*) as varchar(4))
END AS EmpregadosPorSexo
from empregado
group by sexo;

--21._Fai unha consulta que devolva o número de empregados temporales e fixos de cada sexo. Deberá visualizarse o texto do xeito seguinte: O número de empregados fixos de sexo masculino son 24 (e o mesmo para as mulleres e os empregados temporais). 
select 
	case 
		when e.sexo = 'M' then 'O número de mulleres fixas é: ' + CAST(COUNT(*) as varchar(4))
		when e.Sexo = 'H' then 'O número de homes fixos é: ' + CAST(COUNT(*) as varchar(4))
	end as fixos,
	
	case
		when e.sexo = 'M' then 'O número de mulleres fixas é: ' + CAST(COUNT(*) as varchar(4))
		when e.Sexo = 'H' then 'O número de homes fixos é: ' + CAST(COUNT(*) as varchar(4)) 
	end as temporais
from empregado e
	left join EMPREGADOFIXO ef on ef.NSS = e.NSS
	left join EMPREGADOTEMPORAL et on et.NSS = e.nss
	
group by sexo

--22._Mostra o nome completo dos empregados que teñen máis dun fillo de calquera sexo.
select e.nome + ' ' + e.apelido1 as nomeCompleto
from EMPREGADO e
inner join FAMILIAR f on e.NSS= f.NSS_empregado
where 
	f.Parentesco in ('Fillo', 'Filla')
	group by e.NSS,e.Nome,e.Apelido1
	
	having COUNT(*) > 1 


--23._Crea unha consulta que mostre para cada empregado (nome e apelido mostrados nun so campo chamado Nome_completo) as horas totais que traballa cada empregado en todos os proxectos.
select e.nome + ' ' + e.apelido1 + ' ' + ISNULL(apelido2,'') as nomeCompleto,
		SUM(ep.horas) as numeroHoras
from EMPREGADO e
	inner join EMPREGADO_PROXECTO ep on e.NSS=ep.NSSEmpregado
group by e.Nome,e.apelido1,e.Apelido2, ep.Horas


--24._ Supoñendo que as horas semanais que debe traballar un empregado son 40, modifica a consulta anterior para que amose os traballadores que teñen sobrecarga, indicando en cantas horas se pasan.
select e.nome + ' ' + e.apelido1 + ' ' + ISNULL(apelido2,'') as nomeCompleto,
		SUM(ep.horas) as numeroHoras,
		case 
				when SUM(ep.horas) > 40 then SUM(ep.horas) - 40 
		end as horasExtra
from EMPREGADO e
	inner join EMPREGADO_PROXECTO ep on e.NSS=ep.NSSEmpregado


group by e.Nome,e.apelido1,e.Apelido2, ep.Horas

--25._ Realiza unha consulta que devolva o nome, apelidos e departamento dos empregados que teñan o soldo máis baixo.
select top 3 e.nome,e.apelido1,d.nomeDepartamento 
from EMPREGADO e 
inner join DEPARTAMENTO d on e.NumDepartamentoPertenece = e.NSS 



--26._ Fai unha consulta que devolva o número de fillos de calquera sexo que ten cada empregado, pero só para aqueles nos que a suma das idades dos fillos sexa maior de 40.

--27._ Crea unha consulta que devolva o nome do departamento, nome e apelidos dos empregados que teñen un nome que comeza por  J, M ou R e teña por segunda letra o A, ou a dos empregados que teñen como xefe unha persoa que ten un apelido que comeza por V e teña 6 letras.

--28._Queremos ter información dos lugares nos que se están desenvolvendo proxectos nos que participe algún empregado do departamento 1. Realiza unha consulta que devolva esta información.  

--29._Calcula canto deberá pagar o departamento 2 aos seus empregados este ano sen ter en conta as pagas extras. 

--30._¿Cales  son os empregados fixos (nome e apelidos) que tienen más edad ?.

--31._Fai unha consulta que devolva o salario medio, o salario mínimo e o salario máximo que teñen os empregados que non son xefes de departamento por sexo.

--32._ Realiza unha consulta que busque os nomes dos proxectos nos que participan aquelas persoas que teñen o salario Nulo.

--33._ Mostra o nome completo dos empregados que teñen máis familiares ao seu cargo

--34._ Realiza unha consulta que devolva o nome, apelidos, teléfono e departamento dos empregado e matrícula e modelo do vehículo dos empregadoss que teñen un vehículo de máis de 4 anos. Para o teléfono queremos visualizar o teléfono1 no caso de que o teña, se non o ten miraremos se ten o teléfono2 e en caso de non ter ningún visualizarase 'Descoñecido'.

--35._ Fai unha consulta que devolva información dos cursos que se celebran en Vigo e Pontevedra. Para cada curso queremos saber o nome, número de horas e total de alumnos nas edicións que se teñan celebrado deste curso polo momento. Tamén queremos saber cal foi o número de alumnos máis grande e máis pequeno para cada unha das edicións do curso.

--36._ Cantos empregados hai en cada provincia?. Para saber a provincia utiliza os dous primeiros caracteres do código postal e traduce este de modo que se visualice o nome e en caso de non ter CP indica de  cantos se descoñece a provincia. 

--36 :'PONTEVEDRA'     27 :'LUGO'  15 :'SANTIAGO'

--37._Crea unha consulta que mostre para  todos os empregados o seu nome completo (p.e: Javier Quintero Alvarez) e no caso de ter marido ou muller o nome completo deste indicando se se trata de marido ou de muller. Deberán visualizarse todos os empregados independentemente de se teñen parella ou non.  

--38._¿Existe algún empregado que traballa en máis dun proxectos que se desenvolven en lugares diferentes?. 

--39._Desexamos identificar a cada empregado por un mote que terá as dúas primeiras letras do nome, as dúas segundas do apelido1 e a primeira e a última da localidade na que reside (todo en minúsculas). Crea unha táboa que conteña para cada empregado o seu  NSS, mote e o nome do departamento no que traballa.

--40._Queremos ver que empregados podemos asignar aos proxectos que están en marcha. 
/*Para elo imos  seleccionar os empregados que viven no mesmo lugar no que se desenvolve o proxecto e que non están traballando en ningún proxecto na ciudade na que residen. A información que se amosará será o nome de proxecto e NSS , nome e apelido1 dos empregados dispoñibles.*/
select p.nomeProxecto,
		e.nome, e.apelido1 ,
		e.localidade as locEmpleado,
		p.lugar as lugarProxecto
	from empregado e
		inner join proxecto p on p.lugar = e.localidade
where e.localidade = p.lugar
	

--41._O mesmo que a anterior pero só para os empregados que teñan máis de 10 horas dispoñibles á semana tendo en conta que o nº de horas máximo á semana é de 40 horas.