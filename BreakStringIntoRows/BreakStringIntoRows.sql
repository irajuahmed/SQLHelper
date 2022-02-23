USE [UCBLive]
GO
/****** Object:  UserDefinedFunction [dbo].[BreakStringIntoRows]    Script Date: 2/23/2022 10:26:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- EXEC ProsedureName
-- =============================================
-- Author     :	Raju Ahmed
-- Create date: 2022-02-23
-- Description:	SPLIT COMMA SEPARATED STRINGS INTO ROWS
-- =============================================


-- ========================== SPLIT COMMA SEPARATED STRINGS INTO ROWS ==========================
-- EXAMPLE INPUT : '30027,30034,30035'
-- EXAMPLE OUTPUT: 
-- Column1
-- 30027
-- 30034
-- 30035



CREATE FUNCTION [dbo].[BreakStringIntoRows] (@CommadelimitedString   varchar(1000))
RETURNS   @Result TABLE (Column1   VARCHAR(100))
AS
BEGIN
        DECLARE @IntLocation INT
        WHILE (CHARINDEX(',',    @CommadelimitedString, 0) > 0)
        BEGIN
              SET @IntLocation =   CHARINDEX(',',    @CommadelimitedString, 0)      
              INSERT INTO   @Result (Column1)
              --LTRIM and RTRIM to ensure blank spaces are   removed
              SELECT RTRIM(LTRIM(SUBSTRING(@CommadelimitedString,   0, @IntLocation)))   
              SET @CommadelimitedString = STUFF(@CommadelimitedString,   1, @IntLocation,   '') 
        END
        INSERT INTO   @Result (Column1)
        SELECT RTRIM(LTRIM(@CommadelimitedString))--LTRIM and RTRIM to ensure blank spaces are removed
        RETURN 
END
