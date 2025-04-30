--TRANSACCIONES EXPLICITAS

    (declarar variables)
    begin transaction 
        begin try --/begin
            (acciones)
        commit transaction
        end try 

        begin catch 
            begin rollback
                print'error'
        end catch

--TRANSACCIONES IMPLICITAS 
	set implicit_transactions on 

    (variables)
    begin try
        commit transaction
    end try 
    begin catch
    rollback transaction
    print 'error'
    end catch