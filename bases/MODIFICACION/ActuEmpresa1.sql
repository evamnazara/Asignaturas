use BDEmpresa
go

--1. El día de ayer el empleado Eligio Rodrigo y Xiao Vecino Vecino trabajaron 3 horas extra cada uno.

DECLARE @nsseligio int = 
	(SELECT NSS FROM EMPREGADO 
		WHERE Nome = 'Eligio' AND Apelido1 = 'Rodrigo');
DECLARE @nssxiao int = 
	(SELECT NSS FROM EMPREGADO 
		WHERE Nome = 'Xiao' AND Apelido1 = 'Vecino' AND Apelido2 = 'Vecino');

INSERT INTO HORASEXTRA (Data, NSS, HorasExtras)
VALUES 
    (DATEADD(DAY, -1, GETDATE()), @nsseligio, 3),
    (DATEADD(DAY, -1, GETDATE()), @nssxiao, 3);


--2. Se va a impartir un nuevo curso de "Diseño Web" de 30 horas. La primera edición se va a realizar el 15 de abril en Pontevedra y su profesor va a ser el jefe de departamento  Técnico.

insert CURSO(Nome,Horas)
	values('Diseño Web',30)

DECLARE @CodigoCurso int = (SELECT MAX(Codigo) FROM CURSO);
DECLARE @nssdirtecnico int = (SELECT NSSDirector FROM DEPARTAMENTO 
	WHERE NomeDepartamento = 'TÉCNICO');

INSERT INTO EDICIÓN (Codigo, Numero, Data, Lugar, Profesor)
VALUES (@CodigoCurso, 1, '2025-04-15', 'Pontevedra', @nssdirtecnico);

--3. A esta edición del curso asistirán todos los empleados de este departamento (salvo el jefe).

INSERT INTO EDICIÓNCURSO_EMPREGADO (Codigo, Numero, NSS)
	SELECT @CodigoCurso, 1, NSS 
	FROM EMPREGADO 
	WHERE NumDepPertenec = 
		(SELECT NumDepartamento from DEPARTAMENTO
		where NomeDepartamento = 'TÉCNICO')
	AND NSS <> @nssdirtecnico



--4. El departamento de contabilidad decide subir un 2% el salario a sus empleados. Realiza una consulta que incremente el sueldo de estos.

UPDATE EMPREGADOFIXO
SET Salario = Salario * 1.02
WHERE NSS IN (
    SELECT NSS FROM EMPREGADO 
		WHERE NumDepPertenece = (
        SELECT NumDepartamento FROM DEPARTAMENTO 
		WHERE NomeDepartamento = 'CONTABILIDAD'
    )
)


--5. Hubo un error en la asignación de proyectos. La empleada con NSS=9900000 está trabajando en el proyecto "Portal"  en lugar de trabajar en el proyecto "Xestión da calidade". Corrígelo.

UPDATE EMPREGADO_PROXECTO
SET NumProxecto = (SELECT NumProxecto from PROXECTO 
		where nomeProxecto = 'XESTION DA CALIDADE')
	WHERE NSSEmpregado = 9900000
	AND NumProxecto = (SELECT NumProxecto FROM PROXECTO 
		where NomeProxecto = 'PORTAL');


/*6. Añade el proyecto "Deseño nova WEB" que se levará a cabo en Vigo e estará controlado polo departamento Técnico . De momento consta de dúas tareas:*/
--"Definir o obxectivo da páxina", que dará comezo dentro de 15 días e ten unha duración de 7 días. A súa dificultade é media.
--"Elexir o estilo e crear o mapa do sitio", que comezará dentro de 20 días e ten unha dificultade media.
--Neste proxecto estarán involucrados o xefe do departamento técnico con 8 horas e Felix Barreiro Valiña con 5 horas.

--insertar proyecto
DECLARE @numDepTecnico int = 
	(SELECT NumDepartamento FROM DEPARTAMENTO 
	WHERE NomeDepartamento = 'TÉCNICO');
  -- 3

INSERT INTO PROXECTO (NomeProxecto, Lugar, NumDepartControla)
VALUES ('Deseño nova WEB', 'Vigo', @numDepTecnico);

-- nump royecto
DECLARE @NumProxecto INT = (SELECT MAX(NumProxecto) FROM PROXECTO);

-- b) tareas
INSERT INTO TAREFA (NumProxecto, numero, descripcion, data_inicio, data_fin, dificultade, estado)
VALUES 
(@NumProxecto, 1, 'Definir o obxectivo da páxina', DATEADD(DAY, 15, GETDATE()), DATEADD(DAY, 22, GETDATE()), 'Media', 'Pendiente'),
(@NumProxecto, 2, 'Elexir o estilo e crear o mapa do sitio', DATEADD(DAY, 20, GETDATE()), NULL, 'Media', 'Pendiente');

-- c trabajadores
-- nss Felix Barreiro Valiña
DECLARE @nssfelix int (SELECT NSS FROM EMPREGADO 
	WHERE Nome = 'Felix' AND Apelido1 = 'Barreiro' AND Apelido2 = 'Valiña'); -- 1100222

INSERT INTO EMPREGADO_PROXECTO (NSSEmpregado, NumProxecto, Horas)
VALUES 
	(@nssdirtecnico, @NumProxecto, 8),
	(@nssfelix, @NumProxecto, 5);
