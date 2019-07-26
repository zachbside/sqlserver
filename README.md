# sqlserver metric reporting
1. Create the table by running the CreateTable.sql file on the SQL Server instnace you want to monitor
2. Create the stored procedure by running the GatherMetricsProc.sql file on the same database that you created the table on
3. Create the user who will run the command using SQL auth by running CreateUser.sql
  -you will need to specify what database you are connecting to in this file
4. Verify that the sqlps module is installed on PowerShell
5. Run the DataDashboards.ps1 file using PowerShell and follow the prompts
