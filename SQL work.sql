#importing data fifle from csv and creating database
create database international_debt_datadebt_record;
use debt_record;
CREATE TABLE IDS_ALLCountries_Data (
    Country_Name VARCHAR(50),
    Country_Code VARCHAR(3),
    Counterpart_Area_Name VARCHAR(5),
    Counterpart_Area_Code VARCHAR(3),
    Series_Name VARCHAR(99),
    Series_Code VARCHAR(19),
    `1970` DECIMAL(38 , 9 ),
    `1971` DECIMAL(38 , 9 ),
    `1972` DECIMAL(38 , 9 ),
    `1973` DECIMAL(38 , 9 ),
    `1974` DECIMAL(38 , 9 ),
    `1975` DECIMAL(38 , 9 ),
    `1976` DECIMAL(38 , 9 ),
    `1977` DECIMAL(38 , 9 ),
    `1978` DECIMAL(38 , 9 ),
    `1979` DECIMAL(38 , 13 ),
    `1980` DECIMAL(38 , 9 ),
    `1981` DECIMAL(38 , 9 ),
    `1982` DECIMAL(38 , 9 ),
    `1983` DECIMAL(38 , 9 ),
    `1984` DECIMAL(38 , 9 ),
    `1985` DECIMAL(38 , 9 ),
    `1986` DECIMAL(38 , 9 ),
    `1987` DECIMAL(38 , 9 ),
    `1988` DECIMAL(38 , 14 ),
    `1989` DECIMAL(38 , 9 ),
    `1990` DECIMAL(38 , 9 ),
    `1991` DECIMAL(38 , 9 ),
    `1992` DECIMAL(38 , 9 ),
    `1993` DECIMAL(38 , 9 ),
    `1994` DECIMAL(38 , 9 ),
    `1995` DECIMAL(38 , 9 ),
    `1996` DECIMAL(38 , 9 ),
    `1997` DECIMAL(38 , 9 ),
    `1998` DECIMAL(38 , 9 ),
    `1999` DECIMAL(38 , 9 ),
    `2000` DECIMAL(38 , 9 ),
    `2001` DECIMAL(38 , 9 ),
    `2002` DECIMAL(38 , 9 ),
    `2003` DECIMAL(38 , 9 ),
    `2004` DECIMAL(38 , 9 ),
    `2005` DECIMAL(38 , 9 ),
    `2006` DECIMAL(38 , 9 ),
    `2007` DECIMAL(38 , 9 ),
    `2008` DECIMAL(38 , 9 ),
    `2009` DECIMAL(38 , 9 ),
    `2010` DECIMAL(38 , 9 ),
    `2011` DECIMAL(38 , 9 ),
    `2012` DECIMAL(38 , 9 ),
    `2013` DECIMAL(38 , 9 ),
    `2014` DECIMAL(38 , 9 ),
    `2015` DECIMAL(38 , 9 ),
    `2016` DECIMAL(38 , 9 ),
    `2017` DECIMAL(38 , 9 ),
    `2018` DECIMAL(38 , 9 ),
    `2019` DECIMAL(38 , 14 ),
    `2020` DECIMAL(38 , 9 ),
    `2021` DECIMAL(38 , 9 ),
    `2022` DECIMAL(38 , 1 ),
    `2023` DECIMAL(38 , 1 ),
    `2024` DECIMAL(38 , 1 ),
    `2025` DECIMAL(38 , 1 ),
    `2026` DECIMAL(38 , 1 ),
    `2027` DECIMAL(38 , 1 ),
    `2028` DECIMAL(38 , 1 ),
    `2029` DECIMAL(38 , 1 )
);

load data local infile "C:\\Users\\prath\\Downloads\\Compressed\\IDS_CSV\\IDS_ALLCountries_Data.csv"
into table IDS_ALLCountries_Data
fields terminated by ','
enclosed by '"'
lines terminated by '\n' ignore 1 rows;

select * from IDS_ALLCountries_Data;
----------------------------------------------------------------------------------------------------------------

