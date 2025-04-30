import React, { useEffect, useState } from "react";
import "./styles/Stats.css";
import logo from "../images/logo _final.png";
import user from "../images/Frame_5.png";
import { Doughnut } from "react-chartjs-2";
import { useNavigate, useParams } from "react-router-dom";

const StatSurvey = () => {
  const navigate = useNavigate();
  const { id } = useParams();

  const [surveyStats, setSurveyStats] = useState([]);
  const API_URL = process.env.REACT_APP_API_URL;
  useEffect(() => {
    fetch(`${API_URL}/statistics/surveys/${id}`)
      .then((res) => res.json())
      .then((data) => {
        console.log("Données reçues :", data);
        setSurveyStats(data);
      })
      .catch((err) =>
        console.error("Erreur lors du chargement des statistiques :", err)
      );
  }, [id]);

  return (
    <div>
      {/* Barre de navigation */}
      <div className="Nav">
        <div className="Nav-Logo">
          <img src={logo} alt="Logo" />
        </div>
        <div className="Nav-Menu">
          <p onClick={() => navigate("../homepage")} className="nav-item">
            Home
          </p>
          <p onClick={() => navigate("../stats")} className="nav-item active">
            Stats
          </p>
          <p onClick={() => navigate("../quizPage")} className="nav-item">
            Quizzes
          </p>
          <p onClick={() => navigate("../profile")} className="nav-item">
            Profile
          </p>
        </div>
      </div>

      <div className="profile-icon">
        <img src={user} alt="User" />
      </div>

      <div className="msg-welcome">
        <p>Survey {id} Statistics</p>
      </div>

      <div className="rectMenu">
        <div className="nav-second">
          {Array.isArray(surveyStats) &&
            surveyStats.map((qst, qIdx) => {
              const chartData = {
                labels: qst.choices.map((c) => c.choice),
                datasets: [
                  {
                    label: "Count",
                    data: qst.choices.map((c) => c.count),
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

              return (
                <div className="dataCard customerCard" key={qIdx}>
                  <h2>{qst.question}</h2><br />
                  <div className="custom-legend-container">
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
                  <div className="chart-big-container">
                    <div className="chart-container">
                      <Doughnut
                        data={chartData}
                        options={{
                          responsive: true,
                          maintainAspectRatio: false,
                          plugins: {
                            legend: { display: false },
                          },
                        }}
                        width={300}
                        height={300}
                      />
                    </div>
                  </div>
                </div>
              );
            })}
        </div>
      </div>
    </div>
  );
};

export default StatSurvey;
