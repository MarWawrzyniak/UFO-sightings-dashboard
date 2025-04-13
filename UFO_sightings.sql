/* How many records are in the database? */

SELECT
	COUNT(*)
FROM ufo_sightings_base

/* How many columns are in the database? */

SELECT
	COUNT(*) AS Number_of_columns
FROM information_schema.columns
WHERE table_name = 'ufo_sightings_base'

/* The first 15 records in the database. */

SELECT *
FROM ufo_sightings_base
LIMIT 15

/* Names of columns and their types */

SELECT 
	column_name,
	data_type
FROM information_schema.columns
WHERE table_name = 'ufo_sightings_base'

/* Changing the names of columns in the database */

ALTER TABLE ufo_sightings_base 
CHANGE COLUMN `duration (seconds)` duration_seconds int,
CHANGE COLUMN `duration (hours/min)` duration_hours_min varchar(255)

/* What shapes of UFOs are observed most often? */

SELECT
	CASE 
		WHEN shape is null OR shape = '' THEN 'unknown' 
		ELSE shape 
	END AS shape_grouped, 
	count(*) AS number_of_observations,
	round(100 * count(*) / sum(count(*)) OVER (), 3) AS Number_of_observations_in_percentage
FROM ufo_sightings_base
GROUP BY shape_grouped
ORDER BY number_of_observations DESC

/* What are the annual trends in sightings? */

SELECT
	year(`datetime`) AS year,
	count(*) AS number_of_observations
FROM ufo_sightings_base
WHERE year(datetime) >= 2000
group BY year
order BY year ASC

/* Which US states report the most UFO sightings? */

SELECT
	state,
	count(*) AS number_of_observations,
	round(100 * count(*) / sum(count(*)) OVER (), 2) AS Number_of_observations_in_percentage
FROM ufo_sightings_base
WHERE country = "us"
GROUP BY 1
ORDER BY number_of_observations DESC

/* Checking how many empty duration_seconds values there are in the database.*/

SELECT
COUNT(*) AS number_of_empty_duration_seconds
FROM ufo_sightings_base
WHERE duration_seconds =''

/* Checking how many empty duration_seconds values there are in the database and what they are. */

SELECT
	COUNT(*) AS number_of_empty_duration_seconds,
	duration_hours_min 
FROM ufo_sightings_base
WHERE duration_seconds =''
GROUP BY duration_hours_min

/* Distribution of the duration of UFO sightings (data cleaning) */

SELECT 
    duration_category,
    COUNT(*) AS number_of_observations
