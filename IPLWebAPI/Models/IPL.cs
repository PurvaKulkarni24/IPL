using System.ComponentModel.DataAnnotations;
using System.Diagnostics.CodeAnalysis;
namespace IPLWebAPI.Models
{
    public class IPL
    {
        public class Player
        {
            public string PlayerName { get; set; }
            public int TeamID { get; set; }
            public string Role { get; set; }
            public int Age { get; set; }
            public int MatchesPlayed { get; set; }
        }

        public class MatchStatistics
        {
            public DateTime MatchDate { get; set; }
            public string Venue { get; set; }
            public string Team1Name { get; set; }
            public string Team2Name { get; set; }
            public int TotalFanEngagements { get; set; }
        }

        public class PlayerPerformance
        {
            public string PlayerName { get; set; }
            public int MatchesPlayed { get; set; }
            public int TotalFanEngagements { get; set; }
        }

        public class MatchDetails
        {
            public int MatchID { get; set; }
            public DateTime MatchDate { get; set; }
            public string Venue { get; set; }
            public string Team1Name { get; set; }
            public string Team2Name { get; set; }
        }
    }
}
