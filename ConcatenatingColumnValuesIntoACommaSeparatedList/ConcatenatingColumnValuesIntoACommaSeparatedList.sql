/*==================================== Solution 1 ====================================*/

DECLARE @MediaCodes VARCHAR(200)
SET @MediaCodes= ''

SELECT  @MediaCodes = 
    CASE 
	    WHEN @MediaCodes = '' THEN  Code
		ELSE @MediaCodes + COALESCE(',' + Code, '')
    END
FROM TransactionMedia
WHERE TransactionMediaType='WC'
