import React, { useEffect, useState } from 'react';
import { getMatchStatistics } from '../services/productApiServices';
import 'bootstrap/dist/css/bootstrap.min.css';

const MatchStatistics = () => {
  const [matchStats, setMatchStats] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchMatchStatistics = async () => {
      try {
        const data = await getMatchStatistics();
        console.log('Fetched match statistics:', data); // Log the data
        setMatchStats(data);
      } catch (error) {
        console.error('Failed to fetch match statistics', error);
      } finally {
        setLoading(false);
      }
    };

    fetchMatchStatistics();
  }, []);

  return (
    <div className="container mt-5">
      <h1>Match Statistics</h1>
      {loading ? <p>Loading...</p> : (
        <table className="table table-striped">
          <thead>
            <tr>
              <th>Date</th>
              <th>Venue</th>
              <th>Team 1</th>
              <th>Team 2</th>
              <th>Total Fan Engagements</th>
            </tr>
          </thead>
          <tbody>
            {matchStats.map((stat, index) => {
              const matchDate = new Date(stat.MatchDate);
              return (
                <tr key={index}>
                  <td>{isNaN(matchDate.getTime()) ? 'Invalid Date' : matchDate.toLocaleDateString()}</td>
                  <td>{stat.Venue}</td>
                  <td>{stat.Team1Name}</td>
                  <td>{stat.Team2Name}</td>
                  <td>{stat.TotalFanEngagements}</td>
                </tr>
              );
            })}
          </tbody>
        </table>
      )}
    </div>
  );
};

export default MatchStatistics;
