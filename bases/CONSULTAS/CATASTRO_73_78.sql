-- 73._ ¿Quién es el propietario que posee más pisos de más de 2 habitaciones que no están situados en la zona centro?o?

-- multitabla
SELECT TOP 1 with ties
    DNI,
    NOMBRE, APELLIDO1, APELLIDO2, 
    COUNT(*) AS NumPisos
FROM PISO 
    INNER JOIN PROPIETARIO P ON DNIPROPIETARIO = DNI
    INNER JOIN VIVIENDA ON piso.CALLE = Vivienda.CALLE AND Piso.NUMERO = Vivienda.NUMERO

WHERE piso.NUMHABITACIONES > 2 AND vivienda.NOMBREZONA <> 'Centro'
    GROUP BY DNI, nombre, APELLIDO1, APELLIDO2
    ORDER BY NumPisos DESC

--estandar CON variable 
declare @maxPisosPropietario int 
set @maxPisosPropietario=(
	SELECT MAX(NumPisos) --tabla derivada para calcular maxim de pisos
		from (
		select COUNT(*) as numPisos
		from PISO 
			inner join PROPIETARIO on DNI = DNIPROPIETARIO
			inner join VIVIENDA on piso.CALLE = vivienda.CALLE
		and piso.NUMERO=vivienda.NUMERO
		
		where NOMBREZONA <> 'Centro' and NUMHABITACIONES > 2
		group by dnipropietario
		) AS tabla
	)

SELECT	DNI,
		NOMBRE, APELLIDO1, APELLIDO2, 
		COUNT(*) AS NumPisos
FROM PISO 
    INNER JOIN PROPIETARIO P ON DNIPROPIETARIO = DNI
    INNER JOIN VIVIENDA ON piso.CALLE = Vivienda.CALLE AND Piso.NUMERO = Vivienda.NUMERO

WHERE piso.NUMHABITACIONES > 2 AND vivienda.NOMBREZONA <> 'Centro'
    GROUP BY DNI, nombre, APELLIDO1, APELLIDO2
    
    having count(*)=@maxPisosPropietario
	

-- 74._ Indica para cada bloque de pisos (calle y número) el máximo de metros útiles y máximo de número de habitaciones, pero sólo para aquellos bloques en los que tenemos almacenados más de 3 pisos.

SELECT BP.CALLE, BP.NUMERO,
       MAX(P.METROSUTILES) AS MaxMetrosUtiles,
       MAX(P.NUMHABITACIONES) AS MaxHabitaciones
FROM BLOQUEPISOS BP
    
    INNER JOIN PISO P ON BP.CALLE = P.CALLE AND BP.NUMERO = P.NUMERO
    
    GROUP BY BP.CALLE, BP.NUMERO
HAVING COUNT(*) > 3;

--2
SELECT CALLE,NUMERO,
       MAX(METROSUTILES) AS MaxMetrosUtiles,
       MAX(NUMHABITACIONES) AS MaxHabitaciones
FROM piso
    
GROUP BY CALLE, NUMERO
HAVING COUNT(*) > 3;

-- 75._ Obtén el DNI, nombre y apellidos de las personas que tenemos en nuestra base de datos. En el caso de que posean una vivienda de cualquier tipo deberá visualizarse la calle y número de la vivienda de la que son propietarios. Deberá ir ordenado por apellidos y nombre ascendentemente

-- subconsulta

SELECT NOMBRE + ' ' + APELLIDO1 + ' ' + ISNULL(APELLIDO2, ' ') AS NombreCompleto,
        DNI, CALLE, NUMERO

FROM (
    SELECT P.DNI, P.NOMBRE, P.APELLIDO1, P.APELLIDO2, V.CALLE, V.NUMERO
        FROM PROPIETARIO P
    LEFT JOIN PISO PS ON P.DNI = PS.DNIPROPIETARIO
    LEFT JOIN CASAPARTICULAR CP ON P.DNI = CP.DNIPROPIETARIO
    LEFT JOIN VIVIENDA V ON CP.CALLE = V.CALLE AND CP.NUMERO = V.NUMERO
	) AS ViviendasPropietario
	
