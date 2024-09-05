-- Changing the search_path to the schema ipl
SHOW search_path;
SET search_path TO ipl;

-- Creating a table called Teams
CREATE TABLE ipl.Teams (
    team_id SERIAL PRIMARY KEY,
    team_name VARCHAR(50) UNIQUE NOT NULL,
    coach VARCHAR(50) NOT NULL,
    home_ground VARCHAR(100) NOT NULL,
    founded_year INTEGER NOT NULL,
    owner VARCHAR(50) NOT NULL
);

-- Creating a table called Players
CREATE TABLE ipl.Players (
    player_id SERIAL PRIMARY KEY,
    player_name VARCHAR(50) NOT NULL,
    team_id INTEGER NOT NULL REFERENCES ipl.Teams(team_id),
    role VARCHAR(30) NOT NULL,
    age INTEGER NOT NULL,
    matches_played INTEGER NOT NULL
);

-- Creating a table called Matches
CREATE TABLE ipl.Matches (
    match_id SERIAL PRIMARY KEY,
    match_date DATE NOT NULL,
    venue VARCHAR(100) NOT NULL,
    team1_id INTEGER NOT NULL REFERENCES ipl.Teams(team_id),
    team2_id INTEGER NOT NULL REFERENCES ipl.Teams(team_id),
    winner_team_id INTEGER REFERENCES ipl.Teams(team_id)
);

-- Creating a table called Fan_Engagement
CREATE TABLE ipl.Fan_Engagement (
    engagement_id SERIAL PRIMARY KEY,
    match_id INTEGER NOT NULL REFERENCES ipl.Matches(match_id),
    fan_id INTEGER NOT NULL,
    engagement_type VARCHAR(50) NOT NULL,
    engagement_time TIMESTAMP NOT NULL
);

-- Inserting values into the table Teams
INSERT INTO ipl.Teams (team_name, coach, home_ground, founded_year, owner)
VALUES 
('Mumbai Indians', 'Mahela Jayawardene', 'Wankhede Stadium', 2008, 'Reliance Industries'),
('Chennai Super Kings', 'Stephen Fleming', 'M. A. Chidambaram Stadium', 2008, 'India Cements'),
('Royal Challengers Bangalore', 'Sanjay Bangar', 'M. Chinnaswamy Stadium', 2008, 'United Spirits'),
('Kolkata Knight Riders', 'Brendon McCullum', 'Eden Gardens', 2008, 'Red Chillies Entertainment'),
('Delhi Capitals', 'Ricky Ponting', 'Arun Jaitley Stadium', 2008, 'GMR Group & JSW Group');

-- Inserting values into the table Players
INSERT INTO ipl.Players (player_name, team_id, role, age, matches_played)
VALUES 
('Rohit Sharma', 1, 'Batsman', 36, 227),
('Jasprit Bumrah', 1, 'Bowler', 30, 120),
('MS Dhoni', 2, 'Wicketkeeper-Batsman', 42, 234),
('Ravindra Jadeja', 2, 'All-Rounder', 35, 210),
('Virat Kohli', 3, 'Batsman', 35, 237),
('AB de Villiers', 3, 'Batsman', 40, 184),
('Andre Russell', 4, 'All-Rounder', 36, 140),
('Sunil Narine', 4, 'Bowler', 35, 144),
('Rishabh Pant', 5, 'Wicketkeeper-Batsman', 26, 98),
('Shikhar Dhawan', 5, 'Batsman', 38, 206);

-- Inserting values into the table Matches
INSERT INTO ipl.Matches (match_date, venue, team1_id, team2_id, winner_team_id)
VALUES 
('2024-04-01', 'Wankhede Stadium', 1, 2, 1),
('2024-04-05', 'M. A. Chidambaram Stadium', 2, 3, 3),
('2024-04-10', 'M. Chinnaswamy Stadium', 3, 4, 4),
('2024-04-15', 'Eden Gardens', 4, 5, 4),
('2024-04-20', 'Arun Jaitley Stadium', 5, 1, 1),
('2024-04-25', 'Wankhede Stadium', 1, 3, 3),
('2024-05-01', 'M. A. Chidambaram Stadium', 2, 5, 2),
('2024-05-05', 'M. Chinnaswamy Stadium', 3, 1, 1),
('2024-05-10', 'Eden Gardens', 4, 2, 2),
('2024-05-15', 'Arun Jaitley Stadium', 5, 4, 4);

