use CATASTRO 
go

--Haz una consulta que muestre el nombre, descripción y observaciones de las zonas urbanas.
--Haz una consulta que devuelva el nombre de la calle, número y número de plantas de las viviendas unifamiliares.
--Haz una consulta que devuelva el nombre de la calle, número y metros construidos de las viviendas unifamiliares que tienen piscina.
--Obtener la calle, número y metros del solar de las viviendas unifamiliares.  
--Muestra toda la información de los pisos que tienen 3 habitaciones.
--Obtener una relación de viviendas unifamiliares (calle, número y metros de solar) de aquellas viviendas en las que los metros de solar están entre 190 y 300 metros.
--Obtén una relación de bloques de pisos que tienen más de 15 vecinos (pisos) ordenados por calle y número.
--Obtener la calle, número y metros del solar de las viviendas unifamiliares situadas en la zona centro.
--Haz una consulta que devuelva DNI, nombre y apellidos de las personas que tienen López como primer apellido ordenadas por apellidos y nombre.
--Obtener la calle, número y metros del solar de los bloques de pisos situados en la zona Centro o Palomar que tienen mas de 450 metros de solar.
--Haz una consulta que muestre los garajes que están sin vender ordenados por calle, número e id_hueco.
--Obtén el nombre y descripción de las zonas urbanas que tienen más de 1 parque ordenadas por el número de parque descendente y nombre ascendente.
--Mostrar toda la información de las zonas urbanas que tienen algo escrito en el campo de observaciones.
--Haz una consulta que devuelva DNI, nombre y apellidos de las personas que tienen un nombre de 3 letras, ordenado por nombre y apellidos.
--Haz una consulta que muestre calle, número, planta, puerta, metros (construidos y útiles) y la diferencia existente entre los metros construidos y los metros útiles ordenados por esta diferencia descendentemente.
--Muestra los datos de calle, número, planta, puerta y número de habitaciones de los pisos que tienen 1, 3, 5 ó 6 habitaciones.
--Muestra toda la información de los pisos que tienen 1, 3, 5 ó 6 habitaciones cuyos metros construídos superen en más de 10 a los metros útiles. Deberás mostrar también la diferencia entre los metros construídos y los metros útiles (llámale a este campo Diferencia)
--Obtén los nombres de zona y número de parques de las zonas que poseen menos de 3 parques y en los que el campo de observaciones está vacio.
--Haz un consulta que muestre los pisos de dos habitaciones que hay en una calle que empiece por la letra “L” y que tienen menos de 100 metros útiles.
--Haz una consulta que muestre los nombres de zona donde hay viviendas unifamiliares construidas ordenadas descendentemente.
--21. Haz una consulta que muestre el 25% de los pisos con más habitaciones. En el caso de haber más pisos con ese número de habitaciones deberían visualizarse también.

--22. Haz una consulta que muestre toda la información de los garajes con al menos 14 metros. En caso de no tener propietario deberá mostrar desconocido.

--23. Haz una consulta que muestre el nombre completo (p.e. Javier López Díaz) de los propietarios cuyo nombre no empiece por a, b, c, d o e cuyo apellido1 tenga más de 4 letras ordenados por sexo , nombre y apellidos.

--24. Muestra información de las viviendas de la calle Damasco o General Mola cuyos metros solar empiecen por 2.

--25. Haz una consulta que muestre para cada propietario el nombre, apellido1, sexo y un identificador que se creará concatenando el sexo con las 3 primeras letras del nombre y las dos últimas del apellido1.

--26. Haz una consulta que muestre los distintos tipos de huecos que hay en la calle Sol o Luca de Tena.

--27. Haz una consulta que muestre información de los 5 huecos más pequeños. En el caso de que haya más cuyo tamaño sea igual deberán visualizarse todos.

--28. Muestra los nombres de las mujeres con los caracteres invertidos.

--29. Muestra los trasteros o garajes sin mostrar los decimales de los metros.

--30. Muestra los distintos tipos de huecos de manera que se visualice la primera letra en mayúsculas y las siguientes en minúsculas.

--31. Haz una consulta que muestre nombre completo de los propietarios y sexo, indicando los valores Masculino o Femenino en función del valor del campo sexo.

