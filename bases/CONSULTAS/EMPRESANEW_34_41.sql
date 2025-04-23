-- 34. Realiza una consulta que devuelva el nombre, apellidos, teléfono y departamento de los empleado y matrícula y modelo del vehículo de los empleados que tienen un vehículo de más de 4 años. Para el teléfono queremos visualizar el teléfono1 en caso de que lo tenga, si no lo tiene miraremos si tiene el teléfono2 y en caso de no tener ninguno visualizará 'Desconocido'.

SELECT 
    E.Nome + ' ' + E.Apelido1 + ' ' + ISNULL(E.Apelido2, ' ') AS [Nome completo],
    --coalesce(E.Telefono1,E.Telefono2, 'Desconocido') AS Telefonos,
    --genera solo una columna 
    ISNULL(E.Telefono1, 'Desconocido') AS Telefono1, 
    ISNULL(E.Telefono2, 'Desconocido') AS Telefono2,
    D.NomeDepartamento,
    V.Matricula, V.Modelo
FROM EMPREGADO E
    INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento
    INNER JOIN VEHICULO V ON E.NSS = V.NSS
    -- MAL !!! WHERE YEAR(GETDATE()) - YEAR(V.DataCompra) > 4;
WHERE DATEDIFF(DD,V.DataCompra,GETDATE()) / 365.25 > 4;


-- 35._ Fai unha consulta que devolva información dos cursos que se celebran en Vigo e Pontevedra. Para cada curso queremos saber o nome, número de horas e total de alumnos nas edicións que se teñan celebrado deste curso polo momento. Tamén queremos saber cal foi o número de alumnos máis grande e máis pequeno para cada unha das edicións do curso.
--todo lo q este en el select TIENE que estar en group by
--PRIMERA PARTE 
SELECT C.NOME,C.HORAS,ED.NUMERO,COUNT(*) AS NUMALUMNOS
FROM CURSO C 
	INNER JOIN EDICION ED ON C.CODIGO=ED.CODIGO
	INNER JOIN EDICIONCURSO_EMPREGADO EDEMP ON ED.Codigo = EDEMP.Codigo	
		AND ED.Numero=EDEMP.Numero

where ed.Lugar in('Vigo','Pontevedra')
	group by c.Nome, c.Horas,ed.Numero
	order by NUMALUMNOS desc
	
	--completo
	
/*SELECT nome,HORAS,SUM(NUMALUMNOS) as Alumnos,
	MAX(NUMALUMNOS) as MaxAlumnos
	MIN(NUMALUMNOS) as MinAlumnos
	FROM ( --TABLA DERIVADA
	SELECT C.NOME, C.HORAS,ED.NUMERO, COUNT(*) AS NUMALUMNOS
		FROM CURSO C 
			INNER JOIN EDICION ED ON C.Codigo=ED.CODIGO
			INNER JOIN EDICIONCURSO_EMPREGADO EDEMP ON ED.Codigo = EDEMP.Codigo
			
			where ed.Lugar in ('Vigo','Pontevedra') 
			GROUP BY C.NOME, C.Horas,ED.Numero) AS TABLAAUX
	)
	
GROUP BY NOME,HORAS*/
	

-- 36. ¿Cuántos empleados hay en cada provincia? Se usa los dos primeros caracteres del código postal.Si no tiene código postal, se indicará como 'Desconocida'.

SELECT PROVINCIA =
    CASE LEFT(CP,2)
        WHEN 36 THEN 'PONTEVEDRA'
        WHEN 27 THEN 'LUGO'
        WHEN 15 THEN 'SANTIAGO'
        ELSE 'Desconocida'
    END, COUNT(nss) AS [EmpleadosPorProvincia]
FROM EMPREGADO
group by LEFT(CP,2)

-- 37. Muestra para todos los empleados su nombre completo y si tienen pareja, el nombre de esta indicando si es marido o mujer.

