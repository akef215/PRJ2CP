import React from "react";
import "./styles/Stats.css";
import logo from "../images/logo _final.png";
import user from "../images/Frame_5.png";
//Pour les graph
import { Doughnut } from "react-chartjs-2";
import { useNavigate } from "react-router-dom";
const StatsPie = () => {
  const sourceData = [
    {
      "label" : "Anglais",
      "value" : 10
    } ,
    {
      "label" : "Français",
      "value" : 90
    } 
  ]
  const chartData = {
    labels: sourceData.map((data) => data.label),
    datasets: [
      {
        label: "Count",
        data: sourceData.map((data) => data.value),
        backgroundColor: [
          "rgba(191, 242, 255, 1)",
          "rgba(101, 117, 153, 1)",
          "rgba(154, 199, 196, 1)",
          "rgba(33, 51, 78, 1)",
          "rgba(107, 144, 172, 1)",
        ],
        borderRadius: 8,
      },
    ],
  };
  const navigate = useNavigate();
  return (
    <div>
      {/* Barre de navigation */}
      <div className="Nav">
        <div className="Nav-Logo">
          <img src={logo} alt="Logo" />
        </div>
        <div className="Nav-Menu">
          <p
            onClick={() => {
              navigate("../homepage");
            }}
            className={"nav-item"}
          >
            Home
          </p>
          <p
            onClick={() => {
              navigate("../stats");
            }}
            className={"nav-item active"}
          >
            Stats
          </p>
          <p
            onClick={() => {
              navigate("../quizPage");
            }}
            className={"nav-item"}
          >
            Quizzes
          </p>
          <p
            onClick={() => {
              navigate("../profile");
            }}
            className={"nav-item"}
          >
            Profile
          </p>
        </div>
      </div>
      <div className="profile-icon">
        <img src={user} alt="User" />
      </div>
      <div className="msg-welcome">
        <p>Statistics </p>
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
          <div className="dataCard customerCard">
            <div className="custom-legend-container">
              {" "}
              {/* Nouveau conteneur pour la légende */}
              {chartData.labels.map((label, index) => (
                <div key={index} className="legend-item">
                  <div
                    className="color-box"
                    style={{
                      backgroundColor:
                        chartData.datasets[0].backgroundColor[index],
                    }}
                  />
                  <span className="legend-label">{label}</span>
                </div>
              ))}
            </div>
            <div className="chart-container">
              <Doughnut
                data={chartData}
                options={{
                  responsive: true,
                  maintainAspectRatio: false,
                  plugins: {
                    legend: { display: false }, // Désactiver la légende par défaut
                  },
                }}
                width={300}
                height={300}
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default StatsPie;