--32. Obtén el nombre y apellidos de las personas que poseen una vivienda unifamiliar.

--33. Haz una consulta que muestre la zona, número de parques, calle, número y metros de solar de las viviendas que se encuentran en una zona que posea más de un parque .

--34. Haz una consulta que muestre para cada vivienda unifamiliar la calle, número, plantas, metros del solar y metros construidos.

--35. Obtén el nombre y descripción de las zonas urbanas que tienen más de 2 parques donde se hayan construido bloques de pisos.

--36. Haz una consulta que muestre para cada piso la calle, número, planta, puerta, número de habitaciones, metros útiles, nombre de zona, número de parques existentes en la zona y nombre y apellidos del propietario.

--37. Haz una consulta que muestre el nombre y apellidos de las mujeres que tienen bodegas de más de 9 metros cuadrados.

--38. Haz una consulta que devuelva DNI, nombre y apellidos de las mujeres que poseen una vivienda unifamiliar.

--39. Haz una consulta que muestre los pisos (toda la información de la tabla piso) y el nombre completo de los propietarios que se encuentran en una zona con dos parques que tienen entre 2 y 4 habitaciones o que se encuentran en la zona Centro, con ascensor y que tienen más de 70 y menos de 110 metros cuadrados útiles.

--40. Haz una consulta que muestre el nombre en minúsculas y las viviendas unifamiliares de una planta, que poseen los hombres de los cuales tenemos teléfono.

--41. Haz una consulta que muestre las viviendas (calle, numero y tipovivienda) y la zona urbana en la que se encuentran (nombrezona y descripción). 

--42. ¿Cuál es la máxima altura que tienen los pisos que pertenecen a un propietario cuyo nombre empieza por M?

--43. Haz una consulta que devuelva el total de parques que hay en la ciudad .

--44. Haz una consulta que nos indique cual es el tamaño del solar más grande.

--45. ¿Cuál es la máxima altura que tienen los pisos en la calle Damasco? (Utiliza la tabla piso).

--46. Indica cual es el tamaño mínimo y máximo (de metros útiles) de los pisos situados en la calle Lucas de Tena 22.

--47. Obtener la media de parques por zona urbana.
select
	nombreZona as NomeZona, 
	AVG(NUMPARQUES * 1.0) as MediaParques
from ZONAURBANA
group by NOMBREZONA

--48. Indica cuantas viviendas unifamiliares hay en la zona Palomar o Atocha.
select COUNT(*) as numeroViviendas
	from VIVIENDA v 
	where TIPOVIVIENDA = 'Vivienda unifamiliar' 
		and NOMBREZONA in ('Palomar','Atocha')

exec sp_help vivienda 
--49. ¿Cuál es el tamaño medio de una vivienda unifamiliar?.


--50. ¿Cuántos bloques de pisos hay en la zona Centro o Cuatrovientos cuyo solar pasa de 300 metros cuadrados?.



--51. Haz una consulta que devuelva el número de personas distintas que poseen una vivienda unifamiliar.

--52. Haz una consulta que devuelva el número de hombres que poseen un trastero en las zonas Palomar y Centro.
select COUNT(*)
	from PROPIETARIO p 
	inner join HUECO h on h.DNIPROPIETARIO = p.DNI
	inner join VIVIENDA v on 
where 
	p.SEXO = 'H',
	h.TIPO in ('Trastero')
	and 


--53. Haz una consulta que devuelva el número de viviendas (de cualquier tipo) que hay en cada zona urbana.

--54. Haz una consulta que devuelva el número de bloques de pisos que hay en cada zona urbana.

--55. Indica para cada bloque de pisos (calle y número) el número de pisos que hay en este y cual es el piso más alto de cada uno de estos.

--56. Muestra los bloques de pisos (calle y número) que tienen más de 4 pisos.

--57. Indica cual es el tamaño mínimo y máximo (de metros útiles) de los pisos de la zona Centro.

--58. Haz una consulta que muestre cuantos huecos hay de cada tipo en cada calle, teniendo en cuenta unicamente los huecos que están asociados a algún piso.