FROM (
    SELECT 
        CASE 
            WHEN IF(duration_seconds = '', 
                    CASE 
                        WHEN duration_hours_min REGEXP 'millisecond|ms' THEN 1  
                        WHEN duration_hours_min REGEXP '1/2|half' THEN 1  
                        WHEN duration_hours_min REGEXP '^[0-9]+/[0-9]+' THEN 
                            GREATEST(1, CEIL(SUBSTRING_INDEX(duration_hours_min, '/', 1) / 
                                             SUBSTRING_INDEX(duration_hours_min, '/', -1)))  
                        WHEN duration_hours_min REGEXP '[0-9]+\.?[0-9]*' THEN 
                            GREATEST(1, CEIL(CAST(REGEXP_REPLACE(duration_hours_min, '[^0-9.]', '') AS DECIMAL(10,3))))
                        ELSE NULL  
                    END, 
                    duration_seconds
                ) <= 59 THEN '<1 min'
            WHEN IF(duration_seconds = '', 
                    CASE 
                        WHEN duration_hours_min REGEXP 'millisecond|ms' THEN 1  
                        WHEN duration_hours_min REGEXP '1/2|half' THEN 1  
                        WHEN duration_hours_min REGEXP '^[0-9]+/[0-9]+' THEN 
                            GREATEST(1, CEIL(SUBSTRING_INDEX(duration_hours_min, '/', 1) / 
                                             SUBSTRING_INDEX(duration_hours_min, '/', -1)))  
                        WHEN duration_hours_min REGEXP '[0-9]+\.?[0-9]*' THEN 
                            GREATEST(1, CEIL(CAST(REGEXP_REPLACE(duration_hours_min, '[^0-9.]', '') AS DECIMAL(10,3))))
                        ELSE NULL  
                    END, 
                    duration_seconds
                ) BETWEEN 60 AND 300 THEN '1-5 min'
            WHEN IF(duration_seconds = '', 
                    CASE 
                        WHEN duration_hours_min REGEXP 'millisecond|ms' THEN 1  
                        WHEN duration_hours_min REGEXP '1/2|half' THEN 1  
                        WHEN duration_hours_min REGEXP '^[0-9]+/[0-9]+' THEN 
                            GREATEST(1, CEIL(SUBSTRING_INDEX(duration_hours_min, '/', 1) / 
                                             SUBSTRING_INDEX(duration_hours_min, '/', -1)))  
                        WHEN duration_hours_min REGEXP '[0-9]+\.?[0-9]*' THEN 
                            GREATEST(1, CEIL(CAST(REGEXP_REPLACE(duration_hours_min, '[^0-9.]', '') AS DECIMAL(10,3))))
                        ELSE NULL  
                    END, 
                    duration_seconds
                ) BETWEEN 301 AND 600 THEN '5-10 min'
            WHEN IF(duration_seconds = '', 
                    CASE 
                        WHEN duration_hours_min REGEXP 'millisecond|ms' THEN 1  
                        WHEN duration_hours_min REGEXP '1/2|half' THEN 1  
                        WHEN duration_hours_min REGEXP '^[0-9]+/[0-9]+' THEN 
                            GREATEST(1, CEIL(SUBSTRING_INDEX(duration_hours_min, '/', 1) / 
                                             SUBSTRING_INDEX(duration_hours_min, '/', -1)))  
                        WHEN duration_hours_min REGEXP '[0-9]+\.?[0-9]*' THEN 
                            GREATEST(1, CEIL(CAST(REGEXP_REPLACE(duration_hours_min, '[^0-9.]', '') AS DECIMAL(10,3))))
                        ELSE NULL  
                    END, 
                    duration_seconds
                ) BETWEEN 601 AND 1200 THEN '10-20 min'
            WHEN IF(duration_seconds = '', 
                    CASE 
                        WHEN duration_hours_min REGEXP 'millisecond|ms' THEN 1  
                        WHEN duration_hours_min REGEXP '1/2|half' THEN 1  
                        WHEN duration_hours_min REGEXP '^[0-9]+/[0-9]+' THEN 
                            GREATEST(1, CEIL(SUBSTRING_INDEX(duration_hours_min, '/', 1) / 
                                             SUBSTRING_INDEX(duration_hours_min, '/', -1)))  
                        WHEN duration_hours_min REGEXP '[0-9]+\.?[0-9]*' THEN 
                            GREATEST(1, CEIL(CAST(REGEXP_REPLACE(duration_hours_min, '[^0-9.]', '') AS DECIMAL(10,3))))
                        ELSE NULL  
                    END, 
                    duration_seconds
                ) BETWEEN 1201 AND 1800 THEN '20-30 min'
            WHEN IF(duration_seconds = '', 
                    CASE 
                        WHEN duration_hours_min REGEXP 'millisecond|ms' THEN 1  
                        WHEN duration_hours_min REGEXP '1/2|half' THEN 1  
                        WHEN duration_hours_min REGEXP '^[0-9]+/[0-9]+' THEN 
                            GREATEST(1, CEIL(SUBSTRING_INDEX(duration_hours_min, '/', 1) / 
                                             SUBSTRING_INDEX(duration_hours_min, '/', -1)))  
                        WHEN duration_hours_min REGEXP '[0-9]+\.?[0-9]*' THEN 
                            GREATEST(1, CEIL(CAST(REGEXP_REPLACE(duration_hours_min, '[^0-9.]', '') AS DECIMAL(10,3))))
                        ELSE NULL  
                    END, 
                    duration_seconds
                ) BETWEEN 1801 AND 3600 THEN '30-60 min'
            ELSE '>60 min'
        END AS duration_category
    FROM ufo_sightings_base
) AS grouped_data
GROUP BY duration_category
ORDER BY FIELD(duration_category, '<1 min', '1-5 min', '5-10 min', '10-20 min', '20-30 min', '30-60 min', '>60 min')

/* Percentage distribution of duration of UFO sightings (data cleaning) */

SELECT 
    duration_category,
    COUNT(*) AS number_of_observations,
    ROUND((COUNT(*) / total.total_count * 100), 2) AS Number_of_observations_in_percentage
