
--1.	Haz una consulta que visualice el nombre, teléfono, tiempo trascurrido desde la inauguración (en meses) y el
--	nombre completo del dueño (de cualquier sexo) de los restaurantes cuyos dueñ@s no han escrito ningún libro y
--	que hayan estado ejerciendo durante al menos 10 años completos. Los datos deben estar ordenados de mayor a
--	menor número de caracteres del nombre del restaurante.

--	NOME				TELEFONO		TIEMPO EN MESES		NOMBRE
--	Rincón del Gourmet	(952)222.645	118					JUAN  CARREÑO  VILA
--	Jardín Secreto		(948)888.888	89					CARMEN  CALLE PÉREZ
--	Rincón Andaluz		(958)888.888	109					ANA RAMOS RODRIGUEZ
--	Mar y Tierra		(951)234.567	90					CARMEN  CALLE PÉREZ
--	Casa Toscana		(928)884.566	92					ANA RAMOS RODRIGUEZ
--	Pizzeta				(960)056.565	80					CAROLINA ROJAS GOMEZ

select 
	r.NOME as nomerestaurante,
	'(' + substring(p.TELEFONOFIJO,1,3) + ')' + SUBSTRING(p.TELEFONOFIJO,3,3) + '.' +		substring(p.TELEFONOFIJO,6,3) as telefono, 
	datediff(month,r.DATAINAGURACION,GETDATE()) as meses,	
	UPPER (p.nome + ' ' + p.apelido1 + ' ' + ISNULL(p.APELIDO2,'')) as nomecompleto 
		from PERSONAL p 
	inner join COCINERO c on c.CODIGO = p.CODIGO 
	inner join RESTAURANTE r on r.COD_COCINERO = c.CODIGO
	
	where c.CODIGO not in (select COD_COCINERO from libro)
		and DATEDIFF(YEAR,c.DATA_EJERCER,GETDATE()) >= 10
order by LEN(r.nome) desc

--2.	Realizar una consulta para visualizar las provincias que tienen más de una cocinera chef (mujer) nacida entre los 
--	años 1960 y 2000 (ambos inclusive). Se deberá visualizarse el código junto con nombre de la provincia en un solo 
--	campo, el número de cocineras chef. El listado deberá visualizarse ordenado de las que tienen más cocineras a las 
--	que tienen menos y para las coincidentes por el nombre de la provincia en orden alfabético

SELECT CAST(pr.codigo as varchar(3))+ ' - ' + pr.nome as PROVINCIA,
	count(*) as numCocinerasChef 
	from provincia pr
	
	inner join personal p on pr.codigo = p.cod_provincia
	where 
		p.sexo = 'M'
		and p.CODIGO in (SELECT codigo from Chef)
		and datepart(year,p.DATA_NACEMENTO) between 1960 and 2000
group by pr.CODIGO, pr.NOME
having COUNT(*) > 1 
order by COUNT(*) desc
	
--	PROVINCIA		NÚMEROS DE COCINERAS CHEF
--	15-A CORUÑA		3
--	6-BADAJOZ		2
--	8-BARCELONA		2
--	27-LUGO			2
	
	
--3. 	Actualiza el precio de referencia (PVP_REFERENCIA) de los libros escritos por el cocinero o cocineros ( de
--	cualquier sexo ) con mayor número de recetas.
--	La actualización se realizará según el siguiente criterio:
--	• Si el precio de referencía supera la media de todos los libros, se reducirá un 10%. En caso contrario, se reducirá un 5%.
	
--	Antes de la actualización, crea una copia de la tabla LIBRO con el nombre copiaLIBRO y realiza la actualización aquí.

if OBJECT_ID('CopiaLibro') is not null 
	drop table copiaLibro
	
select * into CopiaLIBRO
from libro 

--cocinero con el mayor numero de receta 
select top 1 with ties COD_COCINERO
	from RECETA 
group by COD_COCINERO 
order by COUNT(*) desc;

update CopiaLIBRO
set PVP_REFERENCIA =
case 
	when pvp_referencia > (select AVG(PVP_REFERENCIA) from libro) then pvp_referencia * 0.90
	else pvp_referencia * 0.95
