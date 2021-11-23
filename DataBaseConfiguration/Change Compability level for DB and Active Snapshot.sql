/*------------------------------------------------------
Author:	Raju Ahmed					
Date:	22/11/2021					
Note:	Change Compability level for DB and Active Snapshot
------------------------------------------------------*/


DECLARE @level    NVARCHAR(5)   = '130',					
		@DBname   SYSNAME       = DB_NAME(),				
		@Command  NVARCHAR(400),						
		@Command2 NVARCHAR(400)

SET @Command =	'
				ALTER DATABASE ['+(@DBname)+']
				SET COMPATIBILITY_LEVEL = '+@level+'
				'
SET @Command2 = '
				USE master
				ALTER database ['+@DBname+']
					SET single_user with rollback immediate
				ALTER DATABASE ['+@DBname+']
					SET READ_COMMITTED_SNAPSHOT ON  
				
				ALTER database ['+@DBname+']
					SET Multi_user
				'

Exec sp_executesql	@command
Exec sp_executesql	@command2

/*--Checking All database--*/
SELECT CASE WHEN is_read_committed_snapshot_on=1 THEN N'Committed'
			WHEN is_read_committed_snapshot_on=0 THEN N'Not Committed' 
					END AS N'CommitedStatus',
		 [name] AS N'DatabaseName'
FROM sys.databases
ORDER BY is_read_committed_snapshot_on DESC


SELECT 
	is_read_committed_snapshot_on
   ,snapshot_isolation_state
   ,snapshot_isolation_state_desc
   ,* 
FROM sys.databases
