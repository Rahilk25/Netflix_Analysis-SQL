--1. Count the number of Movies vs TV Shows

Select type, count(*) as t_cnt
From netflix
Group by type
order by t_cnt desc

--2. Find the most common rating for movies and TV shows

Select type, rating, rating_cnt
From 
    (Select type, rating, count(*) as rating_cnt, rank() over(partition by type order by count(*) desc) as rnk
    From netflix
    Group by type, rating) a  
Where rnk = 1
Order by rating_cnt desc


--3. List all movies released in a specific year (e.g., 2020)

Select *
From netflix
Where type = 'Movie' and release_year = 2020


--4. Find the top 5 countries with the most content on Netflix

Select 
  unnest(string_to_array (country,',')) as fixed_country, count(*) as cnt
From 
  netflix
Where 
  country not null
Group by 1
order by 
  cnt desc
Limit 5


--5. Identify the longest movie


Select *
From netflix
where type = 'Movie'
order by split_part(duration,' ',1) desc




--6. Find content added in the last 5 years

Select * 
From netflix
Where to_date(date_added, 'month dd, yyyy') >= current_date - Interval '5 years'


--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

Select *
From netflix
Where director iLike '%Rajiv Chilaka%'



8. List all TV shows with more than 5 seasons

Select *
From netflix
where type = 'TV shows' And 
  duration like '%season%' And
  Split_part(duration, ' ', 1) > 5


--9. Count the number of content items in each genre

  Select unnest(string_to_array(listed_in, ',')) as fixed_listed, count(*) as tot_content
  From netflix
  Group by 1


--10.Find each year and the average numbers of content release in India on netflix. 


Select 
	extract(year from to_date(date_added, 'Month dd,yyyy')) as extracted_year,
	count(*) as tot_content,
	Round(count(*)::numeric / (Select count(*) From netflix where country = 'India')::numeric*100,2)||'%' as contribution_perc
From netflix
Where 
	country = 'India'
Group by 
	extracted_year





  
--11. List all movies that are documentaries

Select title
From netflix
Where listed_in Like '%Documentaries%' And title = 'Movie'


--12. Find all content without a director

Select * 
From netflix
Where director is null


--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

Select title
From netflix
Where type = 'Movie' And
      Casts like '%Salman Khan%' And
      to_date(date_added, 'month dd,yyyy') >= current_date - Interval '10 Years'
  

--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

Select unnest(string_to_array(casts, ',')) as fixed_cast, count(*) as tot_cnt
From netflix
Where country like '%India%'
Group by 1
Order by tot_cnt desc
Limit 10


--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.            


Select 
    Case 
        When description ilike '%kill%' or description ilike '%violence%' 
            Then 'Bad'
        Else 'Good'
    End as category, 
    count(*) as tot_cnt
From netflix
Group by 1

--16. What are the most popular content categories added to Netflix each year? 

Select 
	Extract(Year from to_date(date_added, 'Month dd,yyyy')) as added_year,
    	unnest (string_to_array (listed_in,',')) as category,
    	count(*) as tot_cnt
From netflix
Where date_added is not null
Group by Grouping sets((category,added_year),(added_year))
order by added_year ,category , tot_cnt desc











