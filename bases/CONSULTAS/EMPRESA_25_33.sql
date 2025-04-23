-- 25. Consulta que devolva o nome, apelidos e departamento dos empregados que te�an o soldo m�is baixo

SELECT TOP 1 WITH TIES 
    e.Nome, e.Apelido1, e.Apelido2, d.NomeDepartamento
FROM EMPREGADO e
INNER JOIN EMPREGADOFIXO ef ON e.NSS = ef.NSS
INNER JOIN DEPARTAMENTO d ON e.NumDepartamentoPertenece = d.NumDepartamento
ORDER BY ef.Salario;

-- con subconsultas

SELECT e.Nome, e.Apelido1, e.Apelido2, d.NomeDepartamento
FROM EMPREGADO e
INNER JOIN EMPREGADOFIXO ef ON e.NSS = ef.NSS
INNER JOIN DEPARTAMENTO d ON e.NumDepartamentoPertenece = d.NumDepartamento
WHERE ef.Salario = (
    SELECT MIN(Salario) FROM EMPREGADOFIXO
)

--3

SELECT e.Nome, e.Apelido1, e.Apelido2, d.NomeDepartamento
FROM EMPREGADO e
INNER JOIN EMPREGADOFIXO ef ON e.NSS = ef.NSS
INNER JOIN DEPARTAMENTO d ON e.NumDepartamentoPertenece = d.NumDepartamento
WHERE 
	ef.Salario = (
		SELECT MIN(Salario) FROM EMPREGADOFIXO eF1 
		INNER JOIN EMPREGADO e1 on e1.NSS=eF1.NSS
		WHERE E.NumDepartamentoPertenece=E1.NumDepartamentoPertenece)


-- 26. N�mero de fillos por empregado, onde a suma das idades dos fillos sexa maior de 40

SELECT f.NSS_empregado, COUNT(*) AS NumeroFillos
FROM FAMILIAR f
WHERE f.Parentesco LIKE 'Hij%'
GROUP BY f.NSS_empregado
HAVING SUM(DATEDIFF(YEAR, f.DataNacemento, GETDATE())) > 40

-- 27. Empregados con nome que comeza por J, M ou R e segunda letra A ou con xefe con apelido que comeza por V e te�a 6 letras

SELECT d.NomeDepartamento, e.Nome, e.Apelido1, e.Apelido2
FROM EMPREGADO e
INNER JOIN DEPARTAMENTO d ON e.NumDepartamentoPertenece = d.NumDepartamento
WHERE (e.Nome LIKE '[JRM][A]%')
   OR exists (
        SELECT *
			FROM EMPREGADO xefe
			WHERE xefe.NSS = d.NSSDirector
			AND xefe.Apelido1 LIKE 'V%' 
        )
--terminaer 
SELECT d.NomeDepartamento, e.Nome, e.Apelido1, e.Apelido2
	FROM EMPREGADO e
INNER JOIN DEPARTAMENTO d ON e.NumDepartamentoPertenece = d.NumDepartamento
inner join  EMPREGADO xefe on e.NSSSupervisa=xefe.nss
WHERE e.Nome LIKE '[JRM][A]%' OR (
	xefe.Apelido1 LIKE 'V%' and LEN(jefe.apelido1)=6
        SELECT *
			FROM EMPREGADO xefe
			    WHERE xefe.NSS = d.NSSDirector
			AND xefe.Apelido1 LIKE 'V%' 
        )

-- 28. Lugares onde hai proxectos con empregados do departamento 1

SELECT DISTINCT p.Lugar
FROM PROXECTO p
INNER JOIN EMPREGADO_PROXECTO ep ON p.NumProxecto = ep.NumProxecto
INNER JOIN EMPREGADO e ON e.NSS = ep.NSSEmpregado
WHERE e.NumDepartamentoPertenece = 1

-- 29. Custo total de salarios do departamento 2 este ano (sen pagas extras)

SELECT SUM(ef.Salario* 12) AS TotalPagoAnual
FROM EMPREGADOFIXO ef
INNER JOIN EMPREGADO e ON ef.NSS = e.NSS
WHERE e.NumDepartamentoPertenece = 2

