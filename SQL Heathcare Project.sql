# Healthcare Data Analytics queries
create database healthcare_db;
use healthcare_db;

#01 Total Patients 
select count(distinct `Patient ID`) as Total_Patients
from patient;

#02 Total Doctors
select count(distinct `Doctor ID`) as Total_Doctors
from doctor;

#03 Total Revenue
SELECT 
    CONCAT(ROUND(SUM(`Treatment Cost`) / 100000, 2), ' L') 
    AS Total_Revenue
FROM treatment;

#04 Year wise Total Patients
SELECT YEAR(v.`Visit Date`) AS Year,
       COUNT(DISTINCT p.`Patient ID`) AS Total_Patients
FROM visit v
JOIN patient p
    ON v.`Patient ID` = p.`Patient ID`
GROUP BY YEAR(v.`Visit Date`)
ORDER BY Year;

#05 Top 5 Diagnosed condition 
select Diagnosis, count(distinct `Patient ID`) as Total_Cases
from visit
group by Diagnosis
order by Total_Cases desc
limit 5;

#06 Month-wise Follow up Patients
select monthname(`Visit Date`) as Month,
       concat(round(
         count(case when `Follow Up Required` = 'Yes' then 1 end)
         *100.0/ count(*),2 ), '%') as Follow_up_Rate
from visit
group by month(`Visit Date`), month
order by Month(`Visit Date`);

#07 Total Lab Tests Conducted by Month
SELECT
    monthname(`Test Date`) AS Month,
    COUNT(`Lab Result ID`) AS Total_Lab_Tests
FROM `lab test`
GROUP BY month(`Test Date`), month
ORDER BY month(`Test Date`);

#08 Above Average Treatment Cost
select `Treatment Type`, `Treatment Cost`
from treatment
where `Treatment Cost` > (select avg(`Treatment Cost`)
                          from treatment);

#09 Average Patients per Doctor
WITH Doctor_Patients AS (
    SELECT `Doctor ID`,
        COUNT(DISTINCT `Patient ID`) AS Total_Patients
    FROM visit
    GROUP BY `Doctor ID`)
SELECT ROUND(AVG(Total_Patients), 2) AS Avg_Patients_Per_Doctor
FROM Doctor_Patients;


#10 Doctor Performance Ranking
SELECT d.`Doctor ID`,
    COUNT(v.`Visit ID`) AS Total_Visits,
    RANK() OVER (
        ORDER BY COUNT(v.`Visit ID`) DESC) AS Doctor_Rank
FROM doctor d
LEFT JOIN visit v
    ON d.`Doctor ID` = v.`Doctor ID`
GROUP BY d.`Doctor ID`
ORDER BY Doctor_Rank;



