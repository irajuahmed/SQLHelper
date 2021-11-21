1. Install Microsoft ODBC Driver 17 for SQL Server 
2. connect : 	sqlcmd -S 127.0.0.1\instanceB
		sqlcmd -S ComputerA\instanceB
		sqlcmd -S ComputerA,1691  
		sqlcmd -S 127.0.0.1,1433
		sqlcmd -S tcp:ComputerA,1433  
		sqlcmd -S tcp:127.0.0.1,1433 
		sqlcmd -S np:\\ComputerA\pipe\sql\query  
		sqlcmd -S np:\\127.0.0.1\pipe\sql\query
		sqlcmd -S np:\\ComputerA\pipe\MSSQL$<instancename>\sql\query  
		sqlcmd -S np:\\127.0.0.1\pipe\MSSQL$<instancename>\sql\query 
2.1 connect shared memory (local):
		sqlcmd -S lpc:ComputerA  
		sqlcmd -S lpc:ComputerA\<instancename>  

3. sqlcmd -S myServer\instanceName -i C:\myScript.sql