--59. ¿Cuántos bloques de pisos hay en la zona Centro o Palomar que poseen pisos de más de 3 habitaciones y que están entre 100 y 180 metros cuadrados(útiles)?


--60. Indica cuantas viviendas unifamiliares de una o dos plantas hay en cada calle teniendo en cuenta unicamente aquellas calles en las que el total de metros construidos es mayor de 250.


--61. Haz una consulta que devuelva el número de pisos de 3 o 4 habitaciones que hay en cada zona urbana, mostrando para cada zona su nombre, descripción y número de parques, ordenado por número de parques descendentemente.

--62. Haz una consulta que nos diga cuantos propietarios de pisos hay de cada sexo, indicando los valores Hombres o Mujeres en función del valor del campo sexo.

--63._ Obtén una relación de pisos (calle, número, planta, puerta, número de habitaciones, metros útiles y nombre y apellidos del propietario) cuyos metros útiles superan la media de los metros construidos.

--64._Haz una consulta que nos indique cual el tamaño medio de los solares en los que hay edificados bloques de pisos con más de 15 viviendas (pisos).

--65._ Haz una consulta que muestre devuelva el número de parques que hay en las zonas urbanas donde hay edificada alguna vivienda.

--66._ Haz una consulta que muestre todas las zonas (nombre y descripción) y las viviendas unifamiliares  (calle, número y metros solar) que hay construidas en éstas.

--67._ Haz una consulta que muestre DNI, nombre y apellidos de los propietarios de algún piso y/o vivienda, indicando cuántos pisos poseen y cuantas viviendas unifamiliares poseen.




--68._ Lista los pisos (calle, numero, planta y puerta) cuyo propietario es una mujer, que tienen el máximo número de habitaciones.

--69._ Lista las viviendas unifamiliares que no tienen piscina y en las que los metros construidos son menores que la media de los de todas las viviendas unifamiliares)

--70._ Muestra DNI, nombre, apellidos y número de pisos de las personas que poseen más de un piso que tenga como mínimo dos habitaciones.
select 
	p.dni as DNI, 
	p.NOMBRE + ' ' + p.APELLIDO1 + ' ' + ISNULL(p.apellido2,'') as NomeCompleto,
	COUNT(*) as NumPisos
from PROPIETARIO p 
	inner join PISO ps on ps.DNIPROPIETARIO = p.DNI
where ps.NUMHABITACIONES >= 2 

group by p.DNI, p.NOMBRE,p.APELLIDO1,p.apellido2
having COUNT(*) > 1


--71._ Muestra DNI, nombre y apellidos de las personas que no poseen ningún piso.
select 
	p.dni as DNI, 
	p.NOMBRE + ' ' + p.APELLIDO1 + ' ' + ISNULL(p.apellido2,'') as NomeCompleto
from PROPIETARIO p 

where p.DNI not in (SELECT DNIPROPIETARIO from piso)

--72._ Muestra DNI, nombre, apellidos y número de pisos de las personas que poseen más de un piso y que no poseen ninguna vivienda unifamiliar.
select 
	p.dni as DNI, 
	p.NOMBRE + ' ' + p.APELLIDO1 + ' ' + ISNULL(p.apellido2,'') as NomeCompleto
from PROPIETARIO p 

where p.DNI not in (SELECT DNIPROPIETARIO from piso)

--73._ ¿Quién es el propietario que posee más pisos de más de 2 habitaciones que no están situados en la zona centro?
select top 1 DNI, 
	COUNT(*) as NumPisos
from PROPIETARIO p 
inner join PISO ps on p.DNI = ps.DNIPROPIETARIO
inner join VIVIENDA v ON ps.CALLE = v.CALLE and ps.numero = v.NUMERO
where v.NOMBREZONA <> 'Centro'
	and ps.NUMHABITACIONES > 2
group by DNI

--74._ Indica para cada bloque de pisos (calle y número) el máximo de metros útiles y máximo de número de habitaciones, pero sólo para aquellos bloques en los que tenemos almacenados más de 3 pisos.
select MAX(p.metrosutiles) 
from BLOQUEPISOS bp 
inner join PISO p on bp.CALLE = p.CALLE and bp.NUMERO = p.NUMERO



