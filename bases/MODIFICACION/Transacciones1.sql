

--1. Utiliza transacciones implícitas para garantizar que se realiza la operación completa correspondiente al ejercicio 2 y 3 de la tarea 2 de la UD6.

	--ENUN ORIGINAL 
	--2. Se va a impartir un nuevo curso de "Diseño Web" de 30 horas. La primera edición se va a realizar el 15 de abril en Pontevedra y su profesor va a ser el jefe de departamento  Técnico.
	--3. A esta edición del curso asistirán todos los empleados de este departamento (salvo el jefe).
	/*DECLARE @nssdirtecnico int = (SELECT NSSDirector FROM DEPARTAMENTO 
		WHERE NomeDepartamento = 'TÉCNICO');*/
use EMPRESANEW
go; 

SET IMPLICIT_TRANSACTIONS ON

BEGIN TRY 
	insert CURSO(Nome,Horas)
		values('Diseño Web',30)

	DECLARE @CodigoCurso int = (SELECT MAX(Codigo) FROM CURSO); --valido tmb, la dejo porque la uso mas adelante
	DECLARE @nssdirtecnico int = (SELECT NSSDirector FROM DEPARTAMENTO 
		WHERE NomeDepartamento = 'TÉCNICO');

	INSERT INTO EDICION (Codigo, Numero, Data, Lugar, Profesor)
	--VALUES (@CodigoCurso, 1, '2025-04-15', 'Pontevedra', @nssdirtecnico);
	VALUES (@@identity, 1, '2025-04-15', 'Pontevedra', @nssdirtecnico);

	COMMIT TRANSACTION --
	--select ident_current('Edicion')
	--select * from curso
	--select * from EDICION
	--exec sp_help 'Curso'
	END TRY 
	
	BEGIN CATCH -- Hay un error, deshacemos los cambios
		ROLLBACK TRANSACTION -- O solo ROLLBACK
		PRINT 'Se ha producido un error!'
		END CATCH
	ROLLBACK TRANSACTION
	


	INSERT INTO EDICIONCURSO_EMPREGADO (Codigo, Numero, NSS)
		SELECT @CodigoCurso, 1, NSS 
		FROM EMPREGADO 
		WHERE NumDepartamentoPertenece = 
			(SELECT NumDepartamento from DEPARTAMENTO
			where NomeDepartamento = 'TÉCNICO')
		AND NSS != @nssdirtecnico
	select * from EDICIONCURSO_EMPREGADO


--2. Los garajes libres de la calle Zurbarán 101 se venden a precio de saldo, lo que hace que Clementina Ares García, con DNI 32444423M decida comprarlos todos. Actualiza la base de datos para que refleje esta información utilizando transacciones implícitas si fuera necesario

--HACER CON TRY CATCH !!
use BDCatastro
go

INSERT into PROPIETARIO(dni,nombre,Apellido1, apellido2) 
values ('32444423M','Clementina','Ares','García')

UPDATE HUECO
SET DNIPROPIETARIO = 
	(select dni from PROPIETARIO where NOMBRE = 'Clementina' and APELLIDO1= 'Ares' )
WHERE CALLE='Zurbarán' 
	and Numero=101 
	and dnipropietario=null 
	and TIPO='Garaje'

--3. Se crea una nueva sede para el departamento Técnico en Villagarcía.
use empresanew
go;
	if not exists (SELECT * from lugar where num_Departamento = 
	(SELECT numDepartamento from departamento where nomeDepartamento='Tecnico')
	 and Lugar='Villagarcia' )
	set implicit_transactions on 
begin 
	print 'el departamento no tiene sede en villagarcia'
	insert into lugar
	values ((select MAX(id)+1 from lugar), 
			(select numDepartamento from departamento where nomeDepartamento = 'Técnico')
			,'vilagarcia')
end 


--4. El empleado de nombre Paulo Máximo Guerra se cambia de sexo y pasa a llamarse Mónica. Actualiza la base de datos.
use empresanew
go; 

update empregado
set Sexo = 'M',nome = 'Mónica'
where nome='Paulo' and apelido1 = 'Máximo' and apelido2 = 'Guerra'



--5. Utiliza transacciones explícitas para garantizar que se realiza la operación completa correspondiente al ejercicio 5 de la tarea 2 de la UD6.


--insertar proyecto
DECLARE @numDepTecnico int = 
	(SELECT NumDepartamento FROM DEPARTAMENTO 
	WHERE NomeDepartamento = 'TÉCNICO');

INSERT INTO PROXECTO (NomeProxecto, Lugar, NumDepartControla)
VALUES ('Deseño nova WEB', 'Vigo', @numDepTecnico);

-- nump royecto
DECLARE @NumeroProxecto INT = (SELECT MAX(NumProxecto)+1 FROM PROXECTO where NomeProxecto = 'Deseño nova WEB');

-- b) tareas
INSERT INTO TAREFA (NumProxecto, numero, descripcion, data_inicio, data_fin, dificultade, estado)
VALUES (@NumeroProxecto, 1, 'Definir o obxectivo da páxina', 
		DATEADD(dd, 15, GETDATE()), 
		DATEADD(DAY, 22, GETDATE()), 'Media', 'Pendiente'),
		
		(@NumeroProxecto, 2, 'Elexir o estilo e crear o mapa do sitio', 
		DATEADD(dd, 20, GETDATE()), NULL, -- <- no sabemos fecha de final 
		'Media', 'Pendiente');

