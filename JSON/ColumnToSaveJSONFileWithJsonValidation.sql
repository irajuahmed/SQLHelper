/****** Column to save file and constraint on that column for JSON data. filter on that JSON column with filter JSON data.******/

CREATE DATABASE [WorkingWithJSONFile]
GO

USE [WorkingWithJSONFile]
GO

/****** Object:  Table [dbo].[Families]    Script Date: 11/16/2021 11:38:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Families](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[doc] [nvarchar](max) NULL,
 CONSTRAINT [PK_JSON_ID] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Families]  WITH CHECK ADD  CONSTRAINT [Log record should be formatted as JSON] CHECK  ((isjson([doc])=(1)))
GO
ALTER TABLE [dbo].[Families] CHECK CONSTRAINT [Log record should be formatted as JSON]
GO

INSERT [dbo].[Families] ([doc]) VALUES ( N'{"name":"John","surname":"Doe","age":45,"skills":["SQL","C#","MVC"]}')
GO

SELECT * FROM Families
WHERE ISJSON(Doc) > 0 
GO

SELECT *
FROM Families
WHERE JSON_VALUE(Doc, '$.name')  like N'john'
GO

