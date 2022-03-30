BEGIN TRAN
--select * from StrFilings where Id>10011
--SELECT COUNT(1) FROM StrTransactions--394
DECLARE @incrementalValue BIGINT=1
DECLARE @lastStrId BIGINT
DECLARE @maxAlertSTR BIGINT
SET @maxAlertSTR =(SELECT ISNULL( MAX (CasT(SUBSTRING(AlertId,4,LEN(AlertId)-2) as bigint)),0) FROM StrFilings WHERE IsCTR = 1)

IF OBJECT_ID('tempdb..#TempResults') IS NOT NULL 
DROP TABLE #TempResults;

IF OBJECT_ID('tempdb..#TempTransaction') IS NOT NULL 
DROP TABLE #TempTransaction;


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



SELECT  TOP 1  
			T.[TransactionId]
           ,T.[StrId]
           ,T.[TransactionNo]
           ,T.[TransactionType]
           ,T.[AccountId]
           ,T.[AccountOrReferenceNo]
           ,T.[CategoryId]
           ,T.[CategoryName]
           ,T.[Amount]
           ,T.[Currency]
           ,T.[DepositorName]
           ,T.[BranchId]
           ,T.[Beneficiary]
           ,T.[BenificiaryAccNo]
           ,T.[BenificiaryBankName]
           ,T.[BenificiaryBranchName]
           ,T.[TransactionDate]
           ,T.[TransactionTime]
           ,T.[TellerId]
           ,T.[GeoLocation]
           ,T.[ViolatedRule]
           ,T.[Description]
INTO #TempTransaction
FROM [dbo].[StrTransactions] T
JOIN #TempResults R ON T.AccountId=R.AccountId

SELECT * FROM #TempResults
SELECT * FROM #TempTransaction

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

SET @lastStrId=SCOPE_IDENTITY()

INSERT INTO [dbo].[StrTransactions]
           ([TransactionId]
           ,[StrId]
           ,[TransactionNo]
           ,[TransactionType]
           ,[AccountId]
           ,[AccountOrReferenceNo]
           ,[CategoryId]
           ,[CategoryName]
           ,[Amount]
           ,[Currency]
           ,[DepositorName]
           ,[BranchId]
           ,[Beneficiary]
           ,[BenificiaryAccNo]
           ,[BenificiaryBankName]
           ,[BenificiaryBranchName]
           ,[TransactionDate]
           ,[TransactionTime]
           ,[TellerId]
           ,[GeoLocation]
           ,[ViolatedRule]
           ,[Description])

		SELECT   [TransactionId]
				,@lastStrId [StrId]
				,[TransactionNo]
				,[TransactionType]
				,[AccountId]
				,[AccountOrReferenceNo]
				,[CategoryId]
				,[CategoryName]
				,[Amount]
				,[Currency]
				,[DepositorName]
				,[BranchId]
				,[Beneficiary]
				,[BenificiaryAccNo]
				,[BenificiaryBankName]
				,[BenificiaryBranchName]
				,[TransactionDate]
				,[TransactionTime]
				,[TellerId]
				,[GeoLocation]
				,[ViolatedRule]
				,[Description]
		FROM #TempTransaction
 
 SET @incrementalValue += 1

END
--select * from StrFilings where Id>10011
ROLLBACK

