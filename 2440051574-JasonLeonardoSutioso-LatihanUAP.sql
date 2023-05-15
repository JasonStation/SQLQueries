--2440051574 - Jason Leonardo Sutioso
--Latihan Exercise UAP 'The Externational'

USE The_Externational

--1
SELECT
player_name,
[Team Region] = rt.region_name,
[Player Region] = rp.region_name
FROM region rt JOIN team t ON t.region_id = rt.region_id
JOIN team_detail td ON t.team_id = td.team_id
JOIN player p ON p.player_id = td.player_id
JOIN region rp ON rp.region_id = p.region_id
WHERE rt.region_name LIKE '% %'

--2
SELECT
match_schedule,
team_name,
team_score
FROM
[match] m JOIN match_detail md ON md.match_id = m.match_id
JOIN team t ON md.team_id = t.team_id
WHERE
team_score >= 2 AND DATEDIFF(DAY, match_schedule, '2021-10-20') = 8

--3
SELECT DISTINCT
t.team_name,
[total_play] = COUNT(md.team_id),
[total_score] = SUM(md.team_score)
FROM match_detail md JOIN team t ON t.team_id = md.team_id,
(
	SELECT
	[play_count] = COUNT(md2.team_id),
	t2.team_id
	FROM match_detail md2 JOIN team t2 ON t2.team_id = md2.team_id
	GROUP BY t2.team_id
	
) a,
(	
	SELECT
	[score_count] = SUM(md2.team_score),
	t2.team_id
	FROM match_detail md2 JOIN team t2 ON t2.team_id = md2.team_id
	GROUP BY t2.team_id
) b
GROUP BY t.team_name, a.team_id, b.team_id
HAVING COUNT(md.team_id) = 2 AND SUM(md.team_score) BETWEEN 0 AND 3

USE The_Externational

--4
SELECT
	player_name,
	position_name
FROM
	player p JOIN team_detail td ON p.player_id = td.player_id
	JOIN team t ON td.team_id = t.team_id
	JOIN match_detail md ON t.team_id = md.team_id
	JOIN position po ON td.position_id = po.position_id
WHERE position_name = 'Carry' OR position_name LIKE '%Support%'
GROUP BY player_name, position_name
HAVING SUM(team_score) = 4 OR SUM(team_score) = 5

--5
SELECT
	region_name,
	[Total Team] = COUNT(team_id)
FROM region r JOIN team t ON r.region_id = t.region_id
WHERE r.region_id IN
(
	SELECT
	TOP 1
	r.region_id
	FROM region r JOIN team t ON r.region_id = t.region_id
	GROUP BY r.region_id
	ORDER BY COUNT(t.team_id) ASC
)
GROUP BY r.region_name
UNION
SELECT
	r.region_name,
	[Total Team] = COUNT(t.team_id)
FROM region r JOIN team t ON r.region_id = t.region_id
WHERE r.region_id IN
(
	SELECT
	TOP 1
	r.region_id
	FROM region r JOIN team t ON r.region_id = t.region_id
	GROUP BY r.region_id
	ORDER BY COUNT(t.team_id) DESC
)
GROUP BY r.region_name
ORDER BY [Total Team] DESC

--6
SELECT
ts.team_name,
mds.team_score,
[Opponent] = te.team_name,
[Opponent Score] = mde.team_score,
[Result] = CASE
  WHEN mds.team_score = 2 THEN 'WIN'
  ELSE 'LOSE'
END
FROM 
match_detail mds JOIN team ts ON mds.team_id = ts.team_id
JOIN [match] ms ON ms.match_id = mds.match_id,
match_detail mde JOIN team te ON mde.team_id = te.team_id
JOIN [match] me ON me.match_id = mde.match_id
WHERE ts.team_id IN
(
	SELECT
	team_id
	FROM
	team
	WHERE team_name = 'Team Spirit'
)
AND
te.team_id NOT IN
(
	SELECT
	team_id
	FROM
	team
	WHERE team_name = 'Team Spirit'
)
AND ms.match_schedule = me.match_schedule

--7
CREATE VIEW [Player Who Played the Most]
AS
SELECT
player_name
FROM player p JOIN team_detail td ON td.player_id = p.player_id
JOIN team t ON t.team_id = td.team_id
JOIN match_detail md ON md.team_id = t.team_id,
(
	SELECT [Max Count] = MAX(b.[Player Count])
	FROM
	player p JOIN team_detail td ON td.player_id = p.player_id
	JOIN team t ON t.team_id = td.team_id
	JOIN match_detail md ON md.team_id = t.team_id,
	(
		SELECT [Player Count] = COUNT(player_name)
		FROM
		player p JOIN team_detail td ON td.player_id = p.player_id
		JOIN team t ON t.team_id = td.team_id
		JOIN match_detail md ON md.team_id = t.team_id
		GROUP BY player_name
	) b
) a
GROUP BY player_name
HAVING COUNT(player_name) = MAX(a.[Max Count])


--8
SELECT
player_name,
td.joined_date,
t.team_name
FROM region rt JOIN team t ON t.region_id = rt.region_id
JOIN team_detail td ON t.team_id = td.team_id
JOIN player p ON p.player_id = td.player_id
JOIN region rp ON rp.region_id = p.region_id
WHERE DATEDIFF(YEAR, td.joined_date, '2021-11-01') > 3

--9
SELECT
player_name,
position_name,
team_name,
joined_date
FROM region rt JOIN team t ON t.region_id = rt.region_id
JOIN team_detail td ON t.team_id = td.team_id
JOIN player p ON p.player_id = td.player_id
JOIN region rp ON rp.region_id = p.region_id
JOIN position po ON td.position_id = po.position_id
WHERE YEAR(joined_date) = 2021 AND MONTH(joined_date) < 8

--10
SELECT
	r.region_name,
	[Total Player] = COUNT(player_id)
FROM region r JOIN player p ON p.region_id = r.region_id
WHERE r.region_id IN
(
	SELECT
	TOP 1
	r.region_id
	FROM region r JOIN player p ON p.region_id = r.region_id
	GROUP BY r.region_id
	ORDER BY COUNT(p.player_id) DESC
)
GROUP BY r.region_name
