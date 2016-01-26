--
-- archivelog_histogram.sql
-- by Brian Peasland
-- 15 February 2001
-- 
-- This script shows a histogram of archivelog
-- activity. Use this script to spot the hour(s)
-- with the most archive activity. Meaning the
-- busiest hours of overall activity in your
-- system.

PROMPT 
PROMPT Archivelog Histogram
PROMPT 

set linesize 120

PROMPT Archive Log Dates in the system

SELECT MIN(completion_time) AS min_date,
       MAX(completion_time) AS max_date 
FROM v$archived_log;

PROMPT
PROMPT Which date in the above range do
PROMPT you want to create the histogram for?
PROMPT

ACCEPT log_date PROMPT 'Enter Date (DD-MON-YY): '

COLUMN hour FORMAT a4
COLUMN num_logs FORMAT 9,999
COLUMN graph FORMAT a100
SET FEEDBACK OFF
SET VERIFY OFF
SET ECHO OFF

SELECT TO_CHAR(completion_time,'HH24') AS hour,
       COUNT(*) AS num_logs,
       RPAD(' ',COUNT(*)+1,'*') AS graph
FROM v$archived_log
WHERE TO_CHAR(completion_time,'DD-MON-YY') = UPPER('&log_date')
GROUP BY TO_CHAR(completion_time,'HH24')
ORDER BY TO_CHAR(completion_time,'HH24');

PROMPT 
PROMPT Summary
PROMPT

SET HEADSEP !
COLUMN slowest_hourly_count HEADING Slowest!Hourly!Count FORMAT 9,999
COLUMN average_hourly_count HEADING Average!Hourly!Count FORMAT 9,999
COLUMN busiest_hourly_count HEADING Busiest!Hourly!Count FORMAT 9,999

SELECT MIN(num_logs) AS slowest_hourly_count,
       AVG(num_logs) AS average_hourly_count,
       MAX(num_logs) AS busiest_hourly_count
FROM (
   SELECT TO_CHAR(completion_time,'HH24') AS hour,
          COUNT(*) AS num_logs
   FROM  v$archived_log
   WHERE TO_CHAR(completion_time,'DD-MON-YY') = UPPER('&log_date')
   GROUP BY TO_CHAR(completion_time,'HH24'));