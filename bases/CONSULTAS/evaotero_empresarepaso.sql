use BDEmpresa
go

-- 1. Listado de sueldo medio y número de empleados por localidad ordenado por provincia y dentro de esta por localidad. La localidad debe verse de la forma Localidad (Provincia)
SELECT 
  Localidade + ' (' + ISNULL(Provincia, ' - ') + ')' AS Localidad_Provincia,
  CAST(AVG(EF.Salario) AS DECIMAL(10,2)) AS Sueldo_Medio,
  COUNT(*) AS Numero_Empleados
    FROM EMPREGADO E
        INNER JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
  GROUP BY Localidade, Provincia
  ORDER BY Provincia, Localidade

-- 2. ¿En qué año nacieron más empleados?
-- se puede con > all 
SELECT TOP 1 
  YEAR(DataNacemento) AS Año,
  COUNT(*) AS Total
  FROM EMPREGADO
    GROUP BY YEAR(DataNacemento)
    ORDER BY Total DESC
    
--2
SELECT YEAR(DataNacemento) AS ANO_NACEMENTO, COUNT(*) AS ANONACEMENTO
	FROM EMPREGADO 
	GROUP BY YEAR(DataNacemento)
	having COUNT(*) >= all
		(select count(*)
			from EMPREGADO 
				group by YEAR(DataNacemento))

-- 3. Muestra, para la fecha actual: el año, el mes (su nombre), el día, el día del año, la semana, el día de la semana (nombre), la hora, los minutos y los segundos.
--declare @maxnumero int 

declare @fechaactual date
set @fechaactual=GETDATE()

SELECT 
  GETDATE() AS FechaCompleta,
    YEAR(@fechaactual) AS año,
    DATENAME(MONTH, @fechaactual) AS Mes,
    DAY(GETDATE()) AS Dia,
    DATEPART(DAYOFYEAR, @fechaactual) AS DiaDelAño,
    DATEPART(WEEK, GETDATE()) AS Semana,
    DATENAME(WEEKDAY, GETDATE()) AS DiaSemana,
    DATEPART(HOUR, GETDATE()) AS Hora,
    DATEPART(MINUTE, GETDATE()) AS Minuto,
    DATEPART(SECOND, GETDATE()) AS Segundo;

-- 4. Indica cuántos días, meses, semanas y años faltan para tu próximo cumpleaños. Cambia la fecha de nacimiento a la tuya real (formato YYYY-MM-DD)
-- f 
/*SELECT 
  DATEDIFF(DAY, GETDATE(),'2025-06-18') AS [DIAS],
           /*CASE 
             -- WHEN CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-01-30' AS DATE) >= GETDATE()
             THEN CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-01-30' AS DATE)
             ELSE DATEADD(YEAR, 1, CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-01-30' AS DATE))
           END
  ) AS Dias,*/

  DATEDIFF(MONTH, GETDATE(),'2025-06-18') as [meses],
           /*CASE 
             WHEN CAST(CAST(YEAR(GETDATE(,'2025-06-18')) AS VARCHAR) + '-01-30' AS DATE) >= GETDATE()
             THEN CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-01-30' AS DATE)
             ELSE DATEADD(YEAR, 1, CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-01-30' AS DATE))
           END
  ) AS Meses,*/

  DATEDIFF(WEEK, GETDATE(),
           CASE 
             WHEN CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-01-30' AS DATE) >= GETDATE()
             THEN CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-01-30' AS DATE)
             ELSE DATEADD(YEAR, 1, CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-01-30' AS DATE))
           END
  ) AS Semanas,

  DATEDIFF(YEAR, GETDATE(),
           CASE 
             WHEN CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-01-30' AS DATE) >= GETDATE()
             THEN CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-01-30' AS DATE)
             ELSE DATEADD(YEAR, 1, CAST(CAST(YEAR(GETDATE()) AS VARCHAR) + '-01-30' AS DATE))
           END
  ) AS Años*/


-- 5. Lista de todos los departamentos y los empleados que pertenecen a ellos,
-- incluyendo los departamentos sin empleados asignados.
SELECT D.NomeDepartamento,
  E.Nome + ' ' + E.Apelido1 + ISNULL(' ' + E.Apelido2, '') AS NombreCompleto
FROM DEPARTAMENTO D 
      LEFT JOIN EMPREGADO E 
        ON D.NumDepartamento = E.NumDepartamentoPertenece
  ORDER BY D.NomeDepartamento, NombreCompleto

-- 6. Consulta que muestra el número de caracteres del nombre de departamento y el nombre en formato inverso.
SELECT 
  NomeDepartamento,
  LEN(NomeDepartamento) AS NumCaracteres,
  REVERSE(NomeDepartamento) AS NombreInvertido
FROM DEPARTAMENTO

-- 7a. Consulta para obtener el nombre del departamento y la cantidad total de proyectos que controla
-- a) Sólo departamentos que controlan proyectos
SELECT 
  D.NomeDepartamento,
  COUNT(P.NumProxecto) AS TotalProyectos
