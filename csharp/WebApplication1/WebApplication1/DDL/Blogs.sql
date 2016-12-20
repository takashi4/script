CREATE TABLE [dbo].[Blogs] (
  [BlogId] INT IDENTITY (1, 1) NOT NULL,
  [Name]   NVARCHAR (200) NULL,
  [Url]    NVARCHAR (200) NULL,
  CONSTRAINT [PK_dbo.Blogs] PRIMARY KEY CLUSTERED ([BlogId] ASC)
);

