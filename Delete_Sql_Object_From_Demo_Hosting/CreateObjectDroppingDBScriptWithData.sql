/****** For More Details ******/
/****** https://github.com/irajuahmed/SQLDbObjectDroppingWithASchedular ******/
USE [master]
GO
/****** Object:  Database [ObjectDroppingTestDB]    Script Date: 2/24/2021 3:20:08 PM ******/
CREATE DATABASE [ObjectDroppingTestDB]
GO

USE [ObjectDroppingTestDB]
GO
/****** Object:  UserDefinedFunction [dbo].[fnCountDept]    Script Date: 2/24/2021 3:20:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnCountDept] 
(
	
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	
	RETURN (select COUNT(Id) from tblDepartment)

END
GO
/****** Object:  Table [dbo].[tblDepartment]    Script Date: 2/24/2021 3:20:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblDepartment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tblDepartment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tblEmployee]    Script Date: 2/24/2021 3:20:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblEmployee](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmpName] [varchar](50) NOT NULL,
	[DeptId] [int] NOT NULL,
 CONSTRAINT [PK_tblEmployee] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwGetEmpDetails]    Script Date: 2/24/2021 3:20:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwGetEmpDetails]
AS
SELECT E.Id,E.EmpName,E.DeptId,D.Name DeptName FROM tblEmployee E 
INNER JOIN tblDepartment D ON E.DeptId=D.Id
GO
/****** Object:  View [dbo].[vwGetDetpEmpCount]    Script Date: 2/24/2021 3:20:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwGetDetpEmpCount]
AS
SELECT d.Name DeptName, COUNT(e.Id)DeptEmpCount 
FROM tblEmployee E 
INNER JOIN tblDepartment D ON E.DeptId=D.Id
GROUP BY D.Name
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetAllEmpDept]    Script Date: 2/24/2021 3:20:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnGetAllEmpDept]
(	
@id int 
)
RETURNS TABLE 
AS
RETURN 
(
	
	SELECT a.DeptName,a.EmpName,COUNT(a.Id)NoDeptEmp  from vwGetEmpDetails a
	GROUP BY a.DeptName,a.EmpName
)
GO
/****** Object:  Table [dbo].[tblLogHistory]    Script Date: 2/24/2021 3:20:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblLogHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TableName] [varchar](500) NULL,
	[ActionType] [varchar](500) NULL,
	[ActionDate] [datetime] NULL,
 CONSTRAINT [PK_tblLogHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[tblDepartment] ON 

INSERT [dbo].[tblDepartment] ([Id], [Name]) VALUES (1, N'HR')
INSERT [dbo].[tblDepartment] ([Id], [Name]) VALUES (2, N'IT')
INSERT [dbo].[tblDepartment] ([Id], [Name]) VALUES (3, N'ADMIN')
INSERT [dbo].[tblDepartment] ([Id], [Name]) VALUES (5, N'SUPPLY CHAIN')
INSERT [dbo].[tblDepartment] ([Id], [Name]) VALUES (6, N'MARKETING')
SET IDENTITY_INSERT [dbo].[tblDepartment] OFF
SET IDENTITY_INSERT [dbo].[tblEmployee] ON 

INSERT [dbo].[tblEmployee] ([Id], [EmpName], [DeptId]) VALUES (1, N'Raju Ahmed', 1)
INSERT [dbo].[tblEmployee] ([Id], [EmpName], [DeptId]) VALUES (2, N'Saiful Islam', 2)
INSERT [dbo].[tblEmployee] ([Id], [EmpName], [DeptId]) VALUES (3, N'Abu Sayed', 3)
INSERT [dbo].[tblEmployee] ([Id], [EmpName], [DeptId]) VALUES (4, N'Md. Shohag', 1)
SET IDENTITY_INSERT [dbo].[tblEmployee] OFF
SET IDENTITY_INSERT [dbo].[tblLogHistory] ON 

INSERT [dbo].[tblLogHistory] ([Id], [TableName], [ActionType], [ActionDate]) VALUES (1, N'tblDepartment', N'Insert', CAST(N'2021-02-23T12:23:33.183' AS DateTime))
INSERT [dbo].[tblLogHistory] ([Id], [TableName], [ActionType], [ActionDate]) VALUES (2, N'tblDepartment', N'Update', CAST(N'2021-02-23T12:23:45.670' AS DateTime))
INSERT [dbo].[tblLogHistory] ([Id], [TableName], [ActionType], [ActionDate]) VALUES (3, N'tblDepartment', N'Insert', CAST(N'2021-02-23T12:24:01.420' AS DateTime))
INSERT [dbo].[tblLogHistory] ([Id], [TableName], [ActionType], [ActionDate]) VALUES (4, N'tblDepartment', N'Insert', CAST(N'2021-02-23T12:24:14.013' AS DateTime))
INSERT [dbo].[tblLogHistory] ([Id], [TableName], [ActionType], [ActionDate]) VALUES (5, N'tblDepartment', N'Delete', CAST(N'2021-02-23T12:24:27.717' AS DateTime))
INSERT [dbo].[tblLogHistory] ([Id], [TableName], [ActionType], [ActionDate]) VALUES (6, N'tblEmployee', N'Update', CAST(N'2021-02-23T12:24:43.180' AS DateTime))
INSERT [dbo].[tblLogHistory] ([Id], [TableName], [ActionType], [ActionDate]) VALUES (7, N'tblEmployee', N'Update', CAST(N'2021-02-23T12:24:51.203' AS DateTime))
SET IDENTITY_INSERT [dbo].[tblLogHistory] OFF
ALTER TABLE [dbo].[tblEmployee]  WITH CHECK ADD  CONSTRAINT [FK_tblEmployee_tblDepartment] FOREIGN KEY([DeptId])
REFERENCES [dbo].[tblDepartment] ([Id])
GO
ALTER TABLE [dbo].[tblEmployee] CHECK CONSTRAINT [FK_tblEmployee_tblDepartment]
GO
/****** Object:  StoredProcedure [dbo].[uspGetAllDeptEmpByDeptId]    Script Date: 2/24/2021 3:20:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC	[dbo].[uspGetAllDeptEmpByDeptId]
(
@DeptName varchar(50)
)
AS
SELECT * FROM vwGetEmpDetails WHERE DeptName=@DeptName
GO
/****** Object:  StoredProcedure [dbo].[uspInsertDept]    Script Date: 2/24/2021 3:20:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC	[dbo].[uspInsertDept]
(
@DeptName varchar(50)
)
AS
INSERT INTO tblDepartment (Name) VALUES(@DeptName)
GO
/****** Object:  Trigger [dbo].[tgrTblDepartmentLogHistory]    Script Date: 2/24/2021 3:20:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- Install the trigger to capture updates
create TRIGGER [dbo].[tgrTblDepartmentLogHistory]
ON [dbo].[tblDepartment]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
 
    WITH cte1 AS(
                SELECT 
                    d.Id AS DeletedID
                    ,i.Id AS InsertedID
                FROM Deleted d
                FULL OUTER HASH JOIN Inserted i ON i.Id = d.Id
            ),
 
            cte2 AS(
                SELECT
                    COALESCE(InsertedID,DeletedID) AS UserID
                    ,CASE
                        WHEN InsertedID IS NOT NULL AND DeletedID IS NOT NULL THEN 'Update'
                        WHEN InsertedID IS NOT NULL AND DeletedID IS NULL THEN 'Insert'
                        WHEN InsertedID IS NULL AND DeletedID IS NOT NULL THEN 'Delete'
                        ELSE ''
                    END AS Operation
                FROM cte1
            )
 
    INSERT INTO tblLogHistory(TableName,ActionType,ActionDate)
    SELECT 'tblDepartment',Operation,GETDATE() FROM cte2;
END
GO
ALTER TABLE [dbo].[tblDepartment] ENABLE TRIGGER [tgrTblDepartmentLogHistory]
GO
/****** Object:  Trigger [dbo].[tgrTblEmployeeLogHistory]    Script Date: 2/24/2021 3:20:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- Install the trigger to capture updates
create TRIGGER [dbo].[tgrTblEmployeeLogHistory]
ON [dbo].[tblEmployee]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
 
    WITH cte1 AS(
                SELECT 
                    d.Id AS DeletedID
                    ,i.Id AS InsertedID
                FROM Deleted d
                FULL OUTER HASH JOIN Inserted i ON i.Id = d.Id
            ),
 
            cte2 AS(
                SELECT
                    COALESCE(InsertedID,DeletedID) AS UserID
                    ,CASE
                        WHEN InsertedID IS NOT NULL AND DeletedID IS NOT NULL THEN 'Update'
                        WHEN InsertedID IS NOT NULL AND DeletedID IS NULL THEN 'Insert'
                        WHEN InsertedID IS NULL AND DeletedID IS NOT NULL THEN 'Delete'
                        ELSE ''
                    END AS Operation
                FROM cte1
            )
 
    INSERT INTO tblLogHistory(TableName,ActionType,ActionDate)
    SELECT 'tblEmployee',Operation,GETDATE() FROM cte2;
END
GO
ALTER TABLE [dbo].[tblEmployee] ENABLE TRIGGER [tgrTblEmployeeLogHistory]
GO
USE [master]
GO
ALTER DATABASE [ObjectDroppingTestDB] SET  READ_WRITE 
GO