FROM (
    SELECT 
        CASE 
            WHEN IF(duration_seconds = '', 
                    CASE 
                        WHEN duration_hours_min REGEXP 'millisecond|ms' THEN 1  
                        WHEN duration_hours_min REGEXP '1/2|half' THEN 1  
                        WHEN duration_hours_min REGEXP '^[0-9]+/[0-9]+' THEN 
                            GREATEST(1, CEIL(SUBSTRING_INDEX(duration_hours_min, '/', 1) / 
                                             SUBSTRING_INDEX(duration_hours_min, '/', -1)))  
                        WHEN duration_hours_min REGEXP '[0-9]+\.?[0-9]*' THEN 
                            GREATEST(1, CEIL(CAST(REGEXP_REPLACE(duration_hours_min, '[^0-9.]', '') AS DECIMAL(10,3))))
                        ELSE NULL  
                    END, 
                    duration_seconds
                ) <= 59 THEN '<1 min'
            WHEN IF(duration_seconds = '', 
                    CASE 
                        WHEN duration_hours_min REGEXP 'millisecond|ms' THEN 1  
                        WHEN duration_hours_min REGEXP '1/2|half' THEN 1  
                        WHEN duration_hours_min REGEXP '^[0-9]+/[0-9]+' THEN 
                            GREATEST(1, CEIL(SUBSTRING_INDEX(duration_hours_min, '/', 1) / 
                                             SUBSTRING_INDEX(duration_hours_min, '/', -1)))  
                        WHEN duration_hours_min REGEXP '[0-9]+\.?[0-9]*' THEN 
                            GREATEST(1, CEIL(CAST(REGEXP_REPLACE(duration_hours_min, '[^0-9.]', '') AS DECIMAL(10,3))))
                        ELSE NULL  
                    END, 
                    duration_seconds
                ) BETWEEN 60 AND 300 THEN '1-5 min'
            WHEN IF(duration_seconds = '', 
                    CASE 
                        WHEN duration_hours_min REGEXP 'millisecond|ms' THEN 1  
                        WHEN duration_hours_min REGEXP '1/2|half' THEN 1  
                        WHEN duration_hours_min REGEXP '^[0-9]+/[0-9]+' THEN 
                            GREATEST(1, CEIL(SUBSTRING_INDEX(duration_hours_min, '/', 1) / 
                                             SUBSTRING_INDEX(duration_hours_min, '/', -1)))  
                        WHEN duration_hours_min REGEXP '[0-9]+\.?[0-9]*' THEN 
                            GREATEST(1, CEIL(CAST(REGEXP_REPLACE(duration_hours_min, '[^0-9.]', '') AS DECIMAL(10,3))))
                        ELSE NULL  
                    END, 
                    duration_seconds
                ) BETWEEN 301 AND 600 THEN '5-10 min'
            WHEN IF(duration_seconds = '', 
                    CASE 
                        WHEN duration_hours_min REGEXP 'millisecond|ms' THEN 1  
                        WHEN duration_hours_min REGEXP '1/2|half' THEN 1  
                        WHEN duration_hours_min REGEXP '^[0-9]+/[0-9]+' THEN 
                            GREATEST(1, CEIL(SUBSTRING_INDEX(duration_hours_min, '/', 1) / 
                                             SUBSTRING_INDEX(duration_hours_min, '/', -1)))  
                        WHEN duration_hours_min REGEXP '[0-9]+\.?[0-9]*' THEN 
                            GREATEST(1, CEIL(CAST(REGEXP_REPLACE(duration_hours_min, '[^0-9.]', '') AS DECIMAL(10,3))))
                        ELSE NULL  
                    END, 
                    duration_seconds
                ) BETWEEN 601 AND 1200 THEN '10-20 min'
            WHEN IF(duration_seconds = '', 
                    CASE 
                        WHEN duration_hours_min REGEXP 'millisecond|ms' THEN 1  
                        WHEN duration_hours_min REGEXP '1/2|half' THEN 1  
                        WHEN duration_hours_min REGEXP '^[0-9]+/[0-9]+' THEN 
                            GREATEST(1, CEIL(SUBSTRING_INDEX(duration_hours_min, '/', 1) / 
                                             SUBSTRING_INDEX(duration_hours_min, '/', -1)))  
                        WHEN duration_hours_min REGEXP '[0-9]+\.?[0-9]*' THEN 
                            GREATEST(1, CEIL(CAST(REGEXP_REPLACE(duration_hours_min, '[^0-9.]', '') AS DECIMAL(10,3))))
                        ELSE NULL  
                    END, 
                    duration_seconds
                ) BETWEEN 1201 AND 1800 THEN '20-30 min'
            WHEN IF(duration_seconds = '', 
                    CASE 
                        WHEN duration_hours_min REGEXP 'millisecond|ms' THEN 1  
                        WHEN duration_hours_min REGEXP '1/2|half' THEN 1  
                        WHEN duration_hours_min REGEXP '^[0-9]+/[0-9]+' THEN 
                            GREATEST(1, CEIL(SUBSTRING_INDEX(duration_hours_min, '/', 1) / 
                                             SUBSTRING_INDEX(duration_hours_min, '/', -1)))  
                        WHEN duration_hours_min REGEXP '[0-9]+\.?[0-9]*' THEN 
                            GREATEST(1, CEIL(CAST(REGEXP_REPLACE(duration_hours_min, '[^0-9.]', '') AS DECIMAL(10,3))))
                        ELSE NULL  
                    END, 
                    duration_seconds
                ) BETWEEN 1801 AND 3600 THEN '30-60 min'
            ELSE '>60 min'
        END AS duration_category
    FROM ufo_sightings_base
) AS grouped_data
CROSS JOIN (SELECT COUNT(*) AS total_count FROM ufo_sightings_base) AS total
GROUP BY duration_category, total.total_count
ORDER BY FIELD(duration_category, '<1 min', '1-5 min', '5-10 min', '10-20 min', '20-30 min', '30-60 min', '>60 min')