ORDER BY APELLIDO1, APELLIDO2, NOMBRE

--CLASE
SELECT DISTINCT DNI,NOMBRE,APELLIDO1, CALLE,NUMERO 
	FROM PISO INNER JOIN PROPIETARIO
		ON DNI = DNIPROPIETARIO
		
	UNION 
	SELECT DISTINCT DNI,NOMBRE,APELLIDO1,calle,numero 
	from CASAPARTICULAR inner join propietario
		ON DNI = DNIPROPIETARIO
	union
	
	select distinct dni, nombre,apellido1,null,null 
	from PROPIETARIO
	
	where DNI not in (
	SELECT DISTINCT DNIPROPIETARIO FROM PISO
	UNION
	SELECT DISTINCT DNIPROPIETARIO 
	FROM CASAPARTICULAR
	)
	order by 3,4,2

--union 
SELECT
    p.NOMBRE, P.APELLIDO1,P.APELLIDO2,  
    P.DNI,
    V.CALLE,
    V.NUMERO
FROM PROPIETARIO P
    INNER JOIN PISO PS ON P.DNI = PS.DNIPROPIETARIO
    INNER JOIN VIVIENDA V ON PS.CALLE = V.CALLE AND PS.NUMERO = V.NUMERO

    UNION

SELECT DISTINCT
    p.NOMBRE, P.APELLIDO1,P.APELLIDO2, 
    P.DNI,
    V.CALLE,
    V.NUMERO
        FROM PROPIETARIO P

            INNER JOIN CASAPARTICULAR CP ON P.DNI = CP.DNIPROPIETARIO
            INNER JOIN VIVIENDA V ON CP.CALLE = V.CALLE AND CP.NUMERO = V.NUMERO

ORDER BY APELLIDO1, APELLIDO2, NOMBRE;



-- 76._ ¿Quién es el propietario de la bodega más pequeña? Debe visualizarse nombre y apellidos.


SELECT TOP 1 P.NOMBRE, P.APELLIDO1, P.APELLIDO2
    FROM HUECO H
    INNER JOIN PROPIETARIO P ON H.DNIPROPIETARIO = P.DNI
WHERE H.TIPO = 'Bodega'
    ORDER BY H.METROS ASC;

-- etsandar

SELECT P.NOMBRE, P.APELLIDO1, P.APELLIDO2
    FROM HUECO H

INNER JOIN PROPIETARIO P ON H.DNIPROPIETARIO = P.DNI
    WHERE H.TIPO = 'Bodega' AND H.METROS = (
            SELECT MIN(METROS)
            FROM HUECO
            WHERE TIPO = 'Bodega'
        );

-- 77._ Obtén el nombre completo y DNI de las mujeres que tenemos en nuestra base de datos. En el caso de que posean un trastero de más de 10 metros o un garaje de menos de 13 metros deberá visualizarse la calle , número, tipo y metros de la propiedad que poseen.

SELECT P.DNI, P.NOMBRE + ' ' + P.APELLIDO1 + ' ' + P.APELLIDO2 AS NombreCompleto,
       H.CALLE, H.NUMERO, H.TIPO, H.METROS
FROM PROPIETARIO P
	LEFT JOIN (
		select * from HUECO 
		where (TIPO='Trastero' AND METROS > 10)
			or (TIPO = 'Garaje' AND METROS < 13)
    ) as H 
    on DNI = DNIPROPIETARIO 

-- 78._ Muestra el nombre de la zona urbana que más “propiedades” posee. Entendiendo como propiedades tanto los pisos, como las viviendas unifamiliares como huecos.

--CORRECCION : ES CON UNION ALL!!!
-- Usando TOP 1

