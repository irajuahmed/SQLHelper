DECLARE @Id          INT
DECLARE @firstName   VARCHAR(MAX)
DECLARE @middleName  VARCHAR(MAX)
DECLARE @lastName    VARCHAR(MAX)

-- 2 - Declare Cursor
DECLARE cursorName CURSOR FOR 
-- Populate the cursor with your logic

SELECT Id, FirstName, MiddleName, LastName FROM CustomerInformations

-- Open the Cursor
OPEN cursorName

-- 3 Fetch the next record from the cursor
FETCH NEXT FROM cursorName INTO @Id,@firstName,@middleName,@lastName

-- Set the status for the cursor
WHILE @@FETCH_STATUS = 0  
 
BEGIN  
	-- 4 - Begin the custom business logic

	 SELECT @firstName +' '+@middleName+' '+@lastName

	-- 5 - Fetch the next record from the cursor
 	FETCH NEXT FROM cursorName INTO @Id,@firstName,@middleName,@lastName
END 

-- 6 - Close the cursor
CLOSE cursorName  

-- 7 - Deallocate the cursor
DEALLOCATE cursorName 
