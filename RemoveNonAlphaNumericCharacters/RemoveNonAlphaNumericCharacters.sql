CREATE Function [dbo].[RemoveNonAlphaNumericCharacters] (@Temp VARCHAR(1000))
RETURNS VARCHAR(1000)
AS
BEGIN

    DECLARE @AcceptedCharcaters AS VARCHAR(50)
    SET @AcceptedCharcaters = '%[^0-9a-zA-Z]%'
    WHILE PATINDEX(@AcceptedCharcaters, @Temp) > 0
        SET @Temp = STUFF(@Temp, PATINDEX(@AcceptedCharcaters, @Temp), 1, '')

    RETURN @Temp
END