end 

go

--4. 	Visualiza el nombre completo, el nombre completo de su maestro de los auxiliares de cocina( de cualquier sexo)
--	cuyo correo electrónico no pertenezca al dominio de gmail(@gmail.com) y que desarrolle algún tipo de tarea que 
--	lleve la palabra limpieza (Ejemplo, Limpieza, apoyo a la limpieza, etc...). Si el auxiliar de cocina no tiene un maestro 
--	asignado, deberá visualizarse 'Sin maestro' en el resultado

--	AUXILIAR COCINA				MAESTRO					EMAIL
--	CAMILO GARCIA LOPEZ			MIRIAM LÓPEZ SIERRA		toni@hotmail.com
--	GUSTAVO HERNANDEZ MARTIN	SIN MAESTRO				gus@gmx.com
--	MARINA SANTOS PEREZ			MARIA MAGADÁN PÉREZ		marina@outlook.com 
--	MARTA SANTOS LOPEZ			LAURA FERNANDEZ GARCIA	marti@yahoo.com
--	RICARDO GOMEZ SANCHEZ		LUCIA TARREGA VARELA	ricky@outlook.com 

select distinct 
	p.NOME + ' ' + p.APELIDO1 + ' ' + ISNULL(p.APELIDO2,'') as [AUXILIAR COCINA],
	coalesce(pm.nome + ' ' + pm.apelido1 + ' ' + isnull(pm.apelido2,''), 'SIN MAESTRO') as MAESTRO,
	p.EMAIL as EMAIL
from PERSONAL p
	inner join AUXILIARCOCINA au on au.CODIGO = p.CODIGO 
	left join PERSONAL pm on p.CODCOCINEROMAESTRO = pm.CODIGO
	inner join TAREA t on t.CODIGO = au.TAREA
where 
	t.TIPO like ('%limpieza%')
	and p.EMAIL not like ('%@gmail.com')


--5.	Haz una consulta que visualice código, nombre completo, edad, contacto y fecha de cumpleaños del personal de 
--	cocina(cualquier sexo) cuya edad está comprendida entre 30 y 40 ambos inclusive. Los datos deben estar
--	ordenados de mayor a menor edad.
--	• En el nombre completo se mostrará el nombre y apellidos, indicando delante del nombre el tipo de personal
--	que es(si es auxiliar de cocina o chef junto a la clase, y solo a cocinero o cocinera según corresponda).
--	• En el contacto, se visualizará el teléfono móvil si lo tiene. De no ser el caso, el teléfono fijo, sino tiene ningún
--	teléfono, el email y si no tiene ningún medio de contacto, se visualizará en blanco.
--	• La fecha del cumpleaños se mostrará en formato -dd DE MES- (el mes en letras y en mayúsculas)
--	Ejemplo de visualización:
--CODIGO	NOMBRE	EDAD	CONTACTO	 FECHACUMPLEAÑOS 
--	7	(COCINERO) LUCIA TARREGA GONZALEZ	40	976543566	 3 DE MAYO 
--	29	(CHEF MANAGER) ANA RAMOS GONZALEZ	40	686547648	 12 DE MARZO	

select distinct
	cast(p.CODIGO as varchar(5)) as codigo, 
	--NOMBRES Y PUESTOS
	CASE
		when au.codigo is not null then '(AUXILIAR COCINA) '
		when ch.CODIGO IS NOT null then '(CHEF ' + ch.CLASE + ') '
		when c.CODIGO IS NOT NULL then
			case
				when p.SEXO = 'H' then '(COCINERO) '
				when p.SEXO = 'M' then '(COCINERA) '
				else '' 
			end 
		else ''
	END + p.NOME + ' ' + p.APELIDO1 + ' ' + ISNULL(APELIDO2,'') as NomeCompleto,
	  DATEDIFF(YEAR, p.DATA_NACEMENTO, GETDATE()) as edad,  
	coalesce(p.telefonomovil,p.telefonofijo,p.email,'') as contacto,
	CAST(DATENAME(day,P.DATA_NACEMENTO) as varchar (2)) + ' de ' + datename(MONTH, p.DATA_NACEMENTO)  as fechacumpleaños 
	
	
 from PERSONAL p 
