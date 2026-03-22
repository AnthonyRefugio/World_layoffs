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


WITH duplicate_cte AS(
	SELECT 
        *,
		ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised) AS row_num
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
  `funds_raised` int DEFAULT NULL,
  `country` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO layoffs_staging2
SELECT *,
    ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,`date`, stage, country, funds_raised) AS row_num
FROM layoffs_staging


DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;



-- 2. Standardizing data
SELECT*
FROM layoffs_staging2;


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



-- 3. Look at null values 
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company Like 'Eyeo%';


SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off IS NULL
AND total_laid_off IS NULL;



-- 4. remove any unnecessary columns and alter columns
SELECT *
FROM layoffs_staging2;


DELETE 
FROM layoffs_staging2
WHERE percentage_laid_off IS NULL
AND total_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


ALTER TABLE layoffs_staging2
MODIFY COLUMN company TEXT FIRST,
MODIFY COLUMN location TEXT AFTER company,
MODIFY COLUMN industry TEXT AFTER location,
MODIFY COLUMN total_laid_off INT AFTER industry,
MODIFY COLUMN percentage_laid_off TEXT AFTER total_laid_off,
MODIFY COLUMN `date` DATE AFTER percentage_laid_off,
MODIFY COLUMN stage TEXT AFTER `date`,
MODIFY COLUMN country TEXT AFTER stage,
MODIFY COLUMN funds_raised INT AFTER country

SELECT *
FROM layoffs_staging2;