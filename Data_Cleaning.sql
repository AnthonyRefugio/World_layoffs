/* SQL Project Data Cleaning 
1. check for duplicates 
2. standardize data 
3. Look at null values 
4. remove any columns that are not necessary
*/

-- first thing we want to do is create a staging table. This is the table that we will work in and clean the data
CREATE TABLE layoffs_staging 
LIKE layoffs;

INSERT layoffs_staging 
SELECT * 
FROM layoffs;




-- 1. Remove Duplicates
SELECT *
FROM layoffs_staging;


WITH duplicate_cte AS 
(
	SELECT 
        *,
		ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised_millions) AS row_num
    FROM 
        layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE 
	row_num > 1;

SELECT *
FROM layoffs_staging
WHERE company = 'Beyond Meat'


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `total_laid_off` int DEFAULT NULL,
  `date` text,
  `percentage_laid_off` text,
  `industry` text,
  `stage` text,
  `funds_raised_millions` int DEFAULT NULL,
  `country` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO layoffs_staging2
SELECT *,
    ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging


DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;



-- 2. Standardizing data
SELECT*
FROM layoffs_staging2
ORDER BY 1;


SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);



SELECT `date`,
    STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date`
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;
