--create procedure dbo.x
	--exec dbo.x

--sp_help nombreProcedimiento
--sp_helptext 
--sp_depends

--modificar el metodo: alter table / drop procedure 

---------------------------------------------------------
--1)

--a) Crea un procedimiento almacenado MayorDeDosEnteros que se le pasan dos números enteros y visualice un mensaje indicando si dichos números son iguales o cuál es el mayor.
--Pon un ejemplo de ejecución de dicho procedimiento por valor y otro por referencia

create procedure MayorDeDosEnteros
    @num1 int, 
    @num2 int
AS  
BEGIN
    if @num1 = @num2
        print 'Los números son iguales';
    else if @num1 > @num2
        print 'El número ' + CAST(@num1 as varchar(10)) + ' es mayor que ' + CAST(@num2 as varchar(10));
    else
        print 'El número ' + CAST(@num2 as varchar(10)) + ' es mayor que ' + CAST(@num1 as varchar(10));
END;

--por valor 
exec MayorDeDosEnteros 10,10
--por referencia 
exec MayorDeDosEnteros @num1= 25,@num2 = 5


--b)Modifica el anterior procedimiento, para que devuelva el mensaje en un parámetro de salida.  Pon un ejemplo de ejecución de este procedimiento por valor y otro por referencia .
go
alter procedure MayorDeDosEnteros
    @num1 int, 
    @num2 int,
    @res int output
AS  
	if @num1 = @num2
		set @res = 'Los números son iguales'
	if @num1 > @num2
		set @res = 'El número ' + CAST(@num1 as varchar(10)) + ' es mayor que ' + CAST(@num2 as varchar(10))
	if @num1 < @num2
		set @res = 'El número ' + CAST(@num2 as varchar(10)) + ' es mayor que ' + CAST(@num1 as varchar(10));

go 
declare @res smallint
exec MayorDeDosEnteros 10,2,@res OUTPUT
select 'El resultado es: ', @res

--2)Crea un procedimiento que se le pase un número entero positivo y visualice la suma desde 1 hasta el número introducido. Se tendrá que comprobar que el número introducido sea un número positivo, en caso de error el procedimiento retornará -1 y si el número es correcto retornará 0. Ejecuta este procedimiento, visualizando también el valor retornado, poniendo ejemplos significativos.

create procedure SumaDesdeEntero
    @num int,
    @res int output
AS
begin
    if @num <= 0
    begin
        set @res = -1;
        return;
    end

    declare @suma int = 0;
    declare @i int = 1;

    while @i <= @num
    begin
        set @suma += @i;
        set @i += 1;
    end

    print 'La suma desde 1 hasta ' + CAST(@num AS VARCHAR(10)) + ' es: ' + CAST(@suma AS VARCHAR(10));
    set @res = 0;
end;

DECLARE @ret INT;
EXEC SumaDesdeEntero 10, @ret OUTPUT;
PRINT 'Resultado: ' + CAST(@ret AS VARCHAR);


--3)Crea un procedimiento almacenado MayorQueSueldoMin en la base de datos EMPRESA, para pasar un valor como parámetro (XXXX) y si ese valor es menor que el sueldo del empleado fijo que menos gana, se visualiza el mensaje “el valor XXXX es menor que el sueldo del empleado que menos gana: XXXX” sino visualiza “el valor XXXX no es menor que el sueldo del empleado que menos gana: XXXX”.
--Se deberá comprobar que el Valor XXXX será positivo devolviendo -1 en caso de error y 0 en caso contrario.

create procedure MayorQueSueldoMin
    @valor money,
    @resultado int OUTPUT
AS
BEGIN
    IF @valor <= 0
    BEGIN
        SET @resultado = -1;
        RETURN;
    END

    DECLARE @sueldoMin MONEY;
    SELECT @sueldoMin = MIN(sueldo)
    FROM Empleados
    WHERE tipo = 'Fijo';

    IF @valor < @sueldoMin
        PRINT 'El valor ' + CAST(@valor AS VARCHAR) + 
              ' es menor que el sueldo del empleado que menos gana: ' + CAST(@sueldoMin AS VARCHAR);
    ELSE
        PRINT 'El valor ' + CAST(@valor AS VARCHAR) + 
              ' no es menor que el sueldo del empleado que menos gana: ' + CAST(@sueldoMin AS VARCHAR);

    SET @resultado = 0;
END;

--Ejecuta este procedimiento, poniendo varios ejemplos significativos.


--4)      

