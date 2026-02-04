# Import data
CREATE TABLE ds_jobs (
    id_index INT,
    job_title TEXT,
    salary_estimate VARCHAR(100),
    job_description LONGTEXT,
    rating FLOAT,
    company_name VARCHAR(255),
    location VARCHAR(255),
    headquarters VARCHAR(255),
    size VARCHAR(100),
    founded INT,
    type_of_ownership VARCHAR(255),
    industry VARCHAR(255),
    sector VARCHAR(255),
    revenue VARCHAR(100),
    competitors TEXT
);

LOAD DATA LOCAL INFILE 'C:/Users/Gluden/Downloads/Uncleaned_DS_jobs.csv/Uncleaned_DS_jobs.csv' 
INTO TABLE ds_jobs 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n' -- '\n' (Mac/Linux)
IGNORE 1 ROWS;

# --------------------------------------------------------------------------------
# backup the table
create table jobs_clean
like ds_jobs;

insert jobs_clean
select *
from ds_jobs;

# preview
select *
from jobs_clean;

-- Data cleaning:
-- 1. Remove Duplicates
# find duplicates
select *,
row_number() OVER(
  partition by job_title, salary_estimate, job_description, rating, company_name, location, headquarters, size, founded, type_of_ownership, industry, sector, revenue) as row_num
from jobs_clean;

with duplicates as
(select *,
row_number() OVER(
  partition by job_title, salary_estimate, job_description, rating, company_name, location, headquarters, size, founded, type_of_ownership, industry, sector, revenue) as row_num
from jobs_clean
)
select *
from duplicates
where row_num > 1;

delete duplicates:
delete
from jobs_clean
where id_index =(
with duplicates as
(select *,
row_number() OVER(
  partition by job_title, salary_estimate, job_description, rating, company_name, location, headquarters, size, founded, type_of_ownership, industry, sector, revenue) as row_num
from jobs_clean
)
select id_index
from duplicates
where row_num > 1
limit 1
);

-- 2. Standarize the Data
select distinct job_title
from jobs_clean
where job_title LIke "%Data analyst%" AND (job_title LIKE "%Sr%" OR job_title like "%senior%" OR job_title like "%Senior%")
order by 1;
# most of the job offers in this dataset lack of seniority. Therefore, it won't be regarded.
Update jobs_clean
Set job_title = "Data Analyst"
where job_title LIke "%Data analyst%" AND (job_title LIKE "%Sr%" OR job_title like "%senior%" OR job_title like "%Senior%");

select distinct job_title
from jobs_clean
where job_title LIke "%Data analyst%" AND job_title not like "Senior Data Analyst"
order by 1;
update jobs_clean
set job_title = "Data Analyst"
where job_title LIke "%Data analyst%" AND job_title not like "Senior Data Analyst";

select distinct job_title
from jobs_clean
where (job_title LIke "%Data scientist%" or job_title LIke "%Data science%") and (job_title LIKE "%Sr%" OR job_title like "%senior%" OR job_title like "%Senior%")
order by 1;
# most of the job offers in this dataset lack of seniority. Therefore, it won't be regarded.
Update jobs_clean
set job_title = "Data scientist"
where (job_title LIke "%Data scientist%" or job_title LIke "%Data science%") and (job_title LIKE "%Sr%" OR job_title like "%senior%" OR job_title like "%Senior%");

select distinct job_title
from jobs_clean
where job_title LIke "%Data scientist%" and job_title not like "Senior Data scientist"
order by 1;
update jobs_clean
set job_title ="Data Scientist"
where job_title LIke "%Data scientist%" and job_title not like "Senior Data scientist";

select distinct job_title
from jobs_clean
where job_title LIke "%Data engineer%"
order by 1;
update jobs_clean
set job_title = "Data engineer"
where job_title LIke "%Data engineer%";

select distinct job_title
from jobs_clean
where job_title LIke "%comp%scien%"
order by 1;
update jobs_clean
set job_title = "Computer scientist"
where job_title LIke "%comp%scien%";

select distinct job_title, count(*)
from jobs_clean
group by job_title
order by 2 desc;

select distinct rating
from jobs_clean
order by 1;
update jobs_clean
set rating = null
where rating = "-1";

select distinct headquarters
from jobs_clean
order by 1;