-- Inserting values into the table Fan_Engagement
INSERT INTO Fan_Engagement (match_id, fan_id, engagement_type, engagement_time)
VALUES 
(1, 101, 'Tweet', '2024-04-01 18:30:00'),
(1, 102, 'Like', '2024-04-01 18:35:00'),
(2, 103, 'Comment', '2024-04-05 20:00:00'),
(2, 104, 'Share', '2024-04-05 20:05:00'),
(3, 105, 'Tweet', '2024-04-10 16:00:00'),
(3, 106, 'Like', '2024-04-10 16:05:00'),
(4, 107, 'Comment', '2024-04-15 21:00:00'),
(4, 108, 'Share', '2024-04-15 21:10:00'),
(5, 109, 'Tweet', '2024-04-20 19:00:00'),
(5, 110, 'Like', '2024-04-20 19:05:00'),
(6, 111, 'Comment', '2024-04-25 20:00:00'),
(6, 112, 'Share', '2024-04-25 20:10:00'),
(7, 113, 'Tweet', '2024-05-01 18:00:00'),
(7, 114, 'Like', '2024-05-01 18:05:00'),
(8, 115, 'Comment', '2024-05-05 19:30:00'),
(8, 116, 'Share', '2024-05-05 19:35:00'),
(9, 117, 'Tweet', '2024-05-10 20:30:00'),
(9, 118, 'Like', '2024-05-10 20:35:00'),
(10, 119, 'Comment', '2024-05-15 21:45:00'),
(10, 120, 'Share', '2024-05-15 21:50:00');

-- Phase 2 Queries

-- 1. Retrieve the Details of All Matches Played at a Specific Venue = Wankhede Stadium
SELECT * FROM ipl.Matches WHERE venue = 'Wankhede Stadium';

-- 2. List the Players Who Are Older Than 30 Years and Have Played More Than 200 Matches
SELECT player_name, age, matches_played FROM ipl.Players 
WHERE age > 30 AND matches_played > 200;

-- 3. Display the Number of Matches Played with title "Number of Matches" at Each Venue
SELECT * FROM ipl.Players WHERE age > 30 AND matches_played > 200;

-- 4. Find the match dates and venues for matches where the winner was Mumbai Indians
SELECT venue AS "Venue", COUNT(*) AS "Number of Matches" FROM ipl.Matches GROUP BY venue;

-- 5. Retrieve details of all matches played by Mumbai Indians, and the match was won by a team other than Mumbai Indians
SELECT m.match_id, m.match_date, m.venue, t.team_name AS "Winner_Team", (SELECT team_name FROM ipl.Teams WHERE team_name  ILIKE 'Mumbai Indians') AS "Participating_Team" FROM ipl.Matches AS m JOIN ipl.Teams AS t ON m.winner_team_id = t.team_id WHERE m.winner_team_id != 1 AND (m.team1_id = 1 OR m.team2_id = 1);

-- Advanced Queries
-- 1. Find the player who participated in the highest number of winning matches. Display the Player Name along with the total number of winning matches .
SELECT p.player_name, COUNT(m.match_id) AS total_winning_matches FROM ipl.Players p
JOIN ipl.Matches m ON p.team_id = m.winner_team_id
GROUP BY p.player_name ORDER BY total_winning_matches DESC LIMIT 1;

-- 2. Determine the venue with the highest number of matches played and the total fan engagements at that venue. Display the Venue , Total Matches , Total Fan Engagements.
SELECT m.venue, COUNT(m.match_id) AS total_matches, COUNT(f.engagement_id) AS total_fan_engagements FROM ipl.Matches m
LEFT JOIN Fan_Engagement f ON m.match_id = f.match_id
GROUP BY m.venue ORDER BY total_matches DESC LIMIT 1;

