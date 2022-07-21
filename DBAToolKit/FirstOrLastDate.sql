/*
Title       : First day of current month.
Description :  in this we have taken out the difference between the months from 0 to current date and then 
              add the difference in 0 this will return the first day of current month.
*/
SELECT DATEADD(MM, DATEDIFF(MM,0,GETDATE()),0)

/*
Title       : Last day of current month.
Description : starting from innermost query(DATEDIFF(m,0,GETDATE())) will help you to take out the difference 
			  between the months from 0 to current date after that we will add a month to it which will make it 
			  next month after that we will subtract 1 sec from it and which will give us the last second of this 
			  month post that we will cast that into date, to get last day of this month.
*/


SELECT CAST(DATEADD(S,-1,DATEADD(MM, DATEDIFF(MM,0,GETDATE())+1,0)) AS DATE)

/*
Title       : First day of next month.
Description : in this we have taken out the difference between the months from 0 to current date and then add 1 to 
			  the difference and 0 this will return the first day of next month.
*/

SELECT DATEADD(MM, DATEDIFF(MM,0,GETDATE())+1,0); 

/*
Title       : Last day of next month.
Description : 

*/

SELECT CAST(DATEADD(S,-1,DATEADD(MM, DATEDIFF(MM,0,GETDATE())+2,0)) AS DATE)

/*
Title       : First day of previous month
Description : 

*/

SELECT DATEADD(MM, DATEDIFF(MM,0,GETDATE())-1,0)
/*
Title       : Last day of previous month:
Description : 

*/

SELECT CAST(DATEADD(S,-1,DATEADD(MM, DATEDIFF(MM,0,GETDATE()),0)) AS DATE)
/*
Title       : First day of current year:
Description : in this case we will extract the difference between the years and add

*/
 
SELECT DATEADD(YY, DATEDIFF(YY,0,GETDATE()),0);

/*
Title       : Last day of current year
Description : 

*/

SELECT CAST(DATEADD(S,-1,DATEADD(YY, DATEDIFF(YY,0,GETDATE()),0)) AS DATE);
