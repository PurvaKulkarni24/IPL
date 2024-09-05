import React, { useEffect, useState } from 'react';
import { getTopPlayersByFanEngagements } from '../services/productApiServices';
import 'bootstrap/dist/css/bootstrap.min.css';

const TopPlayers = () => {
  const [topPlayers, setTopPlayers] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchTopPlayers = async () => {
      try {
        const data = await getTopPlayersByFanEngagements();
        console.log('Fetched top players:', data); // Log the data
        setTopPlayers(data);
      } catch (error) {
        console.error('Failed to fetch top players', error);
      } finally {
        setLoading(false);
      }
    };

    fetchTopPlayers();
  }, []);

  return (
    <div className="container mt-5">
      <h1>Top Players by Fan Engagements</h1>
      {loading ? <p>Loading...</p> : (
        <table className="table table-striped">
          <thead>
            <tr>
              <th>Player Name</th>
              <th>Matches Played</th>
              <th>Total Fan Engagements</th>
            </tr>
          </thead>
          <tbody>
            {topPlayers.map((player, index) => (
              <tr key={index}>
                <td>{player.PlayerName}</td>
                <td>{player.MatchesPlayed}</td>
                <td>{player.TotalFanEngagements}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
};

export default TopPlayers;
