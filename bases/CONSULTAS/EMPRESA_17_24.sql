-- 17._ ¿Cánto suman os salarios dos empregados fixos? ¿E cal é a media? Fai unha consulta que devolva os dous valores.

SELECT COUNT(*)  AS 'num empregados', 
    SUM(SALARIO) AS 'suma salarios', 
    AVG(SALARIO) AS 'media salarios'
FROM EMPREGADOFIXO

-- 18._ Fai unha consulta que devolva o número de empregados fixos que ten cada departamento e a media dos salarios.

SELECT NomeDepartamento, COUNT(*) AS 'num empregados', 
    CAST(AVG(SALARIO) AS DECIMAL(8,2)) AS 'media salarios'

FROM EMPREGADOFIXO EFX
    INNER JOIN EMPREGADO E ON EFX.NSS = E.NSS
    INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento
GROUP BY NomeDepartamento 

-- 19._ Fai unha consulta que nos diga cantos empregados naceron cada ano a partir de 1969.

SELECT COUNT(*) AS 'NACIDOS DESPOIS DE 1969'
    FROM EMPREGADO 
    WHERE YEAR(DATANACEMENTO) >= 1969

-- 20._Fai unha consulta que devolva o número de empregados de cada sexo. Deberá visualizarse o texto do xeito seguinte: O número de homes é 24 (e o mesmo para as mulleres).  

SELECT 
    CASE 
        WHEN SEXO = 'H' THEN 'O número de homes é ' + CAST(COUNT(*) AS VARCHAR(4))
        WHEN SEXO = 'M' THEN 'O número de mulleres é ' + CAST(COUNT(*) AS VARCHAR(4))
    END AS 'sexo empleados'

    FROM EMPREGADO
    GROUP BY SEXO

-- 21._Fai unha consulta que devolva o número de empregados temporales e fixos de cada sexo. Deberá visualizarse o texto do xeito seguinte: O número de empregados fixos de sexo masculino son 24 (e o mesmo para as mulleres e os empregados temporais). 

SELECT 
    CASE 
        WHEN E.SEXO = 'H' THEN 'O número de empregados fixos de sexo masculino é ' + 
            CAST(COUNT(DISTINCT EFX.NSS) AS VARCHAR(10)) 
        WHEN E.SEXO = 'M' THEN 'O número de empregadas fixas de sexo feminino é ' + 
            CAST(COUNT(DISTINCT EFX.NSS) AS VARCHAR(10)) 
    END AS 'fixos',
    CASE 
        WHEN E.SEXO = 'H' THEN 'O número de empregados temporais de sexo masculino é ' + 
            CAST(COUNT(DISTINCT EFX.NSS) AS VARCHAR(10)) 
        WHEN E.SEXO = 'M' THEN 'O número de empregadas temporais de sexo feminino é ' + 
            CAST(COUNT(DISTINCT EFX.NSS) AS VARCHAR(10)) 
    END AS 'temporais'

FROM EMPREGADO E
    LEFT JOIN EMPREGADOFIXO EFX ON EFX.NSS = E.NSS
    LEFT JOIN EMPREGADOTEMPORAL ETP ON ETP.NSS = E.NSS
GROUP BY E.SEXO;


-- 22._Mostra o nome completo dos empregados que teñen máis dun fillo de calquera sexo.

SELECT E.Nome + ' ' + E.Apelido1 + ' ' + ISNULL(E.Apelido2,' ') AS 'nome completo'
    FROM EMPREGADO E
    WHERE (
        SELECT COUNT(*) 
            FROM FAMILIAR F 
            WHERE F.NSS_empregado = E.NSS) > 1;

-- 23._Crea unha consulta que mostre para cada empregado (nome e apelido mostrados nun so campo chamado Nome_completo) as horas totais que traballa cada empregado en todos os proxectos.

SELECT 
    E.Nome + ' ' + E.Apelido1 + ' ' + ISNULL(E.Apelido2,' ') AS 'Nome completo', 
    SUM(EP.Horas) AS Horas_totais
    
    FROM EMPREGADO E
        INNER JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado
    GROUP BY E.Nome, E.Apelido1, E.Apelido2;

-- 24._ Supoñendo que as horas semanais que debe traballar un empregado son 40, modifica a consulta anterior para que amose os traballadores que teñen sobrecarga, indicando en cantas horas se pasan.

SELECT E.Nome + ' ' + E.Apelido1 + ' ' + ISNULL(E.Apelido2,' ') AS 'Nome completo',
       SUM(EP.Horas) AS horas,
       CASE 
           WHEN SUM(EP.Horas) > 40 THEN SUM(EP.Horas) - 40
       END AS horasExtra
FROM EMPREGADO E

    INNER JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado
    
    GROUP BY E.Nome, E.Apelido1, E.Apelido2
        HAVING SUM(EP.Horas) > 40;