SELECT COUNT(*) 
FROM NBA_Injury_2024;
## the correct amount of data was imported
;

SELECT COUNT(*)
FROM NBA_Injuries_2020 
## the correct amount of data was imported
;
-- now that the data has been imported correctly I can start working.

CREATE TABLE Injury2024_cp
LIKE nba_injury_2024
;
INSERT Injury2024_cp
SELECT *
FROM NBA_Injury_2024 
;
SELECT * 
FROM Injury2024_cp 
;
ALTER TABLE Injury2024_cp 
DROP COLUMN `status`
;
ALTER TABLE Injury2024_cp 
DROP COLUMN game

-- Add a new column with DATE type
ALTER TABLE Injury2024_cp ADD COLUMN new_date DATE;

-- Convert and insert values
UPDATE Injury2024_cp
SET new_date = STR_TO_DATE(`DATE`, '%m/%d/%Y');

-- drop old column and rename
ALTER TABLE Injury2024_cp DROP COLUMN `date`;
ALTER TABLE Injury2024_cp CHANGE new_date `date` DATE;
;


SELECT * 
FROM Injury2024_cp

;
## getting only the first instance of every injury
SELECT player, reason, MIN(date) AS date
FROM injury2024_cp
GROUP BY player, reason;

;

CREATE TABLE injury2024_cp2 AS
SELECT player, reason, team, MIN(date) AS date
FROM injury2024_cp
GROUP BY player, reason, team;
;

SELECT * 
FROM Injury2024_cp2

;

SELECT *
FROM Injury2024_cp2
WHERE reason LIKE "%acl%"
;

SELECT MAX(`date`)
FROM Injury2024_cp2
;
SELECT MIN(`date`)
FROM Injury2024_cp2
## this list has only injuries from 21-22 season to 23-24 season,
## so some of the dates for players will have to be readjusted, ex. Kahwi Leonard


SELECT * FROM (
SELECT *
FROM Injury2024_cp2
WHERE reason LIKE "%acl%"

) z_q WHERE player = 'Lewis Jr., Kira'

;

UPDATE Injury2024_cp2
SET reason = LOWER(reason)

;

UPDATE Injury2024_cp2
SET reason = 'torn acl'
WHERE reason LIKE '%acl%'
  AND (
    reason LIKE '%torn%' OR
    reason LIKE '%tear%' OR
    reason LIKE '%surgery%' OR
    reason LIKE "%repair%" OR
    reason like "%recovery%" OR
    reason LIKE "%sprain%" OR
    reason LIKE "%recovery%" OR
    reason LIKE "%3rd%"
    		
  );

SELECT *
FROM Injury2024_cp2
WHERE reason LIKE "%acl%"

SELECT DISTINCT player, reason
FROM Injury2024_cp2
WHERE (player, reason) IN (
    SELECT player, reason
    FROM Injury2024_cp2
    WHERE LOWER(reason) LIKE '%acl%'
)
ORDER BY player

-- I realize that I should have done this after joining the two tables so that is what I will work on now.

;

CREATE TABLE injury2020
LIKE NBA_injuries_2020

; 

INSERT injury2020
SELECT *
FROM NBA_injuries_2020
;


RENAME TABLE NBA_Injuries.injury2020 TO NBA_Injuries.injury2020_cp;

;


SELECT *
FROM injury2020_cp
;

ALTER TABLE injury2020_cp 
DROP COLUMN acquired

;

ALTER TABLE injury2020_cp
RENAME COLUMN Relinquished TO player;
;
ALTER TABLE injury2020_cp
RENAME COLUMN Notes TO reason;

;

DELETE FROM Injury2020_cp
WHERE 
    player = ''

-- Ok now the tables are in the same general form
-- time to join them
    
 SELECT * FROM injury2024_cp2   
    
 
CREATE TABLE Injury_union 
SELECT player, reason, date, team
FROM injury2020_cp

Union 

SELECT player, reason, date, team
FROM injury2024_cp2
;
SELECT * FROM injury_union
;

UPDATE injury_union
SET reason = REPLACE(reason, 'injury/illness -', '')

DELETE FROM injury_union
WHERE reason LIKE '%g league%'

DELETE FROM injury_union
WHERE reason = 'rest'



-- now time to normalize
-- but lets make a copy first

CREATE TABLE injuryU
LIKE injury_union

INSERT injuryU
SELECT * 
FROM injury_union
;

SELECT * FROM injuryU
;

UPDATE injuryU
SET reason = LOWER(reason)

;
SELECT * 
FROM injuryU
WHERE reason LIKE "%acl%"

UPDATE InjuryU
SET reason = 'torn acl'
WHERE reason LIKE '%acl%'
  AND (
    reason LIKE '%torn%' OR
    reason LIKE '%tear%' OR
    reason LIKE '%surgery%' OR
    reason LIKE "%repair%" 
)
## pau gasol is the only person to list a acl injury and not have a torn acl

;

SELECT * 
FROM injuryU
WHERE reason LIKE "%achilles%"
;

UPDATE InjuryU
SET reason = 'torn achilles'
WHERE reason LIKE '%achille%'
  AND (
    reason LIKE '%torn%' OR
    reason LIKE '%tear%' OR
    reason LIKE '%surgery%' OR
    reason LIKE "%repair%" OR 
    reason LIKE "%rupture%"
    
)
## piere jackson tore his achilles but not listed as it, maybe cause it was in the G league. I suppose I will add him, can always remove later
UPDATE InjuryU
SET reason = 'torn achilles'
WHERE player = "Pierre Jackson" AND reason = 'right achilles tendon injury (out indefinitely)'

