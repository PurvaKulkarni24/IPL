using Microsoft.AspNetCore.Mvc;
using IPLWebAPI.DAO;
using IPLWebAPI.Models;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using static IPLWebAPI.Models.IPL;

namespace IPLWebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class IPLController : ControllerBase
    {
        private readonly IIPLDAO _dao;

        public IPLController(IIPLDAO dao)
        {
            _dao = dao;
        }

        [HttpPost("add-player")]
        public async Task<IActionResult> AddPlayer([FromBody] Player player)
        {
            if (player == null)
            {
                return BadRequest("Player details are required.");
            }

            if (string.IsNullOrWhiteSpace(player.PlayerName) || player.TeamID <= 0 || player.Age <= 0)
            {
                return BadRequest("Invalid player details.");
            }

            var rowsInserted = await _dao.AddPlayerAsync(player);
            if (rowsInserted > 0)
            {
                return CreatedAtAction(nameof(AddPlayer), new { playerName = player.PlayerName }, player);
            }

            return StatusCode(500, "Failed to add player.");
        }

        [HttpGet("match-statistics")]
        public async Task<IActionResult> GetMatchStatistics()
        {
            var matchStats = await _dao.GetMatchStatisticsAsync();
            if (matchStats != null && matchStats.Count > 0)
            {
                return Ok(matchStats);
            }

            return NotFound("No match statistics found.");
        }

        [HttpGet("top-players")]
        public async Task<IActionResult> GetTopPlayersByFanEngagements()
        {
            var topPlayers = await _dao.GetTopPlayersByFanEngagementsAsync();
            if (topPlayers != null && topPlayers.Count > 0)
            {
                return Ok(topPlayers);
            }

            return NotFound("No top players found.");
        }

        [HttpGet("matches-by-date")]
        public async Task<IActionResult> GetMatchesByDateRange([FromQuery] DateTime startDate, [FromQuery] DateTime endDate)
        {
            if (startDate > endDate)
            {
                return BadRequest("Start date must be earlier than end date.");
            }

            var matches = await _dao.GetMatchesByDateRangeAsync(startDate, endDate);
            if (matches != null && matches.Count > 0)
            {
                return Ok(matches);
            }

            return NotFound("No matches found for the specified date range.");
        }
    }
}
