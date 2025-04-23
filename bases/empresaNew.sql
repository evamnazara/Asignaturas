-- 1. Hallar el número de empleados por departamento (visualiza el nombre) solo para aquellos departamentos que controlan más de 2 proyectos.

-- multitabla 
SELECT d.NomeDepartamento, COUNT(DISTINCT e.NSS) AS NumEmpleados
FROM DEPARTAMENTO d
    INNER JOIN PROXECTO p ON d.NumDepartamento = p.NumDepartControla
    INNER JOIN EMPREGADO e ON d.NumDepartamento = e.NumDepPertenec
GROUP BY d.NumDepartamento, d.NomeDepartamento
    HAVING COUNT(DISTINCT p.NumProxecto) > 2;

--subconsulta
SELECT d.NomeDepartamento, COUNT(e.NSS) AS NumEmpleados
FROM DEPARTAMENTO d
    INNER JOIN EMPREGADO e ON d.NumDepartamento = e.NumDepPertenec
WHERE d.NumDepartamento IN (
    SELECT NumDepartControla FROM PROXECTO
    GROUP BY NumDepartControla
    HAVING COUNT(*) > 2
)
GROUP BY d.NomeDepartamento;


-- 2.-
-- a) ¿cuál es la media del número de empleados por departamento? redondea al número entero más alto

SELECT CEILING(AVG(NumEmpleados)) AS MediaEmpleados
FROM (
    SELECT COUNT(*) AS NumEmpleados
    FROM EMPREGADO
    GROUP BY NumDepPertenec
) AS EmpleadosPorDepto;

-- b) Visualiza el nombre de departamento y número de proyectos que controlan para aquellos departamentos que el número de empleados asignados supera a la media del número de empleados por departamento

-- subconsulta
SELECT d.NomeDepartamento, COUNT(p.NumProxecto) AS NumProxectos
FROM DEPARTAMENTO d
    INNER JOIN PROXECTO p ON d.NumDepartamento = p.NumDepartControla
WHERE d.NumDepartamento IN (
    SELECT NumDepartamentoPertenece
    FROM EMPREGADO
    GROUP BY NumDepartamentoPertenece
    HAVING COUNT(*) > (
        SELECT CEILING(AVG(NumEmpleados))
        FROM (
            SELECT COUNT(*) AS NumEmpleados
            FROM EMPREGADO
            GROUP BY NumDepartamentoPertenece
        ) AS EmpleadosPorDepto
    )
)
GROUP BY d.NomeDepartamento;

-- 3.-
-- a) Para los departamentos que tienen más de 1 empleados con menos de 3 familiares a su cargo, hallar el número de proyectos que controlan.

-- subconsulta:
SELECT d.NomeDepartamento, COUNT(p.NumProxecto) AS NumProxectos
FROM DEPARTAMENTO d
    INNER JOIN PROXECTO p ON d.NumDepartamento = p.NumDepartControla
WHERE d.NumDepartamento IN (
    SELECT e.NumDepPertenec FROM EMPREGADO e
    INNER JOIN (
        SELECT NSS_empregado, COUNT(*) AS NumFamiliares FROM FAMILIAR
        GROUP BY NSS_empregado
        HAVING COUNT(*) < 3
    ) f ON e.NSS = f.NSS_empregado

    GROUP BY e.NumDepPertenec
    HAVING COUNT(*) > 1
)
GROUP BY d.NomeDepartamento;


-- b)           Para los departamentos que tienen más de 1 empleado con menos de 3 familiares a su cargo, hallar el número de proyectos que controlan si estos representan más del 15% del número de proyectos que hay.
SELECT d.NomeDepartamento, COUNT(p.NumProxecto) AS NumProxectos
FROM DEPARTAMENTO d
    INNER JOIN PROXECTO p ON d.NumDepartamento = p.NumDepartControla
WHERE d.NumDepartamento IN (
    SELECT e.NumDepPertenec FROM EMPREGADO e
    INNER JOIN (
        SELECT NSS_empregado, COUNT(*) AS NumFamiliares FROM FAMILIAR
        GROUP BY NSS_empregado
        HAVING COUNT(*) < 3
    ) f ON e.NSS = f.NSS_empregado

    GROUP BY e.NumDepPertenec
    HAVING COUNT(*) > 1
)
GROUP BY d.NomeDepartamento
HAVING COUNT(p.NumProxecto) > (SELECT COUNT(*) * 0.15 FROM PROXECTO)


-- 4 .-Haz una consulta para mostrar la siguiente información referente a los empleados:
SELECT 
    CASE
        WHEN DATEDIFF(DD, DataNacemento, GETDATE()) / 365.25 BETWEEN 40 AND 50 THEN 'ENTRE 40 Y 50 AÑOS'
        WHEN DATEDIFF(DD, DataNacemento, GETDATE()) / 365.25 < 40 THEN 'MENOR DE 40 AÑOS'
        WHEN DATEDIFF(DD, DataNacemento, GETDATE()) / 365.25 > 50 THEN 'MAYOR DE 50 AÑOS'
    END AS EDAD,
    SUM(CASE WHEN Sexo = 'M' THEN 1 ELSE 0 END) AS NUMEROMUJERES,
    SUM(CASE WHEN Sexo = 'H' THEN 1 ELSE 0 END) AS NUMEROHOMBRES,
    COUNT(*) AS TOTAL
FROM EMPREGADO

GROUP BY 
    CASE
        WHEN DATEDIFF(DD, DataNacemento, GETDATE()) / 365.25 BETWEEN 40 AND 50 THEN 'ENTRE 40 Y 50 AÑOS'
        WHEN DATEDIFF(DD, DataNacemento, GETDATE()) / 365.25 < 40 THEN 'MENOR DE 40 AÑOS'
        WHEN DATEDIFF(DD, DataNacemento, GETDATE()) / 365.25 > 50 THEN 'MAYOR DE 50 AÑOS'
    END

UNION ALL

SELECT 
    'TOTAL',
    SUM(CASE WHEN Sexo = 'M' THEN 1 ELSE 0 END),
    SUM(CASE WHEN Sexo = 'H' THEN 1 ELSE 0 END),
    COUNT(*)
FROM EMPREGADO;



-- 5.-  Hallar la media de la edad ( se visualiza con dos decimales) de aquellos empleados que dirigen algún departamento con más 4 empleados.
SELECT 
    CAST(AVG((DATEDIFF(DD, DataNacemento, GETDATE()) / 365.25) * 1.0) AS DECIMAL(5,2)) AS MEDIAEDAD
FROM DEPARTAMENTO d
JOIN EMPREGADO e ON d.NSSDirector = e.NSS
WHERE d.NumDepartamento IN (
    SELECT NumDepartamentoPertenec FROM EMPREGADO
    GROUP BY NumDepartamentoPertenec
    HAVING COUNT(*) > 4
);

-- 6.-Para los proyectos que han tenido el mayor número de problemas, visualiza el nombre de proyecto, nombre del departamento que lo controla y número de empleados asignados

