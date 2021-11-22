/*------------------------------------------------------
-- Author:	Raju Ahmed								 ----
-- Date:	22/11/2021								   ----
-- Note:	READ COMMITTED SNAPSHOT ON	 ----
------------------------------------------------------*/

Declare	@sql	nvarchar(4000)=N'',					
		@DBname	sysname = DB_NAME();			

Set @sql =	'Use Master
			Alter database ['+@DBname+']
			Set single_user with rollback immediate;
			ALTER DATABASE ['+@DBname+'] 
			SET READ_COMMITTED_SNAPSHOT ON;
			Alter database ['+@DBname+']
			Set Multi_user;'

Exec (@sql)

SELECT	name N'DataBaseName' ,
		case is_read_committed_snapshot_on	when 0 then N'Uncommited'
											when 1 then N'Commited'
											end N'ReadCommitedSnapshot'   
FROM sys.databases
WHERE name= @DBname