-- 30. Empregados fixos que te�en m�is idade

SELECT TOP 1 WITH TIES 
    e.Nome, e.Apelido1, e.Apelido2
FROM EMPREGADOFIXO ef
INNER JOIN EMPREGADO e ON ef.NSS = e.NSS
ORDER BY DATEDIFF(YEAR, e.DataNacemento, GETDATE()) DESC;

-- Con subconsultas

SELECT e.Nome, e.Apelido1, e.Apelido2
FROM EMPREGADOFIXO ef
INNER JOIN EMPREGADO e ON ef.NSS = e.NSS
WHERE DATEDIFF(YEAR, e.DataNacemento, GETDATE()) = (
    SELECT MAX(DATEDIFF(YEAR, e2.DataNacemento, GETDATE()))
    FROM EMPREGADOFIXO ef2
    INNER JOIN EMPREGADO e2 ON ef2.NSS = e2.NSS
)

-- 31. Salario medio, m�nimo e m�ximo dos empregados que NON son xefes, agrupado por sexo

SELECT e.Sexo,
       AVG(ef.Salario) AS SalarioMedio,
       MIN(ef.Salario) AS SalarioMinimo,
       MAX(ef.Salario) AS SalarioMaximo
FROM EMPREGADOFIXO ef
INNER JOIN EMPREGADO e ON ef.NSS = e.NSS
WHERE e.NSS NOT IN (
    SELECT NSSDirector FROM DEPARTAMENTO
)
GROUP BY e.Sexo

-- 32. Nomes dos proxectos nos que participan persoas con salario NULO

SELECT DISTINCT p.NomeProxecto
FROM PROXECTO p
INNER JOIN EMPREGADO_PROXECTO ep ON p.NumProxecto = ep.NumProxecto
INNER JOIN EMPREGADOFIXO ef ON ep.NSSEmpregado = ef.NSS
WHERE ef.Salario IS NULL;

-- Alternativa con subconsulta

SELECT DISTINCT NomeProxecto
FROM PROXECTO
WHERE NumProxecto IN (
    SELECT ep.NumProxecto
    FROM EMPREGADO_PROXECTO ep
    JOIN EMPREGADOFIXO ef ON ep.NSSEmpregado = ef.NSS
    WHERE ef.Salario IS NULL
)

-- 33. Nome completo dos empregados que te�en m�is familiares ao seu cargo

SELECT TOP 1 WITH TIES 
    e.Nome + ' ' + e.Apelido1 + ' ' + e.Apelido2 AS NomeCompleto,
    COUNT(f.Numero) AS TotalFamiliares
FROM EMPREGADO e
INNER JOIN FAMILIAR f ON e.NSS = f.NSS_empregado
GROUP BY e.Nome, e.Apelido1, e.Apelido2
ORDER BY COUNT(f.Numero) DESC;

--  subconsulta

SELECT e.Nome + ' ' + e.Apelido1 + ' ' + e.Apelido2 AS NomeCompleto
FROM EMPREGADO e
WHERE e.NSS IN (
    SELECT NSS_empregado
    FROM FAMILIAR
    GROUP BY NSS_empregado
    HAVING COUNT(*) = (
        SELECT MAX(Total)
        FROM (
            SELECT COUNT(*) AS Total
            FROM FAMILIAR
            GROUP BY NSS_empregado
        ) AS Contadores
    )
)
--3 
WITH NumFamiliares AS (
    SELECT NSS_empregado, COUNT(*) AS TotalFamiliares
    FROM FAMILIAR
    GROUP BY NSS_empregado
),
MaxFamiliares AS (
    SELECT MAX(TotalFamiliares) AS MaxF FROM NumFamiliares
)
SELECT e.Nome + ' ' + e.Apelido1 + ' ' + e.Apelido2 AS NomeCompleto
FROM EMPREGADO e
JOIN NumFamiliares nf ON e.NSS = nf.NSS_empregado
JOIN MaxFamiliares mf ON nf.TotalFamiliares = mf.MaxF;