SELECT top 1 with ties NOMBREZONA, COUNT(*) AS numeroPropiedades
FROM (
    SELECT V.NOMBREZONA FROM VIVIENDA V
        JOIN PISO P ON V.CALLE = P.CALLE AND V.NUMERO = P.NUMERO
    UNION all
    SELECT V.NOMBREZONA FROM VIVIENDA V
        JOIN CASAPARTICULAR C ON V.CALLE = C.CALLE AND V.NUMERO = C.NUMERO
    UNION all
        SELECT V.NOMBREZONA FROM VIVIENDA V
    JOIN HUECO H ON V.CALLE = H.CALLE AND V.NUMERO = H.NUMERO
) AS Propiedades
    GROUP BY NOMBREZONA
    ORDER BY numeroPropiedades DESC;

--
-- subconsulta
SELECT TOP 1 NOMBREZONA, COUNT(*) AS TotalPropiedades
    FROM (
        SELECT V.NOMBREZONA FROM VIVIENDA V JOIN PISO P ON V.CALLE = P.CALLE AND V.NUMERO = P.NUMERO
            UNION all
        SELECT V.NOMBREZONA FROM VIVIENDA V JOIN CASAPARTICULAR C ON V.CALLE = C.CALLE AND V.NUMERO = C.NUMERO
            UNION all
        SELECT V.NOMBREZONA FROM VIVIENDA V JOIN HUECO H ON V.CALLE = H.CALLE AND V.NUMERO = H.NUMERO
    ) AS numeroPropiedades

    GROUP BY NOMBREZONA
    ORDER BY COUNT(*) DESC
    
-- estandar

SELECT NOMBREZONA, COUNT(*) AS numeroPropiedades
FROM (
    SELECT V.NOMBREZONA FROM VIVIENDA V
        JOIN PISO P ON V.CALLE = P.CALLE AND V.NUMERO = P.NUMERO
    UNION ALL
    SELECT V.NOMBREZONA FROM VIVIENDA V
        JOIN CASAPARTICULAR C ON V.CALLE = C.CALLE AND V.NUMERO = C.NUMERO
    UNION ALL
        SELECT V.NOMBREZONA FROM VIVIENDA V
    JOIN HUECO H ON V.CALLE = H.CALLE AND V.NUMERO = H.NUMERO
) AS numeroPropiedades
    GROUP BY NOMBREZONA
    
HAVING COUNT(*) = (
    SELECT MAX(contadorZonas)
    FROM (
        SELECT COUNT(*) AS contadorZonas
        FROM (
            SELECT V.NOMBREZONA FROM VIVIENDA V
                JOIN PISO P ON V.CALLE = P.CALLE AND V.NUMERO = P.NUMERO
            UNION ALL
            SELECT V.NOMBREZONA FROM VIVIENDA V
                JOIN CASAPARTICULAR C ON V.CALLE = C.CALLE AND V.NUMERO = C.NUMERO
            UNION ALL 
            SELECT V.NOMBREZONA FROM VIVIENDA V
                JOIN HUECO H ON V.CALLE = H.CALLE AND V.NUMERO = H.NUMERO
        ) AS Sub
        GROUP BY NOMBREZONA
    ) AS ZonasconPropiedades
);

SELECT top 1 with ties NOMBREZONA, COUNT(*) AS numeroPropiedades
FROM (
    SELECT V.NOMBREZONA FROM VIVIENDA V
        JOIN PISO P ON V.CALLE = P.CALLE AND V.NUMERO = P.NUMERO
    UNION all
    SELECT V.NOMBREZONA FROM VIVIENDA V
        JOIN CASAPARTICULAR C ON V.CALLE = C.CALLE AND V.NUMERO = C.NUMERO
    UNION all
        SELECT V.NOMBREZONA FROM VIVIENDA V
    JOIN HUECO H ON V.CALLE = H.CALLE AND V.NUMERO = H.NUMERO
) AS Propiedades
    GROUP BY NOMBREZONA
    ORDER BY numeroPropiedades DESC;