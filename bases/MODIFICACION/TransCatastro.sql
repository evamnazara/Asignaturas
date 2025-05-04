use BDCatastro
go;

/*Sobre la Base de datos CATASTRO

1._ El propietario de la vivienda unifamiliar de la calle Pasión 3 decide dividir la vivienda en 3 apartamentos de una habitación: uno por cada planta y no pone ascensor.

Los del primero y segundo piso de 55 metros cuadrados  construídos (50 útiles) y el del tercero de 50 metros cuadrados construídos (46 útiles).
Refleja este cambio en la base de datos utilizando transacciones explícitas si fuera necesario.*/

BEGIN TRANSACTION	
BEGIN TRY 

insert into bloquepisos
values('Pasión',3,3,'N')

update vivienda 
set tipovivienda = 'BLOQUE'
WHERE CALLE='PASION' and NUMERO=3 

insert into piso 
	values('Pasión',3,1,'A',1,50,55, (select dnipropietario from CASAPARTICULAR 
									where CALLE='pasión' and NUMERO=3)), --bloque1
		('Pasión',3,2,'A',1,50,55, (select dnipropietario from CASAPARTICULAR 
									where CALLE='pasión' and NUMERO=3)), --bloque2
		('Pasión',3,3,'A',1,50,55, (select dnipropietario from CASAPARTICULAR 
									where CALLE='pasión' and NUMERO=3))--bloque3
	delete from CASAPARTICULAR
	where CALLE='PASION' AND NUMERO=3
end try

begin catch 
	rollback transaction
	print 'error'
end catch