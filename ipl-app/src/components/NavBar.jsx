import React from "react";
import { Link } from "react-router-dom";

const NavBar = () => {
  return (
    <nav className="navbar navbar-expand-lg navbar-light bg-light">
      <button
        className="navbar-toggler"
        type="button"
        data-toggle="collapse"
        data-target="#navbarNavAltMarkup"
        aria-controls="navbarNavAltMarkup"
        aria-expanded="false"
        aria-label="Toggle navigation"
      >
        <span className="navbar-toggler-icon"></span>
      </button>
      <div className="collapse navbar-collapse" id="navbarNavAltMarkup">
        <div className="navbar-nav">
          <a className="nav-item nav-link active" href="/">
            Home
          </a>
          <a className="nav-item nav-link active" href="/add-player">
            Add Player
          </a>
          <a className="nav-item nav-link" href="/match-statistics">
            Match Statistics
          </a>
          <a className="nav-item nav-link" href="/top-players">
            Top Players          
          </a>
          <a className="nav-item nav-link" href="/matches-by-date">
            Matches By Date     
          </a>
        </div>
      </div>
    </nav>
  );
};

export default NavBar;
