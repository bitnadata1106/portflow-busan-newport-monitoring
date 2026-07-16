
-- Create a view to show the vessels that are expected to arrive within the next 2 hours
CREATE OR REPLACE VIEW dt4_project2_team3_databricks.gold.v_demo_arrival_within_2h AS
SELECT
  terminal_id,
  berth,
  vessel_name,
  eta,
  etd,
  total_workload
FROM dt4_project2_team3_databricks.gold.gold_today_terminal_schedule
WHERE eta >= current_timestamp()
  AND eta < current_timestamp() + INTERVAL 2 HOURS;



-- Create a view to show the vessels that are scheduled changes in the last 24 hours
CREATE OR REPLACE VIEW dt4_project2_team3_databricks.gold.v_demo_schedule_change_summary AS
SELECT 
  any_value(created_at) as created_at,
  change_detail,
  COUNT(*) AS change_count
FROM dt4_project2_team3_databricks.gold.gold_schedule_change_history
GROUP BY change_detail
ORDER BY created_at;



-- Create a view to show the count of vessels and their total workload at each terminal
CREATE OR REPLACE VIEW dt4_project2_team3_databricks.gold.v_demo_terminal_vessel_count AS
SELECT
  terminal_id,
  COUNT(*) AS vessel_count,
  SUM(total_workload) AS total_workload
FROM dt4_project2_team3_databricks.gold.gold_today_terminal_schedule
GROUP BY terminal_id;



-- Create a view to show the count of vessels, total workload, total discharge, and total loading at each terminal
CREATE OR REPLACE VIEW dt4_project2_team3_databricks.gold.v_demo_terminal_status AS
SELECT
  terminal_id,
  COUNT(*) AS vessel_count,
  SUM(total_workload) AS total_workload,
  SUM(discharge) AS total_discharge,
  SUM(loading) AS total_loading
FROM dt4_project2_team3_databricks.gold.gold_today_terminal_schedule
GROUP BY terminal_id;