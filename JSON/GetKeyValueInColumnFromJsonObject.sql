DECLARE @JsonData VARCHAR(500)
SET @JsonData = '{"name":"Raju Ahmed","surname":"Mr.","age":31,"skills":"MVC,SQL,JQUERY"}';
SELECT [key],[value] FROM OPENJSON(@JsonData)