left join AUXILIARCOCINA au on p.CODIGO = au.CODIGO
left join COCINERO c on c.CODIGO = p.CODIGO 
left join chef ch on ch.codigo = p.codigo 
where     -- Edad exacta (corrigiendo por si no ha cumplido aún)
     DATEDIFF(YEAR, p.DATA_NACEMENTO, GETDATE()) - 
        CASE 
            WHEN MONTH(p.DATA_NACEMENTO) > MONTH(GETDATE()) OR 
                 (MONTH(p.DATA_NACEMENTO) = MONTH(GETDATE()) AND DAY(p.DATA_NACEMENTO) > DAY(GETDATE()))
            THEN 1 ELSE 0
        END BETWEEN 30 AND 40
order by edad desc 
----

SELECT 
    CAST(p.CODIGO AS VARCHAR(5)) AS codigo, 

    -- Nombre completo con tipo de personal
    CASE
        WHEN au.CODIGO IS NOT NULL THEN '(AUXILIAR COCINA) '
        WHEN ch.CODIGO IS NOT NULL THEN '(CHEF ' + ch.CLASE + ') '
        WHEN c.CODIGO IS NOT NULL THEN 
            CASE 
                WHEN p.SEXO = 'H' THEN '(COCINERO) '
                WHEN p.SEXO = 'M' THEN '(COCINERA) '
                ELSE ''
            END
        ELSE ''
    END + p.NOME + ' ' + p.APELIDO1 + ' ' + ISNULL(p.APELIDO2, '') AS NomeCompleto,
    DATEDIFF(YEAR, p.DATA_NACEMENTO, GETDATE()) - 
        CASE 
            WHEN MONTH(p.DATA_NACEMENTO) > MONTH(GETDATE()) OR 
                 (MONTH(p.DATA_NACEMENTO) = MONTH(GETDATE()) AND DAY(p.DATA_NACEMENTO) > DAY(GETDATE()))
            THEN 1 ELSE 0
        END AS edad,

    -- Contacto preferente
    COALESCE(p.TELEFONOMOVIL, p.TELEFONOFIJO, p.EMAIL, '') AS contacto,

    -- Cumpleaños formateado: "dd DE MES"
    RIGHT('0' + CAST(DAY(p.DATA_NACEMENTO) AS VARCHAR), 2) + ' DE ' + UPPER(DATENAME(MONTH, p.DATA_NACEMENTO)) AS FechaCumpleaños

FROM PERSONAL p
LEFT JOIN AUXILIARCOCINA au ON au.CODIGO = p.CODIGO
LEFT JOIN COCINERO c ON c.CODIGO = p.CODIGO
LEFT JOIN CHEF ch ON ch.CODIGO = p.CODIGO

-- Filtro por edad exacta entre 30 y 40
WHERE 
    DATEDIFF(YEAR, p.DATA_NACEMENTO, GETDATE()) - 
        CASE 
            WHEN MONTH(p.DATA_NACEMENTO) > MONTH(GETDATE()) OR 
                 (MONTH(p.DATA_NACEMENTO) = MONTH(GETDATE()) AND DAY(p.DATA_NACEMENTO) > DAY(GETDATE()))
            THEN 1 ELSE 0
        END BETWEEN 30 AND 40

ORDER BY edad DESC;


--6. 
--	a) Crear una tabla llamada RecetaIngredientesGrupo que contenga el nombre, el tiempo y número de 
--	ingredientes de las recetas cuyo tiempo supera al tiempo medio de las recetas de su propio grupo (al grupo a que 
--	pertenecen) ordenado de mayor a menor por el numero de ingredientes.
--	Ejemplo de la tabla RecetaIngredientesGrupo

--	b)Elimina las recetas que tienen los cuatro tiempos más altos de la tabla RecetaIngredientesGrupo
--	Ej de recetas que se borrarían:
if object_id ('RecetaIngredientesGrupo') is not null
	drop table RecetaIngredientesGrupo

select 
	r.NOME, r.TEMPO,
	(select COUNT(*) from receta_ingrediente where COD_RECETA = r.CODIGO) as NumeroIngredientes

