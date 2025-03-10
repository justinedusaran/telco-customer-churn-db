select *
from customer_churn_data;

-- data cleaning
select count(*) as null_count
from customer_churn_data
where `Churn Value` is null;

select CustomerID, count(*)
from customer_churn_data
group by CustomerID
having count(*) > 1;

select `Churn Reason`, count(*)
from customer_churn_data
group by `Churn Reason`
having count(*) > 1;

-- churn rate
select 
	count(*) as total_customers,
	sum(case when `Churn Value` = 1 then 1 else 0 end) as churned_customers,
	(sum(case when `Churn Value` = 1 then 1 else 0 end) / count(*)) * 100 as churn_rate
from customer_churn_data;

-- churn by contract type - Month-to-month has the highest churn rate.
select Contract,
	count(*) as total_customers,
	sum(case when `Churn Value` = 1 then 1 else 0 end) as churned_customers,
	(sum(case when `Churn Value` = 1 then 1 else 0 end) / count(*)) * 100 as churn_rate
from customer_churn_data
group by Contract;

-- churn by tenure -- 0-12 months has the highest churn rate.
select 
	case
		when `Tenure Months` <= 12 then '0-12 months'
		when `Tenure Months` between 13 and 24 then '13-24 months'
		when `Tenure Months` between 25 and 60 then '25-60 months'
        else '60+ months'
	end as tenure_group,
    count(*) as total_customers,
    sum(case when `Churn Value` = 1 then 1 else 0 end) as churned_customers,
	(sum(case when `Churn Value` = 1 then 1 else 0 end) / count(*)) * 100 as churn_rate
from customer_churn_data
group by tenure_group
order by churn_rate desc;

-- churn by monthly charges -- High monthly charges has highest churn rate.
select 
	case 
		when `Monthly Charges` < 30 then 'Low (<$30)'
		when `Monthly Charges` between 30 and 70 then 'Medium ($30-$70)'
        else 'High (>$70)'
	end as charge_category,
    count(*) as total_customers,
    sum(case when `Churn Value` = 1 then 1 else 0 end) as churned_customers,
	(sum(case when `Churn Value` = 1 then 1 else 0 end) / count(*)) * 100 as churn_rate
from customer_churn_data
group by charge_category
order by churn_rate desc;

-- churn by payment - Electronic check has highest churn rate.
select 
	`Payment Method`,
	count(*) as total_customers,
    sum(case when `Churn Value` = 1 then 1 else 0 end) as churned_customers,
	(sum(case when `Churn Value` = 1 then 1 else 0 end) / count(*)) * 100 as churn_rate
from customer_churn_data
group by `Payment Method`
order by churn_rate desc;

-- churn by add-on services - Those who had no subscription has highest churn rate. 
select 
	`Online Security`, 
	`Online Backup`, 
	`Device Protection`, 
	`Tech Support`, 
	count(*) as total_customers,
    sum(case when `Churn Value` = 1 then 1 else 0 end) as churned_customers,
	(sum(case when `Churn Value` = 1 then 1 else 0 end) / count(*)) * 100 as churn_rate
from customer_churn_data
group by 
	`Online Security`, 
	`Online Backup`, 
	`Device Protection`, 
	`Tech Support`
order by churn_rate desc;

-- creating cleaned table view
select *
from customer_churn_data;

create view churn_analysis as
select 
    CustomerID, 
    Gender,
    `Senior Citizen`
    Partner,
    Dependents,
    `Tenure Months`,
    Contract,
    `Paperless Billing`,
    `Payment Method`,
    `Monthly Charges`,
    `Total Charges`,
    `Internet Service`,
    `Online Security`,
    `Tech Support`,
    `Streaming TV`,
    `Streaming Movies`,
    `Churn Value` as Churned,
    `Churn Reason`
from customer_churn_data;