SELECT 
    E.Nome + ' ' + E.Apelido1 + ' ' + ISNULL(E.Apelido2, ' ') AS NomeEmpregado,
    ISNULL(F.Nome + ' ' + F.Apelido1 + ' ' + F.Apelido2, 'Solterx') AS NomeParella,
    CASE 
        WHEN F.Sexo = 'M' THEN 'Marido'
        WHEN F.Sexo = 'H' THEN 'Mujer'
        ELSE 'Solterx'
    END AS ParejasEmpleados
FROM EMPREGADO E
    LEFT JOIN FAMILIAR F ON E.NSS = F.NSS_empregado 
        AND F.Parentesco IN ('Mujer', 'Marido');

-- 38. ¿Existe algún empleado que trabaje en más de un proyecto en lugares diferentes?
SELECT E.NSS, E.Nome, E.Apelido1, ISNULL(E.Apelido2, ' ') AS Apelido2, 
		COUNT(DISTINCT P.Lugar)as ProyectosLugaresDiferentes,
		count(*) as TotalProyectos
FROM EMPREGADO E
    INNER JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado
    INNER JOIN PROXECTO P ON EP.NumProxecto = P.NumProxecto

GROUP BY E.NSS, E.Nome, E.Apelido1, E.Apelido2
    HAVING COUNT(DISTINCT P.Lugar) > 1;

-- 39. Generar un mote para cada empleado con las dos primeras letras de su nombre,  dos segundas de su primer apellido y la primera y última de la localidad donde reside.

SELECT 
    NSS, LOWER(LEFT(NOME,2) + SUBSTRING(Apelido1, 3, 4) + LEFT(Localidade, 1) + RIGHT(Localidade, 1)) AS MoteEmpleado, NOMEDEPARTAMENTO 
    FROM EMPREGADO E 
    INNER JOIN DEPARTAMENTO D
    ON E.NumDepartamentoPertenece = D.NumDepartamento


-- 40. Seleccionar empleados que viven en el mismo lugar donde se desarrolla un proyecto y que no están trabajando en ningún proyecto en la ciudad donde residen.
--MAL 
/*SELECT P.NomeProxecto, E.NSS, E.Nome, E.Apelido1
FROM EMPREGADO E
    INNER JOIN PROXECTO P ON E.Localidade = P.Lugar
    LEFT JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado
WHERE EP.NumProxecto IS NULL
GROUP BY NOMEPROXECTO,NSS,NOME,APELIDO1*/


--2
select nomeproxecto,nss,nome,apelido1 
FROM EMPREGADO E INNER JOIN PROXECTO P
	ON E.Localidade = P.Lugar
	WHERE LOCALIDADE NOT IN (
	SELECT LUGAR
		FROM PROXECTO P INNER JOIN EMPREGADO_PROXECTO EP
			ON P.NumProxecto = EP.NumProxecto
		WHERE EP.NSSEmpregado = E.NSS
							)

-- 41. Lo mismo que la consulta anterior, pero solo para empleados con más de 10 horas disponibles a la semana  (máximo 40 horas semanales).

SELECT P.NomeProxecto, E.NSS, E.Nome, E.Apelido1

FROM EMPREGADO E
    INNER JOIN PROXECTO P ON E.Localidade = P.Lugar
    LEFT JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado
WHERE EP.NumProxecto IS NULL 
    AND (40 - ISNULL(EP.Horas, 0)) > 10;

--2
select nomeproxecto,nss,nome,apelido1 
FROM EMPREGADO E INNER JOIN PROXECTO P
	ON E.Localidade = P.Lugar
	WHERE LOCALIDADE NOT IN (
	SELECT LUGAR
		FROM PROXECTO P INNER JOIN EMPREGADO_PROXECTO EP
			ON P.NumProxecto = EP.NumProxecto
		WHERE EP.NSSEmpregado = E.NSS
							)
and (select (40 - SUM(HORAS)) as horasLibres
	FROM EMPREGADO_PROXECTO 
	where NSSEmpregado = e.NSS
	) > 10;