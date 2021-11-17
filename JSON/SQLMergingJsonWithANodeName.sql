CREATE DATABASE SqlJsonMerging
GO

USE SqlJsonMerging
GO

CREATE TABLE JsonObjTable
(
	Id INT NOT NULL,
	ConfigKey VARCHAR(200) NOT NULL,
	ConfigValue NVARCHAR(MAX) NOT NULL
)
GO

INSERT INTO JsonObjTable(Id,ConfigKey,ConfigValue)
VALUES 
(1,'employee','{"name":"jhon","age":"23","salary":"5000"}'),
(1,'Dept','{"name": "Marketing", "code":"12", "manager":"sam"}'),
(1,'manager','{"managername":"abc", "dept":"AB"}')

GO

SELECT '{' + STRING_AGG(CONCAT('"', configkey, '":', configvalue), ',') + '}'
FROM
(
VALUES
(1, 'employee', '{"name":"jhon","age":"23","salary":"5000"}'),
(2, 'Dept', '{"name": "Marketing", "code":"12", "manager":"sam"}'),
(3, 'manager', '{"managername":"abc", "dept":"AB"}')

) AS tbl(id, configkey, configvalue)

WHERE configkey in ('employee', 'manager')
GO
