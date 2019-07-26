CREATE TABLE [dbo].[Metrics_Repo](
	[Date] [datetime] NOT NULL,
	[Metric] [varchar](50) NOT NULL,
	[Value] [int] NOT NULL,
	[Violation] [bit] NOT NULL 
) ON [PRIMARY]
GO