import axios from "axios";

const BASE_URL = 'http://localhost:5045/api/IPL';

async function addPlayer(player) {
  try {
    const response = await axios.post(`${BASE_URL}/add-player`, player);
    if (response.status === 201) {
      console.log('Player added successfully:', response.data);
      return response.data;
    } else {
      console.error('Failed to add player:', response.statusText);
      return null;
    }
  } catch (error) {
    console.error('Error adding player:', error);
    return null;
  }
}

async function getMatchStatistics() {
  try {
    const response = await axios.get(`${BASE_URL}/match-statistics`);
    if (response.status === 200) {
      console.log('Match statistics:', response.data);
      return response.data;
    } else {
      console.error('Failed to retrieve match statistics:', response.statusText);
      return null;
    }
  } catch (error) {
    console.error('Error retrieving match statistics:', error);
    return null;
  }
}

async function getTopPlayersByFanEngagements() {
  try {
    const response = await axios.get(`${BASE_URL}/top-players`);
    if (response.status === 200) {
      console.log('Top players by fan engagements:', response.data);
      return response.data;
    } else {
      console.error('Failed to retrieve top players:', response.statusText);
      return null;
    }
  } catch (error) {
    console.error('Error retrieving top players:', error);
    return null;
  }
}

async function getMatchesByDateRange(startDate, endDate) {
  try {
    const response = await axios.get(`${BASE_URL}/matches-by-date`, {
      params: { startDate, endDate }
    });
    if (response.status === 200) {
      console.log('Matches by date range:', response.data);
      return response.data;
    } else {
      console.error('Failed to retrieve matches:', response.statusText);
      return null;
    }
  } catch (error) {
    console.error('Error retrieving matches:', error);
    return null;
  }
}

export { addPlayer, getMatchStatistics, getTopPlayersByFanEngagements, getMatchesByDateRange };
