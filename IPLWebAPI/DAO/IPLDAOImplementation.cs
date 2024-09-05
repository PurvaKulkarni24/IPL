using Npgsql;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using IPLWebAPI.Models;
using static IPLWebAPI.Models.IPL;

namespace IPLWebAPI.DAO
{
    public class IPLDAOImplementation : IIPLDAO
    {
        private readonly NpgsqlConnection _connection;

        public IPLDAOImplementation(NpgsqlConnection connection)
        {
            _connection = connection;
        }

        public async Task<int> AddPlayerAsync(Player player)
        {
            int rowsInserted = 0;
            string insertQuery = @"
                INSERT INTO ipl.Players (player_name, team_id, role, age, matches_played)
                VALUES (@PlayerName, @TeamID, @Role, @Age, @MatchesPlayed)";

            try
            {
                if (_connection.State != ConnectionState.Open)
                {
                    await _connection.OpenAsync();
                }

                using (var command = new NpgsqlCommand(insertQuery, _connection))
                {
                    command.CommandType = CommandType.Text;
                    command.Parameters.AddWithValue("@PlayerName", player.PlayerName);
                    command.Parameters.AddWithValue("@TeamID", player.TeamID);
                    command.Parameters.AddWithValue("@Role", player.Role);
                    command.Parameters.AddWithValue("@Age", player.Age);
                    command.Parameters.AddWithValue("@MatchesPlayed", player.MatchesPlayed);

                    rowsInserted = await command.ExecuteNonQueryAsync();
                }
            }
            catch (NpgsqlException e)
            {
                Console.WriteLine("--------Exception-------- " + e.Message);
                throw;
            }
            finally
            {
                if (_connection.State != ConnectionState.Closed)
                {
                    await _connection.CloseAsync();
                }
            }

            return rowsInserted;
        }

        public async Task<List<MatchStatistics>> GetMatchStatisticsAsync()
        {
            var matchStatsList = new List<MatchStatistics>();
            string query = @"
                SELECT m.match_date, m.venue, t1.team_name AS team1_name, t2.team_name AS team2_name,
                       COALESCE(COUNT(f.engagement_id), 0) AS total_fan_engagements
                FROM ipl.Matches m
                JOIN ipl.Teams t1 ON m.team1_id = t1.team_id
                JOIN ipl.Teams t2 ON m.team2_id = t2.team_id
                LEFT JOIN ipl.Fan_Engagement f ON m.match_id = f.match_id
                GROUP BY m.match_date, m.venue, t1.team_name, t2.team_name";

            try
            {
                await _connection.OpenAsync();
                using var command = new NpgsqlCommand(query, _connection);
                using var reader = await command.ExecuteReaderAsync();

                while (await reader.ReadAsync())
                {
                    var matchStat = new MatchStatistics
                    {
                        MatchDate = reader.GetDateTime(0),
                        Venue = reader.GetString(1),
                        Team1Name = reader.GetString(2),
                        Team2Name = reader.GetString(3),
                        TotalFanEngagements = reader.GetInt32(4)
                    };

                    matchStatsList.Add(matchStat);
                }
            }
            catch (NpgsqlException e)
            {
                Console.WriteLine("--------Exception-------- " + e.Message);
                throw;
            }
            finally
            {
                await _connection.CloseAsync();
            }

            return matchStatsList;
        }

        public async Task<List<PlayerPerformance>> GetTopPlayersByFanEngagementsAsync()
        {
            var topPlayers = new List<PlayerPerformance>();
            string query = @"
                WITH PlayerMatchEngagements AS (
                    SELECT p.player_name, p.team_id, COUNT(m.match_id) AS matches_played,
                           SUM(COALESCE(f.engagement_count, 0)) AS total_fan_engagements
                    FROM ipl.Players p
                    JOIN ipl.Matches m ON p.team_id = m.team1_id OR p.team_id = m.team2_id
                    LEFT JOIN (
                        SELECT match_id, COUNT(engagement_id) AS engagement_count
                        FROM ipl.Fan_Engagement
                        GROUP BY match_id
                    ) f ON m.match_id = f.match_id
                    GROUP BY p.player_name, p.team_id
                )
                SELECT player_name, matches_played, total_fan_engagements
                FROM PlayerMatchEngagements
                ORDER BY total_fan_engagements DESC
                LIMIT 5";

            try
            {
                await _connection.OpenAsync();
                using var command = new NpgsqlCommand(query, _connection);
                using var reader = await command.ExecuteReaderAsync();

                while (await reader.ReadAsync())
                {
                    var player = new PlayerPerformance
                    {
                        PlayerName = reader.GetString(0),
                        MatchesPlayed = reader.GetInt32(1),
                        TotalFanEngagements = reader.GetInt32(2)
                    };

                    topPlayers.Add(player);
                }
            }
            catch (NpgsqlException e)
            {
                Console.WriteLine("--------Exception-------- " + e.Message);
                throw;
            }
            finally
            {
                await _connection.CloseAsync();
            }

            return topPlayers;
        }

        public async Task<List<MatchDetails>> GetMatchesByDateRangeAsync(DateTime startDate, DateTime endDate)
        {
            var matchDetailsList = new List<MatchDetails>();
            string query = @"
                SELECT m.match_id, m.match_date, m.venue, t1.team_name AS team1_name, t2.team_name AS team2_name
                FROM ipl.Matches m
                JOIN ipl.Teams t1 ON m.team1_id = t1.team_id
                JOIN ipl.Teams t2 ON m.team2_id = t2.team_id
                WHERE m.match_date BETWEEN @StartDate AND @EndDate";

            try
            {
                await _connection.OpenAsync();
                using var command = new NpgsqlCommand(query, _connection);
                command.Parameters.AddWithValue("@StartDate", startDate);
                command.Parameters.AddWithValue("@EndDate", endDate);
                using var reader = await command.ExecuteReaderAsync();

                while (await reader.ReadAsync())
                {
                    var matchDetail = new MatchDetails
                    {
                        MatchID = reader.GetInt32(0),
                        MatchDate = reader.GetDateTime(1),
                        Venue = reader.GetString(2),
                        Team1Name = reader.GetString(3),
                        Team2Name = reader.GetString(4)
                    };

                    matchDetailsList.Add(matchDetail);
                }
            }
            catch (NpgsqlException e)
            {
                Console.WriteLine("--------Exception-------- " + e.Message);
                throw;
            }
            finally
            {
                await _connection.CloseAsync();
            }

            return matchDetailsList;
        }
    }
}



