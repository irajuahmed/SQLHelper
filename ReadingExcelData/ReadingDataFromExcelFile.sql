--OPENROWSET

--USE [master] 
--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1 

--GO 

--select * from sys.configurations where name='ad hoc distributed queries'
--EXEC sp_configure 'show advanced options', 1
--RECONFIGURE
--GO
--EXEC sp_configure 'ad hoc distributed queries', 1
--RECONFIGURE
--GO

IF OBJECT_ID('tempdb..#tempDesignation') IS NOT NULL 
DROP TABLE #tempDesignation
GO

SELECT 
* 
INTO #tempDesignation
FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0', 
   'Excel 12.0 Xml;Database=E:\Raju\Designation\DesignationName.xlsx;', Sheet1$);
 
--OPENDATASOURCE
--SELECT * FROM OPENDATASOURCE('Microsoft.ACE.OLEDB.12.0', 
--   'Data Source=E:\Raju\Designation\DesignationName.xlsx;Extended Properties=EXCEL 12.0')...[Sheet1$];

INSERT INTO [dbo].[Designation]
           ([DesignationName]
           ,[Description]
           ,[IsActive])
			SELECT   TD.[DesignationName]
					,TD.[Description]
					,TD.IsActive 
			FROM    #tempDesignation TD
			LEFT JOIN  Designation D ON D.DesignationName=TD.DesignationName
			WHERE D.Id IS NULL

SELECT * FROM [dbo].[Designation]