--75._ Obtén el DNI, nombre y apellidos de las personas que tenemos en nuestra base de datos. En el caso de que posean una vivienda de cualquier tipo deberá visualizarse la calle y número de la vivienda de la que son propietarios. Deberá ir ordenado por apellidos y nombre ascendentemente

--76._ ¿Quién es el propietario de la bodega más pequeña? Debe visualizarse nombre y apellidos.

--77._ Obtén el nombre completo y DNI de las mujeres que tenemos en nuestra base de datos. En el caso de que posean un trastero de más de 10 metros o un garaje de menos de 13 metros deberá visualizarse la calle , número, tipo y metros de la propiedad que poseen.

--78._ Muestra el nombre de la zona urbana que más “propiedades” posee. Entendiendo como propiedades tanto los pisos, como las viviendas unifamiliares como huecos.
select COUNT(*) as numPropiedades 
	from ZONAURBANA z 
	

--79. Muestra nombre de zona, y observaciones para todas las zonas urbanas. En el caso de que no haya información en el campo observaciones debe mostrar “no hay observaciones”.

--80. Obtén una relación de propietarios de viviendas unifamiliares (DNI, nombre y apellidos, nombre_zona, calle) por cada zona urbana y ordénalos por los dos últimos caracteres de la zona urbana y dentro de esto por el nombre de la calle.

--81. Se realiza un sorteo entre los propietarios de pisos. Selecciona 2 propietarios (DNI, nombre y apellidos) al azar.  
select top 2
	p.DNI,
	p.NOMBRE + ' ' + p. APELLIDO1 as nombrec
from PROPIETARIO p 

inner join PISO ps on ps.DNIPROPIETARIO = p.DNI
order by NEWID() 

--82. Obtén una relación de pisos (calle, número, planta, puerta, número de habitaciones, metros útiles y nombre y apellidos del propietario), para los pisos que se encuentran en alguna zona que posea más de un parque, y donde haya edificada alguna vivienda unifamiliar un registro por cada piso donde indicarás de que tipo de piso se trata. Para eso tendrás en cuenta el número de habitaciones del piso. Si tiene 1 o 2 habitaciones indicará que se trata de un apartamento, si tiene 3 o 4 indicará que se trata de un piso y si tiene más que se trata de un pisazo. Un ejemplo sería el siguiente:
--Sol       5          1          A         4          115       José Pérez Varela        PISO

select 
	p.CALLE, p.NUMERO, p.PLANTA, p.PUERTA, p.METROSUTILES, p.NUMHABITACIONES,
	pr.dni, pr.nombre + ' ' + pr.apellido1,
	case 
		when p.NUMHABITACIONES between 1 and 2 then 'apartamento' 
		when p.NUMHABITACIONES between 3 and 4 then 'Piso' 
		when p.NUMHABITACIONES >4  then 'pisazo' 
	end as [TIPO PISO] 
 from PISO p 
 inner join PROPIETARIO pr on pr.DNI = p.DNIPROPIETARIO
inner join VIVIENDA v on v.CALLE = p.CALLE and v.NUMERO = p.NUMERO
inner join ZONAURBANA z on v.NOMBREZONA = z.NOMBREZONA
where 
	z.NUMPARQUES > 2 
	and exists 
		( select 1 from VIVIENDA v2 
			where v2.NOMBREZONA = v.NOMBREZONA and v2.TIPOVIVIENDA  = 'Casa' )
	

--83. Haz una consulta que nos de información de quien posee un piso o una casa de la siguiente manera: “Felipe Reyes posee un piso en la calle Lavapies nº 5” … Así para cada propietario de una vivienda, indicando si se trata de un piso o una casa.

select 
	pr.NOMBRE + ' ' + pr.APELLIDO1 + ' posee un' +
	CASE 
		when ps.DNIPROPIETARIO is not null then ' piso '
		when cp.DNIPROPIETARIO is not null  then ' casa '   
	END 
	+ ' en la calle ' + ISNULL(ps.CALLE,cp.CALLE) + ' número ' +  CAST(ISNULL(ps.numero,cp.numero)  as varchar(3))