into RecetaIngredientesGrupo
from RECETA r
where r.TEMPO > (select avg(TEMPO) from RECETA r2 where r2.COD_GRUPO = r.cod_grupo)
order by NumeroIngredientes desc 


delete from RecetaIngredientesGrupo
	where TEMPO in (SELECT distinct top 4 TEMPO 
					from RecetaIngredientesGrupo 
					order by TEMPO desc )

--7. 	Registrar en la base de datos la siguiente información utilizando transacciones explícitas, para garantizar que se realizan todas las operaciones: (Nota: Pon comentarios para aclarar los diferentes pasos u operaciones). Las inserciones seguirán la secuencialidad en el código.

--   ● Una nueva cocinera chef manager llamada Manolita Barco Ramos, de apodo Barquense, nacida en Viana 
--	(Ourense), el mismo día y año pero dos meses antes que la cocinera de apodo Mariló, tiene a Anita como ma-
--	estra y solo se conoce el teléfono fijo que es 988666676 .
--   ● Ha comprado el restaurante con nombre Verrugita en Pontevedra, cambiándole el nombre por “Casa Manolita” 
--	y se va a inaugurar dentro de 6 semanas.
--   ● Ha creado la nueva receta de postres ‘Pudding de Manzana ’, la dificultad es la misma que la receta de Tarta 
--	de Queso, tiempo es 50 , la elaboración  ‘Se añade....’
--   ● Los ingredientes, las cantidades y la medida son los mismo que los de la receta de Tarta de Manzana.

--begin transaction 
--begin try 
----variables 
--	declare 
--		@idManolita int,
--		@idRecetaManolita int,
--		@fechaNacimiento date
--	select @idManolita = MAX(codigo) + 1 from personal
--	select @idRecetaManolita =  MAX(CODIGO)+1 FROM RECETA

--	SELECT TOP 1 @fechaNacimiento = DATEADD(MONTH, -2, data_Nacemento) 
--		from PERSONAL where APODO = 'Mariló' 

--	insert into PERSONAL (codigo,nome,apelido1,apelido2,apodo,sexo,data_nacemento,localidade,cod_provincia,codcocineromaestro,telefonomovil,telefonofijo,email)
--	values (
--		@idManolita,'Manolita','Barco','Ramos', 'Barquense','M',
--		@fechaNacimiento,
--		'Viena', (SELECT codigo from PROVINCIA where NOME = 'Ourense'),
--		(Select c.codigo from COCINERO c
--			inner join PERSONAL p on p.CODIGO = c.CODIGO
--			where p.APODO = 'Anita'),
--	--telefonomovil, fijo e email
--		null,'988666676', NULL 
--	)
--	print('Manolita personal finalizada')

--	insert into COCINERO (CODIGO,TIPO,DATA_EJERCER)
--	values (@idManolita,'C',GETDATE())
--	print ('manolita cocinero finalizada')

--	insert into CHEF (CODIGO,CLASE)
--	values(@idManolita,'Manager')
--	print ('manolita chef finalizada')
	
------   ● Ha comprado el restaurante con nombre Verrugita en Pontevedra, cambiándole el nombre por “Casa Manolita” y se va a inaugurar dentro de 6 semanas.
--	update RESTAURANTE
--	set 
--		COD_COCINERO = @idManolita,
--		NOME = 'Casa Manolita',
--		DATAINAGURACION = DATEADD(WEEK,6,GETDATE()),
--		localidade = 'Pontevedra'
--		where NOME = 'Verrugita' 
		
--		print ('manolita restaurante updated ') 
----   ● Ha creado la nueva receta de postres ‘Pudding de Manzana ’, la dificultad es la misma que la receta de Tarta de Queso, tiempo es 50 , la elaboración  ‘Se añade....’
----   ● Los ingredientes, las cantidades y la medida son los mismo que los de la receta de Tarta de Manzana.

--	insert into RECETA (CODIGO,NOME,DIFICULTADE,TEMPO,ELABORACION) 
--	values (
--		(SELECT MAX(CODIGO) + 1 FROM RECETA),
--		'PUDDING DE MANZANA',
--		(SELECT DIFICULTADE FROM RECETA WHERE NOME = 'TARTA DE QUESO'),
--		'50',
--		'SE AÑADE...'
--		)
--	PRINT ('receta pudding añadida')
	
