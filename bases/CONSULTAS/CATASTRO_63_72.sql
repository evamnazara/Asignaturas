-- 63._ Obtén una relación de pisos (calle, número, planta, puerta, número de habitaciones, metros útiles y nombre y apellidos del propietario) cuyos metros útiles superan la media de los metros construidos.

SELECT * FROM PISO P
INNER JOIN 
    PROPIETARIO PR ON P.DNIPROPIETARIO = PR.DNI
WHERE 
    P.METROSUTILES > (
        SELECT AVG(METROSCONSTRUIDOS) FROM PISO
    );


-- 64._ Haz una consulta que nos indique cuál es el tamaño medio de los solares en los que hay edificados bloques de pisos con más de 15 viviendas (pisos).

SELECT 
    AVG(V.METROSSOLAR) AS MEDIA_METROS_SOLAR
FROM 
    VIVIENDA V
WHERE 
    EXISTS (
        SELECT 1
        FROM BLOQUEPISOS B
        WHERE B.CALLE = V.CALLE AND B.NUMERO = V.NUMERO AND B.NUMPISOS > 15
    );


-- 65._ Haz una consulta que devuelva el número de parques que hay en las zonas urbanas donde hay edificada alguna vivienda.

SELECT 
    COUNT(Z.NUMPARQUES) AS TOTAL_PARQUES
FROM 
    ZONAURBANA Z
WHERE 
    EXISTS (
        SELECT 1 
        FROM VIVIENDA V 
        WHERE V.NOMBREZONA = Z.NOMBREZONA
    );

-- 66._ Haz una consulta que muestre todas las zonas (nombre y descripción) y las viviendas unifamiliares (calle, número y metros solar) que hay construidas en éstas.

SELECT 
    Z.NOMBREZONA, 
    Z.DESCRIPCIÓN, 
    V.CALLE, 
    V.NUMERO, 
    V.METROSSOLAR
FROM 
    CASAPARTICULAR C
INNER JOIN VIVIENDA V ON C.CALLE = V.CALLE AND C.NUMERO = V.NUMERO
INNER JOIN ZONAURBANA Z ON V.NOMBREZONA = Z.NOMBREZONA;

-- Con subconsultas

SELECT 
    V.NOMBREZONA,
    (SELECT DESCRIPCIÓN FROM ZONAURBANA Z WHERE Z.NOMBREZONA = V.NOMBREZONA) AS DESCRIPCION,
    V.CALLE, 
    V.NUMERO, 
    V.METROSSOLAR
FROM 
    VIVIENDA V
WHERE 
    EXISTS (
        SELECT 1 FROM CASAPARTICULAR C 
        WHERE C.CALLE = V.CALLE AND C.NUMERO = V.NUMERO
    );

-- 67._ Haz una consulta que muestre DNI, nombre y apellidos de los propietarios de algún piso y/o vivienda, indicando cuántos pisos poseen y cuántas viviendas unifamiliares poseen.

SELECT 
    PR.DNI, 
    PR.NOMBRE, 
    PR.APELLIDO1, 
    PR.APELLIDO2,
    (SELECT COUNT(*) FROM PISO P WHERE P.DNIPROPIETARIO = PR.DNI) AS NUM_PISOS,
    (SELECT COUNT(*) FROM CASAPARTICULAR C WHERE C.DNIPROPIETARIO = PR.DNI) AS NUM_VIVIENDAS
FROM 
    PROPIETARIO PR
WHERE 
    PR.DNI IN (SELECT DNIPROPIETARIO FROM PISO)
    OR PR.DNI IN (SELECT DNIPROPIETARIO FROM CASAPARTICULAR);

-- 68._ Lista los pisos (calle, número, planta y puerta) cuyo propietario es una mujer, que tienen el máximo número de habitaciones.

SELECT 
    P.CALLE, 
    P.NUMERO, 
    P.PLANTA, 
    P.PUERTA
FROM 
    PISO P
INNER JOIN PROPIETARIO PR ON P.DNIPROPIETARIO = PR.DNI
WHERE 
    PR.SEXO = 'M'
    AND P.NUMHABITACIONES = (
        SELECT MAX(NUMHABITACIONES) FROM PISO
    );
    
    -- Con subconsulta
    
SELECT 
    CALLE, NUMERO, PLANTA, PUERTA
FROM 
    PISO