FROM DEPARTAMENTO D
  INNER JOIN PROXECTO P ON D.NumDepartamento = P.NumDepartControla

GROUP BY D.NomeDepartamento

-- 7b. Consulta que muestra t<3odos los departamentos y, en caso de no controlar ninguno, pondrá 'No tiene'
--es con case 
SELECT 
  D.NomeDepartamento, ISNULL(CAST(COUNT(P.NumProxecto) AS VARCHAR(10)), 'No tiene') AS TotalProyectos
FROM DEPARTAMENTO D
  LEFT JOIN PROXECTO P ON D.NumDepartamento = P.NumDepartControla
GROUP BY D.NomeDepartamento

-- 8. Consulta que cuente el número de espacios que tienen los nombres de proyecto.
SELECT 
  NomeProxecto,
  LEN(NomeProxecto) - LEN(REPLACE(NomeProxecto, ' ', '')) AS Espacios
FROM PROXECTO

-- 9. Consulta para obtener todos los empleados (nss y nombre completo) y los proyectos (nombre) en los que están asignados, incluso si no tienen proyectos asignados.
SELECT 
  E.NSS,
  E.Nome + ' ' + E.Apelido1 + ISNULL(' ' + E.Apelido2, '') AS NombreCompleto,
  ISNULL(P.NomeProxecto, 'SEN PROXECTO')
FROM EMPREGADO E
  LEFT JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSempregado
  LEFT JOIN PROXECTO P ON EP.NumProxecto = P.NumProxecto

-- 10. Consulta para obtener todos los proyectos y los empleados asignados a ellos, incluso si no hay empleados asignados a algún proyecto.
SELECT 
  P.NomeProxecto,
  E.NSS,
  E.Nome + ' ' + E.Apelido1 + ISNULL(' ' + E.Apelido2, '') AS NombreCompleto
FROM PROXECTO P
  LEFT JOIN EMPREGADO_PROXECTO EP ON P.NumProxecto = EP.NumProxecto
  LEFT JOIN EMPREGADO E ON EP.NSSempregado = E.NSS

-- 11. Consulta para obtener los cinco proyectos con la cantidad total de horas semanales más alta asignadas. En caso de empate, deben verse todos.
SELECT top 5 
    P.NumProxecto,
    P.NomeProxecto,
    SUM(EP.Horas) AS TotalHoras
  FROM PROXECTO P
  JOIN EMPREGADO_PROXECTO EP ON P.NumProxecto = EP.NumProxecto
  GROUP BY P.NumProxecto, P.NomeProxecto
  order by SUM(ep.horas) desc

-- 12. Consulta para obtener los dos departamentos con el menor número de caracteres en sus nombres (sin empates).
SELECT TOP 2 
  NomeDepartamento,
  LEN(NomeDepartamento) AS NumCaracteres
FROM DEPARTAMENTO
  ORDER BY LEN(NomeDepartamento), NomeDepartamento

-- 13. Consulta para obtener los empleados (NSS) que no están asignados a ningún proyecto.
SELECT E.NSS,
  E.Nome + ' ' + E.Apelido1 + ISNULL(' ' + E.Apelido2, '') AS NombreCompleto
FROM EMPREGADO E
    LEFT JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSempregado
    WHERE EP.NumProxecto IS NULL
--con subconulta
SELECT E.NSS FROM EMPREGADO E
	WHERE E.NSS NOT IN 
	(SELECT EP.NSSEMPREGADO FROM EMPREGADO_PROXECTO EP)
	
--con tabla correlacionada // exists
SELECT E.NSS,
	E.Nome + ' ' + E.Apelido1 + ISNULL(' ' + E.Apelido2, '') AS NombreCompleto 
FROM EMPREGADO E 
	WHERE NOT EXISTS 
		(SELECT EP.NSSEMPREGADO 
			FROM EMPREGADO_PROXECTO EP
	WHERE EP.NSSEMPREGADO = E.NSS)