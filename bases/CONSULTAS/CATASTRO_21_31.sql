
-- 21. 25% de los pisos con más habitaciones. En el caso de haber más pisos con ese número de habitaciones deberían visualizarse también.
SELECT TOP 25 PERCENT WITH TIES * FROM PISO 
    ORDER BY NUMHABITACIONES desc
go

-- 22. toda la información de los garajes con al menos 14 metros. En caso de no tener propietario deberá mostrar desconocido.
SELECT CODIGO, CALLE, NUMERO, PLANTA, PUERTA, ID_HUECO, TIPO, METROS, OBSERVACIONES, DNI_PROPIETARIO = ISNULL(DNIPROPIETARIO as varchar(11),'Desconocido') FROM HUECO 
    WHERE tipo='garaje' 
    and METROS >= 14
GO

-- 23. nombre completo (p.e. Javier López Díaz) de los propietarios cuyo nombre no empiece por a, b, c, d o e cuyo apellido1 tenga más de 4 letras ordenados por sexo , nombre y apellidos.
SELECT nombreCompleto = NOMBRE +' '+ APELLIDO1 +' '+ ISNULL(APELLIDO2,'') FROM PROPIETARIO 
    WHERE NOMBRE LIKE'[^abcde-ABCDE]%' AND LEN(APELLIDO1)>4 
    ORDER BY SEXO, NOMBRE, APELLIDO1, APELLIDO2
GO

-- 24. información de las viviendas de la calle Damasco o General Mola cuyos metros solar empiecen por 2.
SELECT * FROM VIVIENDA 
    WHERE CALLE IN('Damasco', 'General Mola') 
    AND cast (METROSSOLAR  as varchar (5))LIKE '2%'

SELECT * FROM VIVIENDA 
    WHERE CALLE IN('Damasco', 'General Mola') 
    AND convert  (varchar (5),METROSSOLAR)LIKE '2%'
 
GO

-- 25. para cada propietario el nombre, apellido1, sexo y un identificador que se creará concatenando el sexo con las 3 primeras letras del nombre y las dos últimas del apellido1.
--substring tambien sirve 

SELECT nombreCompleto = NOMBRE +' '+ APELLIDO1 +' '+ ISNULL(APELLIDO2,''), SEXO, identificador = SEXO+LEFT(NOMBRE,3)+RIGHT(APELLIDO1,2) FROM PROPIETARIO
GO

-- 26. muestre los distintos tipos de huecos que hay en la calle Sol o Luca de Tena.
SELECT DISTINCT TIPO FROM HUECO 
    WHERE CALLE IN('Sol', 'Luca de Tena')
GO

-- 27. información de los 5 huecos más pequeños. En el caso de que haya más cuyo tamaño sea igual deberán visualizarse todos.
SELECT TOP 5 WITH TIES * FROM HUECO 
    ORDER BY METROS
GO

-- 28. nombres de las mujeres con los caracteres invertidos.
SELECT NOMBREINVERTIDO = REVERSE(NOMBRE) FROM PROPIETARIO 
    WHERE SEXO = 'M'
GO

-- 29. los trasteros o garajes sin mostrar los decimales de los metros.
-- si pones una funcion no puedes poner *

SELECT codigo, metros = FLOOR(METROS) FROM HUECO 
    WHERE TIPO IN('TRASTERO','GARAJE') 
GO

-- 30. distintos tipos de huecos de manera que se visualice la primera letra en mayúsculas y las siguientes en minúsculas.

SELECT DISTINCT tipoHueco = LEFT(TIPO,1) + LOWER(SUBSTRING(TIPO,2,LEN(TIPO)-1)) FROM HUECO 
GO
--esto funciona porque tienes un num de caracteres en tipo, no se imprime nada extra pero lo anterior es mejor
SELECT DISTINCT tipoHueco = LEFT(TIPO,1) + LOWER(SUBSTRING(TIPO,2,LEN(TIPO))) FROM HUECO 
GO

-- 31. nombre completo de los propietarios y sexo, indicando los valores Masculino o Femenino en función del valor del campo sexo
SELECT nombreCompleto = NOMBRE +' '+ APELLIDO1 +' '+ ISNULL(APELLIDO2,''), 
	sexo = CASE 
		WHEN SEXO = 'M' THEN 'Femenino'
		WHEN SEXO = 'H' THEN 'Masculino'
        else 'desc'
        END as genero
	FROM PROPIETARIO
     
GO