WHERE 
    DNIPROPIETARIO IN (
        SELECT DNI FROM PROPIETARIO WHERE SEXO = 'M'
    )
    AND NUMHABITACIONES = (SELECT MAX(NUMHABITACIONES) FROM PISO);
    
    -- Añadiendo que sea el maximo de habitaciones entre los pisos en propiedad de mujeres, no de todos los pisos
    
    -- Con INNER JOIN
SELECT 
    P.CALLE, 
    P.NUMERO, 
    P.PLANTA, 
    P.PUERTA
FROM 
    PISO P
INNER JOIN PROPIETARIO PR ON P.DNIPROPIETARIO = PR.DNI
WHERE 
    PR.SEXO = 'M'
    AND P.NUMHABITACIONES = (
        SELECT MAX(P2.NUMHABITACIONES)
        FROM PISO P2
        INNER JOIN PROPIETARIO PR2 ON P2.DNIPROPIETARIO = PR2.DNI
        WHERE PR2.SEXO = 'M'
    );

-- Con subconsulta
SELECT 
    CALLE, NUMERO, PLANTA, PUERTA
FROM 
    PISO
WHERE 
    DNIPROPIETARIO IN (
        SELECT DNI FROM PROPIETARIO WHERE SEXO = 'M'
    )
    AND NUMHABITACIONES = (
        SELECT MAX(NUMHABITACIONES)
        FROM PISO
        WHERE DNIPROPIETARIO IN (
            SELECT DNI FROM PROPIETARIO WHERE SEXO = 'M'
        )
    );

-- 69._ Lista las viviendas unifamiliares que no tienen piscina y en las que los metros construidos son menores que la media de los de todas las viviendas unifamiliares.

SELECT 
    C.CALLE, 
    C.NUMERO, 
    C.METROSCONSTRUIDOS
FROM 
    CASAPARTICULAR C
WHERE 
    C.PISCINA = 'N'
    AND C.METROSCONSTRUIDOS < (
        SELECT AVG(METROSCONSTRUIDOS) FROM CASAPARTICULAR
    );

-- 70._ Muestra DNI, nombre, apellidos y número de pisos de las personas que poseen más de un piso que tenga como mínimo dos habitaciones.

SELECT 
    PR.DNI, 
    PR.NOMBRE, 
    PR.APELLIDO1, 
    PR.APELLIDO2, 
    COUNT(P.CALLE) AS NUM_PISOS
FROM 
    PROPIETARIO PR
INNER JOIN 
    PISO P ON PR.DNI = P.DNIPROPIETARIO
WHERE 
    P.NUMHABITACIONES >= 2
GROUP BY 
    PR.DNI, PR.NOMBRE, PR.APELLIDO1, PR.APELLIDO2
HAVING 
    COUNT(P.CALLE) > 1;

-- 71._ Muestra DNI, nombre, apellidos de las personas que no poseen ningún piso.

SELECT 
    PR.DNI, 
    PR.NOMBRE, 
    PR.APELLIDO1, 
    PR.APELLIDO2
FROM 
    PROPIETARIO PR
WHERE 
    PR.DNI NOT IN (
        SELECT DISTINCT DNIPROPIETARIO FROM PISO
    );

-- con except

SELECT PR.DNI, PR.NOMBRE, PR.APELLIDO1, PR.APELLIDO2
	FROM PROPIETARIO PR
EXCEPT  
	SELECT DISTINCT DNIPROPIETARIO, PR.NOMBRE, PR.APELLIDO1, PR.APELLIDO2 
	FROM PISO p
	inner join propietario pr on pr.DNI = DNIPROPIETARIO


-- 72._ Muestra DNI, nombre, apellidos y número de pisos de las personas que poseen más de un piso y que no poseen ninguna vivienda unifamiliar.
SELECT PR.DNI, PR.NOMBRE, PR.APELLIDO1, PR.APELLIDO2, 
    COUNT(P.CALLE) AS NUMERO_PISOS
FROM PROPIETARIO PR
	INNER JOIN PISO P ON PR.DNI = P.DNIPROPIETARIO
	
	WHERE PR.DNI NOT IN (
		SELECT DNIPROPIETARIO FROM CASAPARTICULAR )
	GROUP BY 
		PR.DNI, PR.NOMBRE, PR.APELLIDO1, PR.APELLIDO2
	HAVING 
		COUNT(P.CALLE) > 1;
