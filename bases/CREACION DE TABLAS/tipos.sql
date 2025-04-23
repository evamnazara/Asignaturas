if exists (select * from sys.types where name ='fecha' )
BEGIN
    DROP TYPE 'fecha'
END

CREATE TYPE fecha FROM DATE null 