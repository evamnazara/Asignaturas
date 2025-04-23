--1.-   Haz una consulta que muestre la calle, n�mero, planta, puerta, n�mero de habitaciones de los pisos de los propietarios que su letra del DNI sea A, B o H. Adem�s tambi�n se visualizar� junto a la anterior informaci�n, un comentario que depender� del n�mero de habitaciones. Si el n�mero de habitaciones es 1 0 2 se visualizar� 'Ideal Parejas sin o con 1 hijo', si tiene 3: 'Ideal Parejas con dos hijos' y si tiene m�s de tres: 'Ideal Parejas con m�s de dos hijos'

SELECT calle, numero, planta, puerta, numhabitaciones,
    CASE 
        WHEN numhabitaciones IN (1, 2) THEN 'Ideal Parejas sin o con 1 hijo'
        WHEN numhabitaciones = 3 THEN 'Ideal Parejas con dos hijos'
        WHEN numhabitaciones > 3 THEN 'Ideal Parejas con m�s de dos hijos'
    END AS descripcion
FROM PISO
WHERE RIGHT(DNIPROPIETARIO, 1) IN ('A', 'B', 'H');


--2.-  Muestra informaci�n de los propietarios que tienen un tel�fono que empiezan por los n�meros 610 o 565, clasificados de manera que aparezcan primero aquellos cuyos nombres son m�s cortos y para los que coincidan por el nombre de forma descendente.    
--Pista( puedes poner en el order by una funci�n)
SELECT * FROM PROPIETARIO 
	WHERE LEFT(TELEFONO, 3) IN ('610', '565')

ORDER BY LEN(NOMBRE) ASC, NOMBRE DESC;



--3.-.  Idem del anterior pero ahora se debe crear una tabla llamada PropietariosClasif con la informaci�n de los propietarios que tienen un tel�fono que empiezan por los n�meros 610 o 565, clasificados de manera que aparezcan primero aquellos cuyos nombres son m�s cortos y para los que coincidan por el nombre de forma descendente.
SELECT * FROM PROPIETARIO 
	WHERE LEFT(TELEFONO, 3) IN ('610', '565')

ORDER BY LEN(NOMBRE) ASC, NOMBRE DESC;


--4.-.  Muestra informaci�n de las viviendas cuya calle no es compuesta, es decir, formada por una sola palabra. 
--La informaci�n se mostrar� ordenada por metrossolar de mayor a menor  en el caso de los bloques y para las casas. por los nombres de zonas de m�s cortos a m�s. 
--Pista : mira la funci�n  charindex.  En order by tambi�n puedes poner un case. 
/*Ej:order by case campo 
when  expesi�n1   valore  end desc,
case campo  when expresion2 then valor2 end*/

SELECT * FROM VIVIENDA
	WHERE CHARINDEX(' ',CALLE) = 0
	ORDER BY 
		CASE tipovivienda 
			WHEN 'bloquepisos' THEN METROSSOLAR END DESC,
		CASE tipovivienda 
			WHEN 'casaparticular' THEN METROSSOLAR END 


--5.-.  Visualiza las zonas urbanas con m�s parques.
SELECT TOP 1 WITH TIES * FROM ZONAURBANA
	ORDER BY NUMPARQUES DESC


--estandar
SELECT NOMBREZONA, NUMPARQUES FROM ZONAURBANA
	WHERE NUMPARQUES = (SELECT MAX(NUMPARQUES) FROM ZONAURBANA)

--6.-.  De los pisos cuyos metros constru�dos est�n comprendidos entre 100 y 200, visualiza los que tienen m�s habitaciones. 
--El formato de salida ser� una sola columna que contendr�:  calle, piso planta� puerta. ,Ejemplo de salida:    
--Pista: el operador + concatena cadenas de caracteres. Para concaternar tb alg�n valor que no es de este tipo, hay que castear estos  a cadena.
SELECT calle + ' ' + CAST(numero AS VARCHAR)+ ' ' + CAST(planta AS VARCHAR(2)) + '� ' + puerta AS Direcci�n
	FROM PISO
	WHERE METROSCONSTRUIDOS BETWEEN 100 AND 200
	AND NUMHABITACIONES = 
		(SELECT MAX(NUMHABITACIONES)FROM PISO 
			WHERE METROSCONSTRUIDOS BETWEEN 100 AND 200)


--7.-.  Visualiza la direccion del piso (compuesta por  calle, piso planta� puerta), metrosconstruidos, metrosutiles  y la diferencia entre metros construidos y metros �tilies para los pisos que esta diferencia no supera los 8 metros. Se visualizar� ordenado por esta diferencia de metros de
SELECT calle + ' ' + CAST(numero AS VARCHAR)+ ' ' + CAST(planta AS VARCHAR(2)) + '� ' + puerta AS Direcci�n,

    METROSCONSTRUIDOS, METROSUTILES,(METROSCONSTRUIDOS - METROSUTILES) AS DIFERENCIAMETROS
	FROM PISO
		WHERE (METROSCONSTRUIDOS - METROSUTILES) <= 8
	ORDER BY DIFERENCIAMETROS ASC


--8-.  Para los pisos cuya diferencia entre metros constru�dos y metros �tiles no supera los 8 metros, visualiza los pisos con menor diferencia. La informaci�n que se visualizar� ser� la direcci�n del piso (compuesta por  calle, piso planta� puerta), metrosconstruidos, metrosutiles y la diferencia entre metros constru�dos y metros �tiles.
SELECT calle + ' ' + CAST(numero AS VARCHAR)+ ' ' + CAST(planta AS VARCHAR(2)) + '� ' + puerta AS Direcci�n,
    METROSCONSTRUIDOS, METROSUTILES,
    (METROSCONSTRUIDOS - METROSUTILES) AS diferencia
		FROM PISO
			WHERE (METROSCONSTRUIDOS - METROSUTILES) <= 8
			AND (METROSCONSTRUIDOS - METROSUTILES) = 
				(SELECT MIN(METROSCONSTRUIDOS - METROSUTILES) 
					FROM PISO 
					WHERE (METROSCONSTRUIDOS - METROSUTILES) <= 8)



--9.-.  Para las propietarias, visualizar su nombre completo, dni y t�lefono de la siguiente manera:
SELECT NOMBRE + ' ' + APELLIDO1 + ' ' + APELLIDO2 + ' ' + SUBSTRING(DNI, 1, 2) + '.' +  
		SUBSTRING(DNI, 1, 2) + '.' +  
		SUBSTRING(DNI, 3, 3) + '.' +  
		SUBSTRING(DNI, 6, 3) + '-' +    
		RIGHT(DNI, 1) AS NOMBRECOMPLETOYDNI, 
	
	CASE 
        WHEN TELEFONO IS NULL THEN 'SIN TELEFONO'
        ELSE TELEFONO
    END AS TELEFONO
FROM PROPIETARIO
	WHERE SEXO = 'M';
