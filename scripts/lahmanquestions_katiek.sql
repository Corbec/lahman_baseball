/*3. Find all players in the database who played at Vanderbilt University. 
Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. 
Sort this list in descending order by the total salary earned. 
Which Vanderbilt player earned the most money in the majors?*/
					
SELECT concat(people.namefirst,' ', people.namelast) as player, CAST(SUM(salaries.salary::numeric) as money)
FROM collegeplaying
INNER JOIN schools on collegeplaying.schoolid = schools.schoolid
INNER JOIN people on people.playerid = collegeplaying.playerid
INNER JOIN salaries on people.playerid = salaries.playerid
WHERE schoolname LIKE 'Vanderbilt%'
GROUP BY player
ORDER BY sum DESC;

--David Price


/*6. Find the player who had the most success stealing bases in 2016, 
where success is measured as the percentage of stolen base attempts which are successful. 
(A stolen base attempt results either in a stolen base or being caught stealing.) 
Consider only players who attempted at least 20 stolen bases.*/

SELECT concat(people.namefirst,' ', people.namelast) as player, ROUND((SB::decimal/(SB+CS)::decimal)*100) as sb_success
FROM batting
INNER JOIN people on people.playerid = batting.playerid
WHERE yearid = 2016
AND (SB+CS)>20
ORDER BY sb_success DESC;

--Chris Owings


/*9.Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? 
Give their full name and the teams that they were managing when they won the award.*/

--https://en.wikipedia.org/wiki/Sporting_News_Manager_of_the_Year_Award - 1936-1985 only one manager in either league was given the award

WITH winners AS (SELECT playerID
FROM awardsmanagers
WHERE awardID LIKE 'TSN Man%'
AND lgID LIKE 'AL'
INTERSECT
SELECT playerID
FROM awardsmanagers
WHERE awardID LIKE 'TSN Man%'
AND lgID LIKE 'NL')
SELECT concat(people.namefirst,' ', people.namelast) as manager, teams.name
FROM awardsmanagers
	INNER JOIN winners on  awardsmanagers.playerid = winners.playerid
	INNER JOIN people on winners.playerid = people.playerid
	INNER JOIN managers on winners.playerid = managers.playerid
	INNER JOIN teams on managers.teamid = teams.teamid
GROUP BY teams.name, concat(people.namefirst,' ', people.namelast)
ORDER BY manager;

--teams should be Marlins, Pirates, Nationals & Orioles

