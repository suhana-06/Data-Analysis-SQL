 Global Layoffs Data Analysis SQL 

 📌 Project Overview
This project analyzes 2,300+ global layoff records to uncover trends across companies, industries, countries, and funding stages.  
The data was cleaned and explored entirely using SQL.

 🛠 Tools & Technologies
- SQL (MySQL)
- Excel (for exports)

 🔧 Process
1. Data Cleaning  
   - Removed duplicates using `ROW_NUMBER()`  
   - Handled NULL values in industries & layoffs  
   - Standardized country, location, and industry names  
   - Converted date column to proper `DATE` type  

2. Exploratory Data Analysis (EDA)  
   - Layoffs by year, industry, company, and country  
   - Identified companies with 100% workforce layoffs (shutdowns)  
   - Compared layoffs by funding stage & funding groups  
   - Built monthly and rolling total trends  

 📊 Key Insights
- Tech & Consumer industries were most impacted by layoffs.  
- Several companies experienced complete shutdowns (100% layoffs).  
- Startups with >$1B funding still faced major layoffs.  
- 2023 Q1 marked the peak layoff period across industries.  