--a)Crea un procedimiento llamado DatosDepartamento  que se le pase el nombre de un departamento y devuelva en parámetros para ese departamento:  el número de empleados de cualquier tipo, el número de empleados fijos, el total en salarios, el nombre completo del director de dicho departamento.
--También devolverá un valor de error -1 si no existe el departamento y 0 en caso contrario
CREATE PROCEDURE DatosDepartamento
    @nombreDepto NVARCHAR(50),
    @numEmp INT OUTPUT,
    @numEmpFijos INT OUTPUT,
    @totalSalario MONEY OUTPUT,
    @nombreDirector NVARCHAR(100) OUTPUT,
    @retorno INT OUTPUT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Departamentos WHERE nombre = @nombreDepto)
    BEGIN
        SET @retorno = -1;
        RETURN;
    END

    SELECT @numEmp = COUNT(*)
    FROM Empleados
    WHERE departamento = @nombreDepto;

    SELECT @numEmpFijos = COUNT(*)
    FROM Empleados
    WHERE departamento = @nombreDepto AND tipo = 'Fijo';

    SELECT @totalSalario = SUM(sueldo)
    FROM Empleados
    WHERE departamento = @nombreDepto;

    SELECT @nombreDirector = nombre + ' ' + apellido1 + ' ' + apellido2
    FROM Empleados
    WHERE NSS = (SELECT director FROM Departamentos WHERE nombre = @nombreDepto);

    SET @retorno = 0;
END;



--b)Crea un procedimiento llamado visualizardatosdepartamento  que se le pase un nombre de departamento y llame al procedimiento DatosDepartamento creando anteriormente. Debe visualizar la siguiente información tal como aparece en el siguiente ejemplo, teniendo en cuenta que si en la llamada no se le pasa ningún departamento, por defecto se visualizará el departamento Técnico :

-- DEPARTAMENTO: Persoal
-- DIRECTOR: Manuel Galán Galán
-- TOTAL SALARIO: 16695
-- NUMERO DE EMPLEADOS FIJOS 6 DE UN TOTAL DE 7 EMPLEADOS
CREATE PROCEDURE visualizardatosdepartamento
    @nombreDepto NVARCHAR(50) = 'Técnico'
AS
BEGIN
    DECLARE @numEmp INT, @numEmpFijos INT, @totalSalario MONEY,
            @nombreDirector NVARCHAR(100), @retorno INT;

    EXEC DatosDepartamento
        @nombreDepto, @numEmp OUTPUT, @numEmpFijos OUTPUT,
        @totalSalario OUTPUT, @nombreDirector OUTPUT, @retorno OUTPUT;

    IF @retorno = -1
        PRINT 'Departamento no encontrado';
    ELSE
    BEGIN
        PRINT 'DEPARTAMENTO: ' + @nombreDepto;
        PRINT 'DIRECTOR: ' + @nombreDirector;
        PRINT 'TOTAL SALARIO: ' + CAST(@totalSalario AS VARCHAR);
        PRINT 'NUMERO DE EMPLEADOS FIJOS ' + CAST(@numEmpFijos AS VARCHAR) + 
              ' DE UN TOTAL DE ' + CAST(@numEmp AS VARCHAR) + ' EMPLEADOS';
    END
END;




--5)      

--a)Escribe un procedimiento InicialEmpleados que me devuelve todos los empleados (NSS, NombreCompleto, nombredepartamento, nombre completo del supervisor ) cuyo nombre empieza por una letra que se le pase por parámetro.  Teniendo en cuenta

--Si no tiene supervisor devolverá ‘Sin supervisor” .
-- Si no se le pasa ningún parámetro me tiene que devolver los empleados cuyo nombre empieza por C. 
--El  parámetro debe ser una letra, devolviendo -1 en caso de fallo (que nos sea el parámetro una letra) y el número de filas devueltas en caso de éxito.
-- Ejecuta este procedimiento, visualizando también el valor retornado, poniendo varios ejemplos significativos de funcionamiento.
CREATE PROCEDURE InicialEmpleados
    @inicial CHAR(1) = 'C',
    @retorno INT OUTPUT
AS
BEGIN
    -- Validación: que sea una letra
    IF @inicial NOT LIKE '[A-Z]' AND @inicial NOT LIKE '[a-z]'
    BEGIN
        SET @retorno = -1;
        RETURN;
    END

    -- Obtener los empleados filtrados por inicial
    SELECT 
        e.NSS,
        e.Nombre + ' ' + e.Apellido1 + ' ' + e.Apellido2 AS NombreCompleto,
        d.Nombre AS NombreDepartamento,
        ISNULL(s.Nombre + ' ' + s.Apellido1 + ' ' + s.Apellido2, 'Sin supervisor') AS Supervisor
    FROM Empleados e
    LEFT JOIN Empleados s ON e.Supervisor = s.NSS



