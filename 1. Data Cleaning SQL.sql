-- Data Cleaning

Select *
From layoffs;

-- 1. Remove Dublicates
-- 2. Standardise Data
-- 3. Null Values or Blank Values
-- 4. Remove Any Columns

Create Table layoffs_staging
Like layoffs;

Select *
From layoffs_staging;

Insert layoffs_staging
Select *
From layoffs;

Select *,
ROW_NUMBER() Over(
Partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
From layoffs_staging;

With dublicate_cte As
(
Select *,
ROW_NUMBER() Over(
Partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
From layoffs_staging
)
Select*
From dublicate_cte
Where row_num > 1;

With dublicate_cte As
(
Select *,
ROW_NUMBER() Over(
Partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
From layoffs_staging
)
Select*
From dublicate_cte
Where row_num > 1;

With dublicate_cte As
(
Select *,
ROW_NUMBER() Over(
Partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
From layoffs_staging
)
Select*
From dublicate_cte
Where row_num > 1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Select* 
From layoffs_staging2;

Insert Into layoffs_staging2
Select *,
ROW_NUMBER() Over(
Partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
From layoffs_staging; 

Select* 
From layoffs_staging2
Where row_num > 1;

Delete
From layoffs_staging2
WHERE row_num > 1;

-- Standardising Data

Select Distinct (Trim(company))
From layoffs_staging2;

UPDATE layoffs_staging2
SET company = Trim(company);

Select *
From layoffs_staging2;

Select Distinct industry
From layoffs_staging2
Order by 1;

Select *
From layoffs_staging2
Where industry Like 'Crypto%';

Update layoffs_staging2
Set industry = 'Crypto'
Where industry like 'Crypto%';

Select DIstinct country
From layoffs_staging2
Order by 1;

Update layoffs_staging2
Set country = 'United States'
Where country like 'United States%';

-- Version 2

Select DIstinct country, trim(trailing '.' from country)
From layoffs_staging2
Order by 1;

Update layoffs_staging2
Set country = trim(trailing '.' from country)
Where country like 'United States%';

Select `date`,
str_to_date(`date`, '%m/%d/%Y')
From layoffs_staging2;

Update layoffs_staging2
Set `date` = str_to_date(`date`, '%m/%d/%Y');

Alter table layoffs_staging2
Modify column `date` Date;

Select *
From layoffs_staging2
Where total_laid_off is Null
And percentage_laid_off is Null;

Update layoffs_staging2
Set industry = Null
Where industry = '';

Select *
From layoffs_staging2
Where industry is null
Or  industry = '';

Select *
From layoffs_staging2
Where company = 'Airbnb';

Select t1.industry, t2.industry
From layoffs_staging2 as t1
Join layoffs_staging2 as t2
	On t1.company = t2.company
    And t1.location = t2.location
Where (t1.industry is Null or t1.industry = '')
And t2.industry is not Null;

Update layoffs_staging2 as t1
Join layoffs_staging2 as t2
    On t1.company = t2.company
SEt t1.industry = t2.industry
Where t1.industry is Null
And t2.industry is not Null;

Select *
From layoffs_staging2
Where company like 'Bally%';

select *
From layoffs_staging2
Where total_laid_off is Null
And percentage_laid_off is Null;

select *
From layoffs_staging2;

Delete
From layoffs_staging2
Where total_laid_off is Null
And percentage_laid_off is Null;

Alter table layoffs_staging2
Drop column row_num;
