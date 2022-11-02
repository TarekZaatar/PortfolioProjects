--Displaying data
select * 
from PortfolioProjects..Hotel2018

select * 
from PortfolioProjects..Hotel2019

select * 
from PortfolioProjects..Hotel2020

-- Combining three tables using Union

select * 
from PortfolioProjects..Hotel2018
Union
select * 
from PortfolioProjects..Hotel2019
Union
select * 
from PortfolioProjects..Hotel2020

-- Create a temporary table with all information

with hotels as 
(
select *  from PortfolioProjects..Hotel2018
Union
select * from PortfolioProjects..Hotel2019
Union
select * from PortfolioProjects..Hotel2020)

select * from hotels


-- calculating revenue
with hotels as 
(
select *  from PortfolioProjects..Hotel2018
Union
select * from PortfolioProjects..Hotel2019
Union
select * from PortfolioProjects..Hotel2020)

select (stays_in_week_nights + stays_in_weekend_nights)*adr as revenue from hotels


-- checking if the revenue increase every year

with hotels as 
(
select *  from PortfolioProjects..Hotel2018
Union
select * from PortfolioProjects..Hotel2019
Union
select * from PortfolioProjects..Hotel2020)

select arrival_date_year, (stays_in_week_nights + stays_in_weekend_nights)*adr as revenue from hotels

-- to visualize it in a better way we need to group by year therefore we need to some the revenue


with hotels as 
(
select *  from PortfolioProjects..Hotel2018
Union
select * from PortfolioProjects..Hotel2019
Union
select * from PortfolioProjects..Hotel2020)

select arrival_date_year, ROUND(SUM((stays_in_week_nights + stays_in_weekend_nights)*adr),1) 
as revenue from hotels
group by arrival_date_year


-- checking the revenue of each hotel

with hotels as 
(
select *  from PortfolioProjects..Hotel2018
Union
select * from PortfolioProjects..Hotel2019
Union
select * from PortfolioProjects..Hotel2020)

select arrival_date_year, ROUND(SUM((stays_in_week_nights + stays_in_weekend_nights)*adr),1) 
as revenue , hotel  from hotels
group by arrival_date_year, hotel

-- Market segment table
select * 
from PortfolioProjects..HotelMarket

-- joining two tables

with hotels as 
(
select *  from PortfolioProjects..Hotel2018
Union
select * from PortfolioProjects..Hotel2019
Union
select * from PortfolioProjects..Hotel2020)

select * from hotels
left join PortfolioProjects..HotelMarket 
on hotels.market_segment = PortfolioProjects..HotelMarket.market_segment


-- checking hotel meal cost table
select * from PortfolioProjects..HotelMealCost

-- joining all tables

with hotels as 
(
select *  from PortfolioProjects..Hotel2018
Union
select * from PortfolioProjects..Hotel2019
Union
select * from PortfolioProjects..Hotel2020)

select * from hotels
left join PortfolioProjects..HotelMarket 
on hotels.market_segment = PortfolioProjects..HotelMarket.market_segment
left join PortfolioProjects..HotelMealCost
on hotels.meal = PortfolioProjects..HotelMealCost.meal

--we will use some of these queries to extract information in power bi