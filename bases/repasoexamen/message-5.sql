use BDEMPRESANEW2
go 

--1.-Selecciona todos los empleados varones que nacieron después del año 1970 y que tengan a Sara Plaza Marín como jefa.
select e.nome + ' ' + e.apelido1 + ' ' + isnull(e.apelido2,' ') as NomeCompleto 
from empregado e
	inner join empregado jefa on e.nsssupervisa = jefa.nss
where YEAR(e.dataNacemento) > 1970 
	and e.sexo = 'h'
	and jefa.nome = 'Sara'
	and jefa.apelido1 = 'Plaza'
	and jefa.apelido2 = 'Marín'
						

--2.-Muestra nombre, apellidos y teléfono de los empleados que son jefes ordenado primero por apellidos y luego por nombre. 
--Solo se visualiza un teléfono, cuando existan los dos, se visualiza el primero y si no tienen ninguno en blanco.

select e.nome,+ ' ' + e.apelido1 + ' ' + isnull(e.apelido2, ' ') as Nome_Completo, 
coalesce(telefono1,telefono2) as Telefono
from empregado e 
where e.nss in 
	(select nsssupervisa 
		from empregado 
		where nsssupervisa is not null)
order by e.apelido1 asc, e.nome asc

--3- Muestra nombre junto a los apellidos y la edad de los empleados que no son jefes y mayores de 30 años, ordenado primero por apellidos descendentemente y luego por nombre ascendentemente. Hazlo de varias maneras.              

--4.- Para los empleados que se conoce solo un teléfono, visualizar el nombre completo, el teléfono que tenemos,  junto al nombre completo de su jefe. Para los que no tienen jefe se visualizará el texto "Sin Jefe".

--5.-Visualizar el nombre y apellidos de los empleados jefes que no dirigen ningún departamento.

--6.- Muestra el nombre de los empleados que viven en una localidad en la que existe una sede del departamento al que pertenecen.

--7.- La cree una consulta que muestre para todos los empleados su nombre completo, calle, número, piso, localidad y nombre de departamento. La información debe estar ordenada por localidad en el caso de tratarse de mujeres y por nombre de departamento en el caso de tratarse de hombres.

--1._ Listado de sueldo medio y número de empleados por localidad ordenado por provincia y dentro de esta por localidad.   La localidad debe verse de la forma Localidad (Provincia) Por ejemplo: Ribadeo (Lugo).

--2._ ¿En qué año nacieron más empleados?

--3._ Muestra, para la fecha actual: el año, el mes (su nombre), el día, el día del año, la semana, el día de la semana (nombre), la hora, los minutos y los segundos.

--4._ Indica cuantos días, meses, semanas y años faltan para tu próximo cumpleaños.

--5._ Haz una lista (nombre de departamento y nombre completo de empleado) de todos los departamentos junto con los empleados que pertenecen a ellos, 

  incluyendo aquellos departamentos que no tienen empleados asignados. La información debe estar ordenada por departamento y dentro de esto por empleado.

 6._ Consulta que muestra el número de caracteres del nombre de departamento y el nombre en formato inverso.  

7._  Consulta para obtener el nombre del departamento y la cantidad total de proyectos que controla. Haz dos versiones:

 a) sólo se muestran los departamentos que controlan proyectos.

 b) se muestran todos los departamentos, y en caso de no controlar ninguno pondrá 'No tiene' 

8._ Consulta que cuente el número de espacios que tienen los nombres de proyecto.

9._ Consulta para obtener todos los empleados (nss y nombre completo) y los proyectos (nombre) en los que están asignados, incluso si no tienen proyectos asignados.

10._ Consulta para obtener todos los proyectos y los empleados asignados a ellos, incluso si no hay empleados asignados a algún proyecto:

11._ Consulta para obtener los cinco proyectos con la cantidad total de horas semanales más alta   asignadas a ellos. En caso de empate deben verse todos

12._ Consulta para obtener los dos departamentos con el menor número de caracteres en sus nombres (sin tener en cuenta empates).

13._ Consulta para obtener los empleados (NSS) que no están asignados a ningún proyecto.

1.- Hallar el número de empleados por departamento (visualiza el nombre) solo para aquellos departamentos que controlan más de 2 proyectos.

2.-

a) ¿cuál es la media del número de empleados por departamento? redondea al número entero más alto

b) Visualiza el nombre de departamento y número de proyectos que controlan para aquellos departamentos que el número de empleados asignados supera a la media del número de empleados por departamento

3.-

a) Para los departamentos que tienen más de 1 empleados con menos de 3 familiares a su cargo, hallar el número de proyectos que controlan.

b)           Para los departamentos que tienen más de 1 empleado con menos de 3 familiares a su cargo, hallar el número de proyectos que controlan si estos representan más del 15% del número de proyectos que hay.

4 .-Haz una consulta para mostrar la siguiente información referente a los empleados:

              

5.-  Hallar la media de la edad ( se visualiza con dos decimales) de aquellos empleados que dirigen algún departamento con más 4 empleados.

6.-Para los proyectos que han tenido el mayor número de problemas, visualiza el nombre de proyecto, nombre del departamento que lo controla y número de empleados asignados