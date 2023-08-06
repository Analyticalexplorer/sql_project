create table applestore_combined as

select * from appleStore_description1

union ALL
select * from appleStore_description2

union ALL
select * from appleStore_description3

union ALL
select * from appleStore_description4

--** EXPLORATORY DATA ANALYSIS INORDER TO INCREASE THE DATA QUALITY BEFORE ANALYSIS**--
******************************************************************************************************************************
-- to check the distint count of apps in the dataset in both apple store and apple description datasets inorder to check missing data------------------
******************************************************************************************************************************
select count(DISTINCT id) AS applestore_id
from AppleStore

select count(DISTINCT id ) as appledesc_id
from applestore_combined

-- both statement gave same output of 7197 it shows there is no missing data in dataset---------------
******************************************************************************************************************************


-----the next process in EDA is to check any missing values in a dataset----------------------------


select count(*) as missing_values
from AppleStore
where track_name IS null or user_rating is null or prime_genre is null 

-- it shows 0 missing values AppleStore table---------------------

select count(*) as missing_values2
from applestore_combined
where track_name IS null or size_bytes is null or app_desc is null 

-- it also shows zero missing values in applestore combined table-----------------

*********************************************************************************************************

-- To find the number of apps per genre in dataset inorder to increase the value of analysis------------


select prime_genre,count(*) as numofapps
from AppleStore
group by prime_genre
order by numofapps desc

---it shows the number of apps per genre in apple store table as we used prime genre for groupby------

************************************************************************************************************

----- To know about the userratings for apps on category of minimum ,maximum and average--------------------

select min(user_rating) as minrating,
       max(user_rating) as maxrating,
       avg(user_rating) as avgrating
       from AppleStore
       
       
---- It shows the minimun rating is 0 , maximum rating is 5 and the average rating is 3.52----------
********************************************************************************************************8

DATA ANALYSIS
--- IT SHOWS WHICH TYPE OF APP HAVE A BETTER USER RATING WHETHER PAID OR FREE APPS--------------------------

select CASE
           when price > 0 then 'paid'
           else 'free'
           end as app_type,
           avg(user_rating) as avg_rating
           from AppleStore
           group by app_type
           
----It shows free apps have the avg rating of 3.37 and paid apps have rating of 3.72(IT SHOWS PAID APPS HAVE BETTER USER RATING)---

SELECT CASE
          when lang_num<10 then 'less than 10'
          when lang_num BETWEEN 10 and 30 then 'btw 10 and 30'
          else 'more than 30 langauages'
          end as language_support,
          avg(user_rating) as Ratings
          from AppleStore
          group by language_support
          order by Ratings desc
          
------IT shows higher avg rating of 4.13 for the languages between 10 to 30 in dataset----------------AppleStore
*************************************************************************************************************************
--To check the genres with the low avg ratings  (Top 3)  -------------------AppleStore

select prime_genre , avg(user_rating) as UserRAT
from AppleStore
group by prime_genre
order by UserRAT 
LIMIT 3;

--- IT SHOWS THE TOP 3 GENRES WITH LOW RATINGS ARE ( CATALOGS,FINANCE,BOOKS)--------------------------

*************************************************************************************************************************
--To check the genres with the HIGHER avg ratings  (Top 3)  -------------------AppleStore

select prime_genre , avg(user_rating) as UserRAT
from AppleStore
group by prime_genre
order by UserRAT DESC
LIMIT 3;

--- IT SHOWS THE TOP 3 GENRES WITH LOW RATINGS ARE ( PRODUVTIVITY,MUSIC,PHOTO AND VIDEO)--------------------------

***************************************************************************************************************************


--Lets see its there any correlation between app description and user ratings ------------------------------

select CASE
           when length(app_desc)<500 then 'Short description'
           when length(app_desc) BETWEEN 500 and  1000 then 'Medium description '
           else 'long description'
           end as length_of_descp,
           avg(user_rating) as averg
           
from AppleStore as A        

JOIN
    applestore_combined as B
    on a.id=b.id
    
group by length_of_descp
order by averg desc;

---- it shows long description which has more than 500 have better avg user rating of 3.85594-----------

**********************************************************************************************************

---- to see the top rated apps in genre by using rank function----------------------------

select prime_genre,
track_name,
user_rating
FROM (
select prime_genre,
  track_name,
  user_rating,
  RANK() over( partition by prime_genre order by user_rating desc,rating_count_tot desc) as rank
  from AppleStore
  ) as A
  
  where a.rank=1
 --------------------------------------------------------------------------------------------------
 
 
 
 --                     RECOMMENDATIONS BASED ON ANALYSIS                                       --
 
 -- 1) PAID APPS HAVE BETTER RATING
 -- 2) APPS SUPPORTS BETWEEN 10 TO 30 HAVE BETTER RATINGS
 -- 3) CATALOG,FINANCE,BOOKS HAVE LOW RATINGS
 -- 4) APPS WITH LONGER DESCRIPTION HAVE BETTER RATINGS
          
