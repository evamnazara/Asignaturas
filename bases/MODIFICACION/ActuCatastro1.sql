use BDCatastro
go

--Crea una tabla con información de los pisos que poseen las mujeres que  tienen un nombre que empieza por M. La tabla debe llamarse PISOS_M y la información que debe contener es la calle, número, planta, puerta, numhabitaciones, DNIPropietario, nombrezona.

/*SELECT INTO * FROM PISO P 
	INNER JOIN PROPIETARIO ON DNIPROPIETARIO = DNI
	WHERE SEXO = 'M'

INTO */

if exists (select * from sys.TABLES WHERE NAME = 'PISOS_M')
	DROP TABLE PISOS_M
	GO

SELECT p.calle, p.numero, p.planta, puerta, numhabitaciones, DNIPropietario, nombrezona INTO PISOS_M
	
	FROM PISO P INNER JOIN VIVIENDA V
	ON P.CALLE=V.CALLE AND P.NUMERO = V.NUMERO
	WHERE DNIPROPIETARIO IN (SELECT DNI FROM PROPIETARIO 
	WHERE SEXO='M' AND NOMBRE LIKE 'M%')
GO 

--2 
if exists (select * from sys.TABLES WHERE NAME = 'PISOS_M')
	DROP TABLE PISOS_M
	GO
	
SELECT p.calle, p.numero, p.planta, puerta, numhabitaciones, DNIPropietario, nombrezona INTO PISOS_M
	FROM PISO P 
	INNER JOIN VIVIENDA V ON P.CALLE=V.CALLE AND P.NUMERO = V.NUMERO
	INNER JOIN PROPIETARIO PR ON DNIPROPIETARIO = PR.DNI
	WHERE SEXO = 'M' AND NOMBRE LIKE 'M%'

--Queremos añadir los datos de una nueva vivienda unifamiliar situada en la calle Ponzano 44 que se encuentra en la zona Centro. El código postal es 23701, tiene 2 plantas y el propietario es Malena Franco Valiño.

INSERT INTO VIVIENDA (CALLE,NUMERO,TIPOVIVIENDA,CODIGOPOSTAL,NOMBREZONA)
	VALUES ('Ponzano',44,'Casa',23701,'Centro')
insert into CASAPARTICULAR (CALLE,NUMERO,NUMPLANTAS,DNIPROPIETARIO)
	values ('Ponzano',44,2,(SELECT DNI FROM PROPIETARIO 
				WHERE NOMBRE= 'Malena'
				AND APELLIDO1 = 'Franco'
				AND APELLIDO2 = 'Valiño'
	))

--El propietario de la vivienda situada en la calle Damasco, número 6 amplió su vivienda en 20 metros y constuyó una piscina. Actualiza la base de datos para que refleje estos cambio.

UPDATE CASAPARTICULAR
	SET PISCINA='S',METROSCONSTRUIDOS = METROSCONSTRUIDOS + 20
	WHERE CALLE='Damasco' and NUMERO=6


--Se instaló un enchufe en todas las bodegas de la calle Zurbarán 101. Refleja esta información en la base de datos. (en el campo observaciones.)
UPDATE HUECO 
	SET OBSERVACIONES=isnull(OBSERVACIONES,'')+'Se instaló un enchufe'
	where TIPO='bodega'
	and	calle = 'Zurbarán'
	and NUMERO = '101'

--Haz una consulta que devuelva el número de hombres y de mujeres que tienen un piso pero no tienen una vivienda unifamiliar.

select sexo,COUNT(*) from PROPIETARIO 
	where exists 
		(select * from PISO where DNIPROPIETARIO = dni) 
	and not exists (select * from CASAPARTICULAR
		where DNIPROPIETARIO = dni)
group by SEXO
	

--Haz una consulta que devuelva el nombre completo de los propietarios que tienen un garaje o un trastero en las zonas Palomar o Centro y que no tienen ni pisos ni viviendas unifamiliares.

SELECT NOMBRE,APELLIDO1,APELLIDO2 FROM PROPIETARIO
	WHERE DNI IN (
		SELECT DISTINCT DNIPROPIETARIO
			FROM HUECO H 
			INNER JOIN VIVIENDA V ON H.CALLE=V.CALLE AND H.NUMERO=V.NUMERO
			WHERE TIPO IN ('GARAJE','TRASTERO')
			AND NOMBREZONA IN ('PALOMAR','CENTRO')
			)
AND DNI NOT IN (SELECT DNIPROPIETARIO FROM PISO
				UNION 
				SELECT DNIPROPIETARIO FROM CASAPARTICULAR)