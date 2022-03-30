BEGIN TRAN
--SELECT * FROM StrFilings WHERE Id>10011

DECLARE @incrementalValue BIGINT=1
DECLARE @maxAlertSTR BIGINT
SET @maxAlertSTR =(SELECT ISNULL( MAX (CasT(SUBSTRING(AlertId,4,LEN(AlertId)-2) as bigint)),0) FROM StrFilings WHERE IsCTR = 1)

IF OBJECT_ID('tempdb..#TempResults') IS NOT NULL 
DROP TABLE #TempResults;


SELECT  TOP 1  
		    @maxAlertSTR [AlertId]
           ,[AccountId]
           ,[AccountTitle]
           ,[AccountNo]
           ,[CustomerNo]
           ,[BranchId]
           ,[BranchName]
           ,[Status]
           ,[GenerationDate]
           ,[CreatedUserId]
           ,[CurrentState]
           ,[IsActive]
           ,[InitialState]
           ,[LastComment]
           ,[Modify]
           ,[ModifedUserId]
           ,[RuleList]
           ,[RuleCodeList]
           ,[KycRiskLevel]
           ,[Score]
           ,[IsCTR]
           ,[FiuReportLogId]
           ,[HistoryId]
           ,[Period]
INTO #TempResults
FROM StrFilings 


WHILE(@incrementalValue<=5500)
BEGIN

INSERT INTO [dbo].[StrFilings]
           ([AlertId]
           ,[AccountId]
           ,[AccountTitle]
           ,[AccountNo]
           ,[CustomerNo]
           ,[BranchId]
           ,[BranchName]
           ,[Status]
           ,[GenerationDate]
           ,[CreatedUserId]
           ,[CurrentState]
           ,[IsActive]
           ,[InitialState]
           ,[LastComment]
           ,[Modify]
           ,[ModifedUserId]
           ,[RuleList]
           ,[RuleCodeList]
           ,[KycRiskLevel]
           ,[Score]
           ,[IsCTR]
           ,[FiuReportLogId]
           ,[HistoryId]
           ,[Period])
 SELECT    
            'CTR'+CAST((@maxAlertSTR+@incrementalValue) AS VARCHAR(5000))
		    ,[AccountId]
           ,[AccountTitle]
           ,[AccountNo]
           ,[CustomerNo]
           ,[BranchId]
           ,[BranchName]
           ,[Status]
           ,[GenerationDate]
           ,[CreatedUserId]
           ,[CurrentState]
           ,[IsActive]
           ,[InitialState]
           ,[LastComment]
           ,[Modify]
           ,[ModifedUserId]
           ,[RuleList]
           ,[RuleCodeList]
           ,[KycRiskLevel]
           ,[Score]
           ,[IsCTR]
           ,[FiuReportLogId]
           ,[HistoryId]
           ,[Period]
FROM #TempResults

 SET @incrementalValue += 1

END
--SELECT * FROM StrFilings WHERE Id>10011
ROLLBACK