--b) Escribe un procedimiento almacenado InsertarEmpleados, que reciba una inicial de una letra y  cree una tabla  llamada EmpregadoDepartamento con los campos NSS, NombreCompleto, nombredepartamento, supervisor e inserte los empleados cuyo nombre empieza por la letra que se le ha pasado por parámetro, utilizando para ello el procedimiento InicialEmpleados creado anteriormente 
--( nota: mira las sentencia INSERT ….EXECUTE  en UD6  o busca en la ayuda).

--Se deberá mostrar lo siguiente:

--Si la letra no es un carácter se visualizará el mensaje "parámetro incorrecto, no se insertará ningún registro",
-- Si no existe ningún nombre con esa letra se visualizará "no hay ningún empleado cuyo nombre empiece por la letra X"
--Y en caso contrario, se insertará los empleados en la tabla empregadoDepartamento visualizando también el número de registros insertados.
--Ejecuta este procedimiento, visualizando también el valor retornado, poniendo varios ejemplos significativos de funcionamiento.
CREATE PROCEDURE InsertarEmpleados
    @inicial CHAR(1)
AS
BEGIN
    DECLARE @retorno INT;

    -- Validación: ¿es letra?
    IF @inicial NOT LIKE '[A-Z]' AND @inicial NOT LIKE '[a-z]'
    BEGIN
        PRINT 'Parámetro incorrecto, no se insertará ningún registro';
        RETURN;
    END

    -- Crear tabla si no existe
    IF OBJECT_ID('EmpregadoDepartamento', 'U') IS NULL
    BEGIN
        CREATE TABLE EmpregadoDepartamento (
            NSS CHAR(11),
            NombreCompleto NVARCHAR(100),
            NombreDepartamento NVARCHAR(50),
            Supervisor NVARCHAR(100)
        );
    END
    ELSE
    BEGIN
        TRUNCATE TABLE EmpregadoDepartamento;
    END

    -- Insertar datos desde el procedimiento anterior
    INSERT INTO EmpregadoDepartamento (NSS, NombreCompleto, NombreDepartamento, Supervisor)
    EXEC InicialEmpleados @inicial, @retorno OUTPUT;

    IF @retorno = -1
    BEGIN
        PRINT 'Parámetro incorrecto, no se insertará ningún registro';
    END
    ELSE IF @retorno = 0
    BEGIN
        PRINT 'No hay ningún empleado cuyo nombre empiece por la letra ' + @inicial;
    END
    ELSE
    BEGIN
        PRINT 'Se han insertado ' + CAST(@retorno AS VARCHAR) + ' empleados en la tabla EmpregadoDepartamento';
    END
END;





--6)Crea una copia de la tabla EmpleadosFijos y utiliza la copia para realizar la operación que se indica a continuación. Codifica un procedimiento SubirSalario que reciba como parámetro un porcentaje y aumente en ese porcentaje el salario de  los empleados que tienen asignados más de 2 proyectos, teniendo en cuenta que si se trata de un empleado supervisor  ese porcentaje se le incrementa en un 5% más.  

-- El porcentaje de aumento debe estar comprendido entre el 1% y el 15%, en caso contrario, hay que visualizar un mensaje indicando el error.

--Si se realiza la actualización, se debe visualizar un mensaje  indicando el número de filas que se han modificado ( “SE HA AUMENTADO EL SALARIO A X EMPLEADOS”).
CREATE PROCEDURE InsertarEmpleados
    @inicial CHAR(1)
AS
BEGIN
    DECLARE @retorno INT;

    -- Validación: ¿es letra?
    IF @inicial NOT LIKE '[A-Z]' AND @inicial NOT LIKE '[a-z]'
    BEGIN
        PRINT 'Parámetro incorrecto, no se insertará ningún registro';
        RETURN;
    END

    -- Crear tabla si no existe
    IF OBJECT_ID('EmpregadoDepartamento', 'U') IS NULL
    BEGIN
        CREATE TABLE EmpregadoDepartamento (
            NSS CHAR(11),
            NombreCompleto NVARCHAR(100),
            NombreDepartamento NVARCHAR(50),
            Supervisor NVARCHAR(100)
        );
    END
    ELSE
    BEGIN
        TRUNCATE TABLE EmpregadoDepartamento;
    END

    -- Insertar datos desde el procedimiento anterior
    INSERT INTO EmpregadoDepartamento (NSS, NombreCompleto, NombreDepartamento, Supervisor)
    EXEC InicialEmpleados @inicial, @retorno OUTPUT;

    IF @retorno = -1
    BEGIN
        PRINT 'Parámetro incorrecto, no se insertará ningún registro';
    END
    ELSE IF @retorno = 0
    BEGIN
        PRINT 'No hay ningún empleado cuyo nombre empiece por la letra ' + @inicial;
    END
    ELSE
    BEGIN
        PRINT 'Se han insertado ' + CAST(@retorno AS VARCHAR) + ' empleados en la tabla EmpregadoDepartamento';
    END
END;
