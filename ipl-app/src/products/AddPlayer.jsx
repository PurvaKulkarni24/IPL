import React, { useState } from 'react';
import { addPlayer } from '../services/productApiServices';
import 'bootstrap/dist/css/bootstrap.min.css';

const AddPlayer = () => {
  const [playerName, setPlayerName] = useState('');
  const [teamID, setTeamID] = useState('');
  const [role, setRole] = useState('');
  const [age, setAge] = useState('');
  const [matchesPlayed, setMatchesPlayed] = useState('');
  const [errors, setErrors] = useState({});

  const validateForm = () => {
    const newErrors = {};
    if (!playerName) newErrors.playerName = 'Player Name is required';
    if (!teamID || isNaN(teamID) || teamID <= 0) newErrors.teamID = 'Valid Team ID is required';
    if (!role) newErrors.role = 'Role is required';
    if (!age || isNaN(age) || age <= 0) newErrors.age = 'Valid Age is required';
    if (!matchesPlayed || isNaN(matchesPlayed) || matchesPlayed < 0) newErrors.matchesPlayed = 'Valid Matches Played is required';
    return newErrors;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const newErrors = validateForm();
    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }

    const playerData = {
      playerName,
      teamID,
      role,
      age,
      matchesPlayed,
    };

    const res = await addPlayer(playerData);
    if (res) {
      setPlayerName('');
      setTeamID('');
      setRole('');
      setAge('');
      setMatchesPlayed('');
      alert('Player Added Successfully');
    } else {
      alert('Failed to add player');
    }
  };

  return (
    <div className="container mt-5">
      <h1>Add Player</h1>
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="playerName">Player Name</label>
          <input
            type="text"
            className="form-control"
            id="playerName"
            value={playerName}
            onChange={(e) => setPlayerName(e.target.value)}
          />
          {errors.playerName && <div className="text-danger">{errors.playerName}</div>}
        </div>
        <div className="form-group">
          <label htmlFor="teamID">Team ID</label>
          <input
            type="number"
            className="form-control"
            id="teamID"
            value={teamID}
            onChange={(e) => setTeamID(e.target.value)}
          />
          {errors.teamID && <div className="text-danger">{errors.teamID}</div>}
        </div>
        <div className="form-group">
          <label htmlFor="role">Role</label>
          <input
            type="text"
            className="form-control"
            id="role"
            value={role}
            onChange={(e) => setRole(e.target.value)}
          />
          {errors.role && <div className="text-danger">{errors.role}</div>}
        </div>
        <div className="form-group">
          <label htmlFor="age">Age</label>
          <input
            type="number"
            className="form-control"
            id="age"
            value={age}
            onChange={(e) => setAge(e.target.value)}
          />
          {errors.age && <div className="text-danger">{errors.age}</div>}
        </div>
        <div className="form-group">
          <label htmlFor="matchesPlayed">Matches Played</label>
          <input
            type="number"
            className="form-control"
            id="matchesPlayed"
            value={matchesPlayed}
            onChange={(e) => setMatchesPlayed(e.target.value)}
          />
          {errors.matchesPlayed && <div className="text-danger">{errors.matchesPlayed}</div>}
        </div>
        <button type="submit" className="btn btn-primary">Add Player</button>
      </form>
    </div>
  );
};

export default AddPlayer;
