/* Question # 4
Using the fielding table, group players into three groups based on their position: 
label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", 
and those with position "P" or "C" as "Battery".
Determine the number of putouts made by each of these three groups in 2016.*/

SELECT 
	CASE WHEN pos LIKE 'OF' THEN 'Outfield'
		WHEN pos LIKE 'C' THEN 'Battery'
		WHEN pos LIKE 'P' THEN 'Battery'
		ELSE 'Infield' END AS fielding_group,
	SUM(po) AS putouts
FROM fielding
WHERE yearid = 2016
GROUP BY fielding_group;

/* Question #7
From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? 
What is the smallest number of wins for a team that did win the world series? 
Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. 
Then redo your query, excluding the problem year. 
How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?*/

SELECT teamid, 
	w,
	yearid
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
AND wswin = 'N'
GROUP BY teamid, yearid, w
ORDER BY w DESC
LIMIT 1;

-- 116 wins without winning the World Series (Seattle in 2001)

SELECT teamid, 
	w,
	yearid
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
AND yearid != 1981
AND wswin = 'Y'
GROUP BY teamid, yearid, w
ORDER BY w
LIMIT 1;

-- There was a player's strike in 1981 that shortened the season. The 2006 season had 83 wins for World Series Winner (St Louis).

SELECT yearid,
	MAX(w)
FROM teams
WHERE yearid BETWEEN 1970 and 2016
AND wswin = 'Y'
GROUP BY yearid
INTERSECT
SELECT yearid,
	MAX(w)
FROM teams
WHERE yearid BETWEEN 1970 and 2016
GROUP BY yearid
ORDER BY yearid;

-- The team with the highest number of wins won the world series 12 times between 1970 and 2016.

WITH ws_winners AS (SELECT yearid,
						MAX(w)
					FROM teams
					WHERE yearid BETWEEN 1970 and 2016
					AND wswin = 'Y'
					GROUP BY yearid
					INTERSECT
					SELECT yearid,
						MAX(w)
					FROM teams
					WHERE yearid BETWEEN 1970 and 2016
					GROUP BY yearid
					ORDER BY yearid)
SELECT (COUNT(ws.yearid)/COUNT(t.yearid)::float)*100 AS percentage
FROM teams as t LEFT JOIN ws_winners AS ws ON t.yearid = ws.yearid
WHERE t.wswin IS NOT NULL
AND t.yearid BETWEEN 1970 AND 2016;

-- The team with the highest number of wins won the World Series 26% of the time between 1970 and 2016.


-- Question 5 from review with a generate series
WITH decades as (	
	SELECT 	generate_series(1920,2010,10) as low_b,
			generate_series(1929,2019,10) as high_b)
			
SELECT 	low_b as decade,
		--SUM(so) as strikeouts,
		--SUM(g)/2 as games,  -- used last 2 lines to check that each step adds correctly
		ROUND(SUM(so::numeric)/(sum(g::numeric)/2),2) as SO_per_game,  -- note divide by 2, since games are played by 2 teams
		ROUND(SUM(hr::numeric)/(sum(g::numeric)/2),2) as hr_per_game
FROM decades LEFT JOIN teams
	ON yearid BETWEEN low_b AND high_b
GROUP BY decade
ORDER BY decade

-- Mahesh's Answers
--# 8
WITH mngr_list AS (SELECT playerid, awardid, COUNT(DISTINCT lgid) AS lg_count
				   FROM awardsmanagers
				   WHERE awardid = ‘TSN Manager of the Year’
				   		 AND lgid IN (‘NL’, ‘AL’)
				   GROUP BY playerid, awardid
				   HAVING COUNT(DISTINCT lgid) = 2),
	 mngr_full AS (SELECT playerid, awardid, lg_count, yearid, lgid
				   FROM mngr_list INNER JOIN awardsmanagers USING(playerid, awardid))
SELECT namegiven, namelast, name AS team_name
FROM mngr_full INNER JOIN people USING(playerid)
	 INNER JOIN managers USING(playerid, yearid, lgid)
	 INNER JOIN teams ON mngr_full.yearid = teams.yearid AND mngr_full.lgid = teams.lgid AND managers.teamid = teams.teamid
GROUP BY namegiven, namelast, name;

-- Openended questions


