-- ExploratorY Data Analysis

Select * 
From layoffs_staging2;

Select MAX(total_laid_off), Max(percentage_laid_off)
From layoffs_staging2;

Select * 
From layoffs_staging2
Where percentage_laid_off = 1
Order By total_laid_off DESC;

Select company, SUM(total_laid_off)
From layoffs_staging2
group by company
Order by 2 DESC;

Select MIN(`date`), Max(`date`)
From layoffs_staging2;

Select industry, SUM(total_laid_off)
From layoffs_staging2
group by industry
Order by 2 DESC;

Select year(`date`), SUM(total_laid_off)
From layoffs_staging2
group by year(`date`)
Order by 1 DESC;

Select substring(`date`, 1,7) As `Month`, sum(total_laid_off)
From layoffs_staging2
Where substring(`date`, 1,7) is not Null
group by `Month`
Order by 1 ASC;

With Rolling_Total As
(
Select substring(`date`, 1,7) As `Month`, sum(total_laid_off) AS total_off
From layoffs_staging2
Where substring(`date`, 1,7) is not Null
group by `Month`
Order by 1 ASC
)
Select `Month`, total_off, Sum(total_off) Over(Order by `Month`) As rolling_total
From Rolling_Total;

Select company, year(`date`), SUM(total_laid_off)
From layoffs_staging2
group by company, year(`date`)
Order by 3 DESC;


With Company_Year (company, years, total_laid_off) As
(
Select company, year(`date`), SUM(total_laid_off)
From layoffs_staging2
group by company, year(`date`)
), Company_Year_Rank AS
(
Select *, Dense_rank() Over(Partition by years order by total_laid_off DESC) AS Ranking
From Company_Year
Where years is not Null
Order by Ranking ASC
)
Select *
From Company_Year_Rank
Where Ranking <= 5;