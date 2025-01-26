-- DATA CLEANING PROJECT- 1 
-- This project is from ALEX THE ANALYST and the data set is here :https://github.com/AlexTheAnalyst/MySQL-YouTube-Series/blob/main/layoffs.csv
SELECT *
FROM layoffs;

-- Here in this project we will be doing : 
--   1.Remove any duplicates 
--    2.Standarzied the data 
--    3.Null values or blank values
--    4.Remove any column 
-- STEP 1: lets create a raw data set . For this we need to create table and copy everything of the table  'layoffs'
	
    CREATE TABLE layoffs_staging -- creating table 
    LIKE layoffs;
	
     INSERT   layoffs_staging      -- copying everything  from layoffs table 
    SELECT * 
    FROM layoffs;
        SELECT * 
    FROM layoffs_staging;
      -- Creating the duplicate table is done for best practice beacause we dont want to modify the real table in real world 
      -- soo we are operating on the dummy table or the duplicate table of original one 
      
      -- lets check if there is any duplicate column or not 
       
       SELECT *,
       ROW_NUMBER() OVER (
		PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions 
       ) as row_num
       FROM layoffs_staging;
       
       -- what we goona do is we goona create a cte for storing these condition 
       
        with duplicate_cte AS (
         SELECT *,
       ROW_NUMBER() OVER (
		PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions 
       ) as row_num
       FROM layoffs_staging 
        )
        
        SELECT  *
        from duplicate_cte
        WHERE  row_num >1;
       
      SELECT * 
      FROM duplicate_cte
      WHERE row_num < 1;
      
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

INSERT  INTO layoffs_staging2 
         SELECT *,
       ROW_NUMBER() OVER (
		PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions 
       ) as row_num
       FROM layoffs_staging ;
       
       select * 
       from layoffs_staging2;
       
       select * 
       FROM layoffs_staging2
       where row_num >1;
       
       DELETE 
       FROM layoffs_staging2
       where row_num>1;
       
       select * 
       FROM layoffs_staging2;
       
       -- this is how we handle duplictes 
       
       -- STANDARDIZING DATA 
       -- STEP1: Triming 
       
       select company, TRIM(company)
       from layoffs_staging2;
       
       UPDATE layoffs_staging2
      SET  company = TRIM(company);
      
       select * 
       FROM layoffs_staging2;
      
      -- lets see if there is any similarities in industry 
      -- there is 'crypto ' and 'crypto currency' these both are same so lets change to crypto only 
      
      UPDATE layoffs_staging2
      set industry = "Crypto"
      WHERE industry LIKE "Crypto %";
      
      select DISTINCT country
      FROM layoffs_staging2;
      
      -- from here what we found is there is '.' in the country section ie 'united states.
      -- so lets update this 
      -- we are using triming for this 
      
      UPDATE layoffs_staging2
      SET country = "Unites States"
      WHERE country LIKE "United States%";
      
       -- lets see if the table is updated or not
       select *
       FROM layoffs_staging2;

	   -- date is written in 'string' format so lets change it to date format but this doesnot alter the data type of 'date' 
       UPDATE layoffs_staging2
       set `date`= str_to_date( `date`,'%m/%d/%Y');
        -- to alter the table and change the data type we do this after above update thing 
        
        ALTER table layoffs_staging2
        modify column `date` DATE;
       
         select *
       FROM layoffs_staging2;
       
       
       -- now lets check table and know/learn how do we fill null or empty space
       
       SELECT *
       FROM layoffs_staging2
		where industry is  null 
        or  industry='' ;
	-- what we can do is , 1.we can populate the company so to find the industry like using join 
    -- lets see 
    
    SELECT * 
    FROM layoffs_staging2
    where company = 'Airbnb';
    
    
UPDATE layoffs_staging2
SET industry = NULL 
WHERE industry = '';

    select tbl1.industry,tbl2.industry 
    from layoffs_staging2 tbl1
    join layoffs_staging2 tbl2
    on tbl1.company = tbl2.company
    where (tbl1.industry IS null )
    AND tbl2.industry IS NOT NULL ;
  
    
    
    -- now updating the table  
    UPDATE layoffs_staging2 tbl1
     join layoffs_staging2 tbl2
    on tbl1.company = tbl2.company
    SET tbl1.industry=tbl2.industry
    where (tbl1.industry IS null )
    AND tbl2.industry IS NOT NULL ;


 -- UPDATING another table 
    UPDATE  layoffs_staging2 tbl1
    JOIN  layoffs_staging2 tbl2
    on tbl1.company=tbl2.company 
    SET tbl2.industry=tbl1.industry
      where (tbl2.industry IS null)
    AND tbl1.industry IS NOT NULL ;
    
    select * 
    from layoffs_staging2
    WHERE industry= null;
    
    -- REMEMBER? i created 'row num ' in the table so lets delete it at the end so our data is cleaned.
    
    ALTER table layoffs_staging2
    DROP COLUMN row_num;
    
    select* 
    from layoffs_staging2;
    
    -- THIS IS HOW DATA CLEANING IS DONE  
 
    
    
    
		
          

      
	
       
       
       
       
	
     

       
        

	
    
    
    
       
      
    
    
    
    
    