-- 1. Selecciona todas las empleadas que viven en Pontevedra, Santiago o Vigo.
    --CONSULTA SENCILLA

-- 2. Haz una consulta que devuelva los nombres y fecha de nacimiento de los hijos e hijas de modo que aparezcan en primer lugar los hijos de empleados y a continuación las hijas y dentro de esto ordenados por edad.

SELECT name + ' ' + apellido + ' ' + ISNULL(apellidos2, '') as nombre, fechaNacemento 
    from familiarwhere Parentestoco in ('hijo', 'hija')
    order by parentesto desc, fechanacemento asc

-- 3. Haz una consulta que muestre el nombre del curso y el número de horas de los dos cursos que más duran, En el caso de haber un empate deben visualizarse todos.
select top 2 with ties, nome, horas 
    from curso 
    order by horas desc 


-- 4. ¿En qué localidades se desarrollan proyectos? Muéstralas por orden alfabético.  

select distinct lugar 
from proxecto 
order by lugar

-- 5. Muestra los datos de las tareas que están sin terminar.
select * 
from tarefa 
where data_fin is null


-- 6. Muestra el nombre completo y NSS de los empleados que tienen un supervisor, de Lugo o Monforte, que nacieron entre el año 1970 y 1990.
select * 
from empregado
where localidade in ('Lugo','Monforte')
and nsssupervisor is not null 
and YEAR(datanacemento) netween 1970 and 1990

-- 7. Obtén una relación de localidades de empleados junto con sus gentilicios teniendo en cuenta que no deben aparecer valores duplicados y las siguientes correspondencias (en caso de no tener correspondencia deberá indicar "Otro").
select distinct localidade
    case localidade
        when 'Lugo' then 'Lucense'
        when '' then 
        when '' then
        when then 
        when then
    end as gentilicio 
from empregado 

/*Lugo - lucense
Pontevedra - pontevedrés
Vigo - vigués
Santiago - compostelano
Monforte - monfortino*/

-- 8. Vamos a mejorar la consulta anterior para que tenga en cuenta si se trata de un hombre o una mujer y de este modo ponga:
/*Lugo - lucense 
Pontevedra - pontevedrés / pontevedresa
Vigo - vigués / viguesa
Santiago - compostelano /compostelana
Monforte - monfortino /monfortina*/

select distinct localidade
    case localidade
        when 'Lugo' then 'Lucense'
        when 'Pontevedra' and sexo='M' then 'Pontevedresa'
        when 'Pontevedra' and sexo='H' then 'Pontevedrés'
        when 'Vigo' and sexo='M' then 'viguesa' 
        when 'Vigo' and sexo='H' then 'vigués'
        when 'Santiago' and sexo='M' then 'compostelana'
        when 'Santiago' and sexo='H' then 'compostelano'
        when 'Monforte' and sexo='M' then 'monfortina'
        when 'Monforte' and sexo='H' then 'monfortino'
    end as gentilicio 
from empregado  

-- 6. Muestra el nombre completo de los empleados y la fecha de nacimiento de la siguiente manera:
/*
Azucena Paz Farto - Miércoles, 28 de Febrero de 1996
Rocio López Ferreiro - Miércoles, 21 de Mayo de 1975
Horacio Torres Pousa - Jueves, 21 de Enero de 1999
Javier Quintero Alvarez - Sábado, 23 de Septiembre de 1972
Anita Mora Quintero - Martes, 1 de Febrero de 2000
Micaela Pose Vidal - Sábado, 11 de Febrero de 1995 */
SELECT nome+ '' + apelido1+'' + isnull(apelido2) as 'nombre completo',
    DATENAME(weekday,datanacemento) + ',' 
    cast (DAY(datanacemento) as varchar(2)) 
    + ' de ' + DATENAME(MONTH, datanacemento) 
    + ' de ' + DATENAME(YEAR,datanacemento)
    cast(day(datanacemento) as varchar())
    as dataNacemento 
from empregado

--10. Muestra el nombre completo de los familiares que tienen un apellido (cuaquiera de los dos) de menos de 5 letras, ordenados por primer apellido y dentro de este por segundo apellido.

--el distinct hay q poner lo, si no una persnq eu tenga  6 familaires saldra 6 veces repetido
select distinct 
'hijo' / 'hija'

--11._ Mostra unha relación de departamentos (nome) y persoal (nome completo) asociados a este, ordeados por departamento e dentro deste por nome  completo en orden descendente.
select 


--12._ Selecciona todas as empregadas fixas que viven en Pontevedra, Santiago ou Vigo ou aqueles empregados fixos que cobran máis de 3000 euros.
select 


--13._ Fai unha consulta que seleccione todas as empregadas (NSS, nome e apelido1) que viven en Pontevedra ou Vigo e que teñen algún familiar dado de alta na empresa.
select 


--14._Fai unha relación (nome do departamento e nome completo do empregado e do fillo/filla) de todos os empregados do departamento técnico ou de informática e que son pais dun neno (de calquera sexo)..  
select 


--15._Fai unha consulta que amose o 20% dos homes que traballan no departamento de Informática, Estadística ou Innovación.
select top 20 percent from nomedepartamento, empregado* 
    from deprtamento inner join empregado 
    on --- 

    where departamento in ('Informatica', 'tecnico')
    salario between 1500 and 3000
    and YEAR(datanacemento)< 1980


--16._Mostra todos os datos da táboa empregado xunto co nome e número de horas dos proxectos nos que participou o empregado e salario, pero só para aqueles empregados fixos dos departamentos de Informática e Técnico que cobran entre 1500 e 3000 euros e que naceron con anterioridade ao ano 1980.

select 