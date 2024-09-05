import React from 'react';
import {BrowserRouter, Route, Routes} from "react-router-dom";
import Home  from '../components/Home';
import NavBar from '../components/NavBar';
import AddPlayer from '../products/AddPlayer';
import MatchStatistics from  '../products/MatchStatistics';
import TopPlayers from '../products/TopPlayers';
import MatchesByDateRange from '../products/MatchesByDate';

const RouterConfiguration = () => {
  return (
    <>
      <NavBar />
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/add-player" element={<AddPlayer />} />
          <Route path="/match-statistics" element={<MatchStatistics />} />
          <Route path="/top-players" element={<TopPlayers />} />
          <Route path="/matches-by-date" element={<MatchesByDateRange />} />
        </Routes>
      </BrowserRouter>
    </>
  );
};

export default RouterConfiguration;