from PROPIETARIO pr
left join PISO ps on pr.DNI = ps.DNIPROPIETARIO
left join CASAPARTICULAR cp on pr.dni=cp.DNIPROPIETARIO


--84. Muestra un listado de casas unifamiliares y pisos (calle, numero, planta, puerta ,número de habitaciones, piscina, metros) donde metros es el número de metros útiles para los pisos y los metros de solar para las viviendas unifamiliares. Deberá aparecer ordenado por el número de habitaciones para el caso de los pisos y por los metros para las viviendas unifamiliares.

select 
	v.calle, v.numero, v.TIPOVIVIENDA,
	ps.planta, ps.puerta,ps.numhabitaciones,
	cp.piscina,
	CASE
		when v.TIPOVIVIENDA in ('casa') then metrossolar
		when v.tipovivienda in ('piso') then metrosutiles 
	END as Metros
from VIVIENDA v 
left join CASAPARTICULAR cp on cp.CALLE = v.CALLE and cp.NUMERO = v.NUMERO
left join PISO ps on ps.CALLE = v.CALLE and ps.numero = v.NUMERO 

order by 
	case 
		when NUMHABITACIONES is not null then NUMHABITACIONES
		else METROSUTILES
	end ;
	 


--85. Quien posee más pisos: los hombres o las mujeres?
select pr.SEXO, COUNT(*) as numPisos
from PROPIETARIO pr 
group by pr.SEXO


--86. Haz una consulta que muestre para cada propietario cuantos pisos, viviendas unifamiliares, garajes, trasteros y bodegas posee de la siguiente manera:

select 
	pr.nombre + ' ' + pr.APELLIDO1 as nombre, 
	'Piso' as TipoPropiedad,
	COUNT(*) as numero
from PROPIETARIO pr 
left join PISO ps on ps.DNIPROPIETARIO = pr.DNI
group by pr.NOMBRE,pr.APELLIDO1

union all 

select 
	pr.nombre + ' ' + pr.APELLIDO1 as nombre, 
	'Casa' as TipoPropiedad,
	COUNT(*) as numero
from PROPIETARIO pr 
left join CASAPARTICULAR cp on cp.DNIPROPIETARIO = pr.DNI
group by pr.NOMBRE,pr.APELLIDO1

union all 
select 
	pr.nombre + ' ' + pr.APELLIDO1 as nombre, 
	'Garaje' as TipoPropiedad,
	COUNT(*) as numero
from PROPIETARIO pr 
left join HUECO h on h.DNIPROPIETARIO = pr.dni and h.TIPO = 'GARAJE'
group by pr.NOMBRE,pr.APELLIDO1

union all 
select 
	pr.nombre + ' ' + pr.APELLIDO1 as nombre, 
	'trastero' as TipoPropiedad,
	COUNT(*) as numero
from PROPIETARIO pr 
left join HUECO h on h.DNIPROPIETARIO = pr.dni and h.TIPO = 'trastero'
group by pr.NOMBRE,pr.APELLIDO1

union all 
select 
	pr.nombre + ' ' + pr.APELLIDO1 as nombre, 
	'bodega' as TipoPropiedad,
	COUNT(*) as numero
from PROPIETARIO pr 
left join HUECO h on h.DNIPROPIETARIO = pr.dni and h.TIPO = 'bodega'
group by pr.NOMBRE,pr.APELLIDO1
--PROPIETARIO

--TIPO PROPIEDAD

--NUMERO

--Javier López Díaz

--PISO

--xxx

--Javier López Díaz

--VIVIENDA UNIFAMILIAR

--xxx

--Javier López Díaz

--GARAJE

--xxx

--Javier López Díaz

--TRASTERO

--xxx




--87. ¿Cual es el mayor número de propiedades(de cualquier tipo: pisos, viviendas unifamiliares o huecos) que posee una misma persona?


--88. ¿Quién o quienes son los propietarios que poseen más propiedades?

--89. Calcula la media de los salarios de los empleados sin tener en cuenta los valores máximos y mínimos (esta es sobre la base de datos  EMPRESA).
--REFUERZO
