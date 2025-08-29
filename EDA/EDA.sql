-- ===============================================
-- Exploratory Data Analysis
-- Dataset: Global Layoffs
-- Author: Suhana
-- ====================================================


-- 1. Overview

SELECT * 
FROM layoffs_staging2
;

SELECT company, total_laid_off, percentage_laid_off
FROM layoffs_staging2
ORDER BY percentage_laid_off DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;


-- 2.Company Insights

-- Top 10 companies by total laid offs
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

SELECT company,industry,country
FROM layoffs_staging2
WHERE percentage_laid_off = 1
;


-- 3. Industry Trends

-- Layoffs by Industry
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT industry, ROUND(AVG(percentage_laid_off)*100,2)
FROM layoffs_staging2
WHERE percentage_laid_off IS NOT NULL
GROUP BY industry
ORDER BY 2 DESC;


-- 4. Geography 

-- Layoffs by Countries and Cities
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;


SELECT location, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;


-- 5. Funding & Stage of Layoffs
-- Layoffs by funding status
SELECT funds_raised_millions 
FROM layoffs_staging2 
ORDER BY funds_raised_millions DESC;

-- Layoffs by stages
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT 
    CASE 
      WHEN funds_raised_millions >= 1000 THEN 'High Funding (>= $1B)'
      WHEN funds_raised_millions >= 100 THEN 'Medium Funding ($100M - $1B)'
      ELSE 'Low Funding (< $100M)' END AS funding_group,
    SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY funding_group
ORDER BY 2 DESC;


-- 6. Time Trends

-- Layoffs by Month
SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7)
GROUP BY 1
ORDER BY 1 ASC
;

WITH Rolling_Total AS 
(
SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off) as total_offs
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7)
GROUP BY 1
ORDER BY 1 ASC
)
SELECT `Month`, total_offs,
SUM(total_offs) OVER (ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total
;

-- Company Layoffs by Year
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, `date`
ORDER BY 3 DESC;

-- Top 5 companies by Layoffs per Year
WITH Company_Year (Company, Years, total_laid_off) AS 
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Rank_By_Year As
(
SELECT *,
dense_rank () OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE Years IS NOT NULL
)
SELECT * 
FROM Company_Rank_By_Year
WHERE Ranking <= 5
;