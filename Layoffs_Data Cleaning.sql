SELECT * FROM layoffs;

#Data Cleaning 

#1. Remove Duplicates
#2. Data Standardization
#3. Identify null or blank cells
#4. Remove Any columns

#Duplicate Table Creation Avoid Original Table Altercation
CREATE TABLE layoffs_staging LIKE layoffs;

#Import data
INSERT layoffs_staging
SELECT * FROM layoffs;

#check duplicate table
SELECT * FROM layoffs_staging;

#duplicate identification
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

#Return only duplicates through creation of CTE
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * FROM duplicate_cte WHERE row_num > 1;

#Check duplicates
SELECT * FROM layoffs_staging WHERE company IN ('Casper', 'Cazoo', 'Hibob', 'Wildlife Studios', 'Yahoo');

#Create Table to remove duplicate
CREATE TABLE `layoffs_staging_2` (
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

#Import data with row_num
INSERT INTO layoffs_staging_2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

#Delete duplicates
DELETE 
FROM layoffs_staging_2
WHERE row_num > 1;

#check table
SELECT * FROM layoffs_staging_2;

#Standardizing Data
SELECT company, TRIM(company) AS 'company_'
FROM layoffs_staging_2;

#Remove white spaces
START TRANSACTION;
UPDATE layoffs_staging_2
SET 
	company = TRIM(company),
    location = TRIM(location),
    industry = TRIM(industry),
    stage = TRIM(stage),
    country = TRIM(country);
#check table
SELECT * FROM layoffs_staging_2;
COMMIT;

#check industry column
SELECT DISTINCT industry FROM layoffs_staging_2
ORDER BY 1;

#Remove duplicate Crypto Industry entries
SELECT * FROM layoffs_staging_2
WHERE industry LIKE 'Crypto%';

#Update to 1 spelling with highest entries
UPDATE layoffs_staging_2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

#check location
SELECT DISTINCT location FROM layoffs_staging_2
ORDER BY 1;
#no issues detected

#check country
SELECT DISTINCT country FROM layoffs_staging_2
ORDER BY 1;

UPDATE layoffs_staging_2
SET country = trim(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

#date format
SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging_2;

#update date format
UPDATE layoffs_staging_2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

#convert date from text to date format
ALTER TABLE layoffs_staging_2
MODIFY COLUMN `date` DATE;

#check null
SELECT * FROM layoffs_staging_2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

#check blank
SELECT *
FROM layoffs_staging_2
WHERE industry IS NULL 
OR industry ='';

#check for other entires to repopulate
SELECT * FROM layoffs_staging_2
WHERE company IN ('Airbnb', 'Bally\'s Interactive', 'Carvana', 'Juul');
#Other than Bally's Interactive, others can be repopulated

#change blank to null as t2 (below) has both null and populated entries
UPDATE layoffs_staging_2
SET industry = NULL
WHERE industry ='';

#repopulate null through join
SELECT t1.industry , t2.industry
FROM layoffs_staging_2 t1
JOIN layoffs_staging_2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;	

#update repopulation
UPDATE layoffs_staging_2 t1
JOIN layoffs_staging_2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

#remove not required rows
SELECT * FROM layoffs_staging_2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_staging_2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

#remove row_num column
ALTER TABLE layoffs_staging_2
DROP COLUMN row_num;