using IPLWebAPI.Models;
using static IPLWebAPI.Models.IPL;
namespace IPLWebAPI.DAO
{
    public interface IIPLDAO
    {
        Task<int> AddPlayerAsync(Player player);
        Task<List<MatchStatistics>> GetMatchStatisticsAsync();
        Task<List<PlayerPerformance>> GetTopPlayersByFanEngagementsAsync();
        Task<List<MatchDetails>> GetMatchesByDateRangeAsync(DateTime startDate, DateTime endDate);
    }
}
