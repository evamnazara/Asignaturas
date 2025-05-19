Antes de crear objeto comprueba su existencia. Si existe se borra para volver a crearlo de nuevo.

***en la base de datos EmpresaNew2

1.-

Añadir un campo fecha de dirección a la tabla departamento para guardar la fecha de inicio del director  ( formato mm-dd-aaaa), acepta valores nulos y no puede ser mayor que la fecha actual.

  A)Crea un procedimiento llamado prActualizarDirector que se le pase el nombre de un departamento, un director y la fecha de dirección y  actualice el director y fecha de dirección de dicho departamento. Hay que tener en cuenta lo siguiente:

 - Los nuevos directores tienen que cumplir que solo pueden ser director del departamento al que pertenece y tienen que ser un empleado fijo.

- Los parámetros director y fecha de dirección son opcionales en la llamada al procedimiento y el valor por defecto para estos parámetros será null. En tal caso el director no cambiará, es decir, será el que ya está asignado y la fecha de inicio será la fecha de hace dos meses.

 - Si la fecha es mayor que la fecha actual y para que no incumpla la restricción en la fecha, se le asignará fecha actual.

 - Se devolverán dos parámetros de salida: años que lleva de director y un mensaje informando de la actualización.

Años de antigüedad de director se calculará utilizando una función llamada fnAnhosFechas que se creará. Recibirá dos fechas y devolverá los años que transcurre entre esas dos fechas
El mensaje indicará si se ha cambiado el director o no junto al nombre y  la fecha de dirección
Ejemplos de mensaje de salida:

-Se ha cambiado el director de departamento Persoal por Rocío López Ferreiro.  La fecha de inicio de dirección es 12 de Marzo de 2020.

-No se ha cambiado el director del departamento Persoal sigue siendo Manuel Galán Galán.  La fecha de inicio de dirección es 23 de Mayo de 2021

** Devolverá un código de retorno que nos permita controlar los errores, siendo

  -1  no existe el departamento

  -2  no existe el director

  -3  si el director no pertenece al departamento de cuál va a ser director

  -4 si no es un empleado fijo

 Para ejecutar el anterior procedimiento se hará haciendo una llamada dentro del procedimiento prMensajesActualizarDirector. Se visualizará  la antigüedad, el mensaje o los valores de retornos mediante un mensaje representativo según el código devuelto

b)

Se quiere modificar la fecha de inicio del director para cada departamento. La selección de cada departamento se va a realizar por orden alfabético.  A partir de una fecha dada que será la del primer departamento seleccionado por orden alfabético, la fecha del resto de los departamentos será 45 días después del anterior departamento siguiendo el orden establecido.  El director será es que está ya asignado.

La actualización se realizará utilizando la función prActualizarDirector creada anteriormente

Crea un procedimiento llamado prActualizarfechadirecciónDepartamentos que dada una fecha actualice la fecha de todos los departamentos según se ha indicado anteriormente. Los cambios por otras conexiones se reflejarán.

Se visualizará el mensaje de la actualización de la siguiente manera:

--llamada

exec prActualizarfechadirecciónDepartamentos '14-10-2019'

ejemplo de la visualización del mensaje

No se ha cambiado el director del departamento COMPRAS sigue siendo Rubén Guerra Vázquez.  La fecha de inicio de dirección es 14 de Octubre de 2019.  Hace 2 años

No se ha cambiado el director del departamento CONTABILIDAD sigue siendo Germán Gómez Rodríguez.  La fecha de inicio de dirección es 28 de Noviembre de 2019.  Hace 2 años

 No se ha cambiado el director del departamento INFORMÁTICA sigue siendo Antonia Romero Boo.  La fecha de inicio de dirección es 12 de Enero de 2020 . Hace 1 año

-------------------------

No se ha cambiado el director del departamento TÉCNICO sigue siendo Sara Plaza Marín.  La fecha de inicio de dirección es 10 de Julio de 2020.  Hace 1 año

 

ejercicio 2.- Crear una función que devuelva el nombre completo y en un solo campo todos los proyectos que tiene asignado junto al número de horas, tal como se muestra en la siguiente imagen. No se refleja los cambios realizados por otras conexiones.   Pon ejemplo de llamada.

 



 

AYUDA PARA  RESOLUCIÓN.

Mira en los apuntes los cursores anidados.

Tendrás que utilizar un primer cursor para ir fila a fila en la tabla empleado para coger el nss y el nombreCompleto.
Luego para cada empleado que esté seleccionado en el primer cursor, si tiene proyectos, utilizar un segundo cursor para ir cogiendo fila a fila cada proyecto del empleado  e ir concatenándolo en una variable.
Una vez que se haya terminado de recorrer los proyectos del empleado, se  insertan los valores  en la tabla que devolverá la función, se cierra y liberan los recursos del segundo cursor para el empleado seleccionado,
y se vuelve a leer el siguiente empleado y se repite el proceso con este empleado y así sucesivamente hasta el último empleado. Al finalizar se cierra y liberan los recursos del primer cursor.
Los cursores estáticos fijan el número de filas cuando se abre el cursor y las modificaciones realizadas en las tablas base no se reflejarán en los datos devueltos por las recuperaciones realizadas en el cursor. Por tanto, con la función @@CURSOR_ROWS podemos saber si el cursor se ha llenado con  N filas o no.