

-- 1. muestre el nombre, descripción y observaciones de las zonas urbanas.
SELECT nombrezona, descripción, observaciones FROM ZONAURBANA
--SELECT nombrezona, descripción, ISNULL (observaciones,'') FROM ZONAURBANA

go 

-- 2. devuelva el nombre de la calle, número y número de plantas de las viviendas unifamiliares
SELECT calle, numero, numplantas FROM CASAPARTICULAR
go 
-- 3. nombre de la calle, número y metros construidos de las viviendas unifamiliares que tienen piscina.

SELECT calle, numero, metrosconstruidos FROM CASAPARTICULAR WHERE  PISCINA ='S'
go 

-- 4. calle, número y metros del solar de las viviendas unifamiliares.  
SELECT calle, numero, METROSSOLAR FROM VIVIENDA where TIPOVIVIENDA = 'Casa'
go 


-- 5. información de los pisos que tienen 3 habitaciones.
SELECT * FROM PISO WHERE NUMHABITACIONES = '3'
go 


-- 6. obtener una relación de viviendas unifamiliares (calle, número y metros de solar) de aquellas viviendas en las que los metros de solar están entre 190 y 300 metros.

SELECT calle, numero, METROSSOLAR FROM VIVIENDA 
	WHERE METROSSOLAR BETWEEN 190 AND 300
	AND TIPOVIVIENDA = 'Casa'
go 

-- 7. relación de bloques de pisos que tienen más de 15 vecinos (pisos) ordenados por calle y número.

	--SELECT * from BLOQUEPISOS where PROPIETARIO > 15 ;  

-- 8. calle, número y metros del solar de las viviendas unifamiliares situadas en la zona centro.
SELECT calle, numero, metrossolar FROM VIVIENDA WHERE NOMBREZONA = 'centro'
go 

-- 9. devuelva DNI, nombre y apellidos de las personas que tienen López como primer apellido ordenadas por apellidos y nombre.

SELECT DNI,NOMBRE,APELLIDO1,APELLIDO2 FROM PROPIETARIO 
	WHERE APELLIDO1 = 'López' ORDER BY APELLIDO1, APELLIDO2, NOMBRE
go 
--en un solo campo hay q concatenarlo nobnre+' ' + apellido etc isnull(apellido2,' ') as [nombre completo] 


-- 10. calle, número y metros del solar de los bloques de pisos situados en la zona Centro o Palomar que tienen mas de 450 metros de solar

SELECT CALLE,NUMERO,METROSSOLAR FROM VIVIENDA 
	WHERE (NOMBREZONA = 'CENTRO' OR NOMBREZONA = 'PALOMAR')
		AND METROSSOLAR > 450
go 

-- 11. consulta que muestre los garajes que están sin vender ordenados por calle, número e id_hueco

SELECT * FROM HUECO 
	WHERE TIPO = 'GARAJE' AND DNIPROPIETARIO IS NULL
	ORDER BY CALLE, NUMERO, ID_HUECO
go 


-- 12. nombre y descripción de las zonas urbanas que tienen más de 1 parque ordenadas por el número de parque descendente y nombre ascendente

SELECT nombrezona, descripción FROM ZONAURBANA 
	WHERE NUMPARQUES > 1 
	ORDER BY NUMPARQUES desc
go 

-- 13. Mostrar toda la información de las zonas urbanas que tienen algo escrito en el campo de observaciones.
select * from ZONAURBANA where OBSERVACIONES is not null
go 

-- 14. consulta que devuelva DNI, nombre y apellidos de las personas que tienen un nombre de 3 letras, ordenado por nombre y apellidos 

SELECT DNI, NOMBRE, APELLIDO1, APELLIDO2 FROM PROPIETARIO
 WHERE LEN(NOMBRE) = 3
 ORDER BY NOMBRE, APELLIDO1, APELLIDO2
go 
 
-- 15. que muestre calle, número, planta, puerta, metros (construidos y útiles) y la diferencia existente entre los metros construidos y los metros útiles ordenados por esta diferencia descendentemente
select calle, numero, planta, puerta, metrosconstruidos,metrossolar 
metrosconstruidos - metrosutiles as DIFERENCIA
from piso 
order by diferencia 
go 


-- 16.  datos de calle, número, planta, puerta y número de habitaciones de los pisos que tienen 1, 3, 5 ó 6 habitaciones. 
select calle, numero, planta, puerta, habitaciones 
	from piso 
	where habitaciones in (1,3,5,6)
go 


-- 17. toda la información de los pisos que tienen 1, 3, 5 ó 6 habitaciones cuyos metros construídos superen en más de 10 a los metros útiles. 
--Deberás mostrar también la diferencia entre los metros construídos y los metros útiles (llámale a este campo Diferencia)
select * from piso 
	where habitaciones in (1,3,5,6)
go 


-- 18. nombres de zona y número de parques de las zonas que poseen menos de 3 parques y en los que el campo de observaciones está vacio.
select nombrezona,NUMPARQUES from ZONAURBANA 
	where NUMPARQUES < 3
	and observaciones is null
go 


-- 19. pisos de dos habitaciones que hay en una calle que empiece  “L” y menos de 100m útiles.
select * from piso 
	where NUMHABITACIONES = 2 
	and calle like ('L%') 
	and metrosutiles < 100
go 

-- 20. Nombres de zona donde hay viviendas unifamiliares construidas ordenadas descendentemente

select distinct NOMBREZONA from vivienda 
	where vivienda='casa'
	order by 1 desc
go 

