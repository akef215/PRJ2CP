import React from "react";
import "./styles/Stats.css";
import logo from "../images/logo _final.png";
import user from "../images/user.png";
import { Bar, Doughnut, Line } from "react-chartjs-2";
import LineData from "./data/LineData.json";
// Importation de Chart.js et du plugin d'annotation
import { Chart as ChartJS, defaults } from "chart.js/auto";
import annotationPlugin from "chartjs-plugin-annotation";
import { useNavigate } from "react-router-dom";
ChartJS.register(annotationPlugin);

defaults.maintainAspectRatiolse = false;
defaults.responsive = true;
const StatsLine = () => {
    const navigate = useNavigate();
  return (
    <div>
      {/* Barre de navigation */}
      <div className='Nav'>
        <div className='Nav-Logo'>
          <img src={logo} alt='Logo'/>
        </div>
       <div className='Nav-Menu'>
        <p onClick={() => {navigate("../homepage")}} className={'nav-item'}>Home</p>
        <p onClick={() => {navigate("../stats")}} className={'nav-item active'}>Stats</p>
        <p onClick={() => {navigate("../quizPage")}} className={'nav-item'}>Quizzes</p>
        <p onClick={() => {navigate("../profile")}} className={'nav-item'}>Profile</p>
        </div>
      </div>
      <div className="profile-icon">
        <img src={user} alt="User" />
      </div>
      <div className="msg-welcome">
        <p>"name" stats</p>
      </div>

      <div className="rectMenu">
        <div className="nav-second">
          <div className="first-nav">
            <p>By Quiz</p>
            <p>By chapter</p>
          </div>
          <div className="second-nav">
            <p onClick={() => navigate("/StatsLine")}>Line graph</p>
            <p onClick={() => navigate("/StatsBar")}>Bar chart</p>
            <p onClick={() => navigate("/StatsPie")}>Pie Chart</p>
          </div>
          <div className="Line-container">
            <Line
              data={{
                labels: LineData.map((data) => data.label),
                datasets: [
                  {
                    label: "",
                    data: LineData.map((data) => data.revenue),
                    backgroundColor: "rgba(154, 199, 196, 1)",
                    borderColor: "rgba(154, 199, 196, 1)",
                    borderWidth: 2,
                    tension: 0.4,
                  },
                ],
              }}
              options={{
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                  legend: {
                    display: false,
                  },
                  annotation: {
                    annotations: Object.fromEntries(
                      LineData.map((data, index) => [
                        `line${index}`,
                        {
                          type: "line",
                          mode: "horizontal",
                          scaleID: "y",
                          value: data.revenue,
                          borderColor: "rgba(154, 199, 196, 0.5)",
                          borderWidth: 1.5,
                          borderDash: [5, 5],
                        },
                      ])
                    ),
                  },
                },
                scales: {
                  x: {
                    grid: {
                      display: false,
                    },
                  },
                  y: {
                    grid: {
                      display: false,
                    },
                  },
                },
              }}
              height={400}
              width={1200}
            />
          </div>
        </div>
      </div>
    </div>
  );
};

export default StatsLine;
