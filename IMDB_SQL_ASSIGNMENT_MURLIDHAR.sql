/* SQL RSVP ASSIGNMENT - BY MURLIDHAR MAINDARGIKAR - UPGRAD - PGDDS FEB 2020*/

USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 
	TABLE_NAME, 
	TABLE_ROWS 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'imdb';

-- Answer 1 : Above query provides number of rows as output.
   
-- Q2. Which columns in the movie table have null values?
-- Type your code below:

WITH movie_col_check AS (
SELECT 
	count(*)-count(country) AS null_in_country, count(*)-count(date_published) AS null_in_date_published, count(*)-count(duration) AS null_in_duration, 
    count(*)-count(id) AS null_in_id, count(*)-count(languages) AS null_in_languages, count(*)-count(production_company) AS null_in_production_company, 
    count(*)-count(title) AS null_in_title, count(*)-count(worlwide_gross_income) AS null_in_worlwide_gross_income, count(*)-count(year) AS null_in_year 
FROM movie
)
SELECT 
	*
FROM movie_col_check;

-- Answer 2 : 4 Columns "country, languages, production_company, worlwide_gross_income" have null values in movie table.

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Code for first part to show total number of movies released each year
SELECT 
    year AS Year, 
    COUNT(id) AS number_of_movies
FROM movie
GROUP BY year
ORDER BY year;

-- Answe 3.1: Number of movies released are decreasing yearwise.
    
-- Code for second part to show the trend look month wise
SELECT 
    month(date_published) AS month_num, 
    COUNT(id) AS number_of_movies
FROM movie
GROUP BY month_num
ORDER BY month_num;

-- Answe 3.2: Highest number of movies are released in March and lowest number of movies released in December.

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT 
    COUNT(id) AS no_of_movies_india_usa
FROM movie
WHERE ((country LIKE '%India%' OR country LIKE '%USA%') AND year = 2019);

-- Answer 4: In year 2019, in India or USA, total 1059 movies are produced.

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT 
	DISTINCT(genre) AS list_of_genres
FROM genre;

-- Answer 5: There are total 13 genres.

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
WITH genre_rank AS (
SELECT 
    genre, 
    COUNT(movie_id) AS no_of_movies,
    RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_ranking
FROM genre
GROUP BY genre
ORDER BY no_of_movies DESC
)
SELECT
	genre,
    no_of_movies
FROM genre_rank
WHERE genre_ranking = 1;
	
-- Anser 6: Drama genre has highest number of movies produced overall.
    
/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH single_genre AS
(
SELECT 
    movie_id, 
    COUNT(movie_id) AS no_of_genres
FROM genre
GROUP BY movie_id
HAVING  COUNT(movie_id) = 1
) 
SELECT 
    COUNT(movie_id) AS no_of_movies_single_genre
FROM single_genre;

-- Answer 7 : 3289 movies belong to one genre.
	
/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)
/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
    g.genre, 
    ROUND(AVG(m.duration),2) AS avg_duration
FROM 
	genre AS g
	INNER JOIN
	movie AS m 
	ON g.movie_id = m.id
GROUP BY  g.genre;

-- Answer 8 : From output we can say that Drama genre has highest average duration.

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH Thriller_rank AS (
SELECT 
    genre, 
    COUNT(movie_id) AS movie_count,
    RANK() OVER(ORDER BY COUNT(movie_id) DESC) genre_rank
FROM genre
GROUP BY genre
)
SELECT
	*
FROM Thriller_rank
WHERE genre = 'Thriller';

-- Answer 9 : Thriller genre has 3rd rank with movies count as 1484.

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT
	min(avg_rating) AS min_avg_rating,
    max(avg_rating) AS max_avg_rating,
    min(total_votes) AS min_total_votes,
    max(total_votes) AS max_total_votes,
    min(median_rating) AS min_median_rating,
    max(median_rating) AS max_median_rating
FROM ratings; 

/*Answer 10: Output of above query provides information asked in question 10. Also from the values in each ratings column we can 
say that there are no outliers in the table*/

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
WITH top_10_movies AS (
SELECT
	m.title,
    r.avg_rating,
    RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank,
    ROW_NUMBER() OVER(ORDER BY avg_rating DESC) AS row_num
FROM 
	movie AS m
	INNER JOIN
	ratings AS r
	ON m.id=r.movie_id
)
SELECT 
	title,
    avg_rating,
    movie_rank