update jobs_clean
set headquarters = "McLean, VA"
where headquarters like "%mc%lean%";
update jobs_clean
set headquarters = "New York, NY"
where headquarters like "%new%york%";
update jobs_clean
set headquarters = "Philadelphia, PA"
where headquarters like "%phila%";

select distinct size
from jobs_clean
order by 1;
update jobs_clean
set size = "Unknown"
where size = "-1";

# cleaned data preview
select distinct *
from jobs_clean
order by 1;

-- 3. Null values or blank values
delete
FROM jobs_clean
WHERE (headquarters = '-1' OR (headquarters IS NULL) OR headquarters = '')
and rating is null;

update jobs_clean
set headquarters = "Unknown"
WHERE (headquarters = '-1' OR (headquarters IS NULL) OR headquarters = '');

select *
from jobs_clean
WHERE (industry = '-1' OR (industry IS NULL) OR industry = '');

delete
from jobs_clean
where (rating ="-1" OR (rating is null) or rating = "")
and (industry ="-1")
and (revenue ="Unknown / Non-Applicable")
and (founded ="-1")
and size = "Unknown";

delete
from jobs_clean
where (rating ="-1" OR (rating is null) or rating = "")
and (industry ="-1")
and (type_of_ownership ="-1")
and (founded ="-1");

select salary_estimate
from jobs_clean
where salary_estimate not like "%glassdoor%";
update jobs_clean
set salary_estimate = "$145K-$225K (Glassdoor est.)"
where salary_estimate not like "%glassdoor%";

-- 4. Remove any columns
select competitors, count(*)
from jobs_clean
group by competitors
order by count(*) desc;

alter table jobs_clean
drop column competitors;

select *, case
when length(salary_estimate) = 28 then substring(salary_estimate, 2, 3)# as `minimum(k)`, substring(salary_estimate, 8, 3) as `maximum(k)`
when length(salary_estimate) = 27 then substring(salary_estimate, 2, 2)# as `minimum(k)`, substring(salary_estimate, 8, 3) as `maximum(k)`
when length(salary_estimate) = 26 then substring(salary_estimate, 2, 2)# as `minimum(k)`, substring(salary_estimate, 7, 3) as `maximum(k`
end as minimum,
case
when length(salary_estimate) = 28 then substring(salary_estimate, 8, 3)
when length(salary_estimate) = 27 then substring(salary_estimate, 7, 3)
when length(salary_estimate) = 26 then substring(salary_estimate, 7, 2)
end as maximum
from jobs_clean;

CREATE TABLE `jobs_clean2` (
  `id_index` int DEFAULT NULL,
  `job_title` text,
  `salary_estimate` varchar(100) DEFAULT NULL,
  `job_description` longtext,
  `rating` float DEFAULT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `headquarters` varchar(255) DEFAULT NULL,
  `size` varchar(100) DEFAULT NULL,
  `founded` int DEFAULT NULL,
  `type_of_ownership` varchar(255) DEFAULT NULL,
  `industry` varchar(255) DEFAULT NULL,
  `sector` varchar(255) DEFAULT NULL,
  `revenue` varchar(100) DEFAULT NULL,
   `min_salary` int DEFAULT NULL,
   `max_salary` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into jobs_clean2
select *, case
when length(salary_estimate) = 28 then substring(salary_estimate, 2, 3)# as `minimum(k)`, substring(salary_estimate, 8, 3) as `maximum(k)`
when length(salary_estimate) = 27 then substring(salary_estimate, 2, 2)# as `minimum(k)`, substring(salary_estimate, 8, 3) as `maximum(k)`
when length(salary_estimate) = 26 then substring(salary_estimate, 2, 2)# as `minimum(k)`, substring(salary_estimate, 7, 3) as `maximum(k`
end as minimum,
case
when length(salary_estimate) = 28 then substring(salary_estimate, 8, 3)
when length(salary_estimate) = 27 then substring(salary_estimate, 7, 3)
when length(salary_estimate) = 26 then substring(salary_estimate, 7, 2)
end as maximum
from jobs_clean;

alter table jobs_clean2
rename column `min_salary` to `min_salary(K)`;
alter table jobs_clean2
rename column `max_salary` to `max_salary(K)`;

select *
from jobs_clean2;

-- Clean database [OK]
