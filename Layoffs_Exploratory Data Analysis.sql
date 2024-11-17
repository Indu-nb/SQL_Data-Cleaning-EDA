#Exploratory Data Analysis

#see
SELECT * FROM layoffs_staging_2;

#extreme
SELECT MAX(total_laid_off), MAX(percentage_laid_off) FROM layoffs_staging_2;

#trace max percentage laid off company
SELECT * FROM layoffs_staging_2 WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

#trace max total laid off company
SELECT * FROM layoffs_staging_2 WHERE total_laid_off  = 12000;

#understand time period of data
SELECT MIN(`date`), MAX(`date`) FROM layoffs_staging_2;

#understand total laid off for each company in this time period
SELECT company, SUM(total_laid_off) FROM layoffs_staging_2
GROUP BY company
ORDER BY 2 DESC;

#understand total laid off for each industry in this time period
SELECT industry, SUM(total_laid_off) FROM layoffs_staging_2
GROUP BY industry
ORDER BY 2 DESC;

#understand which industry has highest and lowest percentage laid off in this time period
SELECT industry, AVG(percentage_laid_off) FROM layoffs_staging_2
GROUP BY industry
ORDER BY 2 DESC;

#understand which country had the highest/lowest laid off 
SELECT country, SUM(total_laid_off) FROM layoffs_staging_2
GROUP BY country
ORDER BY 2 DESC;

#understand magnitude of laid off by year
SELECT YEAR(`date`), SUM(total_laid_off) FROM layoffs_staging_2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

#understand which company stage relates to highest magnitude of layoffs
SELECT stage, SUM(total_laid_off) FROM layoffs_staging_2
GROUP BY stage
ORDER BY 2 DESC;

#magnitude of layoff by timeline of month and year
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging_2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

#cte for rolling total
WITH Rolling_Total AS (
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging_2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

SELECT company, SUM(total_laid_off) FROM layoffs_staging_2
GROUP BY company
ORDER BY 2 DESC;

SELECT company, YEAR(`date`), SUM(total_laid_off) FROM layoffs_staging_2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

#cte for co responsible for max layoff by years
WITH Company_Year (company, years, total_laid_off) AS (
SELECT company, YEAR(`date`), SUM(total_laid_off) FROM layoffs_staging_2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS (
SELECT * , DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Year_Rank
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT * FROM Company_Year_Rank
WHERE Year_Rank <=5;
