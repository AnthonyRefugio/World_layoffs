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
        company, industry, total_laid_off,`date`,
		ROW_NUMBER() OVER (PARTITION BY company, industry, total_laid_off,`date`) AS row_num
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