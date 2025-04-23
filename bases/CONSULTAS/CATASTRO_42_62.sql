--las funciones de agregado solo van en select o en having 


--42. ¿Cuál es la máxima altura que tienen los pisos que pertenecen a un propietario cuyo nombre empieza por M?
SELECT MAX(p.PLANTA) AS MaxAltura
    FROM PISO p
    WHERE p.DNIPROPIETARIO IN (
        SELECT pr.DNI
			FROM PROPIETARIO pr
			WHERE pr.NOMBRE LIKE 'M%'
    );
--
SELECT MAX(p.PLANTA) AS MaxAltura
    FROM PISO p
		INNER JOIN PROPIETARIO pr ON p.DNIPROPIETARIO = pr.DNI
		WHERE pr.NOMBRE LIKE 'M%';

--43. Haz una consulta que devuelva el total de parques que hay en la ciudad .
SELECT SUM(NUMPARQUES) AS TotalParques
    FROM ZONAURBANA;


--44. Haz una consulta que nos indique cual es el tamaño del solar más grande.
SELECT MAX(METROSSOLAR) AS SolarMasGrande
    FROM VIVIENDA;

--45. ¿Cuál es la máxima altura que tienen los pisos en la calle Damasco? (Utiliza la tabla piso).
SELECT MAX(PLANTA) AS MaxAltura
    FROM PISO
    WHERE CALLE = 'Damasco';

--46. Indica cual es el tamaño mínimo y máximo (de metros útiles) de los pisos situados en la calle Lucas de Tena 22.

SELECT MIN(METROSUTILES) AS MinTamaño, MAX(METROSUTILES) AS MaxTamaño
    FROM PISO
        WHERE CALLE = 'Lucas de Tena' 
        AND NUMERO = 22;

--47. Obtener la media de parques por zona urbana.
	--CASTEAR PARA DECIMALES 
SELECT AVG(cast (NUMPARQUES as float)) AS MediaParques
    FROM ZONAURBANA;
--48. Indica cuantas viviendas unifamiliares hay en la zona Palomar o Atocha.

SELECT COUNT(*) AS NumViviendasUnifamiliares
    FROM VIVIENDA
    WHERE TIPOVIVIENDA = 'Casa' 
    AND NOMBREZONA IN ('Palomar', 'Atocha');


--49. ¿Cuál es el tamaño medio de una vivienda unifamiliar?.

--xd 

--SELECT cast(AVG(cast(METROSCONSTRUIDOS as float)) as decimal(0,2)) AS tamanoMedio
 --   FROM CASAPARTICULAR;



--50. ¿Cuántos bloques de pisos hay en la zona Centro o Cuatrovientos cuyo solar pasa de 300 metros cuadrados?.
SELECT COUNT(*) AS NumBloques
    FROM VIVIENDA
    WHERE TIPOVIVIENDA = 'Bloque' 
    AND NOMBREZONA IN ('Centro', 'Cuatrovientos')
    AND METROSSOLAR > 300;


--51. Haz una consulta que devuelva el número de personas distintas que poseen una vivienda unifamiliar.
SELECT COUNT(DISTINCT DNIPROPIETARIO) AS NumPropietarios
    FROM CASAPARTICULAR;

-- 52. Haz una consulta que devuelva el número de hombres que poseen un trastero en las zonas Palomar y Centro.
SELECT COUNT(DISTINCT h.DNIPROPIETARIO) AS NumHombres
    FROM HUECO h
    
    WHERE h.TIPO = 'TRASTERO' AND h.CALLE IN (
        SELECT v.CALLE 
            FROM VIVIENDA v 
            WHERE v.NOMBREZONA IN ('Palomar', 'Centro')
    ) AND h.DNIPROPIETARIO IN (
        SELECT p.DNI 
            FROM PROPIETARIO p 
            WHERE p.SEXO = 'H'
    );


--53. Haz una consulta que devuelva el número de viviendas (de cualquier tipo) que hay en cada zona urbana.
SELECT NOMBREZONA, COUNT(*) AS NumViviendas
    FROM VIVIENDA
    GROUP BY NOMBREZONA;


--54. Haz una consulta que devuelva el número de bloques de pisos que hay en cada zona urbana.
SELECT NOMBREZONA, COUNT(*) AS NumBloques
    FROM VIVIENDA
    WHERE TIPOVIVIENDA = 'Bloque'
    GROUP BY NOMBREZONA;

