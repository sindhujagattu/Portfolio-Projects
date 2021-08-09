/*

Data Analysis in SQL queries

*/


-- Top 50 Countries that made the largest estimated improvements in life expectancy


Select *
From MyPortfolioProjects..mortality_life_expectancy

Select Top(50) A.country_name, A.life_expectancy as life_expectancy2021, B.life_expectancy as life_expectancy2050, B.life_expectancy-A.life_expectancy as ChangeInLifeExpectancy
From MyPortfolioProjects..mortality_life_expectancy A, MyPortfolioProjects..mortality_life_expectancy B
Where A.Year = 2021 and B.Year = 2050 and A.country_name = B.country_name
Order By ChangeInLifeExpectancy DESC


--------------------------------------------------------------------------------------------------------------------------


-- Countries with lowest birth and death rates


Select *
From MyPortfolioProjects..birth_death_growth_rates


Select Top(50) country_name, Min(crude_birth_rate) as MinBirthRate, Min(crude_death_rate) as MinDeathRate
From MyPortfolioProjects..birth_death_growth_rates
Where Year Between 2021 and 2036
Group By country_name
Order By MinBirthRate, MinDeathRate ASC


--------------------------------------------------------------------------------------------------------------------------


-- Countries with highest birth and death rates


Select Top(50) country_name, Max(crude_birth_rate) as MaxBirthRate, Max(crude_death_rate) as MaxDeathRate
From MyPortfolioProjects..birth_death_growth_rates
Where Year Between 2021 and 2036
Group By country_name
Order By MaxBirthRate, MaxDeathRate DESC


--------------------------------------------------------------------------------------------------------------------------


-- Countries with estimated increase in Population through the years


Select *
From MyPortfolioProjects..midyear_population_age_country_


Select distinct Top(50) A.country_name, max(A.population) as population2021, max(B.population) as population2050, max(B.population-A.population) as IncreaseInPopulation
From MyPortfolioProjects..midyear_population_age_country_ A, MyPortfolioProjects..midyear_population_age_country_ B
Where A.population < B.population And A.Year = 2021 and B.Year = 2050 and A.country_name = B.country_name
Group By A.country_name
Order By IncreaseInPopulation DESC


--------------------------------------------------------------------------------------------------------------------------



-- Ages with the most fertility rates through the years


Select *
From MyPortfolioProjects..age_specific_fertility_rates

Select Top(50) A.country_name, Max(A.fertility_rate_15_19) as ages15_19, Max(A.fertility_rate_20_24) as ages20_24, Max(A.fertility_rate_25_29) as ages25_29, Max(A.fertility_rate_30_34) as ages30_34, Max(A.fertility_rate_35_39) as ages35_39, Max(A.fertility_rate_40_44) as ages40_44, Max(A.fertility_rate_45_49) as ages45_49, Max(A.total_fertility_rate) as total_fertility_rate
From MyPortfolioProjects..age_specific_fertility_rates A, MyPortfolioProjects..age_specific_fertility_rates B
Where A.Year = 2021 and B.Year = 2050 and A.country_name = B.country_name
Group By A.country_name, A.total_fertility_rate
Order By A.total_fertility_rate DESC



		               
