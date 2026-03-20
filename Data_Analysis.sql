/* Layoff Trends Analysis
- Which industries were hit the hardest
- Which countries had the most layoffs
- What years/months saw the most layoffs
- Are layoffs increasing or decreasing over time 
*/

SELECT *
FROM layoffs_staging2;



-- 1. What industries were hit the hardest 
SELECT SUM(total_laid_off), SUM(percentage_laid_off)
FROM layoffs_staging2;


SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;


SELECT 
    industry,
    SUM(total_laid_off) AS total_layoffs,
    ROUND(SUM(total_laid_off) * 100 / (SELECT SUM(total_laid_off) FROM layoffs_staging2), 2) AS percentage_of_total
FROM layoffs_staging2
WHERE industry IS NOT NULL
GROUP BY industry
ORDER BY total_layoffs DESC;



-- 2. Which countries had the most layoffs

SELECT 
    country,
    SUM(total_laid_off) AS total_layoffs,
    ROUND(SUM(total_laid_off) * 100 / (SELECT SUM(total_laid_off) FROM layoffs_staging2), 2) AS percentage_of_total
FROM layoffs_staging2
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_layoffs DESC;


SELECT 
    CASE WHEN country = 'United States' THEN 'United States' ELSE 'Rest of World' END AS region,
    SUM(total_laid_off) AS total_layoffs,
    ROUND(SUM(total_laid_off) * 100 / (SELECT SUM(total_laid_off) FROM layoffs_staging2), 2) AS percentage_of_total
FROM layoffs_staging2
WHERE country IS NOT NULL
GROUP BY region
ORDER BY total_layoffs DESC;



-- What years/months saw the most layoffs