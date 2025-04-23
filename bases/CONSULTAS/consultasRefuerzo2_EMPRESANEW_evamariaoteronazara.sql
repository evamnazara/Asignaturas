--1.-Selecciona todos los empleados varones que nacieron despu�s del a�o 1970 y que tengan a Sara Plaza Mar�n como jefa.
SELECT e.NOME + ' ' + e.APELIDO1 + ' ' + ISNULL(e.APELIDO2, ' ') AS NombreCompleto
	FROM EMPREGADO e
		INNER JOIN EMPREGADO JEFA ON e.NSSSupervisa = JEFA.NSS
	WHERE YEAR(e.DataNacemento) > 1970
		AND e.SEXO = 'H'
		AND jefa.NOME = 'Sara' 
		AND jefa.APELIDO1 = 'Plaza' 
		AND jefa.APELIDO2 = 'Marín';

--2.-Muestra nombre, apellidos y tel�fono de los empleados que son jefes ordenado primero por apellidos y luego por nombre. 
--Solo se visualiza un tel�fono, cuando existan los dos, se visualiza el primero y si no tienen ninguno en blanco.
 
SELECT e.NOME + ' ' + e.APELIDO1 + ' ' + ISNULL(e.APELIDO2, ' ') AS NombreCompleto,
	COALESCE(TELEFONO1,TELEFONO2, ' ')
	FROM EMPREGADO e
	WHERE e.NSS IN 
		(SELECT NSSSupervisa 
			FROM EMPREGADO 
			WHERE NSSSupervisa IS NOT NULL)
	ORDER BY e.APELIDO1 ASC, e.NOME ASC;


--3- Muestra nombre junto a los apellidos y la edad de los empleados que no son jefes y mayores de 30 a�os, ordenado primero por apellidos descendentemente y luego por nombre ascendentemente. Hazlo de varias maneras.              
SELECT e.NOME + ' ' + e.APELIDO1 + ' ' + ISNULL(e.APELIDO2, ' ') AS NombreCompleto,
		DATEDIFF(YEAR, e.DataNacemento, GETDATE())  AS EDAD
	FROM EMPREGADO e
		LEFT JOIN EMPREGADO j ON e.NSS = j.NSSSupervisa
			WHERE j.NSSSupervisa IS NULL
			AND DATEDIFF(YEAR, e.DataNacemento, GETDATE()) > 30
	ORDER BY e.APELIDO1 DESC, e.NOME ASC


--4.- Para los empleados que se conoce solo un tel�fono, visualizar el nombre completo, el tel�fono que tenemos,  junto al nombre completo de su jefe. Para los que no tienen jefe se visualizar� el texto "Sin Jefe".

SELECT DISTINCT e.NOME + ' ' + e.APELIDO1 + ' ' + ISNULL(e.APELIDO2, ' ') AS NombreCompleto,
	coalesce(e.telefono1,e.telefono2),
	
    CASE 
        WHEN j.NSS IS NOT NULL THEN j.NOME + ' ' + j.APELIDO1 + ' ' + j.APELIDO2
        ELSE 'SIN JEFE'
    END AS JEFE

	FROM EMPREGADO e
	LEFT JOIN EMPREGADO j ON e.NSSSupervisa = j.NSS

-- 2
SELECT DISTINCT e.NOME + ' ' + e.APELIDO1 + ' ' + ISNULL(e.APELIDO2, ' ') EMPLEADO,
	
	(SELECT j.NOME + ' ' + j.APELIDO1 + ' ' + j.APELIDO2 
		FROM EMPREGADO J
		WHERE J.NSS = E.NSSSupervisa
		)	
		
	FROM EMPREGADO E
	WHERE E.telefono1 IS NOT NULL AND telefono2 IS NULL OR
		  E.telefono2 IS NOT NULL AND telefono2 IS NULL
	
--5.-Visualizar el nombre y apellidos de los empleados jefes que no dirigen ning�n departamento.
SELECT e.NOME, e.APELIDO1
	FROM EMPREGADO e

	WHERE e.NSS IN 
		(SELECT DISTINCT NSSSupervisa 
			FROM EMPREGADO 
			WHERE NSSSupervisa IS NOT NULL)
		AND e.NSS NOT IN 
			(SELECT NSSDirector 
				FROM DEPARTAMENTO)

-- CON MULTITABLA:
select distinct jefe.nss,jefe.nome,jefe.apelido1 from EMPREGADO JEFE 
	inner join EMPREGADO e on jefe.nss = E.NSSSupervisa
	left join DEPARTAMENTO d on jefe.nss = D.NSSDirector
	
	WHERE D.NSSDirector IS NULL


--6.- Muestra el nombre de los empleados que viven en una localidad en la que existe una sede del departamento al que pertenecen.
SELECT e.NOME + ' ' + e.APELIDO1 + ' ' + ISNULL(e.APELIDO2, ' ') AS NombreCompleto
	FROM EMPREGADO e
	INNER JOIN LUGAR L ON e.NumDepartamentoPertenece = L.Num_departamento
	WHERE e.Localidade = L.Lugar;
	
	
--SUBCONSULTA CORRELACIONADA
SELECT NOME + ' ' + APELIDO1 + ' ' + ISNULL(APELIDO2, ' ') AS NombreCompleto, 
	LOCALIDADE 
	FROM EMPREGADO 
	--WHERE exists 
	WHERE exists --Localidade IN 
		(SELECT LUGAR 
			FROM LUGAR
			WHERE EMPREGADO.NumDepartamentoPertenece = lugar.Num_departamento )
		
--7.- La cree una consulta que muestre para todos los empleados su nombre completo, calle, n�mero, piso, localidad y nombre de departamento. 
--La informaci�n debe estar ordenada por localidad en el caso de tratarse de mujeres y por nombre de departamento en el caso de tratarse de hombres.
SELECT 
    e.NOME + ' ' + e.APELIDO1 + ' ' + ISNULL(e.APELIDO2, ' ') AS NombreCompleto,
    e.Rua + ', ' + CAST(e.Numero_Calle AS VARCHAR) + ', ' + 
    e.Piso,
    e.Localidade,
    d.NomeDepartamento
	FROM EMPREGADO e
		INNER JOIN DEPARTAMENTO d ON e.NumDepartamentoPertenece = d.NumDepartamento
	ORDER BY 
		CASE 
			WHEN e.SEXO = 'M' THEN e.Localidade
		END ASC,
		CASE 
			WHEN e.SEXO = 'H' THEN d.NomeDepartamento
		END ASC

--subc

SELECT 
    NOME + ' ' + APELIDO1 + ' ' + ISNULL(APELIDO2, ' ') AS NombreCompleto,
    Rua + ', ' + CAST(Numero_Calle AS VARCHAR) + ', ' + 
    Piso,
    Localidade,
   
	(select nomedepartamento 
		from departamento
		where NumDepartamentoPertenece = NumDepartamento) as nomepartamento
		from empregado

	ORDER BY 
		CASE 
			WHEN SEXO = 'M' THEN Localidade
		END ASC
