-- TAREA 2

-- Utiliza un procedimiento almacenado para generar una lista de todas las bases de datos.
EXEC sp_databases;  

-- Utiliza una vista de cataloga para generar una lista de todas las bases de datos excepto las base de datos del sistema
SELECT name  
FROM sys.databases  
WHERE database_id > 4;


-- En la base de datos ventas

-- Visualiza informacion de los grupos que hay de 2 maneras

SELECT * FROM sys.filegroups WHERE data_space_id > 0;  -- 1 
EXEC sp_helpfilegroup;  


-- Visualiza informacion de la base de datos de 2 maneras
SELECT * FROM sys.databases WHERE name = 'Ventas';  
EXEC sp_helpdb 'Ventas';  
