use master;

 RESTORE FILELISTONLY FROM DISK = N'D:\ь\User_Actions.bak';

 backup database User_Actions to disk = N'D:\ь\User_Actions.bak'

go

create procedure bdbak
    @lg1 varchar(1000),
    @lg2 varchar(1000),
    @lg3 varchar(1000)
    
    as 
        restore database User_Actions
        from disk = @lg1
        with replace,
        move N'User_Actions' to @lg2,
        move N'User_Actions_log' to @lg3

go

exec bdbak @lg1 = N'D:\ь\User_Actions.bak', @lg2 = N'D:\ь\rest\User_Actions.mdf', @lg3 = N'D:\ь\rest\User_Actions.ldf';