CREATE TABLE IDS_SeriesMetaData (
	`Code` VARCHAR(19) NOT NULL, 
	License_Type VARCHAR(9), 
	Indicator_Name VARCHAR(99) NOT NULL, 
	Short_definition VARCHAR(1285), 
	Long_definition VARCHAR(1285) NOT NULL, 
	`Source` VARCHAR(257) NOT NULL, 
	Topic VARCHAR(86) NOT NULL, 
	Dataset VARCHAR(29) NOT NULL, 
	Periodicity VARCHAR(6) NOT NULL, 
	Aggregation_method VARCHAR(16) NOT NULL, 
	General_comments VARCHAR(161)
);

LOAD DATA LOCAL INFILE 'C:\\Users\\prath\\Downloads\\Compressed\\IDS_CSV\\IDS_SeriesMetaData.csv'
INTO TABLE IDS_SeriesMetaData
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from IDS_SeriesMetaData;


------------------------------------------------------------------------------------------------------------------
# 1. The World Bank's international debt data
-------------------------------------------------------------------------------------------------------------------
use debt_record;
select * from IDS_SeriesMetaData;
select * from IDS_ALLCountries_Data;

create table International_Debt_Data as
select Country_Name,Country_Code,Series_Code as Indicator_Code,Indicator_Name,
(`1970` + `1971` + `1972` + `1973` + `1974` + `1975` + `1976` + `1977` + `1978` + `1979`+ `1980` + `1981` + 
	`1982` + `1983` + `1984` + `1985` +`1986` + `1987` + `1988` + `1989` + `1990` + `1991` + `1992` + `1993` + 
    `1994` +`1995` + `1996` + `1997` + `1998` + `1999` + `2000` + `2001` + `2002` + `2003` + `2004` + `2005` + 
    `2006` + `2007` + `2008` + `2009` + `2010` + `2011` + `2012` + `2013` + `2014` + `2015`)as Debt
from IDS_ALLCountries_Data ACD
inner join IDS_SeriesMetaData SMD 
on ACD.Series_Code = SMD.Code
where country_name not like '%income%' 
and lower(country_name) not like '%ida%' ;

select * from International_Debt_Data;

--------------------------------------------------------------------------------------------------------------------
# 2. Finding the number of distinct countries
--------------------------------------------------------------------------------------------------------------------

select count(distinct Country_Name) as total_number_of_distinct_countries
from International_Debt_Data; -- 123

--------------------------------------------------------------------------------------------------------------------
# 3. Finding out the distinct debt indicators
--------------------------------------------------------------------------------------------------------------------

select distinct Indicator_Code as Distinct_Debt_Indicators
from International_Debt_Data
order by 1;

---------------------------------------------------------------------------------------------------------------------
# 4. Totaling the amount of debt owed by the countries
---------------------------------------------------------------------------------------------------------------------

select sum(debt) as Total_amount_of_debt
from international_debt_data;

--------------------------------------------------------------------------------------------------------------------
# 5. Country with the highest debt
--------------------------------------------------------------------------------------------------------------------

select Country_Name, sum(debt) as Total_amount_of_debt
from international_debt_data
group by 1 
order by 2 desc 
limit 1;

---------------------------------------------------------------------------------------------------------------
# 6. Average amount of debt across indicators
---------------------------------------------------------------------------------------------------------------

select indicator_code as debt_indicator, indicator_name, avg(debt) as average_debt
from international_debt_data
group by 1, 2
ORDER BY 3 DESC;

----------------------------------------------------------------------------------------------------------------
# 7. The highest amount of principal repayments
-----------------------------------------------------------------------------------------------------------------

select country_name, indicator_name,debt as repayment_amount 
from international_debt_data
where indicator_code='DT.AMT.DLXF.CD' 
order by debt desc limit 1;

----------------------------------------------------------------------------------------------------------------
# 8. The most common debt indicator
-----------------------------------------------------------------------------------------------------------------

select Indicator_Code , count(Indicator_Code) as indicator_count
from international_debt_data 
group by Indicator_code order by 2 desc;

------------------------------------------------------------------------------------------------------------------
# 9. Other viable debt issues and conclusion
------------------------------------------------------------------------------------------------------------------

select country_name, round((debt),0) as maximum_debt
from international_debt_data
group by 1
ORDER BY 2 DESC;

------------------------------------------###-----------------------------------------------------------------------