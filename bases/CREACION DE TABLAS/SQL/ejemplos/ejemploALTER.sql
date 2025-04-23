-- para borrar un grupo hay que borrar todos sus archivos
-- para borrar un archivo hay qu eborrar los datos

ALTER DATABASE Ventas
ADD FILE
( 
    NAME = EjADDarchivo,
    FILENAME = 'C:\Server\MSSQL\EjADDarchivo.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)




ALTER DATABASE <nombreBasedeDatos>
{
 <añadir_o_modificar_archivos>
 | <añadir_o_modificar_gruposArchivos>
 | MODIFY NAME = nuevo_nombre
 | COLLATE nombreintercalacion
}[;]
<añadir_o_modificar_archivos>
{ ADD FILE <filespec> [ ,...n ]
 [ TO FILEGROUP { nombreGrupoArchivo } ]
 | ADD LOG FILE <filespec> [ ,...n ]
 | REMOVE FILE nombreLogico
 | MODIFY FILE <filespec>
}
<filespec>::=
( NAME = nombreLogico
 [ , NEWNAME = nuevo_nombreLogico]
 [ , FILENAME = nombreFisico ]
 [ , SIZE = tamaño [ KB | MB | GB | TB ] ]
 [ , MAXSIZE = { max_size [ KB | MB | GB | TB ] | UNLIMITED } ]
 [ , FILEGROWTH = incremento [ KB | MB | GB | TB| % ] ]
 [ , OFFLINE ]
)
| <añadir_o_modificar_gruposArchivos>{
 | ADD FILEGROUP nombre_GrupoArchivo
 [ CONTAINS FILESTREAM ]
 | REMOVE FILEGROUP nombre_GrupoArchivo
 | MODIFY FILEGROUP nombre_GrupoArchivo
 { <cambiar_propiedadesdeActualizacion>
 | DEFAULT
 | NAME = nuevo_nombreGrupoArchivo
 }
}
<cambiar_propiedadesdeActualizacion> {
 READONLY | READ_ONLY | READ_WRITE
}