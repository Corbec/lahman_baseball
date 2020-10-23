--1. What range of years for baseball games played does the provided database cover? 

SELECT MIN(yearid), MAX(yearid)
FROM teams;
-- 1871 - 2016

/*5. Find the average number of strikeouts per game by decade since 1920. 
Round the numbers you report to 2 decimal places. Do the same for home runs per game. 
Do you see any trends?*/
/*
table = pitching
SO HR COUNT GAME yearid
*/

/*
SELECT EXTRACT('decade' FROM yearid::text::date) as decade, AVG(so/g) as AVG_so

SELECT (FLOOR(yearid/10)*10) as decade, ROUND(AVG(so/g),2) as AVG_so
FROM pitching
WHERE yearid > 1920
GROUP by decade
ORDER BY decade DESC;
*/

SELECT * FROM pitching;

SELECT ROUND(AVG(so/g),2) as AVG_so 
FROM (SELECT SUM(so), (FLOOR(yearid/10)*10) as decade
	  FROM pitching 
	  WHERE yearid BETWEEN '1920' AND '2016' 
GROUP by decade
ORDER BY decade DESC;

WITH avg_so_per_game as (SELECT SUM(so) as so, g, (FLOOR(yearid/10)*10) as decade
								FROM pitching
								WHERE yearid BETWEEN '1920' AND '2016'
								GROUP BY decade, so, g
								HAVING g = 
										(SELECT SUM(g) FROM pitching)
								ORDER BY decade DESC)
SELECT ROUND(AVG(so/g),2) as avg_so
FROM avg_so_per_game
	  GROUP BY avg_so_per_game;
	  
	  
	  
SELECT ROUND(AVG(so/g),2) as AVG_so, (FLOOR(yearid/10)*10) 
FROM (SELECT SUM(so) FROM pitching as so
	   	    (SELECT(FLOOR(yearid/10)*10) FROM pitching
			WHERE yearid BETWEEN '1920' AND '2016';
GROUP by yearid
ORDER BY yearid DESC;
	  
SELECT SUM(so) as so, g, (FLOOR(yearid/10)*10) as decade
								FROM pitching
								WHERE yearid BETWEEN '1920' AND '2016'
								GROUP BY decade, so, g
								HAVING g = 
										(SELECT SUM(g) FROM pitching)
								ORDER BY decade DESC;
/*
 yearid AVG(COUNT(pitching.so))


FROM pitching;
 

CASE WHEN decade AS(yearid 

> 1920
ROUND , 2 

team.so pitching.so 



AVG COUNT homeruns



*/
SELECT * FROM pitching;