-- now its time to create a table for just ACL and Achilles
;

CREATE TABLE acl_ach_tear
LIKE injuryU

;

INSERT acl_ach_tear
SELECT *
FROM injuryU
WHERE reason = "torn acl"
OR reason = "torn achilles"
;
SELECT *
FROM acl_ach_tear
;
SELECT *
FROM acl_ach_tear 
WHERE player Like "%Klay%"

## klay thompson tore both his acl and his achilles, I will have to exlude him from certain measurements

;
SELECT * 
FROM acl_ach_tear 
WHERE player LIKE "%danilo%"
## the names are reversed in the second half of the list, I will have to fix that.
;

SELECT *
FROM acl_ach_tear
ORDER BY player
;

## the names are reversed in the second half of the list, I will have to fix that.

UPDATE acl_ach_tear
SET player = CONCAT(
    TRIM(SUBSTRING_INDEX(player, ',', -1)), ' ',
    TRIM(SUBSTRING_INDEX(player, ',', 1))
)
WHERE player LIKE '%,%';



## danilo Gallinari, Ricky Rubio, Jabari parker and Micheal redd(once in 2009 before the list) tore their acl twice


SELECT player
FROM acl_ach_tear
WHERE reason IN ('torn acl', 'torn achilles')
GROUP BY player
HAVING COUNT(DISTINCT reason) = 2;

# Demarcus cousins and klay thompson

SELECT * 
FROM acl_ach_tear




## trying to select so that it only includes players initial injury date.

CREATE TEMPORARY TABLE temp4 AS
SELECT DISTINCT i.player, i.reason, i.date, i.team
FROM acl_ach_tear as i
JOIN (
	SELECT player, reason, MIN(date) as min_date
	from acl_ach_tear
	GROUP BY player, reason
	
) AS first
ON i.player = first.player AND i.reason = first.reason
WHERE i.date = first.min_date
	OR i.date > DATE_ADD(first.min_date, INTERVAL 28 MONTH)

;
SELECT * 
FROM temp4
;
SELECT player
FROM temp4
GROUP BY player 
HAVING COUNT(date) > 1
;

SELECT * FROM temp3 
WHERE player LIKE "%rush%"
;
SELECT player
FROM temp4
GROUP BY player 
HAVING count(player) > 2
;

DELETE FROM temp4
WHERE player = 'Ricky Rubio' AND `date` > '2022-01-02'

##OK my temp 4 table is all set, Now I just have to add missing value to it. the ones from 2020 and 

CREATE TABLE Injury_final AS
SELECT DISTINCT i.player, i.reason, i.date, i.team
FROM acl_ach_tear as i
JOIN (
	SELECT player, reason, MIN(date) as min_date
	from acl_ach_tear
	GROUP BY player, reason
	
) AS first
ON i.player = first.player AND i.reason = first.reason
WHERE i.date = first.min_date
	OR i.date > DATE_ADD(first.min_date, INTERVAL 28 MONTH)
;


SELECT player
FROM injury_final
GROUP BY player 
HAVING count(player) > 2

DELETE FROM injury_final
WHERE player = 'Ricky Rubio' AND `date` > '2022-01-02'


SELECT * FROM INJURY_FINAL

INSERT INTO injury_final (player, reason, date, team) VALUES
('Tyrese Haliburton', 'torn achilles', '2025-06-23', 'Indiana Pacers'),
('Jayson Tatum', 'torn achilles', '2025-05-12', 'Boston Celtics'),
('Dejounte Murray', 'torn achilles', '2025-01-31', 'New Orleans Pelicans'),
('Damian Lillard', 'torn achilles', '2025-04-27', 'Milwaukee Bucks'),
('Isaiah Jackson', 'torn achilles', '2024-11-01', 'Indiana Pacers'),
('James Wiseman', 'torn achilles', '2024-10-23', 'Indiana Pacers'),
('Dru Smith', 'torn achilles', '2024-12-23', 'Miami Heat'),
('Kyrie Irving', 'Torn achilles', '2025-03-03', 'Dallas Mavericks'),
('Grant Williams', 'Torn ACL ', '2024-11-23', 'Charlotte Hornets'),
('Anthony Melton', 'Torn ACL', '2024-11-20', 'Brooklyn Nets'),
('Moritz Wagner', 'Torn ACL', '2024-12-21', 'Orlando Magic'),
('Spencer Dinwiddie', 'Torn ACL', '2020-12-27', 'Brooklyn Nets'),
('Markelle Fultz', 'Torn ACL', '2021-01-06', 'Orlando Magic'),
('Thomas Bryant', 'Torn ACL', '2021-01-09', 'Washington Wizards'),
('Jamal Murray', 'Torn ACL', '2021-04-12', 'Denver Nuggets'),
('Kawhi Leonard', 'Torn ACL', '2021-07-13', 'Los Angeles Clippers'),
('Dario Šarić', 'Torn ACL', '2021-07-06', 'Phoenix Suns'),
('Klay Thompson', 'torn achilles', '2020-11-19', 'Golden State Warriors'),
('Chris Clemons', 'torn achilles', '2021-12-15', 'Houston Rockets');

SELECT * 
FROM INJURY_FINAL
ORDER BY player
;
SELECT player
FROM injury_final
GRoup BY player
HAVING COUNT(date) > 1
;
DELETE FROM Injury_final 
WHERE player = "Klay Thompson" AND date = '2021-10-19'
;
UPDATE injury_final
SET reason = LOWER(reason)


