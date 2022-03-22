
DECLARE @table_name                VARCHAR(MAX)='tblEmployee';
DECLARE @COLUMN_NAME               VARCHAR(MAX);
DECLARE @DATA_TYPE                 VARCHAR(MAX);
DECLARE @IS_NULLABLE               VARCHAR(MAX); 
DECLARE @CHARACTER_MAXIMUM_LENGTH  VARCHAR(MAX);
DECLARE @NUMERIC_PRECISION         VARCHAR(MAX); 
DECLARE @NUMERIC_SCALE             VARCHAR(MAX);
DECLARE @SqlQuery                  VARCHAR(MAX)='INSERT INTO [dbo].['+@table_name+']( ';
DECLARE @TableColumn               VARCHAR(MAX)=''
DECLARE @TableColumnValues         VARCHAR(MAX)=''
DECLARE @NewLineChar			   CHAR(2) = CHAR(13) + CHAR(10)

-- declare cursor
DECLARE cursor_ForInsertScript CURSOR FOR
		SELECT COLUMN_NAME, 
			DATA_TYPE, 
			IS_NULLABLE, 
			CHARACTER_MAXIMUM_LENGTH, 
			NUMERIC_PRECISION, 
			NUMERIC_SCALE 
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME=@table_name;
-- open cursor
OPEN cursor_ForInsertScript;
-- loop through a cursor
FETCH NEXT FROM cursor_ForInsertScript INTO @COLUMN_NAME,@DATA_TYPE,@IS_NULLABLE,@CHARACTER_MAXIMUM_LENGTH,@NUMERIC_PRECISION,@NUMERIC_SCALE;
WHILE @@FETCH_STATUS = 0    
	BEGIN	

	IF(@IS_NULLABLE='NO') 
	BEGIN
		IF(LEN(@TableColumn)>0)
		BEGIN
		 SET @TableColumn +=(','+@COLUMN_NAME)
		END
		ELSE 
		BEGIN
		  SET @TableColumn=@COLUMN_NAME
		END

		IF(LEN(@TableColumnValues)>0)
		BEGIN
			IF(@DATA_TYPE IN ('smallmoney','tinyint','bigint','int','bit','decimal','float','money','numeric','smallint') )
			BEGIN 
			  SET @TableColumnValues+= (',1')
			END
			ELSE IF(@DATA_TYPE IN ('date','datetime','datetimeoffset','smalldatetime','datetime2','decimal','float','money','numeric','smallint') )
			BEGIN 
			  SET @TableColumnValues+= (',''2022-01-01''')
			END
			ELSE 
			BEGIN
				SET @TableColumnValues+= (',''A''')
			END
		END
		ELSE
		BEGIN
		IF(@DATA_TYPE IN ('smallmoney','tinyint','bigint','int','bit','decimal','float','money','numeric','smallint') )
		BEGIN 
			SET @TableColumnValues=1
		END
		ELSE 
		BEGIN
			SET @TableColumnValues='A'
		END
		END
	END

		FETCH NEXT FROM cursor_ForInsertScript INTO @COLUMN_NAME,@DATA_TYPE,@IS_NULLABLE,@CHARACTER_MAXIMUM_LENGTH,@NUMERIC_PRECISION,@NUMERIC_SCALE;
    END;
-- close and deallocate the cursor
CLOSE cursor_ForInsertScript;
DEALLOCATE cursor_ForInsertScript;

SET @SqlQuery=( @SqlQuery+@TableColumn+') VALUES ('+@TableColumnValues+')'+@NewLineChar+'GO 100')
PRINT @SqlQuery