--55. Indica para cada bloque de pisos (calle y número) el número de pisos que hay en este y cual es el piso más alto de cada uno de estos.
SELECT CALLE, NUMERO, COUNT(*) AS NumPisos, MAX(PLANTA) AS PisoMasAlto
    FROM PISO
    GROUP BY CALLE, NUMERO;

--56. Muestra los bloques de pisos (calle y número) que tienen más de 4 pisos.
SELECT CALLE, NUMERO
    FROM BLOQUEPISOS
    WHERE NUMPISOS > 4;


--57. Indica cual es el tamaño mínimo y máximo (de metros útiles) de los pisos de la zona Centro.
SELECT MIN(METROSUTILES) AS MinMetros, MAX(METROSUTILES) AS MaxMetros
    FROM PISO
    WHERE CALLE+CAST(numero as varchar(4)) IN (
        SELECT CALLE+CAST(numero as varchar(4))
            FROM VIVIENDA 
            WHERE NOMBREZONA = 'Centro'
    );


--58. Haz una consulta que muestre cuantos huecos hay de cada tipo en cada calle, teniendo en cuenta unicamente los huecos que están asociados a algún piso.

SELECT p.CALLE, h.TIPO, COUNT(*) AS NUMEROHUECOS
    FROM HUECO h inner join PISO p 
    on (h.CALLE = p.CALLE 
		and h.NUMERO = p.NUMERO 
		and h.PLANTA = p.PLANTA)

    GROUP BY p.CALLE, h.TIPO
    order by p.calle;


--59. ¿Cuántos bloques de pisos hay en la zona Centro o Palomar que poseen pisos de más de 3 habitaciones y que están entre 100 y 180 metros cuadrados(útiles)?

SELECT COUNT(CALLE+CAST(NUMERO AS VARCHAR(20))) AS NUMERODEBLOQUES
FROM PISO 
WHERE CALLE+CAST(NUMERO AS VARCHAR(3)) IN 
	(SELECT CALLE+CAST(NUMERO AS VARCHAR(3)) FROM VIVIENDA 
		WHERE NOMBREZONA IN ('Centro', 'Palomar') )
	AND NUMHABITACIONES > 3
	AND METROSUTILES BETWEEN 100 AND 180

--60. Indica cuantas viviendas unifamiliares de una o dos plantas hay en cada calle teniendo en cuenta unicamente aquellas calles en las que el total de metros construidos es mayor de 250.
SELECT CALLE, COUNT(*) AS NumViviendas
    FROM CASAPARTICULAR
    WHERE NUMPLANTAS IN (1, 2)
    AND CALLE IN (
        SELECT CALLE 
        FROM CASAPARTICULAR 
            GROUP BY CALLE 
                HAVING SUM(METROSCONSTRUIDOS) > 250
    )

    GROUP BY CALLE;


--61. Haz una consulta que devuelva el número de pisos de 3 o 4 habitaciones que hay en cada zona urbana, mostrando para cada zona su nombre, descripción y número de parques, ordenado por número de parques descendentemente.
SELECT v.NOMBREZONA, z.DESCRIPCIÓN, z.NUMPARQUES, COUNT(*) AS NumPisos
    FROM PISO p

    INNER JOIN VIVIENDA v ON p.CALLE = v.CALLE AND p.NUMERO = v.NUMERO
    INNER JOIN ZONAURBANA z ON v.NOMBREZONA = z.NOMBREZONA

    WHERE p.NUMHABITACIONES IN (3, 4)

    GROUP BY v.NOMBREZONA, z.DESCRIPCIÓN, z.NUMPARQUES
    ORDER BY z.NUMPARQUES DESC;


--62. Haz una consulta que nos diga cuantos propietarios de pisos hay de cada sexo, indicando los valores Hombres o Mujeres en función del valor del campo sexo.

--CON SUBCONSULTS
SELECT SEXO = CASE SEXO
	 WHEN 'M' THEN 'Mujeres' 
        ELSE 'Hombres' 
    END, 
    COUNT(*) AS NUMERO 
    FROM PROPIETARIO 
    WHERE  DNI IN (
		SELECT DNI PROPIETARIO FROM PISO) 
    GROUP BY SEXO;
    
--CON INNER JOIN NO FUCNIONA , TE COGE TODAS LAS VECES QUE UNA PERSONA APARECE 
SELECT SEXO =
    CASE SEXO
        WHEN 'M' THEN 'Mujeres' 
        ELSE 'Hombres' 
    END, 
    COUNT(*) AS NUMERO 
    
    FROM PROPIETARIO PR INNER JOIN PISO PIS ON DNI = DNIPROPIETARIO
    GROUP BY SEXO;