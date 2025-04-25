use BDEmpresa
go

--1. El día de ayer el empleado Eligio Rodrigo y Xiao Vecino Vecino trabajaron 3 horas extra cada uno.

DECLARE @nsseligio int = 
	(SELECT NSS FROM EMPREGADO 
		WHERE Nome = 'Eligio' AND Apelido1 = 'Rodrigo');
DECLARE @nssxiao int = 
	(SELECT NSS FROM EMPREGADO 
		WHERE Nome = 'Xiao' AND Apelido1 = 'Vecino' AND Apelido2 = 'Vecino');

INSERT INTO HORASEXTRAS (Data, NSS, HorasExtras)
VALUES 
    (DATEADD(DD, -1, GETDATE()), @nsseligio, 3),
    (DATEADD(DAY, -1, GETDATE()), @nssxiao, 3);


--2. Se va a impartir un nuevo curso de "Diseño Web" de 30 horas. La primera edición se va a realizar el 15 de abril en Pontevedra y su profesor va a ser el jefe de departamento  Técnico.

insert CURSO(Nome,Horas)
	values('Diseño Web',30)

DECLARE @CodigoCurso int = (SELECT MAX(Codigo) FROM CURSO); --valido tmb, la dejo porque la uso mas adelante
DECLARE @nssdirtecnico int = (SELECT NSSDirector FROM DEPARTAMENTO 
	WHERE NomeDepartamento = 'TÉCNICO');

INSERT INTO EDICION (Codigo, Numero, Data, Lugar, Profesor)
--VALUES (@CodigoCurso, 1, '2025-04-15', 'Pontevedra', @nssdirtecnico);
VALUES (@@identity, 1, '2025-04-15', 'Pontevedra', @nssdirtecnico);

select ident_current('Edicion')
select * from curso
select * from EDICION
exec sp_help 'Curso'

--3. A esta edición del curso asistirán todos los empleados de este departamento (salvo el jefe).
/*DECLARE @nssdirtecnico int = (SELECT NSSDirector FROM DEPARTAMENTO 
	WHERE NomeDepartamento = 'TÉCNICO');*/

INSERT INTO EDICIONCURSO_EMPREGADO (Codigo, Numero, NSS)
	SELECT @CodigoCurso, 1, NSS 
	FROM EMPREGADO 
	WHERE NumDepartamentoPertenece = 
		(SELECT NumDepartamento from DEPARTAMENTO
		where NomeDepartamento = 'TÉCNICO')
	AND NSS != @nssdirtecnico
select * from EDICIONCURSO_EMPREGADO


--4. El departamento de contabilidad decide subir un 2% el salario a sus empleados. Realiza una consulta que incremente el sueldo de estos.
--sub
UPDATE EMPREGADOFIXO
SET Salario = Salario * 1.02
WHERE NSS IN (
    SELECT NSS FROM EMPREGADO 
		WHERE NumDepartamentoPertenece = (
			SELECT NumDepartamento FROM DEPARTAMENTO 
			WHERE NomeDepartamento = 'CONTABILIDAD'
    )
)

--inner join
UPDATE EMPREGADOFIXO
SET Salario = Salario * 1.02
	from DEPARTAMENTO
	inner join EMPREGADO on NumDepartamento = NumDepartamentoPertenece
	where NomeDepartamento='Contabilidad'
	and EMPREGADOFIXO.NSS=EMPREGADO.nss

--5. Hubo un error en la asignación de proyectos. La empleada con NSS=9900000 está trabajando en el proyecto "Portal"  en lugar de trabajar en el proyecto "Xestión da calidade". Corrígelo.

UPDATE EMPREGADO_PROXECTO
SET NumProxecto = (SELECT NumProxecto from PROXECTO 
		where nomeProxecto = 'XESTION DA CALIDADE')
	WHERE NSSEmpregado = 9900000
	AND NumProxecto = (SELECT NumProxecto FROM PROXECTO 
		where NomeProxecto = 'PORTAL');

select * from EMPREGADO_PROXECTO
select * from PROXECTO

/*6. Añade el proyecto "Deseño nova WEB" que se levará a cabo en Vigo e estará controlado polo departamento Técnico . De momento consta de dúas tareas:*/
--"Definir o obxectivo da páxina", que dará comezo dentro de 15 días e ten unha duración de 7 días. A súa dificultade é media.
--"Elexir o estilo e crear o mapa do sitio", que comezará dentro de 20 días e ten unha dificultade media.
--Neste proxecto estarán involucrados o xefe do departamento técnico con 8 horas e Felix Barreiro Valiña con 5 horas.

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

-- c trabajadores
-- nss Felix Barreiro Valiña

--prueba de try catch
BEGIN TRANSACTION
BEGIN TRY 
	DECLARE @nssfelix int = (SELECT NSS FROM EMPREGADO 
		WHERE Nome = 'Felix' AND Apelido1 = 'Barreiro' AND Apelido2 = 'Valiña');

	INSERT INTO EMPREGADO_PROXECTO (NSSEmpregado, NumProxecto, Horas)
	VALUES 
		(@nssdirtecnico, @NumeroProxecto, 8),
		(@nssfelix, @NumeroProxecto, 5);
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION 
	PRINT 'ERROR'
	
END CATCH 
GO