-- 3. Find the player who has the most fan engagements across all matches.Display the player name and the count of fan engagements.
SELECT p.player_name, COUNT(f.engagement_id) AS total_fan_engagements FROM ipl.Players p JOIN ipl.Matches m ON p.team_id = m.team1_id OR p.team_id = m.team2_id JOIN Fan_Engagement f ON m.match_id = f.match_id GROUP BY p.player_name ORDER BY total_fan_engagements DESC;

-- 4. Write an SQL query to find out which stadium and match had the highest fan engagement. The query should return the stadium name, match date, and the total number of fan engagements for that match, ordered by the latest match date.
SELECT m.venue, m.match_date, COUNT(f.engagement_id) AS total_fan_engagements
FROM ipl.Matches m JOIN Fan_Engagement f ON m.match_id = f.match_id GROUP BY m.venue, m.match_date, m.match_id ORDER BY total_fan_engagements DESC, m.match_date DESC LIMIT 1;

-- 5. Generate a report for the "Mumbai Indians" that includes details for each match they played: 
-- a. Match date.	b. Opposing team's name.	c. Venue.
-- d. Total number of fan engagements recorded during each match.
-- e. Name of the player from "Mumbai Indians" who has played the most matches up to the date of each match.
SELECT m.match_date,
    CASE WHEN m.team1_id = mi.team_id THEN t2.team_name ELSE t1.team_name
    END AS opposing_team,
    m.venue, COUNT(f.engagement_id) AS total_fan_engagements,
    p.player_name AS top_player
FROM ipl.Matches m
JOIN ipl.Teams mi ON m.team1_id = mi.team_id OR m.team2_id = mi.team_id
LEFT JOIN ipl.Teams t1 ON m.team1_id = t1.team_id
LEFT JOIN ipl.Teams t2 ON m.team2_id = t2.team_id
LEFT JOIN Fan_Engagement f ON m.match_id = f.match_id
JOIN ipl.Players p ON p.team_id = mi.team_id
WHERE mi.team_name = 'Mumbai Indians'
GROUP BY m.match_date, opposing_team, m.venue, p.player_name ORDER BY  m.match_date;

-- Views
-- 1. Create a view named TopPerformers that shows the names of players, their teams, and the number of matches they have played, filtering only those who have played more than 100 matches.
CREATE VIEW ipl.TopPerformers AS SELECT p.player_name, t.team_name, p.matches_played
FROM ipl.Players p JOIN ipl.Teams t ON p.team_id = t.team_id WHERE p.matches_played > 100;

-- 2. Create a view named MatchHighlights that displays the match date, teams involved, venue, and the winner of each match.
CREATE VIEW ipl.MatchHighlights AS SELECT m.match_date, t1.team_name AS team1_name,
t2.team_name AS team2_name, m.venue, COALESCE(tw.team_name, 'Draw') AS winner_name
FROM ipl.Matches m JOIN ipl.Teams t1 ON m.team1_id = t1.team_id JOIN ipl.Teams t2 
ON m.team2_id = t2.team_id LEFT JOIN ipl.Teams tw ON m.winner_team_id = tw.team_id;

-- 3. Create a view named FanEngagementStats that summarizes the total engagements for each match, including match date and venue.
CREATE VIEW ipl.FanEngagementStats AS SELECT m.match_date, m.venue, COUNT(f.engagement_id) AS total_engagements FROM ipl.Matches m LEFT JOIN ipl.Fan_Engagement f ON m.match_id = f.match_id
GROUP BY m.match_date, m.venue;

-- 4. Create a view named TeamPerformance that shows each team's name, the number of matches played, and the number of matches won.
CREATE VIEW ipl.TeamPerformance AS SELECT t.team_name, COUNT(m.match_id) AS matches_played,
COUNT(CASE WHEN m.winner_team_id = t.team_id THEN 1 END) AS matches_won FROM ipl.Teams t
LEFT JOIN ipl.Matches m ON t.team_id = m.team1_id OR t.team_id = m.team2_id GROUP BY t.team_name;
