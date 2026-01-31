-- EDA
select *
from jobs_clean2;

# Which jobs are the most demandaded
with others_cte as
(
select job_title, count(*)
from jobs_clean2
where job_title not like "Data Scientist" and
	job_title not like "Data engineer" and
    job_title not like "Senior Data scientist" and
    job_title not like "Data Analyst" and
    job_title not like "Computer scientist" and
    job_title not like "Senior Data Analyst" and
    job_title not like "Machine Learning Engineer"
group by job_title
order by count(*) desc # con esto lo que hago es sacar los trabajos más significativos, para agrupar el resto
)
select "Others Data jobs" as "Data jobs", count(job_title) as "Number of Offers"
from others_cte # con esto obtengo la cantidad de ofertas de otros trabajos no principales
union # finalmente, hago una union con los trabajos principales
select job_title "Data Jobs" , count(*)
from jobs_clean2
group by job_title
order by 2 desc
limit 8;
-- 

# Which jobs get major retribution, in average
with others_cte2 as
(
select job_title, avg(`min_salary(K)`) as min, avg(`max_salary(K)`) as max, count(*)
from jobs_clean2
where job_title not like "Data Scientist" and
	job_title not like "Data engineer" and
    job_title not like "Senior Data scientist" and
    job_title not like "Data Analyst" and
    job_title not like "Computer scientist" and
    job_title not like "Senior Data Analyst" and
    job_title not like "Machine Learning Engineer"
group by job_title
order by 2 desc # con esto lo que hago es sacar los trabajos más significativos, para agrupar el resto
)
select "Others Data jobs" as "Data jobs", avg(min) as "min anual salary", avg(max) as "max anual salary", count(*) as count
from others_cte2
union
select job_title, avg(`min_salary(K)`), avg(`max_salary(K)`), count(*)
from jobs_clean2
group by job_title
order by count desc
limit 8;

# Which job offered major retribution
select job_title, avg(`min_salary(K)`), avg(`max_salary(K)`)
from jobs_clean2
group by job_title
order by avg(`min_salary(K)`) desc;

# Which company offered major retribution
select company_name, avg(`min_salary(K)`) "min AVG salary", avg(`max_salary(K)`) as "max AVG salary", count(*) as offers
from jobs_clean2
group by company_name
having offers > 1
order by avg(`min_salary(K)`) desc;

# Which companies are the best to work in
select company_name, avg(rating), count(id_index) as offers
from jobs_clean2
group by company_name
having offers > 2
order by avg(rating) desc, offers desc;

# Which companies must improve their employee satisfaction
select company_name, avg(rating), count(id_index) as offers
from jobs_clean2
where rating is not null
group by company_name
order by avg(rating) asc, offers desc;

# Biggest companies offers more jobs than smallers?, 
select size, avg(`min_salary(K)`) as "min AVG salary", avg(`max_salary(K)`) as "max AVG salary", count(id_index) as offers
from jobs_clean2
where size != "Unknown"
group by size
order by offers desc;

# Which industry offers more jobs for the most demanded job (Data Scientist)?
select sector, job_title, count(id_index) offers
from jobs_clean2
where (sector != "-1") and (job_title like "%Scientist%")
group by sector, job_title
order by count(id_index) desc;

select *
from jobs_clean2