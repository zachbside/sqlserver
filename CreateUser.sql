USE [master]
GO

CREATE LOGIN [tester] WITH PASSWORD=N'test', DEFAULT_DATABASE=[test], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

GRANT VIEW SERVER STATE TO tester
GO

USE --enter database name here
GO
CREATE USER [tester] FOR LOGIN [tester] WITH DEFAULT_SCHEMA=[tester]
GRANT EXECUTE ON [dbo].[Gathermetrics] TO [tester]
GRANT SELECT ON [dbo].[Metrics_Repo] TO [tester]
GO
