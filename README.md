# sqlserver metric reporting
1. Create the table by running the CreateTable.sql file on the SQL Server instnace you want to monitor
2. Create the stored procedure by running the GatherMetricsProc.sql file on the same database that you created the table on
3. Verify that the sqlps module is installed on PowerShell
4. Verify that the SQL auth user you are going to run the command as has sufficient permissions to read DMVs
5. Run the DataDashboards.PS1 file using PowerShell and follow the prompts
