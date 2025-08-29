-- ====================================================

-- Data Cleaning Script
-- Dataset: Global Layoffs
-- Author: Suhana
-- ====================================================


	SELECT *
    FROM layoffs
    ;

-- 1. Remove Duplicates
-- 2. Handle Missing and Null Values
-- 3. Standardize the data
-- 4. Reduce redundancy
-- 5. Format the Date Column

CREATE TABLE layoffs_staging
like layoffs;

INSERT layoffs_staging
SELECT * 
FROM layoffs;

SELECT * 
FROM layoffs_staging;

-- 1.Removing Duplicates 

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num >1 ;

SELECT * 
FROM layoffs_staging
WHERE company = 'Casper';


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

SELECT * 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT * 
FROM layoffs_staging2
WHERE row_num >1;

DELETE  
FROM layoffs_staging2
WHERE row_num > 1;

SELECT * 
FROM layoffs_staging2
;

-- 2. Handling Missing and Null Values

SELECT DISTINCT industry 
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry='')
AND t2.industry IS NOT NULL
;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = ''
;

 
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL
;

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%'
;



-- 3. Standardization of data

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company)
;

SELECT DISTINCT industry
From layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET industry = "Crypto"
WHERE industry LIKE "crypto%"
;

SELECT DISTINCT industry
From layoffs_staging2
ORDER BY 1;

SELECT DISTINCT location
From layoffs_staging2
ORDER BY 1;

SELECT location
From layoffs_staging2
WHERE location LIKE "%polis";

UPDATE layoffs_staging2
SET location = "Florianopolis"
WHERE location LIKE "Florian%";

SELECT location
From layoffs_staging2
WHERE location LIKE "%sseldorf";

UPDATE layoffs_staging2
SET location = "dusseldorf"
WHERE location LIKE "%sseldorf";


UPDATE layoffs_staging2
SET location = "Malmo"
WHERE location LIKE "Malm%";

SELECT DISTINCT country
From layoffs_staging2
ORDER BY 1;


SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';





-- 4. Drop redundant Rows

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;


DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;








-- 5. Formatting the date
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2
;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y')
;
SELECT `date`
FROM layoffs_staging2
;

DESCRIBE layoffs_staging2;

ALTER TABLE layoffs_Staging2
MODIFY COLUMN `date` DATE;

DESCRIBE layoffs_staging2;


SELECT * 
FROM layoffs_staging2
;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num
;


SELECT * 
FROM layoffs_staging2
;