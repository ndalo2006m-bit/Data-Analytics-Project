----A1
create database SunVolt;
GO

----A2
create table customers (
customer_id int,
marital_status varchar(50),
gender varchar(50),
annual_income int,
household_dependents int,
education_level varchar(50),
occupation varchar(50),
homeowner_status int,
vehicles_owned int,
distance_band nvarchar(50),
region varchar(50),
age int,
purchased_solar_system bit,
purchase_flag bit,
age_group int,
income_band nvarchar(50)
);
go
select* from customers;

----A3
create table distance_bands (
distance_band nvarchar(50) primary key,
installer_distance_order int not null
);
insert into distance_bands values
('0-1 km', 1),
('1-2 km', 2),
('2-5 km', 3),
('5-10 km', 4),
('10+ km', 5);
go
SELECT*
FROM distance_bands
ORDER by installer_distance_order;

----A4   PROBLEM AREA
SELECT TOP (1026) [Customer_ID]
      ,[Marital_Status]
      ,[Gender]
      ,[Annual_Income]
      ,[Household_Dependents]
      ,[Education_Level]
      ,[Occupation]
      ,[Homeowner_Status]
      ,[Vehicles_Owned]
      ,[Distance_from_Nearest_Installer]
      ,[Region]
      ,[Age]
      ,[Purchased_Solar_System]
      ,[Purchase_Flag]
      ,[Age_Group]
      ,[Income_Band]
      ,[Installer_Distance_Order]
  FROM [SunVolt].[dbo].[SunVolt_Solar_Customer_Data]

  select count(*) as current_rows
  from SunVolt.dbo.customers;

  insert into SunVolt.dbo.customers
  (
    customer_id,
    marital_status,
    gender,
    annual_income,
    household_dependents,
    education_level,
    occupation,
    homeowner_status,
    vehicles_owned,
    distance_band,
    region,
    age,
    purchased_solar_system,
    purchase_flag,
    age_group,
    income_band
)
select
    Customer_ID,
    Marital_Status,
    Gender,
    try_convert(int,replace(Annual_Income, ' ', '')),
    Household_Dependents,
    Education_Level,
    Occupation,
    Homeowner_Status,
    Vehicles_Owned,
    Distance_from_Nearest_Installer,
    Region,
    Age,
    Purchased_Solar_System,
    Purchase_Flag,
    Age_Group,
    Income_Band
FROM SunVolt.dbo.SunVolt_Solar_Customer_Data;


select count(*) as row_count
from SunVolt.dbo.SunVolt_Solar_Customer_Data;

  

  ----A5
  --Delete removes all the selected rows from a table,
  --while Truncate deletes rows but will keep the table structure and Drop deletes everything, table, structure and data.

  ----B1
  select
       Customer_ID,
       Age,
       Annual_Income as Income
  from SunVolt_Solar_Customer_Data
  where Age >= 40 and Region = 'Europe';

  ----B2
  select distinct Occupation
  from SunVolt_Solar_Customer_Data
  order by Occupation ASC;

  ----B3  
  select 
        Customer_ID as customer_id,
        Annual_Income as annual_income
  from  SunVolt.dbo.SunVolt_Solar_Customer_Data
  where try_convert(int,replace(Annual_Income, ' ', '')) between 30000 and 70000
  order by try_convert(int,replace(Annual_Income, ' ','')) desc;

  ----B4
  select count(*) as Total_Rows,
         count(Distinct Customer_ID) as Unique_Customers
  from SunVolt_Solar_Customer_Data;

  ----B5
  select Customer_ID,
         Education_Level,
         Homeowner_Status
  from SunVolt_Solar_Customer_Data
  where Education_Level in ('Bachelors', 'Graduate Degree') and Homeowner_Status = 1;

  ----B6
  select Customer_ID,
         Occupation
  from SunVolt_Solar_Customer_Data
  where Occupation like 'Man%';

  ----B7
  select Customer_ID,
         Marital_Status,
         VehicleS_Owned,
         Household_Dependents
 from SunVolt_Solar_Customer_Data
 where Marital_status = 'Single' and (Vehicles_Owned >= 2 or Household_Dependents >= 3);

 ----C1
 select count(*) as customers,
        sum(case when Purchase_Flag = 1 then 1 else 0 end) as purchases,
        cast(
             sum(case when Purchase_Flag = 1 then 1 else 0 end) *100.0/ count(*) as decimal(5,2)
             ) as conversion_pct
