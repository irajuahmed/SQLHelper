--https://stackoverflow.com/questions/69826357/import-text-file-into-sql-server-table-using-query-or-stored-procedure
-- 'C:\Data', OLD
-- 'C:\Data2', NEW
CREATE PROC uspReadTextFileAndMove
(
	@oldDir VARCHAR(1000)='C:\Data',
	@newDir VARCHAR(1000)='C:\Data2'
)
AS
BEGIN
DECLARE @command VARCHAR(1000);
DECLARE @insertCommand VARCHAR(1000);
DECLARE @cmdFileMove VARCHAR(1000);
DECLARE @files TABLE ([Id] INT IDENTITY, [FileName] VARCHAR(1000));
DECLARE @FileToRead VARCHAR(1000)

SET @command = 'dir /b ' + @oldDir;
INSERT INTO @files EXECUTE xp_cmdshell @command;

DECLARE fileReadCursor CURSOR FOR

	 SELECT [FileName] FROM @files

OPEN fileReadCursor;
FETCH fileReadCursor INTO @FileToRead;
WHILE (@@FETCH_STATUS = 0) 
BEGIN
    
	    SET @insertCommand= 'BULK INSERT [dbo].[tbl_NewVendorData] FROM ''' +@oldDir+'\'+ @FileToRead + ''' WITH  ( FIELDTERMINATOR='','', ROWTERMINATOR='';\n'');'	
		EXECUTE(@insertCommand);
	    
		SET @cmdFileMove= 'MOVE ' + @oldDir + '\' + @FileToRead  +' '+ @newDir +'\'+@FileToRead
		EXEC master..xp_cmdshell @cmdFileMove
	
	--PRINT @insertCommand;
	--PRINT @FileToRead;
	--PRINT @cmdFileMove;
    
    FETCH fileReadCursor INTO @FileToRead;
END;
CLOSE fileReadCursor;
DEALLOCATE fileReadCursor;

END