--	insert into RECETA_INGREDIENTE (COD_RECETA, COD_INGREDIENTE, CANTIDAD,medida)
--	SELECT @idRecetaManolita, cod_ingrediente, cantidad, medida from RECETA_INGREDIENTE where COD_RECETA  = (select codigo from receta where NOME = 'Tarta de manzana' )

--	print ('manolita receta ingrediente finalizada')	
--commit transaction

--end try
--begin catch 
--	rollback transaction
--	print 'error'
--end catch 



BEGIN TRANSACTION
BEGIN TRY

-- Variables
DECLARE 
    @idManolita INT,
    @idRecetaManolita INT,
    @fechaNacimiento DATE,
    @provOurense INT,
    @codigoChefAnita INT

-- Obtener fecha de nacimiento 2 meses antes que Mariló
SELECT TOP 1 @fechaNacimiento = DATEADD(MONTH, -2, data_nacemento) 
FROM PERSONAL 
WHERE apodo = 'Mariló'

-- Obtener provincia Ourense
SELECT TOP 1 @provOurense = codigo FROM PROVINCIA WHERE nome = 'Ourense'

-- Obtener código de cocinera Anita
SELECT TOP 1 @codigoChefAnita = c.codigo 
FROM COCINERO c
JOIN PERSONAL p ON c.codigo = p.codigo 
WHERE p.apodo = 'Anita'

-- Calcular nuevos códigos
SELECT @idManolita = ISNULL(MAX(codigo), 0) + 1 FROM PERSONAL
SELECT @idRecetaManolita = ISNULL(MAX(codigo), 0) + 1 FROM RECETA

-- Insertar nueva persona
INSERT INTO PERSONAL (codigo, nome, apelido1, apelido2, apodo, sexo, data_nacemento, localidade, cod_provincia, codcocineromaestro, telefonomovil, telefonofijo, email)
VALUES (
    @idManolita, 'Manolita', 'Barco', 'Ramos', 'Barquense', 'M', 
    @fechaNacimiento, 
    'Viana', @provOurense, 
    @codigoChefAnita, 
    NULL, '988666676', NULL
)
PRINT 'Manolita insertada en PERSONAL'

-- Insertar en cocinero
INSERT INTO COCINERO (codigo, tipo, data_ejercer)
VALUES (@idManolita, 'C', GETDATE())
PRINT 'Manolita insertada en COCINERO'

-- Insertar en chef
INSERT INTO CHEF (codigo, clase)
VALUES (@idManolita, 'Manager')
PRINT 'Manolita insertada en CHEF'

-- Actualizar restaurante
UPDATE RESTAURANTE
SET 
    cod_cocinero = @idManolita,
    nome = 'Casa Manolita',
    datainaguracion = DATEADD(WEEK, 6, GETDATE()),
    localidade = 'Pontevedra'
WHERE nome = 'Verrugita'
PRINT 'Restaurante actualizado'

-- Insertar nueva receta
INSERT INTO RECETA (codigo, nome, dificultade, tempo, elaboracion)
VALUES (
    @idRecetaManolita,
    'PUDDING DE MANZANA',
    (SELECT TOP 1 dificultade FROM RECETA WHERE nome = 'Tarta de queso'),
    50,
    'Se añade....'
)
PRINT 'Receta añadida'

-- Insertar ingredientes de otra receta
INSERT INTO RECETA_INGREDIENTE (cod_receta, cod_ingrediente, cantidad, medida)
SELECT 
    @idRecetaManolita, cod_ingrediente, cantidad, medida 
FROM RECETA_INGREDIENTE 
WHERE cod_receta = (SELECT TOP 1 codigo FROM RECETA WHERE nome = 'Tarta de manzana')

PRINT 'Ingredientes añadidos'

COMMIT TRANSACTION

END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    PRINT 'error'
    PRINT ERROR_MESSAGE()
    PRINT ERROR_LINE()
    PRINT ERROR_NUMBER()
END CATCH