FROM  top_10_movies
WHERE movie_rank<=10;

-- Answer 11: Based on use of RANK() function we can see that there are 14 movies with rank less than or equal to 10. Fan movie is there in output.
    
/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT
	median_rating,
    COUNT(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY movie_count DESC;

-- Answer 12: Movies is median rating 7 has highest count as per checkpoint.

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
WITH hit_production_house AS (
SELECT
	m.id,
	m.production_company,
    r.avg_rating
FROM
	movie AS m
	INNER JOIN
	ratings AS r
	ON m.id=r.movie_id
WHERE r.avg_rating>8
),
top_2_prd_house AS (
SELECT 
	production_company,
    COUNT(id) AS movie_count,
    RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_company_rank
FROM hit_production_house
WHERE production_company IS NOT NULL
GROUP BY production_company
)
SELECT
	*
FROM top_2_prd_house
WHERE prod_company_rank<2;

-- Answer 13: Dream Warrior Pictures and National Theatre Live are both producing highest number of hit movies

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH mar_2017_movies AS (
SELECT
    g.movie_id,
    g.genre,
    MONTH(m.date_published) AS month_released,
    m.year AS year_released,
    m.country,
    r.total_votes
FROM
	genre AS g
	INNER JOIN
	movie AS m
	ON g.movie_id=m.id
	INNER JOIN
	ratings AS r
	ON g.movie_id=r.movie_id
)
SELECT 
	genre,
    COUNT(movie_id) AS movie_count
FROM mar_2017_movies
WHERE country LIKE '%USA%' AND month_released = 3 AND year_released = 2017 AND total_votes>1000
GROUP BY genre
ORDER BY movie_count DESC;
	
-- Answer 14: From query output we can see that max movies released in drama genre in mar 2017. It also shows movie count for all applicable genres.
    
-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_THE_movies AS (
SELECT
	m.title,
    r.avg_rating,
    g.genre
FROM
	genre AS g
	INNER JOIN
	movie AS m
	ON g.movie_id=m.id
	INNER JOIN
	ratings AS r
	ON g.movie_id=r.movie_id
)
SELECT
	title,
    avg_rating,
    genre
FROM genre_THE_movies
WHERE title LIKE 'The%' AND avg_rating>8
ORDER BY genre;

-- Answer 15: Above query output provides list of movies of each genre that start with the word ‘The’ and which have an average rating > 8.


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

WITH april_18_to_19 AS (
SELECT
	m.id,
    m.date_published,
    r.median_rating
FROM
	movie AS m
	INNER JOIN
	ratings AS r
	ON m.id=r.movie_id
WHERE median_rating = 8
)
SELECT
	COUNT(id) AS movie_count
FROM april_18_to_19
WHERE date_published BETWEEN '2018-04-01' AND '2019-04-01';

-- Answer 16: Of the movies released between 1 April 2018 and 1 April 2019, 361 movies were given a median rating of 8.

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

WITH german_movies AS (
SELECT 
	SUM(r.total_votes) AS total_german_votes
FROM 
	movie AS m
	INNER JOIN
	ratings AS r
	ON m.id=r.movie_id
WHERE languages LIKE '%German%'
),
italian_movies AS (
SELECT 
	SUM(r.total_votes) AS total_italian_votes
FROM
	movie AS m
	INNER JOIN
	ratings AS r
	ON m.id=r.movie_id
WHERE languages LIKE '%Italian%'
)
SELECT 
	*
FROM
	italian_movies,
	german_movies;

-- Answer 17 : German movies get more votes than Italian movies.
-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH name_null_check AS (
SELECT 
	count(*)-count(name) AS name_nulls, 
    count(*)-count(height) AS height_nulls, 
    count(*)-count(date_of_birth) AS date_of_birth_nulls, 
    count(*)-count(known_for_movies) AS known_for_movies_nulls
FROM 
	names
)
SELECT 
	*
FROM
	name_null_check;

-- Answer 18 : name coumn does not have any null values.


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
    
WITH top_3_genres AS (
SELECT
	g.genre,
    COUNT(g.movie_id) as movie_count
FROM
	genre g
	INNER JOIN
    ratings r 
    ON g.movie_id=r.movie_id
WHERE avg_rating > 8
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 3
),
top_directors AS (
SELECT
	n.name AS director_name,
    COUNT(g.movie_id) AS movie_count,
    RANK() OVER(ORDER BY COUNT(g.movie_id) DESC) AS dir_rank
FROM
	director_mapping AS d
	INNER JOIN
	names AS n
	ON d.name_id = n.id
	INNER JOIN
    genre g 
    ON d.movie_id = g.movie_id
    INNER JOIN
    ratings r 
    ON r.movie_id = g.movie_id, 
    top_3_genres
WHERE g.genre IN (top_3_genres.genre) AND AVG_RATING >8
GROUP BY director_name
ORDER BY movie_count DESC
)
SELECT
	director_name,
    movie_count
FROM top_directors
WHERE dir_rank<4;
    
/*-- Answer 19 : The top directors in the top three genres whose movies have an average rating > 8 and with rank less than 3 or 
equal to 3 are James Mangold, Anthony Russo, Joe Russo, Soubin Shahir*/

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_2_actors AS (
SELECT
	n.name AS actor_name,
    COUNT(rm.movie_id) AS movie_count,
    RANK() OVER(ORDER BY COUNT(rm.movie_id) DESC) AS actor_rank
FROM 
	role_mapping AS rm
    INNER JOIN
    names AS n
    ON rm.name_id = n.id
    INNER JOIN
    ratings AS r
    ON rm.movie_id = r.movie_id
WHERE r.median_rating >= 8
GROUP BY actor_name
ORDER BY movie_count DESC
)
SELECT
	actor_name,
	movie_count
FROM top_2_actors
WHERE actor_rank<3;

-- Answer 20 : Mammootty and Mohanlal are the top two actors whose movies have a median rating >= 8.

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH top_3_prod_houses AS (
SELECT
	m.production_company,
    SUM(r.total_votes) as vote_count,
    RANK() OVER(ORDER BY SUM(r.total_votes) DESC) as prod_comp_rank
FROM
	movie AS m 
    INNER JOIN
    ratings AS r
	ON m.id = r.movie_id
GROUP BY m.production_company
ORDER BY vote_count DESC
)
SELECT
	*
FROM top_3_prod_houses
WHERE prod_comp_rank<4;

/* Answer 21 : the top three production houses based on the number of votes received by their movies are Marvel Studios, 
Twentieth Century Fox and Warner Bros.*/
    
/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH top_indian_actors AS (
SELECT
    n.name AS actor_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(rm.movie_id) AS movie_count,
    ROUND((SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes)),2) AS actor_avg_rating
FROM
	role_mapping AS rm
	INNER JOIN
	names AS n
	ON rm.name_id = n.id
	INNER JOIN
	ratings AS r
	ON rm.movie_id = r.movie_id
	INNER JOIN
	movie AS m 
	ON rm.movie_id = m.id
WHERE m.country LIKE '%India%' AND rm.category = 'actor'
GROUP BY n.name
HAVING movie_count >= 5
ORDER BY 
	actor_avg_rating DESC,
    total_votes DESC
)
SELECT
	actor_name,
	total_votes,
	movie_count,
	actor_avg_rating,
	RANK() OVER(ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank
FROM top_indian_actors;

-- Answer 22 : On the basis of rank of actors with movies released in India based on their average ratings, Vijay Sethupathi is at the top of the list.

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH top_indian_actresses AS (
SELECT
    n.name AS actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(rm.movie_id) AS movie_count,
    ROUND((SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes)),2) AS actress_avg_rating
FROM
	role_mapping AS rm
	INNER JOIN
	names AS n
	ON rm.name_id = n.id
	INNER JOIN
	ratings AS r
	ON rm.movie_id = r.movie_id
	INNER JOIN
	movie AS m 
	ON rm.movie_id = m.id
WHERE m.country LIKE '%India%' AND m.languages LIKE '%Hindi%' AND rm.category = 'actress'
GROUP BY n.name
HAVING  movie_count >= 3
ORDER BY 
	actress_avg_rating DESC,
    total_votes DESC
),
top_5 AS (
SELECT
	actress_name,
	total_votes,
	movie_count,
	actress_avg_rating,
	RANK() OVER(ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM
	top_indian_actresses
)
SELECT 
	*
FROM top_5
WHERE actress_rank < 6;
    
/* Answer 23 : The top five actresses in Hindi movies released in India based on their average ratings are Taapsee Pannu, Kriti Sanon, Divya Dutta,
Shraddha Kapoor and Kriti Kharbanda*/


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH thriller_movie_set AS (
SELECT
	g.movie_id,
	m.title as movie_name,
    g.genre,
    r.avg_rating,
    CASE
		WHEN r.avg_rating >8 THEN 'Superhit movies'
		WHEN r.avg_rating > 7 AND r.avg_rating <= 8 THEN 'Hit movies'
		WHEN r.avg_rating >= 5 AND r.avg_rating <= 7 THEN 'One-time-watch movies'
		ELSE 'Flop movies'
    END AS movie_category
FROM
	genre AS g
	INNER JOIN
	movie AS m
	ON g.movie_id = m.id
	INNER JOIN
	ratings AS r
	ON g.movie_id = r.movie_id
WHERE g.genre REGEXP 'Thriller'
)
SELECT 
	movie_category,
    COUNT(movie_category) as number_of_movies
FROM thriller_movie_set
GROUP BY movie_category
ORDER BY number_of_movies DESC;

-- Answer 24: In thriller movies category, superhit movies are very low.

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH genre_duration_summary AS (
SELECT
	g.genre,
    AVG(m.duration) AS avg_duration,
    SUM(AVG(m.duration)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration, 
    AVG(AVG(m.duration)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS moving_avg_duration
FROM
	genre AS g
	INNER JOIN
	movie AS m
	ON g.movie_id = m.id
GROUP BY g.genre
)
SELECT
	genre,
    avg_duration,
	ROUND(running_total_duration,2) AS running_total_duration,
    ROUND(moving_avg_duration,2) AS moving_avg_duration
FROM genre_duration_summary;

-- Answer 25: Above query provides output shows genre-wise running total and moving average of the average movie duration.

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Creating table with gross collection column as numeric
WITH income_as_int AS (
SELECT
	id,
    CAST(TRIM(LEADING '$' FROM worlwide_gross_income) AS UNSIGNED) AS int_income
FROM movie
), 
-- Top 3 Genres based on most number of movies  
top_3_genre AS (
SELECT
	genre,
    COUNT(movie_id) as movie_count
FROM genre
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 3
), 
high_gross_movies AS (
SELECT
	g.genre,
	m.year,
    m.title AS movie_name,
    m.worlwide_gross_income AS worldwide_gross_income,
    DENSE_RANK() OVER(PARTITION BY m.year ORDER BY gint.int_income DESC) AS movie_rank
FROM
	movie AS m
	INNER JOIN
	genre AS g
	ON m.id = g.movie_id
	INNER JOIN income_as_int AS gint
	ON gint.id = m.id,
    top_3_genre
WHERE g.genre IN (top_3_genre.genre)
) 
SELECT 
	*
FROM 
	high_gross_movies
WHERE movie_rank <= 5;
	
-- Answer 26: Above query provides the five highest-grossing movies of each year that belong to the top three genres.

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH multilingual_summary AS (
SELECT
	production_company,
    COUNT(id) AS movie_count,
    RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_rank
FROM
	movie AS m
	INNER JOIN
	ratings AS r
	ON m.id = r.movie_id
WHERE POSITION(',' IN languages)>0 AND r.median_rating>=8 AND production_company IS NOT NULL
GROUP BY production_company
ORDER BY movie_count DESC
)
SELECT
	*
FROM multilingual_summary
WHERE prod_comp_rank<3;

-- Answer 27 : Star Cinema and Twentieth Fox are the top two production houses that have produced the highest number of hits among multilingual movies.

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Extracting table for superhit movies in dram category
WITH drama_superhit AS (
SELECT
	g.movie_id,
    g.genre,
    r.total_votes,
    r.avg_rating
FROM
	genre AS g
	INNER JOIN
	ratings AS r
	ON g.movie_id = r.movie_id
	WHERE g.genre = 'Drama' AND r.avg_rating > 8
), 
-- Getting actress details
actress_summary AS (
SELECT
	rm.movie_id,
    rm.name_id,
    n.name
FROM
	role_mapping as rm
	INNER JOIN
	names as n
	ON rm.name_id = n.id
WHERE rm.category = 'actress'
),
-- Joining actress summary and drama superhit tables to get the output
top_actress AS (
SELECT
	asum.name AS actress_name,
    SUM(ds.total_votes) AS total_votes,
    COUNT(asum.movie_id) AS movie_count,
    ROUND((SUM(ds.avg_rating*ds.total_votes)/SUM(ds.total_votes)),2) AS actress_avg_rating
FROM
	actress_summary AS asum
	INNER JOIN
	drama_superhit AS ds
	ON asum.movie_id = ds.movie_id
group by  asum.name
ORDER BY movie_count desc
),
top_actress_with_rank AS (
SELECT
	actress_name,
    total_votes,
    movie_count,
    actress_avg_rating,
    RANK() OVER(ORDER BY movie_count desc) AS actress_rank
FROM top_actress
)
SELECT 
	*
FROM top_actress_with_rank
WHERE actress_rank < 4;

/* Answer 28: Top actresses based on number of Super Hit movies (average rating >8) in drama genre are Parvathy Thiruvothu,
Susan Brown, Amanda Lawrwnce and Denise Gough. These actresses have ranks less than 4.*/

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

-- Creating director summary table first and computing all columns except intermovie days
WITH dir_summary AS (
SELECT
	dm.movie_id,
    m.title,
    dm.name_id,
    n.name,
    r.avg_rating,
    r.total_votes,
    m.date_published,
    m.duration
FROM
	director_mapping AS dm
	INNER JOIN
	names AS n
	ON  dm.name_id = n.id
	INNER JOIN
	movie AS m
	ON dm.movie_id = m.id
	INNER JOIN
	ratings AS r
	ON dm.movie_id = r.movie_id
), 
dir_top_part1 AS (
SELECT 
	name_id AS director_id,
    name AS director_name,
    COUNT(movie_id) as number_of_movies,
    ROUND((SUM(avg_rating*total_votes)/SUM(total_votes)),2) AS avg_rating,
    SUM(total_votes) AS total_votes,
    MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
    SUM(duration) AS total_duration
FROM  dir_summary
GROUP BY director_id
ORDER BY number_of_movies DESC
),
-- Creating  table with inter movie days calculation by joining director mapping and movie table. 
-- By using lead and date difference inter movie day is calculated.
dir_inter AS (
SELECT
	dm1.movie_id,
    dm1.name_id,
    m1.date_published
FROM
	director_mapping AS dm1
	INNER JOIN
	movie AS m1
	ON dm1.movie_id = m1.id
ORDER BY
	name_id,
    date_published
), 
next_date_summary AS (
SELECT
	*,
	LEAD(date_published,1) OVER(PARTITION BY name_id ORDER BY date_published) AS next_date
FROM dir_inter
), 
dir_top_part2 AS (
SELECT 
	name_id, 
	ROUND(AVG(datediff(next_date,date_published))) AS avg_inter_movie_days
FROM next_date_summary
GROUP BY name_id
ORDER BY avg_inter_movie_days DESC
),
-- Finally combining the tables dir_top_part1 and dir_top_part2 based on director id
final_9_top_directors AS (
SELECT 
	dp1.director_id, dp1.director_name, dp1.number_of_movies, dp2.avg_inter_movie_days, dp1.avg_rating, dp1.total_votes,
    dp1.min_rating, dp1.max_rating, dp1.total_duration,
    RANK() OVER(ORDER BY number_of_movies DESC) AS dir_rank,
    ROW_NUMBER() OVER(ORDER BY number_of_movies DESC) AS row_num
FROM 
	dir_top_part1 AS dp1
	LEFT JOIN
	dir_top_part2 AS dp2
ON dp1.director_id = dp2.name_id
)
SELECT 
	*
FROM  final_9_top_directors
WHERE dir_rank <= 9;

-- Answer 29: Above query output provides list of top directors with rank less than 10 based on number of movies.


