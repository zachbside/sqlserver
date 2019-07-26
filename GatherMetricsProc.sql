SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

-- ============================================= 
-- Author:    Zach Burnside 
-- Create date: 7/25/2019 
-- Description:  Stored procedure used to gather metrics on the local SQL server 
-- ============================================= 
CREATE PROCEDURE Gathermetrics 
AS 
  BEGIN 
      SET nocount ON; 

      DECLARE @CurrentMemory INT 
      DECLARE @NumOfLocks INT 
      DECLARE @BatchesPerSec INT 
      DECLARE @AVG INT 
      DECLARE @ViolationBit BIT = 0 

      --Get the current memory  
      SET @CurrentMemory=(SELECT ( physical_memory_in_use_kb / 1024 ) AS 
                                 Memory_GB 
                          FROM   sys.dm_os_process_memory) 
	  --Get the average of the memory usage from the table
      SET @AVG = (SELECT Avg(value) 
                  FROM   #DatabaseName.dbo.metrics_repo 
                  WHERE  metric = 'Memory') 

      --if memory used is 10% higher than average, set violation bit 
      IF @CurrentMemory > @AVG + ( @AVG * 0.1 ) 
        SET @ViolationBit=1 

      --insert the date, metric name(Memory), metric value(Memory in MB), and the violation bit 
      INSERT INTO #DatabaseName.dbo.metrics_repo 
      VALUES      ( Getdate(), 
                    'Memory', 
                    @CurrentMemory, 
                    @ViolationBit ) 

      --check the number of locks being held 
      SET @NumOfLocks = (SELECT Count(*) 
                         FROM   sys.dm_tran_locks) 
      SET @AVG = (SELECT Avg(value) 
                  FROM   #DatabaseName.dbo.metrics_repo 
                  WHERE  metric = 'Locks') 
      --reset violation bit 
      SET @ViolationBit = 0 

      --check if the number of locks held is higher than average 
      IF @NumOfLocks > @AVG + ( @AVG * 0.1 ) 
        SET @ViolationBit=1 

      --insert the date, metric name(Locks), metric value(Number of Locks), and the violation bit 
      INSERT INTO #DatabaseName.dbo.metrics_repo 
      VALUES      ( Getdate(), 
                    'Locks', 
                    @NumOfLocks, 
                    @ViolationBit ) 

      --check the number of batches per second 
      SET @BatchesPerSec = (SELECT cntr_value 
                            FROM   sys.dm_os_performance_counters 
                            WHERE  counter_name LIKE 'Batch Requests/sec%') 
      SET @AVG = (SELECT Avg(value) 
                  FROM   #DatabaseName.dbo.metrics_repo 
                  WHERE  metric = 'BatchesPerSec') 
      --reset violation bit 
      SET @ViolationBit = 0 

      --check if the number of batches per second is higher than average 
      IF @BatchesPerSec > @AVG + ( @AVG * 0.1 ) 
        SET @ViolationBit=1 

      --insert the date, metric name(batches per second), metric value(batches per second), and the violation bit
      INSERT INTO #DatabaseName.dbo.metrics_repo 
      VALUES      ( Getdate(), 
                    'BatchesPerSec', 
                    @BatchesPerSec, 
                    @ViolationBit ) 
  END 

go 