from  SunVolt_Solar_Customer_Data;
            
----C2
select 
      Region,
      count(*) as customers,
      sum(case when Purchase_Flag = 1 then 1 else 0 end) as Purchases,
cast(
      sum(case when Purchase_Flag = 1 then 1 else 0 end) * 100.00 / count(*) as decimal(5,2)
) as conversion_pct
from SunVolt_Solar_Customer_Data
group by Region
order by conversion_pct DESC;

----C3
select
      Education_Level,
      count(*) as customers,
      round(avg(try_convert(float, replace(Annual_Income, ' ', ''))),0) as avg_income
from SunVolt_Solar_Customer_Data
group by Education_Level
having count(*) >= 100
order by avg_income desc;

----C4
select
      Age_Group,
      count(*) as customers,
      sum(case when Purchase_Flag = 1 then 1 else 0 end) as purchases
from SunVolt_Solar_Customer_Data
group by Age_Group
having sum(case when Purchase_Flag = 1 then 1 else 0 end) > 50
order by purchases desc;

----C5
select
      Gender,
      min(Age) as youngest,
      max(Age) as oldest,
      round(avg(try_convert(float,replace(annual_income, ' ', ''))),0) as avg_income
from SunVolt_Solar_Customer_Data
group by Gender;

----D1
select
      distance_bands.installer_distance_order,
      count(*) as customers,
      sum(case when SunVolt_Solar_Customer_Data.Purchase_Flag = 1 then 1 else 0 end) as purchases
from SunVolt.dbo.SunVolt_Solar_Customer_Data
inner join SunVolt.dbo.distance_bands 
on SunVolt_Solar_Customer_Data.Distance_from_Nearest_Installer = distance_bands.distance_band
group by distance_bands.installer_distance_order
order by distance_bands.installer_distance_order asc;

----D2
select 
     Customer_ID as customer_id,
     Annual_Income as annual_income
from SunVolt.dbo.SunVolt_Solar_Customer_Data
where try_convert(decimal(18,2), replace(Annual_Income, ' ',''))>
(
select avg(try_convert(decimal(18,2), replace(Annual_Income, ' ', '')))
from SunVolt.dbo.SunVolt_Solar_Customer_Data
);

select avg(try_convert(float,replace(Annual_Income, ' ', ''))) as average_income
from SunVolt.dbo.SunVolt_Solar_Customer_Data;

----D3
select
      Customer_ID as customer_id,
      Region as region,
      Purchase_Flag as purchase_flag
from SunVolt.dbo.SunVolt_Solar_Customer_Data
where Region in 
(

select Region
from SunVolt.dbo.SunVolt_Solar_Customer_Data
group by Region
having avg(cast(Purchase_Flag as float)) > 0.45
);

----D4
select
      distance_bands.distance_band,
      count(SunVolt_Solar_Customer_Data.Customer_ID) as customers
from SunVolt.dbo.distance_bands
left join SunVolt.dbo.SunVolt_Solar_Customer_Data
on distance_bands.distance_band = 
   SunVolt_Solar_Customer_Data.Distance_from_Nearest_Installer
group by 
        distance_bands.distance_band,
        distance_bands.installer_distance_order
order by distance_bands.installer_distance_order asc;

----E1
select
      case
          when Age < 40 then 'Under 40'
          when Age between 40 and 59 then '40-59'
          else '60+'
          end as age_segment,
    count(*) as customers,
    sum(case when Purchase_Flag = 1 then 1 else 0 end) as purchases,
    cast(
         sum(case when Purchase_Flag = 1 then 1 else 0 end) * 100.00 / count (*)
         as decimal(5,2)
) as conversion_pct
from SunVolt.dbo.SunVolt_Solar_Customer_Data
group by
        case 
             when Age < 40 then 'Under 40'
             when Age between 40 and 59 then '40-59'
             else '60+'
             end
order by age_segment asc;

----E2
select
      Customer_ID as customer_id,
      count(*) as copies
from SunVolt.dbo.SunVolt_Solar_Customer_Data
group by Customer_ID
having count(*) > 1
order by Customer_ID asc;

----E3
select
      count(*) as mismatches 
from SunVolt.dbo.SunVolt_Solar_Customer_Data
where Purchased_Solar_System <> Purchase_Flag;

----E4
select
      count(distinct Customer_ID) as unique_buyers
from SunVolt.dbo.SunVolt_Solar_Customer_Data
where Purchased_Solar_System = 1;



